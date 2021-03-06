#include <drivers/ps2/ps2main.h>
#include <drivers/ps2/kbd.h>
#include <drivers/pit.h>
#include <drivers/acpi.h>
#include <interrupt.h>
#include <string.h>
#include <ctype.h>
#include <klog.h>
#include <io.h>

// Include the array definitions for the keyboard conversion lookup tables
#include "kbd_mappings.c"

#define KBD_RELEASE_MASK 0x80
#define KBD_CMD_ACK 0xFA
#define KBD_CMD_RESEND 0xFE
#define KBD_CMD_LED 0xED
#define KBD_LED_SCROLL (1 << 0)
#define KBD_LED_NUM (1 << 1)
#define KBD_LED_CAPS (1 << 2)

extern const uint8_t keyboard_us_offsets[];
extern const uint8_t keyboard_us_uppercase[];
extern const uint8_t keyboard_us_lowercase[];

struct kbd_state key_states;

static inline uint8_t keyboard_scancode_to_offset(uint8_t scancode) {
	return keyboard_us_offsets[((scancode & KBD_RELEASE_MASK) ? scancode - KBD_RELEASE_MASK : scancode)];
}

static inline uint8_t keyboard_scancode_to_char(uint8_t scancode, struct key_modifiers mod, bool *force_print) {
	uint8_t val = 0;
	if (mod.shift)
		val = keyboard_us_uppercase[scancode];
	else
		val = keyboard_us_lowercase[scancode];

	if (mod.capslock == !mod.shift)
		val = toupper(val);
	else
		val = tolower(val);

	if (mod.control) {
		*force_print = 1;

		if (tolower(val) == 'c')
			acpi_shutdown();

		if (isalpha(val))
			val = tolower(val) - 'a' + 1;
		else {
			// TODO: Is there a better way to do this?
			switch(val) {
				case '@':
					val = '\x00'; break;
				case '[':
					val = '\x1B'; break;
				case ']':
					val = '\x1D'; break;
				case '\\':
					val = '\x1C'; break;
				case '^':
					val = '\x1E'; break;
				case '_':
					val = '\x1F'; break;
				default:
					*force_print = 0; break;
			}
		}
	} else
		*force_print = 0;
	return val;
}

void keyboard_set_key(size_t index) {
	key_states.cache[index / KBD_CACHE_BITS] |= (1 << (index % KBD_CACHE_BITS));
}

void keyboard_clear_key(size_t index) {
	key_states.cache[index / KBD_CACHE_BITS] &= ~(1 << (index % KBD_CACHE_BITS));
}

bool keyboard_test_key(size_t index) {
	return (key_states.cache[index / KBD_CACHE_BITS] & (1 << (index % KBD_CACHE_BITS)));
}

bool keyboard_test_persist(uint8_t mask) {
	return (key_states.persist && mask);
}

struct key_modifiers keyboard_get_key_modifiers() {
	struct key_modifiers mods = {
		keyboard_test_key(KBD_K_LSHIFT) || keyboard_test_key(KBD_K_RSHIFT),
		keyboard_test_key(KBD_K_LCTRL) || keyboard_test_key(KBD_K_RCTRL),
		keyboard_test_persist(KBD_CAPSLOCK_MASK),
		keyboard_test_key(KBD_K_LALT) || keyboard_test_key(KBD_K_RALT)
	};
	return mods;
}

void keyboard_set_led(uint8_t flags) {
	// TODO: Rewrite this
	flags &= 0x07; // Only use last 3 bits
	ps2_port1_write(KBD_CMD_LED);
	uint8_t temp = 0;
	while (temp != KBD_CMD_ACK) {
		temp = ps2_port_read();
		if (temp == KBD_CMD_RESEND)
			ps2_port1_write(KBD_CMD_LED);
	}

	ps2_port1_write(flags);
	temp = 0;
	while (temp != KBD_CMD_ACK) {
		temp = ps2_port_read();
		if (temp == KBD_CMD_RESEND) {
			ps2_port1_write(KBD_CMD_LED);
			ps2_port1_write(flags);
		}
	}
}

void keyboard_capslock_toggle() {
	if (keyboard_test_persist(KBD_CAPSLOCK_MASK)) {
		// Disable capslock
		key_states.persist &= ~KBD_CAPSLOCK_MASK;
		keyboard_set_led(0);
	} else {
		// Enable capslock
		key_states.persist |= KBD_CAPSLOCK_MASK;
		keyboard_set_led(KBD_LED_CAPS);
	}
}

void keyboard_handler(struct interrupt_frame *r) {
	ps2_wait_input();
	uint8_t scancode = io_inportb(PS2_DATA);
	irq_ack(r->int_no - 32);
	uint8_t offset = keyboard_scancode_to_offset(scancode);
	if (scancode & KBD_RELEASE_MASK) {
		keyboard_clear_key(offset);
	} else {
		struct key_modifiers mods = keyboard_get_key_modifiers();
		keyboard_set_key(offset);
		if (offset == KBD_K_CAPS)
			keyboard_capslock_toggle();
		bool force_print = 0;
		char c = keyboard_scancode_to_char(scancode, mods, &force_print);
		if (!(c != 0 || isprint(c)) && !force_print)
			return;
		printf("%c", c);
	}
}

void keyboard_init(void) {
	memset(&key_states, 0, sizeof(key_states));
	irq_install_handler(1, keyboard_handler);
	//keyboard_set_led(0);
}
