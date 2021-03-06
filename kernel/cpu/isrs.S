.section .text
.align 4

.macro ISR_ERR_HANDLER index, has_error=0
	.global _isr\index
	_isr\index:
		cli
		.ifeq \has_error
			push $0
		.endif
		push $\index
		jmp isr_common
.endm

.macro ISR_HANDLER index
	.global _isr\index
	_isr\index:
		cli
		push $0
		push $\index
		jmp isr_common
.endm

.macro IRQ_HANDLER index byte
	.global _irq\index
	.type _irq\index, @function
	_irq\index:
		cli
		push $0
		push $\byte
		jmp irq_common
.endm

ISR_ERR_HANDLER 0
ISR_ERR_HANDLER 1
ISR_ERR_HANDLER 2
ISR_ERR_HANDLER 3
ISR_ERR_HANDLER 4
ISR_ERR_HANDLER 5
ISR_ERR_HANDLER 6
ISR_ERR_HANDLER 7
ISR_ERR_HANDLER 8,  1
ISR_ERR_HANDLER 9
ISR_ERR_HANDLER 10, 1
ISR_ERR_HANDLER 11, 1
ISR_ERR_HANDLER 12, 1
ISR_ERR_HANDLER 13, 1
ISR_ERR_HANDLER 14, 1
ISR_ERR_HANDLER 15
ISR_ERR_HANDLER 16
ISR_ERR_HANDLER 17, 1
ISR_ERR_HANDLER 18
ISR_ERR_HANDLER 19
ISR_ERR_HANDLER 20
ISR_ERR_HANDLER 21
ISR_ERR_HANDLER 22
ISR_ERR_HANDLER 23
ISR_ERR_HANDLER 24
ISR_ERR_HANDLER 25
ISR_ERR_HANDLER 26
ISR_ERR_HANDLER 27
ISR_ERR_HANDLER 28
ISR_ERR_HANDLER 29
ISR_ERR_HANDLER 30, 1
ISR_ERR_HANDLER 31

IRQ_HANDLER 0, 32
IRQ_HANDLER 1, 33
IRQ_HANDLER 2, 34
IRQ_HANDLER 3, 35
IRQ_HANDLER 4, 36
IRQ_HANDLER 5, 37
IRQ_HANDLER 6, 38
IRQ_HANDLER 7, 39
IRQ_HANDLER 8, 40
IRQ_HANDLER 9, 41
IRQ_HANDLER 10, 42
IRQ_HANDLER 11, 43
IRQ_HANDLER 12, 44
IRQ_HANDLER 13, 45
IRQ_HANDLER 14, 46
IRQ_HANDLER 15, 47

