.include "M32DEF.INC"
.org $0000
	RJMP INIT
.org $000E ; Dyrektywa przerwania z adresem przerwania Timer1 dla Compare A (z dokumentacji)
	RJMP TOOGLE

INIT: ; Procedura inicjalizacji
	SBI DDRA, 0 ; Ustawienie linii w tryb wyjscia

	LDI R16, (1<<COM1B0) ; Ustawienie przerwania
	OUT TCCR1A, R16

	LDI R16, (1<<WGM12)|(1<<CS12)|(1<<CS10) ; Tryb CTC i preskaler 1024
	OUT TCCR1B, R16

	LDI R16, LOW(200) ; Ustawienie młodszej części rejestru 16-bitowego
	OUT OCR1AL, R16
	LDI R16, HIGH(200) ; Ustawienie starszej części rejestru 16-bitowego
	OUT OCR1AH, R16

	LDI R16, (1<<OCIE1A) ; Włączenie przerwania z porównywaniem
	OUT TIMSK, R16

	SEI ; Włączenie przerwań

LOOP: ; Nieskończona pętla programu
	RJMP LOOP

TOOGLE: ; Procedura obsługio przerwania
	IN R16, PORTA
	CPI R16, 0b00000000 ; Sprawdzenie stanu diody
	BREQ ON ; Jeśli dioda wyłączona - włącz
	BRNE OFF ; Jeśli dioda włączona - wyłącz
	
ON: ; Procedura włączająca diodę 
	SBI PORTA, 0 ; Włączenie diody
	LDI R16, LOW(1500) ; Ustawnienie nowego czasu po jakim zostanie wywowłane przerwanie
	OUT OCR1AL, R16 ; Załadowanie czasu nowego przerwania
	LDI R16, HIGH(1500) ; Ustawnienie nowego czasu po jakim zostanie wywowłane przerwanie
	OUT OCR1AH, R16 ; Załadowanie czasu nowego przerwania
	RETI

OFF: ; Procedura wyłączająca diodę
	CBI PORTA, 0 ; Wyłączenie diody
	LDI R16, LOW(200) ; Ustawnienie nowego czasu po jakim zostanie wywowłane przerwanie
	OUT OCR1AL, R16 ; Załadowanie czasu nowego przerwania
	LDI R16, HIGH(200) ; Ustawnienie nowego czasu po jakim zostanie wywowłane przerwanie
	OUT OCR1AH, R16 ; Załadowanie czasu nowego przerwania
	RETI
