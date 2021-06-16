		ORG 0000H
		SJMP BASLA

		ORG 0BH	; timer0 interrupt icin 0BH adresine konumlandirma yapildi
KESME_T0:
		MOV TH0, #3CH	
		MOV TL0, #0B0H		
		RETI

		ORG 0030H	; BASLA nin baslangic adresi
BASLA:
	JB P1.0, DURDUR	; butona basilmazsa ekranda hicbir sey olmayacak
	
	MOV TMOD, #01H	; timer0 mod1 ayarlandi
	MOV TH0, #3CH	; yuksek byte atama  
	MOV TL0, #0B0H	; dusuk byte atama		
	SETB P2.0	; p2.0 a bagli led icin bit birlendi
	MOV IE, #82H	; kesme icin yetkilendirme yapildi
	SETB TR0		; sayma baslatildi
	ACALL BEKLEDONGU 
	CLR P2.0	; ilk led sonduruldu
	SETB P2.1	; p2.1 e bagli led icin bit birlendi
	ACALL BEKLEDONGU	
	CLR P2.1	; ikinci led sonduruldu
	
DURDUR:
	MOV P2, #00H	
	SJMP BASLA

BEKLEDONGU:
	MOV R2,#17	; 1 saniye saymasi icin  17 kez tekrarlanmasi gerekiyor
	BIRSANIYEDUR: ACALL BEKLE  
	JB P1.0, DURDUR ; buton birakilirsa ledi aninda kesmek icin
	DJNZ R2, BIRSANIYEDUR	; her adimda r2nin degeri 1 azaltiliyor
	
BEKLE: 
	JNB TF0, BEKLE ; tasma olana kadar bekleniyor
	CLR TF0	; tasma bayragi sifirlaniyor
		
RET
END