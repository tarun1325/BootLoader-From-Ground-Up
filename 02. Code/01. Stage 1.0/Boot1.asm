;******************************************************************
;	Author 	: Tarun Jain
;	Roll No.: MT2015120
;	Project	: Operating System Development
;	Module	: Boot Loader - Version 1.0 - A Simple Bootloader
;	File	: Boot1.asm
;
;******************************************************************

org		0x7c00			; This Bootloader is Loaded by BIOS at 0x7c00 address - To Tell NASM Assembler

bits		16			; All x86 Compatible computers boot into 16 bit mode
					; Limits to using only 1MB of memory - Switching to 32 bit will be done later

Start:

		cli			; Clear all Interrupts
		hlt			; Halt the System

times		510 - ( $ - $$ ) db 0	; Check to be within 512 bytes - Bootloader has to be in 1 sector
					; In NASM -----	$ = Address of Current Line
					;		$$= Address of First Instruction ( here it should be 0x7c00)
					; ($ - $$) = Gives the Number of Byte between two address
					; 510 Bytes counted because Boot Signature instruction takes 2 Bytes, Hence total = 512 Bytes


dw		0xAA55			; Boot Signature
					; BIOS INT 0x19 searches for a bootable disk. The boot signature tells that this is the bootable disk
					; if 511 Byte = 0xAA and 512 Byte = 0x55 , INT 0x19 will load and execute the boot loader