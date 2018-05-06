;
; Dos Interruption Constants (Services)
;
      dosCreateFile    equ  03ch
      dosOpenFile      equ  03dh
      dosExtOpenCreate equ  06Ch
      dosCloseFile     equ  03eh
      dosReadFile      equ  03fh
      dosSaveFile      equ  040h
      dosSeekFile      equ  042h
      dosStdCreateFile equ  05bh

      dosReadCDev      equ  04402h
      dosSaveCDev      equ  04403h
      dosReadBDev      equ  04404h
      dosSaveBDev      equ  04405h