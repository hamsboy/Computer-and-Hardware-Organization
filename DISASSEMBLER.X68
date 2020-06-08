
     ORG    $1000
START:                  ; first instruction of program
;starting adress
        LEA     MESSAGE,A1
        MOVE.L  #14,D0
        TRAP    #15
        CLR.L   D0
        CLR.L   D1
        CLR.L   D2  
        CLR.L   D3
        CLR.L   D4
        CLR.L   D5
        CLR.L   D6  
        CLR.L   D7
       
        MOVE.L  #2,D0      
        Trap    #15        
                           
                               
        MOVE.L  (A1)+,D2
        JSR   ASCITOHEX
        MOVEA.L D3,A2
        
        CLR.L   D3
        CLR.L   D2
        CLR.L   D7
        ;ending adress
        LEA     MESSAGE2,A1
        MOVE.L  #14,D0
        TRAP    #15
       
        MOVE.L  #2,D0     
        Trap    #15 
        MOVE.L  (A1)+,D2  
        JSR    ASCITOHEX  
        MOVEA.L D3,A6
        
        
        CLR.L   D0
        CLR.L   D1
        CLR.L   D2  
        CLR.L   D3
        CLR.L   D4
        CLR.L   D5
        CLR.L   D6  
        CLR.L   D7
        MOVE.L A2,D1

        BRA MAIN 
      
        
 
   *ASCII Character Decompiler
ASCITOHEX LSL.L   #4,D3       *Rotate for the next hexa number.
        ROL.L   #8,D2
        ADD.B   #$1,D7
        JSR     PARSE
        CMP.L   #$FFFFFFFF,D2   *This determines if I'm done
        BNE     ASCITOHEX
        CMP.B    #$8,D7
        BEQ     ENDCONVERTING
        MOVE.L  D3,D1
        MOVE.L  (A1)+,D2
        
        *Increment to check second half of the string
        BRA     ASCITOHEX
        
ENDCONVERTING   RTS

        

        
PARSE   
        CMP.B   #$30,D2
        BEQ     NUMBER_0
        CMP.B   #$31,D2
        BEQ     NUMBER_1
        CMP.B   #$32,D2
        BEQ     NUMBER_2
        CMP.B   #$33,D2
        BEQ     NUMBER_3
        CMP.B   #$34,D2
        BEQ     NUMBER_4
        CMP.B   #$35,D2
        BEQ     NUMBER_5
        CMP.B   #$36,D2
        BEQ     NUMBER_6
        CMP.B   #$37,D2
        BEQ     NUMBER_7
        CMP.B   #$38,D2
        BEQ     NUMBER_8
        CMP.B   #$39,D2
        BEQ     NUMBER_9
 
        CMP.B   #$41,D2
        BEQ     LETTER_A
        CMP.B   #$42,D2
        BEQ     LETTER_B
        CMP.B   #$43,D2
        BEQ     LETTER_C
        CMP.B   #$44,D2
        BEQ     LETTER_D
        CMP.B   #$45,D2
        BEQ     LETTER_E
        CMP.B   #$46,D2
        BEQ    LETTER_F
       
        CMP.B   #$61,D2
        BEQ     LETTER_A
        CMP.B   #$62,D2
        BEQ     LETTER_B
        CMP.B   #$63,D2
        BEQ     LETTER_C
        CMP.B   #$64,D2
        BEQ     LETTER_D
        CMP.B   #$65,D2
        BEQ     LETTER_E
        CMP.B   #$66,D2
        BEQ     LETTER_F
                               
                                
    	LEA 	BadAddr,A1
    	MOVE.B  #14,D0      	
    	TRAP	#15         
        MOVE.L  #$01000000, SP  *Reset the stack pointer
        BRA     START           *Go back to the beginning; start over
         
NUMBER_0   ADD.B     #$00,D3
           MOVE.B    #$FF,D2
           RTS
NUMBER_1   ADD.B     #$01,D3
           MOVE.B    #$FF,D2
           RTS
NUMBER_2   ADD.B     #$02,D3
           MOVE.B    #$FF,D2
           RTS
NUMBER_3   ADD.B     #$03,D3
           MOVE.B    #$FF,D2
           RTS
NUMBER_4   ADD.B     #$04,D3
           MOVE.B    #$FF,D2
           RTS
NUMBER_5   ADD.B     #$05,D3
           MOVE.B    #$FF,D2
           RTS
NUMBER_6   ADD.B     #$06,D3
           MOVE.B    #$FF,D2
           RTS
NUMBER_7   ADD.B     #$07,D3
           MOVE.B    #$FF,D2
           RTS
NUMBER_8   ADD.B     #$08,D3
           MOVE.B    #$FF,D2
           RTS
NUMBER_9   ADD.B     #$09,D3
           MOVE.B    #$FF,D2
           RTS
LETTER_A   ADD.B     #$0A,D3
           MOVE.B    #$FF,D2
           RTS
LETTER_B   ADD.B     #$0B,D3
           MOVE.B    #$FF,D2
           RTS
LETTER_C   ADD.B     #$0C,D3
           MOVE.B    #$FF,D2
           RTS
LETTER_D   ADD.B     #$0D,D3
           MOVE.B    #$FF,D2
           RTS
LETTER_E   ADD.B     #$0E,D3
           MOVE.B    #$FF,D2
           RTS
LETTER_F   ADD.B     #$0F,D3
           MOVE.B    #$FF,D2
           RTS

                
        
        







HEXTOASCII   MOVEM.L   D0-A7,-(SP)     *Save the state of the calling code
        *MANAGE output
            LEA      HEXSIGN,A1  *load dollar sign  
            MOVE.B   #14,D0       *load text-out command
            TRAP     #15          *call trap #15 to output
            LEA      DATA,A1   *load the place for data; Don't worry, trap #15 will still read the byte afterward, and get the null.
        
          
            CLR.L   D1
            CLR.B   D2
        
