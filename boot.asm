; 16 bit mode
bits 16
org 0x7c00

; offsets into the gdt
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

boot:
	mov ax, 0x2401
	int 0x15                            ; ENABLE A20-GATE (To access more than 1MB of memory)
	mov ax, 0x3
	int 0x10                            ; SET VGA TEXT MODE 3
	cli
	lgdt [gdt_pointer]                  ; LOAD GDT TABLE
	mov eax, cr0                                            
	or eax, 0x1                         ; SET THE PROTECTED MODE SET THE PROTECTED MODE BIT ON SPECIAL CPU REG CR0
	mov cr0, eax
	jmp CODE_SEG:boot2                  ; JUMP TO CODE SEGMENT


; GLOBAL DESCRIPTOR TABLE FROM SCRATCH 
gdt_start:
	dq 0x0

gdt_code:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10011010b
	db 11001111b
	db 0x0

gdt_data:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0

gdt_end:

; GDT POINTER STRUCTURE (16 bit with gdt size, followed by 32 bit pointer to structure itself)
gdt_pointer:
	dw gdt_end - gdt_start
	dd gdt_start

; Dive into 32 bit mode!
bits 32

boot2:
	mov ax, DATA_SEG
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	mov esi, message
	mov ebx, 0xb8000

.loop:
	lodsb
	or al, al
	jz halt
	or eax,0x0100
	mov word [ebx], ax
	add ebx, 2
	jmp .loop

halt:
	cli
	hlt

 message: db "Bootloader from floppy disk go brrrrrrr",0

times 510 - ($-$$) db 0
dw 0xaa55
