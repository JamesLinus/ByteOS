#pragma once

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <system.h>

struct mouse_state {
	int32_t x;
	int32_t y;
	uint8_t btns;
};

void mouse_init();
void mouse_interrupt(struct interrupt_frame *);