CONVERTTOASCII
        *Prepare the data to be analized.
        MOVE.L  D4,D2         *copy our working value to D2
        ROL.L   #4,D2         *This is how we get the correct bits in place.
        ANDI.B  #$0F,D2       *mask out the greatest 4 bits of that, because we only focus on the least 4 at any time
        
        *characters
        CMP.B   #$00,D2
        BEQ     NUMBER0   
        CMP.B   #$01,D2
        BEQ     NUMBER1
        CMP.B   #$02,D2
        BEQ     NUMBER2
        CMP.B   #$03,D2
        BEQ     NUMBER3
        CMP.B   #$04,D2
        BEQ     NUMBER4
        CMP.B   #$05,D2
        BEQ     NUMBER5
        CMP.B   #$06,D2
        BEQ     NUMBER6
        CMP.B   #$07,D2
        BEQ     NUMBER7
        CMP.B   #$08,D2
        BEQ     NUMBER8
        CMP.B   #$09,D2
        BEQ     NUMBER9
        CMP.B   #$0A,D2
        BEQ     LETTERA
        CMP.B   #$0B,D2
        BEQ     LETTERB
        CMP.B   #$0C,D2
        BEQ     LETTERC
        CMP.B   #$0D,D2
        BEQ     LETTERD
        CMP.B   #$0E,D2
        BEQ     LETTERE
        CMP.B   #$0F,D2
        BEQ     LETTERF
        
ISHEXTOASCIIDONE
        TRAP     #15          *Output DATA
        
        
        LSL.L   #4,D4         *Shif the data over 1 byte, so we can look at the next number.
        ADDI.B  #1,D1         *increment H2CLOOP counter
        CMP.B   D5,D1         *Are we done, yet?
        BGT    ENDHEXTOASCII      *End, if we are.
        BRA    CONVERTTOASCII     *Keep going, if we are not.

ENDHEXTOASCII  
        ;PRINT EMPTY LINE ROMOVE THIS LATTER
       
        MOVEM.L (SP)+,D0-A7     *Restore the state of the calling code
        RTS                     *Go back to the calling code.




NUMBER0     MOVE.B    #$30,DATA
             BRA      ISHEXTOASCIIDONE
NUMBER1     MOVE.B    #$31,DATA
             BRA       ISHEXTOASCIIDONE
NUMBER2     MOVE.B    #$32,DATA
             BRA      ISHEXTOASCIIDONE
NUMBER3     MOVE.B    #$33,DATA
             BRA       ISHEXTOASCIIDONE
NUMBER4     MOVE.B    #$34,DATA
             BRA       ISHEXTOASCIIDONE
NUMBER5     MOVE.B    #$35,DATA
             BRA       ISHEXTOASCIIDONE
NUMBER6     MOVE.B    #$36,DATA
             BRA       ISHEXTOASCIIDONE
NUMBER7     MOVE.B    #$37,DATA
             BRA       ISHEXTOASCIIDONE
NUMBER8     MOVE.B    #$38,DATA
             BRA       ISHEXTOASCIIDONE
NUMBER9     MOVE.B    #$39,DATA
             BRA       ISHEXTOASCIIDONE
LETTERA     MOVE.B    #$41,DATA
             BRA      ISHEXTOASCIIDONE
LETTERB     MOVE.B    #$42,DATA
             BRA       ISHEXTOASCIIDONE
LETTERC     MOVE.B    #$43,DATA
             BRA       ISHEXTOASCIIDONE
LETTERD     MOVE.B    #$44,DATA
             BRA       ISHEXTOASCIIDONE
LETTERE     MOVE.B    #$45,DATA
             BRA       ISHEXTOASCIIDONE
LETTERF    MOVE.B     #$46,DATA
             BRA       ISHEXTOASCIIDONE




GET_EA_NUMBER            *register NUMBER
        CMP.B   #$00,D5
        BEQ     EANUMBER0
        CMP.B   #$01,D5
        BEQ    EANUMBER1
        CMP.B   #$02,D5
        BEQ     EANUMBER2
        CMP.B   #$03,D5
        BEQ    EANUMBER3
        CMP.B   #$04,D5
        BEQ    EANUMBER4
        CMP.B   #$05,D5
        BEQ     EANUMBER5
        CMP.B   #$06,D5
        BEQ     EANUMBER6
        CMP.B   #$07,D5
        BEQ     EANUMBER7
        RTS

EANUMBER0 LEA     PRINT0,A1
        MOVE.L  #14,D0
        TRAP    #15 
        RTS

EANUMBER1 LEA     PRINT1,A1
        MOVE.L  #14,D0
        TRAP    #15 
        RTS
        
EANUMBER2 LEA     PRINT2,A1
        MOVE.L  #14,D0
        TRAP    #15 
        RTS
        
EANUMBER3 LEA     PRINT3,A1
        MOVE.L  #14,D0
        TRAP    #15 
        RTS

EANUMBER4 LEA     PRINT4,A1
        MOVE.L  #14,D0
        TRAP    #15 
        RTS
        
EANUMBER5 LEA     PRINT5,A1
        MOVE.L  #14,D0
        TRAP    #15 
        RTS
       
EANUMBER6 LEA     PRINT6,A1
        MOVE.L  #14,D0
        TRAP    #15 
        RTS
        
EANUMBER7  LEA     PRINT7,A1
        MOVE.L  #14,D0
        TRAP    #15 
        RTS
        


 ;===========================================MAIN================================================         
           
