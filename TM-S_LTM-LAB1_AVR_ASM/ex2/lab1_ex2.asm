.include "M32DEF.INC"

; Inicjalizacja portow

; Ustawienie linii PA7 na wyjœcie
SBI DDRA, 7 ; DDRA: 00000000
; DDRA: 10000000

; Ustawienie stanu linii PA7 na niski
CBI PORTA, 7 ; PORTA: 00000000
; PORTA: 00000000

; Ustawienie linii PD0 na wejscie
CBI DDRD, 0 ; DDRD: 00000000
; DDRD: 00000000

; Podciagniecie linii PD0
SBI PORTD, 0 ; PORT 00000001
; PORT 00000001

; Koniec inicjalizacji portow

; Wejscie programu w nieskonczona petle
LOOP:

CBI PORTA, 7
; PORTA: 00000000

SBIS PIND, 0 ; Jesli PD0 ma stan wysoki, pomija nastepna instrukcje

SBI PORTA, 7 ; Ustawia PA7 na stan wysoki (wlacza LED)
; PORTA: 10000000

rjmp LOOP ; Nakazuje powrot do etykiety LOOP
