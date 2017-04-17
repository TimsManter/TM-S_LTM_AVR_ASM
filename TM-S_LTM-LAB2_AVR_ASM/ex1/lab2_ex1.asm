.include "M32DEF.INC"

; Inicjalizacja portow


CBI DDRA, 0 ; Ustawienie linii PA0 w tryb wejscia
SBI PORTA, 0 ; Podciagniecie linii PA0

LDI R16, 0B11111111 ; Zaladowanie ustawien portu B na tryb wyjscia do rejestru
OUT DDRB, R16 ; Zaladowanie ustawien portu B z rejestru R16

LDI R16, 0B00000000 ; Zaladowanie ustawien portu B na stan niski do rejestru
OUT PORTB, R16 ; Zaladowanie ustawien portu B z rejestru R16

; Koniec inicjalizacji portow

; Wejscie programu w nieskonczona petle
LOOP:

LDI R16, 0B01010101 ; Zaladowanie ustawien portu B na stan wysoki dla diod parzystych do rejestru
SBIS PINA, 0 ; Jesli PD0 ma stan wysoki, pomija nadpisanie rejestru
LDI R16, 0B10101010 ; Zaladowanie ustawien portu B na stan wysoki dla diod nieparzystych do rejestru

OUT PORTB, R16 ; Zaladowanie ustawien portu B z rejestru R16

RJMP LOOP ; Nakazuje powrot do etykiety LOOP