MAIN    CLR.L   D0
        
        CLR.L   D2  
      
        CLR.L   D4
        CLR.L   D5
        CLR.L   D6  
        CLR.L   D7
        
         LEA  RESULT,A1
         MOVE.B #13,D0
         TRAP  #15
         
         CMP.B  #30,D3
         BEQ  PRINTNEXTPAGE
         
        
         MOVEA.L  D1,A0
         ADDI.L   #$2,D1
         
         ADDI.L   #1,D3
         
         CMPA.L A6,A0
         BGE     FINISH
         CMP.B  #30,D3
         BEQ  PRINTNEXTPAGE
         ;PRINT ADDRESS
         MOVE.L   A0,D4
         MOVE.B #$7,D5
         JSR  HEXTOASCII
         
         
         LEA  PRINTTAB,A1
         MOVE.B #14,D0
         TRAP  #15
         
         
         ;PRINT CONTENT
         MOVE.L (A0),D4
         JSR  HEXTOASCII
         
         LEA  PRINTTAB,A1
         MOVE.B #14,D0
         TRAP  #15
         
         ;-------DECOMPILING
         ;-------MOVE----------------------
         MOVE.L D4,D7
         ANDI.L  #$F0000000,D7
         
        
         
         
         ;MOVE
         
         CMP.L   #$10000000,D7
         BEQ   MOVEBYTE
         
         CMP.L  #$30000000,D7
         BEQ   MOVEWORD
         
         CMP.L  #$20000000,D7
         BEQ    MOVELONG
         ;
         CMP.L  #$40000000,D7
         BEQ    _0100
         
         ;
         CMP.L  #$50000000,D7
         BEQ    _0101
         ;ALL BRANCHES BCC
         CMP.L  #$60000000,D7
         BEQ    _0110
         ;
         CMP.L  #$70000000,D7
         BEQ    _0111
         ;
         CMP.L  #$80000000,D7
         BEQ    _1000
         
          CMP.L  #$90000000,D7
         BEQ    _1001
         
         CMP.L  #$C0000000,D7
         BEQ    _1100
         
          CMP.L  #$D0000000,D7
          BEQ    _1101
          ;ALL SHIFT AND ROTION OPERATIONS
          CMP.L  #$E0000000,D7
          BEQ    _1110



         
          BRA BADADDRESS




PRINTNEXTPAGE  LEA     NEXTMESSAGE,A1
               MOVE.L  #14,D0
               TRAP    #15
               MOVE.L D1,D2
               MOVE.L  #5,D0     
               Trap    #15 
               MOVE.L D1,D3
               MOVE.L D2,D1
               SUBI.L   #$2,D1
               CMP.B #$D,D3
               BEQ   NEXTPAGE
               
               CMP.B #$51,D3
               BEQ    START
               
               CMP.B #$71,D3
               BEQ  START


              
              
NEXTPAGE  CLR.L D3
          BRA MAIN              
 
 ;----------------NOP*,NOT*,RTS*,JSR*,MOVEM,LEA*------------------    
_0100 MOVE.L  D4,D7
      ;NOP
      ANDI.L  #$FFFF0000,D7
      CMP.L   #$4E710000 ,D7
      BEQ   _0100NOP
      
      CMP.L  #$4E750000,D7
      BEQ    _RTS
    
      ;NOT
      MOVE.L  D4,D7
      ANDI.L  #$FF000000,D7
      CMP.L   #$46000000 ,D7
      BEQ   _0100NOT
      ;JSR
      MOVE.L  D4,D7
      ANDI.L  #$FF800000,D7
      CMP.L   #$4E800000 ,D7
      BEQ   _0100JSR
      
      ;lEA
       MOVE.L  D4,D7
      ANDI.L  #$F1C00000,D7
      CMP.L   #$41C00000,D7
      BEQ   _0100LEA
      
      
      ;MOVEM
      MOVE.L  D4,D7
      ANDI.L  #$F8000000,D7
      CMP.L   #$48000000,D7
      BEQ   _0100MOVEM

      
      
      BRA BADADDRESS
;-------------------------RTS--------
_RTS LEA PRINTRTS,A1
     MOVE.B #14,D0
     TRAP #15
     BRA  MAIN
;-----------MOVEM
_0100MOVEM  



;----------LEA
_0100LEA  lEA PRINTLEA,A1
          MOVE.B #14,D0
          TRAP #15
          MOVE.B #$5,D2
         MOVE.L  D4,D7
         ANDI.L  #$00380000,D7
         CMP.L   #$41C00000,D7
         BRA  SOURCEADDRESS  
         
          
FINISHLEA      LEA PRINTCOMMA,A1
               MOVE.B #14,D0
               TRAP #15 
  
               MOVE.L D6,D5 
               ANDI.L #$0E000000,D5
               ROL.L  #7,D5
              
               
               LEA PRINTA,A1
               MOVE.B #14,D0
               TRAP #15
               
               JSR GET_EA_NUMBER 
               CLR.L D2
               BRA MAIN         



      
 
 
 ;---JSR
 
_0100JSR  LEA PRINTJSR,A1
           MOVE.B #14,D0
           TRAP #15
           MOVE.B #$2,D2
           BRA  SOURCEADDRESS  

;-----------NOT

_0100NOT   LEA PRINTNOT,A1
           MOVE.B #14,D0
           TRAP #15
           
         MOVE.L  D4,D7
         ANDI.L  #$00C00000,D7
         ROL.L   #8,D7
         ROL.L   #2,D7
         
         CMP.B   #$00,D7
         BEQ   _0100NOTBYTE
         
         CMP.B   #$01,D7
         BEQ   _0100NOTWORD
         
         CMP.B   #$02,D7
         BEQ   _0100NOTLONG
         
_0100NOTBYTE  JSR _PRINTBYTE
             MOVE.B #$2,D2
             BRA  SOURCEADDRESS  
              
          

             
