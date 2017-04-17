.include "M32DEF.INC"

; Inicjalizacja portow

; Ustawienie linii PA7 na wyjœcie
SBI DDRA, 7; DDRA: 00000000
; DDRA: 10000000

; Ustawienie stanu linii PA7 na wysoki
SBI PORTA, 7 ; PORTA: 00000000
; PORTA: 10000000

; Koniec inicjalizacji portow

; Wejscie programu w nieskonczona petle bez wykonywania operacji
LOOP: ; PORTA: 10000000
rjmp LOOP ; PORTA: 10000000
