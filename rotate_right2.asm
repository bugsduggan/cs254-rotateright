; Tom Leaman cs25410 assignment
; thl5@aber.ac.uk
;
; Rotate right subroutine

; Init
.ORIG x3000

;
; This is just here so I can test it. If it's still here when I hand-in, I am
; a fool and should really pay more attention to what I'm doing, sorry.
;

AND R0, R0, x0000
AND R1, R1, x0000
ADD R0, R0, x0007
ADD R1, R1, x0003

; END OF TEST SETUP

; Check input conditions
; R1 > 0 and R1 < 16

;
; The main loop
;
LOOP AND R2, R2, x0000 ; Zero the LSB flag
     AND R3, R3, x0000 ; Zero the division counter
     AND R2, R0, x0001 ; If the LSB is 1, set R2 = 1, else R2 = 0
     BRnz DIV ; Skip ahead to the division, we don't need to subtract 1
     AND R0, R0, xFFFE ; Decrement R0 ready to divide
; Divide R0 by 2 to move all the bits right
DIV  ADD R3, R3, x0001 ; Increment counter
     ADD R0, R0, xFFFE ; Subtract 2
     BRnp DIV ; Still not zero yet, go and do it again
     AND R0, R3, xFFFF ; Copy R3 into R0
; So now if R2 is positive, we need to add x8000
     AND R2, R2, xFFFF ; Set status registers based on R2
     BRnz FIN ; R2 is not positive, skip ahead
; To set the MSB back to 1, we need to or R0 with x8000
     LD R3, MSBMASK ; Load x8000 into R3
     NOT R0, R0 ; Start the or (X or Y = not(not(x) and not(y))j
     NOT R3, R3
     AND R0, R0, R3
     NOT R0, R0 ; End of or routine
FIN  ADD R1, R1, xFFFF ; Decrement the counter
     BRp LOOP ; If it's > 0, go around again

; Error!
; Set R1 to -1 and return

; Data & end
MSBMASK .FILL x8000
.END
