.include "M32DEF.INC"

; Inicjlizacja portow

LDI R16, 0b00001111
OUT DDRA, R16 ; Ustawienie linii wierszy klawiatury na wejscie, linii kolumn klawiatury na wyjscie

LDI R16, 0b11111111
OUT PORTA, R16 ; Ustawnienie wyjsc na san wysoki i podciagniecie wejsc

LDI R16, 0b11111111
OUT DDRB, R16 ; Ustawienie linii obslugujacej diody na wyjscie

LDI R16, 0b00000000
OUT PORTB, R16 ; Ustawienie linii diod na stan niski

; Koniec inicjalizacji portow

; Poczatek instrukcji programu

START:
LDI R17, 0 ; Ustawienie poczaczkowej wartosci rejestru okreslajacego stan diod
IN R18, PINA ; Zapisanie stanu wescia portu A w celu pozniejszego porownywania bitow

CBI PORTA, 3 ; Ustawienie pierwszej kolumny na wejście w celu sprawdzenia stanu
	SBIS R18, 7 ; Sprawdzanie pierwszego wiersza
	LDI R17, 0 ; Ustawianie bitu w rejestrze R17 w zaleznosci od stanu linii
	SBIS R18, 6 ; Analogicznie sprawdzanie warunkowe drugiego i kolejnego wiersza...
	LDI R17, 1
	SBIS R18, 5
	LDI R17, 2
	SBIS R18, 4
	LDI R17, 3
SBI PORTA, 3 ; Ponowne ustawianie linii kolumny klawiatury na wyjśćie
CPI R17, 0 ; Jesli wartosc rejestru sie zmienila, zakoncz sprawdzanie
BRNE END ; Skok na koniec programu

CBI PORTA, 2 ; Analogicznie instrukcje dla drugiej i kolejnej kolumny...
	SBIS R18, 7
	LDI R17, 4
	SBIS R18, 6
	LDI R17, 5
	SBIS R18, 5
	LDI R17, 6
	SBIS R18, 4
	LDI R17, 7
SBI PORTA, 2
CPI R17, 0
BRNE END

CBI PORTA, 1
	SBIS R18, 7
	LDI R17, 8
	SBIS R18, 6
	LDI R17, 9
	SBIS R18, 5
	LDI R17, 10
	SBIS R18, 4
	LDI R17, 11
SBI PORTA, 1
CPI R17, 0
BRNE END

CBI PORTA, 0
	SBIS R18, 7
	LDI R17, 12
	SBIS R18, 6
	LDI R17, 13
	SBIS R18, 5
	LDI R17, 14
	SBIS R18, 4
	LDI R17, 15
SBI PORTA, 0
CPI R17, 0
BRNE END

RJMP START ; Jesli nie ma zmian (zaden przycisk nie byl wcisniety) wykonanie skoku do poczatku programu

END:
OUT PORTB, R17 ; Ustawia wartosc rejestru R17 do portu sterujacego diodami
RJMP END