ISR_HANDLER 48
ISR_HANDLER 49
ISR_HANDLER 50
ISR_HANDLER 51
ISR_HANDLER 52
ISR_HANDLER 53
ISR_HANDLER 54
ISR_HANDLER 55
ISR_HANDLER 56
ISR_HANDLER 57
ISR_HANDLER 58
ISR_HANDLER 59
ISR_HANDLER 60
ISR_HANDLER 61
ISR_HANDLER 62
ISR_HANDLER 63
ISR_HANDLER 64
ISR_HANDLER 65
ISR_HANDLER 66
ISR_HANDLER 67
ISR_HANDLER 68
ISR_HANDLER 69
ISR_HANDLER 70
ISR_HANDLER 71
ISR_HANDLER 72
ISR_HANDLER 73
ISR_HANDLER 74
ISR_HANDLER 75
ISR_HANDLER 76
ISR_HANDLER 77
ISR_HANDLER 78
ISR_HANDLER 79
ISR_HANDLER 80
ISR_HANDLER 81
ISR_HANDLER 82
ISR_HANDLER 83
ISR_HANDLER 84
ISR_HANDLER 85
ISR_HANDLER 86
ISR_HANDLER 87
ISR_HANDLER 88
ISR_HANDLER 89
ISR_HANDLER 90
ISR_HANDLER 91
ISR_HANDLER 92
ISR_HANDLER 93
ISR_HANDLER 94
ISR_HANDLER 95
ISR_HANDLER 96
ISR_HANDLER 97
ISR_HANDLER 98
ISR_HANDLER 99
ISR_HANDLER 100
ISR_HANDLER 101
ISR_HANDLER 102
ISR_HANDLER 103
ISR_HANDLER 104
ISR_HANDLER 105
ISR_HANDLER 106
ISR_HANDLER 107
ISR_HANDLER 108
ISR_HANDLER 109
ISR_HANDLER 110
ISR_HANDLER 111
ISR_HANDLER 112
ISR_HANDLER 113
ISR_HANDLER 114
ISR_HANDLER 115
ISR_HANDLER 116
ISR_HANDLER 117
ISR_HANDLER 118
ISR_HANDLER 119
ISR_HANDLER 120
ISR_HANDLER 121
ISR_HANDLER 122
ISR_HANDLER 123
ISR_HANDLER 124
ISR_HANDLER 125
ISR_HANDLER 126
ISR_HANDLER 127
ISR_HANDLER 128
ISR_HANDLER 129
ISR_HANDLER 130
ISR_HANDLER 131
ISR_HANDLER 132
ISR_HANDLER 133
ISR_HANDLER 134
ISR_HANDLER 135
ISR_HANDLER 136
ISR_HANDLER 137
ISR_HANDLER 138
ISR_HANDLER 139
ISR_HANDLER 140
ISR_HANDLER 141
ISR_HANDLER 142
ISR_HANDLER 143
ISR_HANDLER 144
ISR_HANDLER 145
ISR_HANDLER 146
ISR_HANDLER 147
ISR_HANDLER 148
ISR_HANDLER 149
ISR_HANDLER 150
ISR_HANDLER 151
ISR_HANDLER 152
ISR_HANDLER 153
ISR_HANDLER 154
ISR_HANDLER 155
ISR_HANDLER 156
ISR_HANDLER 157
ISR_HANDLER 158
ISR_HANDLER 159
ISR_HANDLER 160
ISR_HANDLER 161
ISR_HANDLER 162
ISR_HANDLER 163
ISR_HANDLER 164
ISR_HANDLER 165
ISR_HANDLER 166
ISR_HANDLER 167
ISR_HANDLER 168
ISR_HANDLER 169
ISR_HANDLER 170
ISR_HANDLER 171
ISR_HANDLER 172
ISR_HANDLER 173
ISR_HANDLER 174
ISR_HANDLER 175
ISR_HANDLER 176
ISR_HANDLER 177
ISR_HANDLER 178
ISR_HANDLER 179
ISR_HANDLER 180
ISR_HANDLER 181
ISR_HANDLER 182
ISR_HANDLER 183
ISR_HANDLER 184
ISR_HANDLER 185
ISR_HANDLER 186
ISR_HANDLER 187
ISR_HANDLER 188
ISR_HANDLER 189
ISR_HANDLER 190
ISR_HANDLER 191
ISR_HANDLER 192
ISR_HANDLER 193
ISR_HANDLER 194
ISR_HANDLER 195
ISR_HANDLER 196
ISR_HANDLER 197
ISR_HANDLER 198
ISR_HANDLER 199
ISR_HANDLER 200
ISR_HANDLER 201
ISR_HANDLER 202
ISR_HANDLER 203
ISR_HANDLER 204
ISR_HANDLER 205
ISR_HANDLER 206
ISR_HANDLER 207
ISR_HANDLER 208
ISR_HANDLER 209
ISR_HANDLER 210
ISR_HANDLER 211
ISR_HANDLER 212
ISR_HANDLER 213
ISR_HANDLER 214
ISR_HANDLER 215
ISR_HANDLER 216
ISR_HANDLER 217
ISR_HANDLER 218
ISR_HANDLER 219
ISR_HANDLER 220
ISR_HANDLER 221
ISR_HANDLER 222
ISR_HANDLER 223
ISR_HANDLER 224
ISR_HANDLER 225
ISR_HANDLER 226
ISR_HANDLER 227
ISR_HANDLER 228
ISR_HANDLER 229
ISR_HANDLER 230
ISR_HANDLER 231
ISR_HANDLER 232
ISR_HANDLER 233
ISR_HANDLER 234
ISR_HANDLER 235
ISR_HANDLER 236
ISR_HANDLER 237
ISR_HANDLER 238
ISR_HANDLER 239
ISR_HANDLER 240
ISR_HANDLER 241
ISR_HANDLER 242
ISR_HANDLER 243
ISR_HANDLER 244
ISR_HANDLER 245
ISR_HANDLER 246
ISR_HANDLER 247
ISR_HANDLER 248
ISR_HANDLER 249
ISR_HANDLER 250
ISR_HANDLER 251
ISR_HANDLER 252
ISR_HANDLER 253
ISR_HANDLER 254
ISR_HANDLER 255

.extern isr_fault_handler
.type isr_fault_handler, @function

.extern irq_handler
.type irq_handler, @function

isr_common:
	pusha

	push %ds
	push %es
	push %fs
	push %gs
	mov $0x10, %ax
	mov %ax, %ds
	mov %ax, %es
	mov %ax, %fs
	mov %ax, %gs

	push %esp
	call isr_fault_handler
	add $4, %esp

	pop %gs
	pop %fs
	pop %es
	pop %ds

	popa
	add $8, %esp
	iret

irq_common:
	pusha

	push %ds
	push %es
	push %fs
	push %gs
	mov $0x10, %ax
	mov %ax, %ds
	mov %ax, %es
	mov %ax, %fs
	mov %ax, %gs

	push %esp
	call irq_handler
	add $4, %esp

	pop %gs
	pop %fs
	pop %es
	pop %ds

	popa
	add $8, %esp
	iret
