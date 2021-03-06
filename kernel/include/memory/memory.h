#pragma once

#include <stdint.h>
#include <stddef.h>
#include <system.h>

extern phys_addr placement_address;

void mem_init(uint32_t multiboot_magic, const void *multiboot_header);

struct mem_info {
	uintptr_t lower;
	uintptr_t upper;
	int8_t *bootloader_name;
};
