.model tiny
.386
.code
org 100h

include DosConst.Inc
include XorConst.Inc
include XorMacros.Inc

; ---
; -   Types
; ---
 Pointer Struc
   Offs  dw ?
   Segm  dw ?
 EndS

 VarStruct Struc                    ; Struct of the vars in the code segment!
  Used     dw ?
  FileH    dw ?
  WeDS     dw ?
  OldDS    dw ?
  oldSS    dw ?
  oldSP    dw ?
  TempW    dw ?
  TemCx    dw ?
  TemDs    dw ?
  TemDx    dw ?
 Ends

Start: jmp Begin
; ---
; -   Vars
; ---
OurData     VarStruct   <0,0,0,0,0,0,0,0,0,0>
OurExt      db          '.ENC'

ShowChar macro Car
 mov  [cs:OurData].Tempw, Car
 call [Show]
endm

; ---
; -   Dos Function Dispatcher handler
; ---
Our21Handler Proc
Main21:  pushf
   ShowChar ActivityCharOn

         cmp  ah, dosReadFile
         je   short i21Read
         cmp  ah, dosSaveFile
         je   short i21Save
         cmp  ah, dosExtOpenCreate
         je   short i21ExtOpen
         cmp  ah, dosCreateFile                      ; Check int 21h services
         je   i21Open
         cmp  ah, dosStdCreateFile
         je   i21Open
         cmp  ah, dosOpenFile
         je   i21Open
         cmp  ah, dosCloseFile
         je   i21Close
         ; Device Support (I don't think that this must be needed, but i try!)
         ;cmp  ax, dosReadCDev
         ;je   short i21Read
         ;cmp  ax, dosReadBDev
         ;je   short i21Read
         ;cmp  ax, dosSaveCDev
         ;je   short i21Save
         ;cmp  ax, dosSaveBDev
         ;je   short i21Save
   ShowChar ActivityCharOff
Prev21:  popf
Orig21:  db 0eah                                    ; jmp Far to old Int 21h
OldInt21 Pointer ?

i21Save:;--- Begin of Save a File ---
         cmp    [cs:OurData].Used, 1
         jne    short short Prev21
         cmp    [cs:OurData].FileH,bx
         jne    short short Prev21
         ;If Codein is needed..
         cmp    cx, 0
         je     short NoCodeIn
          call  CodeIn
         NoCodeIn:
         jmp    short Prev21
        ;--- End of Save a File ---

i21Read:;--- Begin of READ a File ---
         cmp    [cs:OurData].Used, 1
         jne    short Prev21
         cmp    [cs:OurData].FileH,bx
         jne    short Prev21

         mov    [cs:OurData].TemCx,cx                     ; Save Read Params
         mov    [cs:OurData].TemDs,ds
         mov    [cs:OurData].TemDx,dx
         popf
         int    OldDosInt
         push   ds
         push   ax
         xchg   dx,[cs:OurData].TemDx                     ; Restore Read Params
         mov    cx,[cs:OurData].TemCx
         mov    ds,[cs:OurData].TemDs
         call   CodeIn
         pop    ax
         pop    ds
         jmp    int21Exit
        ;--- End of READ a File ---

        ;--- Begin of Extended Create|Open a file ---
        ; It takes me a couple of hours..
i21ExtOpen:
         cmp   [cs:OurData].Used, 0
         jne   short Prev21
         mov   [cs:OurData].TemDx, dx
         mov   dx, si
         call  [CheckFName]
         mov   dx, [cs:OurData].TemDx
         jmp   short @TrueOpen
        ;--- End of Extended Create|Open a file ---

i21Open:;--- Begin of CREATE or OPEN a File ---
         cmp   [cs:OurData].Used, 0
         jne   Prev21 ;short
         call  [CheckFName]
@TrueOpen:
         popf
         int   OldDosInt
         jc    int21Exit
         pushf
         cmp   [cs:OurData].TempW, 1
         jne   short OpenEnd2
          mov  [cs:OurData].TempW, 0
          mov  [cs:OurData].Used, 1
          mov  [cs:OurData].FileH, ax
         OpenEnd2:
         popf
         jmp   short int21Exit
        ;--- End of CREATE or OPEN a File ---

i21Close:;--- Begin of CLOSE a File ---
         cmp   [cs:OurData].Used, 1
         jne   Prev21
         cmp   [cs:OurData].FileH,bx
         jne   Prev21
         popf
         int   OldDosInt
         jc    CloEnd
         mov   [cs:OurData].Used,0
         mov   [cs:OurData].FileH,0
CloEnd: ;--- End of CLOSE a File ---
int21Exit:
   ShowChar ActivityCharOff
           retf 02
Endp

; ---
; -   Other..
; ---

; CodeIn rutine!
; |Data in DS:DX
; \Bytes in CX
CodeIn Proc
   ShowChar ActivityCharOn
   pushf
   StoreRegs CodeInReg
   push ds
   pop  es
   mov  si, dx
   mov  di, dx
   cld
   Cycle:
     lodsb
     xor al, CryptCode
     stosb
   Loop Cycle

   LoadRegs CodeInReg
   popf
   ret
   CodeInReg RegsStruct <?,?,?,?,?>
Endp; CodeIn end

; Check File Name (Must end with .Enc)
; |DS:DX = pointer to an ASCIIZ file name
; \TempW = Result (0=False,1=True)
CheckFName Proc
   StoreRegs CheckReg
    push  ds
    pop   es

   xor   cx, cx
   mov   [cs:OurData].Tempw, cx      ; Clear Tempw (result)
   ; Searchs for #0 at filename
   mov   di, dx
   dec   cl
   mov   si, cx
   xor   al, al
   cld
   repne scasb
   ; DS:SI points to '.Ext'
   mov   ax, si      ; 0ffh
   sub   ax, cx
   mov   cx, 5
   sub   ax, cx
   mov   si, dx
   add   si, ax
   push  si
   ;Upcase All Extension chars
   UpcaseAll:
    lodsb
    call  [UPCaseAL]
    mov   [si-1], al
   loop UpcaseAll
   ;Compare file ext with OurExtension (.Enc)
   pop   si
    push cs
    pop  es
   mov   di, offset OurExt
   mov   cx, 4
   cld
   rep   cmpsb            ;DS:SI<=>ES:DI|ext2open-our.ext
   jne   short NoOpenThis
    mov  [cs:OurData].TempW, 1
   NoOpenThis:

   LoadRegs CheckReg
   ret
   CheckReg RegsStruct <?,?,?,?,?>
Endp; CheckFName end


; Shows working char
; \TempW = Char|Attr
Show Proc
     mov  cs:[TempAx], ax
     mov  cs:[TempEs], es
     mov  ax, 0b800h
     mov  es, ax
     mov  ax, [cs:OurData].Tempw
     mov  es:[ShowAt], ax
     mov  ax, cs:[TempAx]
     mov  es, cs:[TempEs]
     ret
     TempAx dw ?
     TempEs dw ?
Endp;End of Show

; UpCaseAL
; \AL=Up(AL)
UPCaseAL Proc
  cmp al, 'a'
  jb  short UPCaseEnd
  cmp al, 'z'
  ja  short UPCaseEnd
  sub al, 'a'-'A'
 UPCaseEnd:
  ret
Endp


; ---
; -   Multiplex Interrupt handler
; ---
Our2fHandler Proc
Main2f:    cmp   ah, XorId
           jne   short Orig2f
           or    al, al                          ;=cmp al,XorIsInstalledb
           je    short iIsInst
           cmp   al, XorCanUninstallb
           je    short iCanUn
           cmp   al, XorUninstallb
           je    short TsrEnd
Orig2f:    db    0eah                            ;jmp Far old int 2f
OldInt2f   Pointer ?
iCanUn:   ;Get Int Vecs
           mov  ax, 352fh
           int  21h
           cmp  bx, offset Our2fhandler
           jne  short Cant
           mov  dx, cs
           mov  bx, es
           cmp  bx, dx
           jne  short Cant
           mov  al, 21h
           int  21h
           cmp  bx, offset Our21handler
           jne  short Cant
           mov  bx, es
           cmp  bx, dx
           jne  short Cant
           xor  ax, ax
           jmp  int2fExit
iIsInst:   mov  ax, XorInstalled
Cant:
int2fExit: iret
EndP

TsrEnd Proc
          ;Set Int Vecs
           push ds
           mov  ax, 252fh
           mov  ds, cs:[Oldint2f].Segm
           mov  dx, cs:[Oldint2f].Offs
           int  21h
           mov  al, 21h
           mov  ds, cs:[Oldint21].Segm
           mov  dx, cs:[Oldint21].Offs
           int  21h
           pop  ds
          ;Bye Bye Xor.Com
           cli
           mov   ax,  cs
           mov   es,  ax
           mov   ah,  49h
           int   21h
           sti
           iret
Endp


; ---
; -   Here, free mem from here to then end..
; -   It's the Terminate and Stay Resident!
; ---
TSR    Proc                                 ; Free useless mem..
       cli                                  ;  bye bye, stupid enviroment MCB!
       mov   ah,  49h
       mov   es,  ds:[2Ch]                     ;mov es,[PrefixSeg][2Ch]
       int   21h
       sti
       mov ax, 3100h                        ;  Terminat & Stay Resident
       mov dx, (offset TSR-offset Start+100h)/16+1
       int 21h
EndP

; Is Xor.Com installed in mem?
; \EF=True
AlreadyInstalled Proc
       mov  ax, XorIsInstalled
       int  2fh
       cmp  ax, XorInstalled
       ret
Endp

CheckParams Proc
       mov  al, cs:[ComTailLenAt]
       or   al, al
       ret
Endp

StrCantUninstall db 'Can''t be uninstalled now.$'
StrUninstalled   db 'Uninstalled!$'
StrAlreadyInst   db 'Already installed.$'
StrInstalled     db 'Installed.$'
StrCopyRight     db 'Xor v0.5à by aWe.',13,10
                 db 'Compiled Date: ',??Date,' ',??Time,'.',13,10,'$'

Begin: mov  dx, offset StrCopyRight
       mov  ah, 09h
       int  21h
       call [CheckParams]
       jne  @TryUnInstall
       call [AlreadyInstalled]
       mov  dx, offset strAlreadyInst
       je   short @Print
       ;Get Int Vecs
       mov  ax, 352fh
       int  21h
       mov  oldint2f.Offs,BX
       mov  oldint2f.Segm,ES
       mov  al, 21h
       int  21h
       mov  oldint21.Offs,BX
       mov  oldint21.Segm,ES
       ;Set 80h<=Dos int
       push ds
       mov  dx, bx
        push es
        pop  ds
       mov  ax, 2580h
       int  21h
       pop  ds
       ;Set Int Vecs
       mov  al, 21h
       mov  dx, offset Our21handler
       int  21h
       mov  al, 2fh
       mov  dx, offset Our2fhandler
       int  21h
       ;Terminat & Stay Resident
       mov  dx, offset strInstalled
       mov  ah, 09h
       int  21h
       jmp  TSR

@TryUnInstall:
       call [AlreadyInstalled]
       jne  short @Exit
       mov  ax, XorCanUninstall
       int  2fh
       or   ax, ax
       jne  short @CantUninstall
       mov  ax, XorUninstall
       int  2fh
       mov  dx, offset strUninstalled
       jmp  short @Print

@CantUninstall:
       mov  dx, offset strCantUninstall
@Print:mov  ah, 09h
       int  21h
@Exit: mov  ah, 4ch
       int  21h
end Start
