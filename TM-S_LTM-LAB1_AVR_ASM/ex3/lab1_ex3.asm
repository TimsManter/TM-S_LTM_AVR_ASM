.include "M32DEF.INC"

; Inicjalizacja portow
SBI DDRA, 7 ; Ustawienie linii PA7 na wyjscie
CBI PORTA, 7 ; Ustawienie stanu linii PA7 na niski
CBI DDRD, 0 ; Ustawienie linii PD0 na wejscie
SBI PORTD, 0 ; Podciagniecie linii PD0
; Koniec inicjalizacji portow

; Wejscie programu w nieskonczona petle
LOOP: ; Glowna petla programu
	SBIC PIND, 0
	RJMP LOOP

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

	SBIC PORTA, 7 ; Jesli dioda jest juz wlaczona...
	RJMP OFF ; ...wylacz ja
		
	SBIS PORTA, 7 ; Jesli dioda nie jest wlaczona...
	RJMP ON ; ...wlacz ja
		
	OFF:
		CBI PORTA, 7 ; Wylaczanie diody
		RJMP LOOP

	ON:
		SBI PORTA, 7 ; Wlaczanie diody
		RJMP LOOP
