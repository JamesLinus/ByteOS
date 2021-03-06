#include <io.h>
#include <stdint.h>
#include <klog.h>
#include <stddef.h>
#include <descriptors.h>
#include <drivers/pit.h>
#include <drivers/ps2/kbd.h>

#define PIC1		 0x20		/* IO base address for master PIC */
#define PIC2		 0xA0		/* IO base address for slave PIC */
#define PIC1_COMMAND PIC1
#define PIC1_DATA	 (PIC1 + 1)
#define PIC2_COMMAND PIC2
#define PIC2_DATA	 (PIC2 + 1)
#define PIC_EOI	  0x20
#define PIC_WAIT() \
	do { \
		asm volatile ( "jmp 1f\n\t" \
			   "1:jmp 2f\n\t" \
			   "2:" ); \
	} while (0)

typedef void (*idt_gate)(void);
extern void idt_set_entry(uint8_t index, idt_gate base, uint16_t selector, uint8_t flags);

#define IRQ_INSTALL_HANDLER(index) { \
		extern void _irq##index (); \
		idt_set_entry(index + 32, _irq##index, 0x08, 0x8E); \
	}

void irq_ack(uint8_t irq_num) {
	if (irq_num >= 8)
		io_outportb(PIC2_COMMAND, PIC_EOI);
	io_outportb(PIC1_COMMAND, PIC_EOI);
}

void irq_handler_ignore(struct interrupt_frame *r) {
	(void)r;
	irq_ack(r->int_no - 32);
}

void irq_remap() {
	io_outportb(0x20, 0x11); PIC_WAIT();
	io_outportb(0xA0, 0x11); PIC_WAIT();
	io_outportb(0x21, 0x20); PIC_WAIT();
	io_outportb(0xA1, 0x28); PIC_WAIT();
	io_outportb(0x21, 0x04); PIC_WAIT();
	io_outportb(0xA1, 0x02); PIC_WAIT();
	io_outportb(0x21, 0x01); PIC_WAIT();
	io_outportb(0xA1, 0x01); PIC_WAIT();
	io_outportb(0x21, 0x00); PIC_WAIT();
	io_outportb(0xA1, 0x00); PIC_WAIT();
}

extern void (*isr_handlers[256])(struct interrupt_frame *r);
void irq_install_handler(uint32_t index, void (*handler)(struct interrupt_frame *)) {
	isr_handlers[index + 32] = handler;
}

void irq_install() {
	irq_remap();

	IRQ_INSTALL_HANDLER(0);
	IRQ_INSTALL_HANDLER(1);
	IRQ_INSTALL_HANDLER(2);
	IRQ_INSTALL_HANDLER(3);
	IRQ_INSTALL_HANDLER(4);
	IRQ_INSTALL_HANDLER(5);
	IRQ_INSTALL_HANDLER(6);
	IRQ_INSTALL_HANDLER(7);
	IRQ_INSTALL_HANDLER(8);
	IRQ_INSTALL_HANDLER(9);
	IRQ_INSTALL_HANDLER(10);
	IRQ_INSTALL_HANDLER(11);
	IRQ_INSTALL_HANDLER(12);
	IRQ_INSTALL_HANDLER(13);
	IRQ_INSTALL_HANDLER(14);
	IRQ_INSTALL_HANDLER(15);
}

void irq_handler(struct interrupt_frame *r) {
	if (isr_handlers[r->int_no] != NULL) {
		isr_handlers[r->int_no](r);
	} else {
		klog_detail("Recieved unhandled IRQ number %d\n", r->int_no - 32);
		irq_ack(r->int_no - 32);
	}
}