_0100NOTWORD   JSR _PRINTWORD
              MOVE.B #$2,D2
             BRA  SOURCEADDRESS        
          
_0100NOTLONG  JSR _PRINTLONG
              MOVE.B #$2,D2
              BRA  SOURCEADDRESS
  
  ;-------NOP       
_0100NOP   LEA PRINTNOP,A1
           MOVE.B #14,D0
           TRAP #15
           BRA MAIN
           
    ;--------PRINT SIZE       
_PRINTBYTE LEA PRINTBYTE,A1
          MOVE.B #14,D0
          TRAP #15
          RTS
           
_PRINTWORD LEA PRINTWORD,A1
          MOVE.B #14,D0
          TRAP #15
          RTS
           
_PRINTLONG LEA PRINTLONG,A1
          MOVE.B #14,D0
          TRAP #15
          RTS
;-----------------------------------------------------------     
   
;--------------------------ADDQ,
_0101 LEA PRINTADDQ,A1
      MOVE.B #14,D0
      TRAP #15
      
      MOVE.L  D4,D7
      ANDI.L  #$00C00000,D7
      
      
      CMP.L   #$00000000 ,D7
      BEQ    _0101ADDQBYTE
      
      CMP.L   #$00400000 ,D7
      BEQ    _0101ADDQWORD
      
      CMP.L   #$00800000 ,D7
      BEQ     _0101ADDQLONG
      
      BRA MAIN

_0101ADDQBYTE JSR _PRINTBYTE
              BRA _0101MAIN
   ;MAIN           
_0101MAIN   LEA PRINTHASTAG,A1
            MOVE.B #14,D0
            TRAP #15
            
*            LEA HEXSIGN,A1
*            MOVE.B #14,D0
*            TRAP #15

            MOVE.L D4,D5
            ANDI.L #$0E000000,D5
            ROL.L  #7,D5
            CMP.L  #$00000000,D5
            BEQ PRINT_8
           
             JSR GET_EA_NUMBER 
              CLR.L D2
              
            LEA PRINTCOMMA,A1
            MOVE.B #14,D0
            TRAP #15
            BRA SOURCEADDRESS  
             
PRINT_8 LEA PRINT8,A1
        MOVE.B #14,D0
        TRAP #15
        CLR.L D2
         LEA PRINTCOMMA,A1
        MOVE.B #14,D0
        TRAP #15

        BRA SOURCEADDRESS 
        
_0101ADDQWORD JSR _PRINTWORD
              BRA _0101MAIN
_0101ADDQLONG JSR _PRINTLONG
              BRA _0101MAIN

;------------------    



;--------------------------BRA,Bcc
_0110   MOVE.L  D4,D7
        ANDI.L  #$0F000000,D7
        
        CMP.L   #$07000000,D7
        BEQ     _0110BEQ
        
        CMP.L   #$0E000000,D7  *Compare for BGT
        BEQ     _0110BGT
      
        CMP.L   #$0F000000,D7
        BEQ     _0110BLE
        
        CMP.L   #$00000000,D7
        BEQ     _0110BRA
        
        BRA     BADADDRESS
        
_0110BRA LEA     PRINTBRA,A1  
        MOVE.L  #14,D0
        TRAP    #15
        BRA     DISPLACEMENT  

        
_0110BGT LEA     PRINTBGT,A1  
        MOVE.L  #14,D0
        TRAP    #15
        BRA     DISPLACEMENT
  

_0110BLE LEA     PRINTBLE,A1  
        MOVE.L  #14,D0
        TRAP    #15
        BRA     DISPLACEMENT

   
_0110BEQ LEA     PRINTBEQ,A1  
        MOVE.L  #14,D0
        TRAP    #15
        BRA    DISPLACEMENT
       
    *Branch displacement 
DISPLACEMENT
       * ADDI.L  #2,D1
        MOVE.L  D4,D7
        ANDI.L  #$00FFFF00,D7
        
        CMP.L   #$00000000,D7
        BEQ     POSITIVE_DISPLACEMENT
        MOVE.L  D4,D7
        ANDI.L  #$00FF0000,D7
        CMP.L   #$00000000,D7
        BEQ     NEGATIVE_DISPLACEMENT
        
        
        
        MOVE.L  D4,D7
        ANDI.L  #$00FF0000,D7
        ROR.L #8,D7
        ROR.L #8,D7
        MOVE.L D1,D6
        MOVE.L  D1,D4
        ADD.B D7,D6
        AND.L  #$000000FF,D6
        MOVE.W D6,D4
        MOVE.B #$7,D5
        JSR  HEXTOASCII
      
        BRA     MAIN
POSITIVE_DISPLACEMENT
        MOVE.L  D4,D7
        ANDI.L  #$0000FFFF,D7
        MOVE.L D1,D6
        MOVE.L  D1,D4
        ADD.W D7,D6
        AND.L  #$0000FFFF,D6
        MOVE.W D6,D4
        
       MOVE.B #$7,D5
       JSR  HEXTOASCII
       ADDI.L  #2,D1
       BRA     MAIN
       
NEGATIVE_DISPLACEMENT
       MOVE.L  D4,D7
       ANDI.L  #$0000FFFF,D7
       MOVE.L D1,D6
       MOVE.L  D1,D4
       ADD.W D7,D6
       AND.L  #$0000FFFF,D6
       MOVE.W D6,D4
       

       MOVE.B #$7,D5
       JSR  HEXTOASCII
       ADDI.L  #2,D1
       BRA     MAIN

     
        
        
