.include "M32DEF.INC"
.org $0000
	RJMP RESET
.org $0002
	RJMP INTERRUPT

RESET:
; Inicjlizacja portow

	LDI R16, 0b11110000
	OUT DDRA, R16 ; Ustawienie linii wierszy klawiatury na wejscie, linii kolumn klawiatury na wyjscie

	LDI R16, 0b00001111
	OUT PORTA, R16 ; Ustawnienie wyjsc na stan wysoki i podciagniecie wejsc

	LDI R16, 0b11111111
	OUT DDRB, R16 ; Ustawienie linii obslugujacej diody na wyjscie

	CBI DDRD, 2 ; Linia przerwania zewnetrznego usatwiona na wejscie...
	SBI PORTD, 2 ; ...i podciagnieta do zasilania



	LDI R16, (1<<ISC01) ; Przerwanie przy zboczu opadajacym dla INT0
	OUT MCUCR, R16

	LDI R16, (1<<INT0) ; Wlacz przerwanie INT0
	OUT GICR, R16

	SEI ; Wlaczenie przerwan

; Koniec inicjalizacji portow

LOOP:
	RJMP LOOP


INTERRUPT: ; Procedura przerwania
LDI R17, 0 ; Ustawienie poczaczkowej wartosci rejestru stanu wierszy

; Sprawdzanie wiersza, w ktorym nastapilo nacisniecie przycisku
SBIS PINA, 0
	SBR R17, 0b00000001
SBIS PINA, 1
	SBR R17, 0b00000010
SBIS PINA, 2
	SBR R17, 0b00000100
SBIS PINA, 3
	SBR R17, 0b00001000
; Koniec sprawdzania wierszy

CPI R17, 0b00000000 ; Sprawdzenie, czy warotosc sie nie zmienila
BRNE COL ; Jesli tak, skok do procedury sprawdzania kolumn
RETI ; Jesli nie ma zmian (zaden przycisk nie byl wcisniety) wykonanie skoku do petli programu

COL: ; Procedura sprawdzania kolumn
LDI R18, 0 ; Ustawienie poczaczkowej wartosci rejestru stanu kolumn

SBI PORTA, 4 ; Wlaczenie stanu wysokiego linii wiersza, aby mozna bylo okreslic kolumne
	SBIS PINA, 0 ; Sprawdzanie kolejnych kolumn
		SBR R18, 0b00011111
	SBIS PINA, 1
		SBR R18, 0b00011111
	SBIS PINA, 2
		SBR R18, 0b00011111
	SBIS PINA, 3
		SBR R18, 0b00011111
CBI PORTA, 4

SBI PORTA, 5 ; Analogicznie sprawdzanie kolumn dla kolejnego wiersza...
	SBIS PINA, 0
		SBR R18, 0b00101111
	SBIS PINA, 1
		SBR R18, 0b00101111
	SBIS PINA, 2
		SBR R18, 0b00101111
	SBIS PINA, 3
		SBR R18, 0b00101111
CBI PORTA, 5

SBI PORTA, 6
	SBIS PINA, 0
		SBR R18, 0b01001111
	SBIS PINA, 1
		SBR R18, 0b01001111
	SBIS PINA, 2
		SBR R18, 0b01001111
	SBIS PINA, 3
		SBR R18, 0b01001111
CBI PORTA, 6

SBI PORTA, 7
	SBIS PINA, 0
		SBR R18, 0b10001111
	SBIS PINA, 1
		SBR R18, 0b10001111
	SBIS PINA, 2
		SBR R18, 0b10001111
	SBIS PINA, 3
		SBR R18, 0b10001111
CBI PORTA, 7


LDI R19, 0b11111111 ; Rejestr pomocniczy
EOR R18, R19 ; Odwrocenie bitow w rejestrze kolumn
OR R17, R18 ; Polaczenie wartosci aby w jednym rejestrze miescil sie stan wierszy i kolumn
OUT PORTB, R17 ; Ustawia wartosc rejestru R17 do portu sterujacego diodami

RETI ; Powrot z przerwania

