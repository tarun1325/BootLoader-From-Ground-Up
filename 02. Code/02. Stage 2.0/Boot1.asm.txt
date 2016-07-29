;******************************************************************
;	Author 	: Tarun Jain
;	Roll No.: MT2015120
;	Project	: Operating System Development
;	Module	: Boot Loader - Stage 2.0 - A Simple Bootloader
;	File	: Boot1.asm
;
;******************************************************************

bits		16			; We are Still in 16 bit Real Mode

org		0x7c00			; We are loaded by BIOS at 0x7c00

start		jmp loader		; Jump Over OEM block

;******************************************************************
;	OEM Parameter Block
;******************************************************************

bpbOEM			db "Tarun OS"	; This member must be exactly 8 bytes. It is just 
					; the name of your OS.


bpbBytesPerSector:	DW 512
bpbSectorsPerCluster:	DB 1
bpbReservedSectors:	DW 1
bpbNumberOfFATs:	DB 2
bpbRootEntries:		DW 224
bpbTotalSectors:	DW 2880
bpbMedia:		DB 0xF0
bpbSectorsPerFAT:	DW 9
bpbSectorsPerTrack:	DW 18
bpbHeadsPerCylinder:	DW 2
bpbHiddenSectors:	DD 0
bpbTotalSectorsBig:	DD 0
bsDriveNumber:		DB 0
bsUnused:		DB 0
bsExtBootSignature:	DB 0x29
bsSerialNumber:		DD 0xa0a1a2a3
bsVolumeLabel:		DB "MOS FLOPPY"
bsFileSystem:		DB "FAT12   "


msg	db	"Welcome to Tarun Jain Operating System !!!", 0		; String to print


;******************************************************************
;	Prints a string
;	DS=>SI: 0 terminated String
;******************************************************************

Print:

	lodsb			; load next byte from string from SI to AL
	or	al,al		; Does AL=0?
	jz	PrintDone	; Null Terminator Found-Bail Out
	mov	ah, 0eh		; Nope-Print the character
	int	10h
	jmp	Print		; Repeat until null terminator

PrintDone:
	ret			; We are done, so return

;******************************************************************
;	Bootloader Entry Point
;******************************************************************

loader:
	xor	ax,ax	; Setup segments to ensure they are 0. Remember that
	mov	ds,ax	; we have ORG 0x7c00. This means all addressess are based
	mov	es,ax	; from 0x7c00:0. Because the data segments are within the same
			; code segment, null them up.

	mov	si,msg	; our messsage to print
	call	Print	; call out print function

	xor	ax, ax	; clear ax
	int	0x12	; get the amount of KB from the BIOS


	cli		; Clear all interrupts
	hlt		; halt the system

times 510-($-$$) db 0	; We have to be 512 bytes. Clear the rest of the bytes with 0

dw	0xAA55		; Boot Signature