WORD_DISPLACEMENT
        MOVE.B #$3,D5
        MOVEA.L D1,A0
        MOVE.W  (A0),D4
        MOVE.L  D4,D7
        MOVE.L  D1,D6
        ADD.L   D7,D6
        ADDI.L  #4,D6
        MOVE.L D6,D4
        JSR  HEXTOASCII
        ADDI.L  #4,D1
        BRA     MAIN


LONG_DISPLACEMENT
        MOVE.B #$7,D5
        ADDI.L  #2,D1
        MOVEA.L D1,A0
        MOVE.L  (A0),D4
        MOVE.L  D4,D7
        MOVE.L  D1,D6
        ADD.L   D7,D6
        ADDI.L  #4,D6
        JSR  HEXTOASCII
        MOVE.L D6,D4
        ADDI.L  #6,D1
        BRA    MAIN
;------------------   ----------------------------------------------------



;--------------------------MOVEQ,
_0111   LEA PRINTMOVEQ,A1
        MOVE.B #14,D0
        TRAP #15
        
        LEA PRINTHASTAG,A1
        MOVE.B #14,D0
        TRAP #15
        
        MOVE.L D4,D6
        
        
        MOVE.B #$1,D5
        LSL.L  #$8,D4
        JSR  HEXTOASCII
        
        MOVE.L D6,D5
        ANDI.L #$0E000000,D5
        ROL.L  #7,D5
        
        
        
        
        LEA PRINTCOMMA,A1
        MOVE.B #14,D0
        TRAP #15
        
        LEA PRINTD,A1
        MOVE.B #14,D0
        TRAP #15
        JSR GET_EA_NUMBER 
        CLR.L D2
        
        BRA MAIN
        
        
        

;------------------  

;--------------------------,OR
_1000 LEA PRINTOR,A1
      MOVE.B #14,D0
      TRAP #15
      BRA _SUPERMAIN 
      
      
_SUPERMAIN  MOVE.L  D4,D7
      ANDI.L  #$01C00000,D7
      ROR.L   #6,D7
      
      CMP.L   #$00000000,D7
      BEQ     _1000ORBYTE

	  CMP.L   #$00040000,D7
      BEQ     _1000ORBYTE2
      
      CMP.L   #$00010000,D7
      BEQ     _1000ORWORD
      
      CMP.L   #$00050000,D7
      BEQ     _1000ORWORD2
	
	  CMP.L   #$00020000,D7
      BEQ     _1000ORLONG
	
	 CMP.L   #$00060000 ,D7
     BEQ     _1000ORLONG2
     
     CMP.L   #$00030000,D7
     BEQ     _1000ORWORD
      

	 CMP.L   #$00070000,D7
     BEQ     _1000ORLONG

;<EA> ,DN
_1000ORBYTE JSR _PRINTBYTE
             MOVE.L #$50000000,D2
             MOVE.B #$10,D2
             BRA SOURCEADDRESS 
              

_1000ORWORD JSR _PRINTWORD
            MOVE.L #$60000000,D2
            MOVE.B #$10,D2
            BRA SOURCEADDRESS 
           
          

_1000ORLONG  JSR _PRINTLONG
            MOVE.L #$70000000,D2
            MOVE.B #$10,D2
            BRA SOURCEADDRESS 



_1000MAIN2 
          MOVE.L  D4,D7
          ANDI.L  #$01C00000,D7
          ROR.L   #6,D7
          
          CMP.L   #$00030000,D7
          BEQ      FINISHADDA

	      CMP.L   #$00070000,D7
          BEQ     FINISHADDA

           LEA PRINTCOMMA,A1
           MOVE.B #14,D0
           TRAP #15
           LEA PRINTD,A1
           MOVE.B #14,D0
           TRAP #15
             
           MOVE.L D4,D5
           ANDI.L #$0E000000,D5
           ROL.L  #7,D5  
           
           JSR GET_EA_NUMBER 
           CLR.L D2
           BRA MAIN 
           
FINISHADDA LEA PRINTCOMMA,A1
           MOVE.B #14,D0
           TRAP #15
           LEA PRINTA,A1
           MOVE.B #14,D0
           TRAP #15
             
           MOVE.L D4,D5
           ANDI.L #$0E000000,D5
           ROL.L  #7,D5  
           
           JSR GET_EA_NUMBER 
           CLR.L D2
           BRA MAIN            
            
FINISHOR    BRA _1000MAIN2

;DN,<EA>          
_1000MAIN  LEA PRINTD,A1
           MOVE.B #14,D0
           TRAP #15
             
           MOVE.L D4,D5
           ANDI.L #$0E000000,D5
           ROL.L  #7,D5  
           
           JSR GET_EA_NUMBER 
           CLR.L D2
           
           LEA PRINTCOMMA,A1
           MOVE.B #14,D0
           TRAP #15
           
           BRA SOURCEADDRESS              


_1000ORBYTE2 JSR _PRINTBYTE
             BRA _1000MAIN
_1000ORWORD2 JSR _PRINTWORD
             BRA _1000MAIN

_1000ORLONG2  JSR _PRINTLONG
              BRA _1000MAIN

;------------------ 


;--------------------------SUB,
_1001 LEA PRINTSUB,A1
      MOVE.B #14,D0
      TRAP #15
      
       BRA _SUPERMAIN 

;------------------ 


;-------------------------- AND
_1100 LEA PRINTAND,A1
      MOVE.B #14,D0
      TRAP #15
      BRA _SUPERMAIN 
;------------------ 


;--------------------------ADD, ADDA--------------------------------------
_1101 MOVE.L  D4,D7
      ANDI.L  #$01C00000,D7
      ROR.L   #6,D7
      
      CMP.L   #$00030000,D7
      BEQ     _1101ADDA
      
	  CMP.L   #$00070000,D7
      BEQ     _1101ADDA
      

      LEA PRINTADD,A1
      MOVE.B #14,D0
      TRAP #15
      BRA _SUPERMAIN 
      

