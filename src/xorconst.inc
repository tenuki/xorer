;
; Xor Constants
;

; Xor 2fh interrupt services & responses
  XorID            equ  0DAh      ; 2fh. ah=                        Result
  XorIsInstalledb  equ  000h      ;  Is xor installed?         ³
  XorisEnd         equ  001h      ;  not implemented yet       ³
  XorCanUninstallb equ  002h      ;  Can be xor uninstalled?   ³(ax=0)=ok!
  XorUninstallb    equ  003h      ;  Uninstall xor!            ³
  XorInstalled     equ  0FFFFh    ;  Xor is installed!

  XorIsInstalled   equ  0DA00h    ;  Is xor installed?         ³
  XorCanUninstall  equ  0DA02h    ;  Can be xor uninstalled?   ³(ax=0)=ok!
  XorUninstall     equ  0DA03h    ;  Uninstall xor!            ³

; Xor Activity Constants
  ShowAt           equ  (80-1)*2  ; X-axis, Where Show Activity char
  ActivityCharOn   equ  0f0fh     ; '' lightred on black.
  ActivityCharOff  equ  0920h     ; ' ' on black.

; Other Xor constants
  CryptCode        equ  066h      ; xor each byte by 066h
  olddosint        equ  080h      ; old dos int at 080h int.
  StackSize        equ  020h      ; our stack internaly controlled size - niy
  ComTailLenAt     equ  080h      ; Command Tail Len in PSP at..
  ComTailAt        equ  081h      ; Command Tail at..