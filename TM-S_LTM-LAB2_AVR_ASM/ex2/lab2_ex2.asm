.include "M32DEF.INC"

; Inicjalizacja portow


CBI DDRA, 0 ; Ustawienie linii PA0 w tryb wejscia
SBI PORTA, 0 ; Podciagniecie linii PA0

LDI R16, 0B11111111 ; Zaladowanie ustawien portu B na tryb wyjscia do rejestru
OUT DDRB, R16 ; Zaladowanie ustawien portu B z rejestru R16

LDI R16, 0B10000011 ; Zaladowanie ustawien diod 11000001 portu B do rejestru
OUT PORTB, R16 ; Zaladowanie ustawien portu B z rejestru R16

; Koniec inicjalizacji portow

LDI R18, 0B00000010 ; Rejestr przytrzymujacy ustwanienie aktywnej diody 2-7

; Wejscie programu w nieskonczona petle

LOOP: ; Glowna petla programu
	SBIS PINA, 0 ; Sprawdzanie czy przycisk jest wcisniety
	RJMP LOOP ; Jesli nie, powraca do poczatku petli

	; Petle opozniajace
	LDI R16, 0 ; Wyzerowanie licznika pierwszej petli wewnetrznej
	LOOP16:
		LDI R17, 0 ; Wyzerowanie licznika drugiej petli wewnetrznej
		LOOP17:
			INC R17 ; Inkrementacja licznika petli LOOP17
			CPI R17, 255 ; Sprawdzenie warunku konca petli
			BRNE LOOP17 ; Jesli warunek nie jest spelniony, powrot na poczatek petli
		INC R16 ; Inkrementacja licznika petli LOOP16
		CPI R16, 255 ; Sprawdzenie warunku konca petli
		BRNE LOOP16 ; Jesli warunek nie jest spelniony, powrot na poczatek petli
	; Koniec petli opozniajacych

	LSL R18 ; Przesuniecie bitowe rejestru sterujacego dioda 2-7

	CPI R18, 0B10000000 ; Sprawdzenie czy przesuniecie bitowe nie wykroczylo poza zakres
	BRNE CONT ; Jesli nie, kontynuacja
	LDI R18, 0B00000010 ; Jesli tak, zresetowanie rejestru do poczatkowej wartosci

	CONT: 
	OUT PORTB, R18 ; Zaladowanie ustawien portu B z rejestru R18
	SBI PORTB, 0 ; Wlaczenie diody 8
	SBI PORTB, 7 ; Wlaczenie diody 1
	RJMP LOOP ; Powrot na poczatek petli glownej