_1101ADDA  LEA PRINTADDA,A1
           MOVE.B #14,D0
           TRAP #15
           BRA _SUPERMAIN 
      
;------------------ ---------------------------------------------------------------------------


;--------------------------LSL, LSR,ASR,ASL,ROL,ROR-------------------------------------------------------------------------
_1110 MOVE.L  D4,D7
      ;ROM
      ANDI.L  #$FEC00000,D7
      CMP.L   #$E6C00000 ,D7
      BEQ   _1110ROM
      
      ;ASM
      MOVE.L  D4,D7
      ANDI.L  #$FEC00000,D7
      CMP.L   #$E0C00000 ,D7
      BEQ   _111ASM
      
      ;LSM
      MOVE.L  D4,D7
      ANDI.L  #$FEC00000,D7
      CMP.L   #$E2C00000 ,D7
      BEQ   _1110LSM
      
      ;--REGISTER SHIFTING
      ;AS REGISTER
      MOVE.L  D4,D7
      ANDI.L  #$00180000,D7
      CMP.L   #$00000000 ,D7
      BEQ   _1110AS_R
      ;LS REGISTER
        MOVE.L  D4,D7
      ANDI.L  #$00180000,D7
      CMP.L   #$00080000 ,D7
      BEQ   _1110LS_R
      
      ;RO  REGISTER
      MOVE.L  D4,D7
      ANDI.L  #$00180000,D7
      CMP.L   #$00180000 ,D7
      BEQ   _1110RO_R

      
      
      BRA BADADDRESS
      
  ;-------AS REGISTER    
_1110AS_R  LEA PRINTAS,A1  
          JSR _1110COMPARE 
           BEQ _1110AS_R_R
           
          JSR PRINTLEFT
          ;---------
          BRA _1110_SIZE

          

          
_1110AS_R_BYTE JSR _PRINTBYTE
               BRA _1110MAIN  

              
              
               
               
              

_1110MAIN      MOVE.L  D4,D7
               ANDI.L  #$00200000,D7
               CMP.L   #$00000000 ,D7
               BEQ   _1110DATA
               
               LEA PRINTD,A1
               MOVE.B #14,D0
               TRAP #15
               
               MOVE.L D4,D5
               ANDI.L #$0E000000,D5
               ROL.L  #7,D5
               JSR GET_EA_NUMBER 
               
               BRA END_REGISTER_SHIFT
                            
END_REGISTER_SHIFT 
        LEA PRINTCOMMA,A1
        MOVE.B #14,D0
        TRAP #15
        
        LEA PRINTD,A1
        MOVE.B #14,D0
        TRAP #15
        
       MOVE.L D4,D5
       ANDI.L #$00070000,D5
       ROR.L  #8,D5
       ROR.L  #8,D5
       JSR GET_EA_NUMBER 
       
       BRA MAIN 
        
        
               

_1110DATA  MOVE.L D4,D5
           ANDI.L #$0E000000,D5
           ROL.L  #7,D5
           CMP.L  #$00000000,D5
           BEQ PRINT_COUNT_REGISTER
           
           JSR GET_EA_NUMBER 
           BRA END_REGISTER_SHIFT
           
           

PRINT_COUNT_REGISTER  LEA PRINT8,A1
                      MOVE.B #14,D0
                      TRAP #15
        
                      BRA END_REGISTER_SHIFT

       
_1110AS_R_WORD  JSR _PRINTWORD
                BRA _1110MAIN  

_1110AS_R_LONG  JSR _PRINTLONG 
                BRA _1110MAIN     
          
          
                  
_1110AS_R_R JSR PRINTRIGHT
            BRA _1110_SIZE



_1110_SIZE  MOVE.L  D4,D7
          ANDI.L  #$00C00000,D7
          CMP.L   #$00000000 ,D7 
          BEQ _1110AS_R_BYTE
          
          CMP.L   #$00400000 ,D7 
          BEQ _1110AS_R_WORD
          
          CMP.L   #$00800000 ,D7 
          BEQ _1110AS_R_LONG
          BRA BADADDRESS
;-- LS REGISTER
_1110LS_R  LEA PRINTLS,A1  
           JSR _1110COMPARE 
           BEQ _1110AS_R_R
           
          JSR PRINTLEFT
          ;---------
          BRA _1110_SIZE



;----RO REGISTER
_1110RO_R  LEA PRINTRO,A1  
          JSR _1110COMPARE 
           BEQ _1110AS_R_R
           
          JSR PRINTLEFT
          ;---------
          BRA _1110_SIZE



 

_1110COMPARE  
          MOVE.B #14,D0
          TRAP #15
          MOVE.L  D4,D7
          ANDI.L  #$01000000,D7
          CMP.L   #$00000000 ,D7  
          RTS       
;---MEMORY SHIFTING AND ROTATION     
_1110ROM  LEA PRINTRO,A1
          JSR _1110COMPARE 
          BEQ _1110ROM_R
          
          JSR PRINTLEFT
          JSR SOURCEADDRESS  

_1110ROM_R  JSR PRINTRIGHT
           CLR.L D2
           JSR SOURCEADDRESS
           
_111ASM   LEA PRINTAS,A1
          JSR _1110COMPARE 
          BEQ _1110ASM_R
          
          JSR PRINTLEFT
          JSR SOURCEADDRESS  

_1110ASM_R JSR PRINTRIGHT
           CLR.L D2
           JSR SOURCEADDRESS


_1110LSM  LEA PRINTLS,A1
                     
          JSR _1110COMPARE  
          BEQ _1110LSM_R
          
          JSR PRINTLEFT
          JSR SOURCEADDRESS  

_1110LSM_R  JSR PRINTRIGHT
           CLR.L D2
           JSR SOURCEADDRESS
           
       
