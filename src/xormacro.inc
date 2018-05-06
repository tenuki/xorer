;
; Regs Struct/Load/Store
;
 RegsStruct Struc
  tes      dw ?
  tax      dw ?
  tcx      dw ?
  tdi      dw ?
  tsi      dw ?
 Ends

 StoreRegs macro RS
  mov  [cs:RS].tax, ax
  mov  [cs:RS].tcx, cx
  mov  [cs:RS].tdi, di
  mov  [cs:RS].tsi, si
  mov  [cs:RS].tes, es
 endm

 LoadRegs macro RS
  mov  ax, RegsStruct[cs:RS].tax
  mov  cx, RegsStruct[cs:RS].tcx
  mov  di, RegsStruct[cs:RS].tdi
  mov  si, RegsStruct[cs:RS].tsi
  mov  es, RegsStruct[cs:RS].tes
 endm

;
; Stack def/use
;
;OurStack    db          StackSize DUP (?)
;OurStackTop label
; How to work with our ownStack..
; ³cli
; ³mov [cs:OurData].OldSS, ss
; ³mov [cs:OurData].OldSP, sp
; ³push cs
; ³pop  ss
; ³mov sp, offset OurStackTop
; ³sti
; ³cli
; ³mov ss, [cs:OurData].OldSS
; ³mov sp, [cs:OurData].OldSP
; ³sti
; End
