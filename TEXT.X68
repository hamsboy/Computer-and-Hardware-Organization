*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $00009000
START:
    JSR       (A0)
    JSR       $1234
    JSR       $12345678
    JSR       label1
    JSR       label2
    JSR       label3

      NOP
     NOT.L  D7
     
     NOP
     MOVE.B   #$AB,D7
     MOVE.L  A0,D7  
     MOVEA.L A2,A3               ; first instruction of program
     MOVE.B  (A1),D7
     MOVE.W  (A2)+,D7
     MOVE.L  -(A3),D7
      MOVE.W   #$100E,D7
     MOVE.W  D5,D7
     MOVE.L  D6,D7
     NOT.L D5
     MOVE.L  D7,D7
     MOVE.L   #$100E0005,D7
     MOVE.L  D4,D7
label1
label2
label3    
* Put program code here

    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