PRINTLEFT LEA PRINTL,A1
          MOVE.B #14,D0
          TRAP #15
          CLR.L D2
          RTS
       
PRINTRIGHT LEA PRINTR,A1
          MOVE.B #14,D0
          TRAP #15
          CLR.L D2
          RTS
;----------------------------------------------------------------------------------------------------------- 
         
         
  ;_LEA   LEA PRINTLEA,A1
       ;MOVE.B #14,D0
       ; #15
       ;BRA MAIN
      
MOVEBYTE  LEA PRINTMOVE,A1
          MOVE.B #14,D0
          TRAP #15
          
          MOVE.L #$50000000,D2
          JSR _PRINTBYTE
          
          BRA MOVEEA
          
MOVEWORD  LEA PRINTMOVE,A1
          MOVE.B #14,D0
          TRAP #15
           MOVE.L #$60000000,D2
          JSR _PRINTWORD
          BRA MOVEEA
          
MOVELONG  LEA PRINTMOVE,A1
          MOVE.B #14,D0
          TRAP #15
          
          MOVE.L #$70000000,D2
          JSR _PRINTLONG
          BRA   MOVEEA


;==========================================================EFFECTIVE ADDRESS================================

MOVEEA 
        
        
        MOVE.B #$1,D2
        
        BRA SOURCEADDRESS  
        
SOURCEADDRESS  
        MOVE.L  D4,D6
        MOVE.L D4,D7
        MOVE.L D4,D5
        ANDI.L #$00070000,D5
        ROR.L  #8,D5
        ROR.L  #8,D5
        
        ANDI.L #$00380000,D7
        ROR.L  #3,D7             
        CMP.L  #$00000000,D7
        BEQ  MOVE_SOURCE_D   

        CMP.L  #$00010000,D7
        BEQ  MOVE_SOURCE_ADDRESS
        
        CMP.L  #$00020000,D7
        BEQ  MOVE_SOURCE_A
        
        CMP.L  #$00030000,D7
        BEQ  MOVE_SOURCE_A_PLUS
        
        CMP.L  #$00040000,D7
        BEQ  MOVE_SOURCE_A_MINUS 
        
        CMP.L  #$00070000,D7
        BEQ  MOVE_SOURCE_DATA
        
        BRA BADADDRESS
        
       

MOVEEA_D 
         LEA PRINTCOMMA,A1
         MOVE.B #14,D0
         TRAP #15
         ADDI.B #$1,D2
         MOVE.L D4,D7
        
        MOVE.L D4,D5
        ANDI.L #$0E000000,D5
        ROL.L  #7,D5
        
        
        ANDI.L #$01C00000,D7
        
        CMP.L  #$00000000,D7
        BEQ  MOVE_SOURCE_D   

        
        CMP.L  #$00800000,D7
        BEQ  MOVE_SOURCE_A
        
        CMP.L  #$00C00000,D7
        BEQ  MOVE_SOURCE_A_PLUS
        
        CMP.L  #$01000000,D7
        BEQ  MOVE_SOURCE_A_MINUS 
        
        CMP.L  #$01C00000,D7
        BEQ  MOVE_ABSOLUTE2
        
        BRA BADADDRESS
             

   
MOVE_SOURCE_D  
               LEA PRINTD,A1
               MOVE.B #14,D0
               TRAP #15
               
               JSR GET_EA_NUMBER 
               BRA FINISH_SD
         
MOVE_SOURCE_ADDRESS               
               LEA PRINTA,A1
               MOVE.B #14,D0
               TRAP #15
               
               JSR GET_EA_NUMBER 
               BRA FINISH_SD

           
MOVE_SOURCE_A           
               LEA PRINTOPEN,A1
               MOVE.B #14,D0
               TRAP #15
               
               LEA PRINTA,A1
               MOVE.B #14,D0
               TRAP #15
               
               JSR GET_EA_NUMBER 
               
               LEA PRINTCLOSE,A1
               MOVE.B #14,D0
               TRAP #15
               
                BRA FINISH_SD
MOVE_SOURCE_A_PLUS 
               LEA PRINTOPEN,A1
               MOVE.B #14,D0
               TRAP #15
               LEA PRINTA,A1
               MOVE.B #14,D0
               TRAP #15
               
              
               
               JSR GET_EA_NUMBER 
               
               LEA PRINTCLOSE,A1
               MOVE.B #14,D0
               TRAP #15
               
               LEA PRINTPLUS,A1
               MOVE.B #14,D0
               TRAP #15
               
                BRA FINISH_SD
MOVE_SOURCE_A_MINUS
                              
               LEA PRINTMINUS,A1
               MOVE.B #14,D0
               TRAP #15
               
               LEA PRINTOPEN,A1
               MOVE.B #14,D0
               TRAP #15
               
               LEA PRINTA,A1
               MOVE.B #14,D0
               TRAP #15
               
              
               
               JSR GET_EA_NUMBER 
               
               LEA PRINTCLOSE,A1
               MOVE.B #14,D0
               TRAP #15
               
               BRA FINISH_SD

MOVE_SOURCE_DATA 
                MOVE.L D4,D7
                ANDI.L #$00070000,D7
                CMP.L  #$00000000,D7
                BEQ MOVE_ABSOLUTE  
                
                CMP.L  #$00010000,D7
                BEQ MOVE_ABSOLUTE 
                          
               LEA PRINTHASTAG,A1
               MOVE.B #14,D0
               TRAP #15
               
               MOVEA.L  D1,A0
               MOVE.L   (A0),D4
               
                CMP.L  #$50000010,D2
               BEQ   BYTEDATA
               
               CMP.L  #$60000010,D2
               BEQ   WORDDATA
               
               CMP.L  #$70000010,D2
               BEQ   LONGDATA
               
               CMP.L  #$50000001,D2
               BEQ   BYTEDATA
               
               CMP.L  #$60000001,D2
               BEQ   WORDDATA
               
               CMP.L  #$70000001,D2
               BEQ   LONGDATA
               
               BRA BADADDRESS
                             
               
