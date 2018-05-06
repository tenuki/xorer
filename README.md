    ..................
    .  Index
    . .......
    .
    . .Index
    . .Xor v0.60
    . .Usage
    . .Info
    . .Little History
    . .Thanks To
    . .EoF
    .
    ..................
    
    
    
    
    
    
    ..............................................................................
    .                                                                            .
    .                                 Xor v0.60                                  .
    .                                ...........                                 .
    .                                                                            .
    .    Una vez que se ejecuta queda residente en memoria, e intercepta la int  .
    . 21h (Dos) y 2fh (Multiplex int).                                           .
    .    Ya instalado el programa, los files encriptados se pueden leer/escribir .
    . normalmente, y sin que uno se de cuenta en disco son grabados encriptados. .
    .    Adem�s, si esta la opci�n Prompt del xor activada (xor /p1) cada vez    .
    . que sea creado un file, aparecer� en pantalla la pregunta de si desea      .
    . crear el archivo como encriptado.. (y=si)                                  .
    . La opci�n Prompt se desinstala con xor /p0.                                .
    .                                                                            .
    . () El m�todo de encripci�n es, realmente, muy trucho, pero, tengase en    .
    . cuenta que esto esta en vias de desarrollo, y para hacer algo interesante  .
    . que funcione, conviene empezarlo de a poco!                                .
    .                                                                            .
    ..............................................................................
    .............................................................
    .  Usage                                                   ..
    .........                                            .......
    .                                                        ..
    .  Xor.Com     :If it's not installed => install          ..
    .                                else => show Msg.         ..
    .                                                           .
    .  Xor.Com /u  :If it's installed                           .
    .                  => If CAN be uninstalled => Uninstalls   .
    .                                      else => Show Msg.    .
    .                                                           .
    .  Xor.Com /px :If it's not installed => show msg           .
    .                  else if x=1 => Set Prompt On             .
    .                          else   Set Prompt Off.           .
    .                                                           .
    .............................................................
    
    .................................................................- - �
    .  Info
    .  ..Source
    .  . ..Language\Compiler
    .  . . ..Version 0.00. Pascal 7.0 with much BAsm.
    .  . . ..Version 0.50. Full asm code. Tasm 3.2.
    .  . . ..Version 0.52. Tasm 4.0.
    .  . . ..Version 0.60. Tasm 4.0.
    .  . ..Files             Bytes    Lines
    .  .   ..DosConst.inc      456       16
    .  .   ..XorConst.inc     1236       27
    .  .   ..XorMacro.inc      834       26
    .  .   ..Xor.asm          9885      472
    .  ..Executable
    �    ..Xor.com             920

    ......
    ..
    .  Little History
    . ................
    .
    .   +   Added.
    .   *   Changed.
    .   o   Who knows when/where it comes from?
    .   -   Stirpped bug.
    .
    .  Version
    .   0.01   o Unknow version. :-)
    .   0.50   o Detect in memory.
    .          o Encrypt. (only .enc files)
    .          o Decrypt. (idem)
    .          + Uninstall.
    .          + Full asm code.
    .          + Screen messages.
    .          + De/Coding flag in screen.
    .          + Little parameters checker.
    .   0.51   + Little code/var optimization.
    .          - DN int 2fh incompatibility (now use 16h int).
    .          - Some bug with some internal variable.
    .   0.60   + Use file time (don't use .Enc extension).
    .          + /p0 Set Prompt=Off. (Default)
    .              1 Set Prompt=On.
    .          + Ask to crypt a file when the dos goes to create one.
    .          - Can't set prompt if xor is not installed.
    .
    ..
    ......

    ......
    ..
    .   Thanks To
    .  ...........
    .
    .   .Woody, for the help gived.
    .   .FidoNet.
    .   .Borland, for the BP 7.0 & TAsm.
    .   .Norton, for the Norton Guides.
    .   .
    .   ...
    .
    ..
    ......
    �EoF�
