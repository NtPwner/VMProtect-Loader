;	VMProtect	Loader	template	
;	Author	:	NtPwner/AT4RE	
;	date	:	10/07/2022

.386
.model	flat,stdcall
option	casemap:none

include	masm32rt.inc
includelib	masm32.lib





.const												
lpAppName		db		"CrackMe.vmp.exe",0
lpCaption		db		"info",0
lpOperationFailed		db		"Operation Failed",0
.data?													
lpValue			dd		?
hProcess		dd		?
lpBuffer		dd		?
.data												
lpSi	STARTUPINFO<>
lpPi	PROCESS_INFORMATION<>
.code
start:
	invoke	CreateProcess,addr	lpAppName,NULL,NULL,NULL,NULL,CREATE_DEFAULT_ERROR_MODE,NULL,NULL,addr lpSi,addr lpPi
	test	eax,eax
	jz	@F
	mov	hProcess,eax
	.while	TRUE
		invoke	ReadProcessMemory,lpPi.hProcess,00401076h,addr	lpBuffer,2,NULL	;00401076h=VA	PATCH	ADDRESS
		test	eax,eax
		jz	@F
		mov	al,byte	ptr	ds:[lpBuffer]	;	ORIGINAL BYTE:	74h	(JE/JZ)
		mov	cl,byte	ptr	ds:[lpBuffer+1]	
		.if	al==74h	&&	cl==18h			
				.break
		.endif
	.endw
		mov	byte	ptr	ds:[lpBuffer],0EBh	;	PATCHED BYTE	EBh	(JMP)
		invoke	Sleep,1000
		invoke	WriteProcessMemory,lpPi.hProcess,00401076h,addr	lpBuffer,2,NULL
	ret
	@@:
	invoke	MessageBox,0,addr lpOperationFailed,addr lpCaption,MB_ICONERROR
	invoke	ExitProcess,0
end	start