BYTEDATA  MOVE.B #$1,D5
          LSL.L  #$8,D4
          JSR  HEXTOASCII
           ADDI.L #$2,D1
           MOVE.L  D6,D4
           BRA FINISH_SD

WORDDATA MOVE.B #$3,D5
         JSR  HEXTOASCII
          ADDI.L #$2,D1
           MOVE.L  D6,D4
           BRA FINISH_SD

LONGDATA MOVE.B #$7,D5
          JSR  HEXTOASCII 
          ADDI.L #$4,D1  
          MOVE.L  D6,D4
         BRA FINISH_SD
         
         
         
MOVE_ABSOLUTE  MOVE.L D4,D7  
                               
               MOVEA.L  D1,A0
               MOVE.L   (A0),D4
               ANDI.L  #$00070000,D7 
             
               CMP.L  #$00000000,D7
               BEQ   WORDDATA2
               
               CMP.L  #$00010000,D7
               BEQ   LONGDATA2
               
               BRA BADADDRESS
               
               
MOVE_ABSOLUTE2 
               MOVE.L D4,D7 
               
               MOVEA.L  D1,A0
               MOVE.L   (A0),D4
               ANDI.L  #$0E000000,D7 
             
               CMP.L  #$00000000,D7
               BEQ   WORDDATA2
               
               CMP.L  #$02000000,D7
               BEQ   LONGDATA2
               
               BRA BADADDRESS
                             
WORDDATA2 MOVE.B #$3,D5
         JSR  HEXTOASCII
          ADDI.L #$2,D1
           MOVE.L  D6,D4
           
           BRA FINISH_SD

LONGDATA2 MOVE.B #$7,D5
          JSR  HEXTOASCII 
          ADDI.L #$4,D1  
          MOVE.L  D6,D4
           
         BRA FINISH_SD
          
FINISH_SD 
          CMP.B #$5,D2 ;FINISH LEA
          BEQ  FINISHLEA
          
          CMP.B #$10,D2 ;FINISH OR ,ADD,AND,SUB ADDA
          BEQ  FINISHOR
          CMP.B #$1,D2
          BEQ  MOVEEA_D
          BRA MAIN      
         
          
;-----------destination EA

    

;===============================================================================================================

BADADDRESS LEA PRINTDATA,A1
           MOVE.B #14,D0
           TRAP #15
           
          LEA  PRINTTAB,A1
          MOVE.B #14,D0
          TRAP  #15
          MOVE.B #$3,D5
          JSR  HEXTOASCII
          

          BRA MAIN
           
                   
FINISH   

HEXSIGN DC.B '$',0

*This is for each byte of text output
DATA  DS.B 1
;ENDLINE  DC.B $0D,$0A,0,0



H2CNULL  DC.B 0
    

    
CR      EQU     $0D 
LF      EQU     $0A
MESSAGE DC.W    'Enter a  starting address: ',0
RESULT DC.W    ' ',0
MESSAGE2 DC.W    'Enter an ending   address: ',0
BadAddr DC.W    'Invalid Address!',CR,LF,0
PRINTMOVE  DC.W 'MOVE',0
PRINTBYTE  DC.W '.B   ',0
PRINTWORD  DC.W '.W   ',0
PRINTLONG  DC.W '.L   ',0
PRINTD    DC.W  'D',0
PRINTA DC.W 'A',0
PRINTPLUS DC.W '+',0
PRINTMINUS DC.W '-',0
PRINTOPEN DC.W '(',0
PRINTCLOSE DC.W ')',0
PRINTHASTAG DC.W '#',0
PRINTNOP DC.W 'NOP',0
PRINTNOT DC.W 'NOT',0
PRINTJSR   DC.W 'JSR',0
PRINTLEA  DC.W 'LEA  ',0
;EMPTYLINE DC.W    '  ',CR,LF,0
PRINTDATA DC.W 'DATA',0
PRINTMOVEQ DC.W 'MOVEQ.L ',0
PRINTAS  DC.W 'AS',0
PRINTLS  DC.W 'LS',0
PRINTRO  DC.W 'RO',0
PRINTR  DC.W 'R',0
PRINTL  DC.W 'L',0


PRINTADDQ	DC.W 'ADDQ',0
PRINTOR 	DC.W 'OR',0
PRINTSUB 	DC.W 'SUB',0
PRINTAND	DC.W 'AND',0
PRINTADD	DC.W 'ADD',0
PRINTADDA	DC.W 'ADDA',0
PRINTBGT    DC.W 'BGT',0
PRINTBLE     DC.W 'BLE',0
PRINTBEQ   DC.W  'BEQ',0
PRINTBRA   DC.W    'BRA   ',0
PRINTRTS   DC.W  'RTS',0
;----------------------------NUMBERS-------------------------
PRINT0  DC.W '0',0
PRINT1  DC.W '1',0
PRINT2  DC.W '2',0
PRINT3  DC.W '3',0
PRINT4  DC.W '4',0
PRINT5  DC.W '5',0
PRINT6  DC.W '6',0
PRINT7  DC.W '7',0
PRINT8  DC.W '8',0
PRINTCOMMA  DC.W ',',0
NEXTMESSAGE DC.W 'PRESS ENTER TO PRINT THE NEXT SCREEN OR Q TO EXIT',0
PRINTTAB DC.W  '            ',0


* Put variables and constants here

    END    START        ; last line of source











*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
