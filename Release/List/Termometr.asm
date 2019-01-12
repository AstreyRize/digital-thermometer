
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATtiny2313
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Tiny
;Optimize for           : Speed
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 32 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_TINY_

	#pragma AVRPART ADMIN PART_NAME ATtiny2313
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 128
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU WDTCR=0x21
	.EQU WDTCSR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F
	.EQU GPIOR0=0x13
	.EQU GPIOR1=0x14
	.EQU GPIOR2=0x15

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x00DF
	.EQU __DSTACK_SIZE=0x0020
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _TEMPERATURE_REQUESTED=R3

;GPIOR0-GPIOR2 INITIALIZATION VALUES
	.EQU __GPIOR0_INIT=0x00
	.EQU __GPIOR1_INIT=0x00
	.EQU __GPIOR2_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_conv_delay_G100:
	.DB  0x64,0x0,0xC8,0x0,0x90,0x1,0x20,0x3
_bit_mask_G100:
	.DB  0xF8,0xFF,0xFC,0xFF,0xFE,0xFF,0xFF,0xFF

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0

_0x3:
	.DB  0x14,0x77,0x4C,0x45,0x27,0x85,0x84,0x57
	.DB  0x4,0x5,0xEF
_0x4:
	.DB  0x1,0x8,0x4,0x2

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x03
	.DW  __REG_VARS*2

	.DW  0x0B
	.DW  _numbers
	.DW  _0x3*2

	.DW  0x04
	.DW  _digit
	.DW  _0x4*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	;__GPIOR1_INIT = __GPIOR0_INIT
	OUT  GPIOR1,R30
	;__GPIOR2_INIT = __GPIOR0_INIT
	OUT  GPIOR2,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x80

	.CSEG
;#include <tiny2313.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <ds18b20.h>
;
;// Данные
;#define DS PORTD.1
;
;// Защелка
;#define ST_CP PORTA.0
;
;// Тактовый импульс
;#define SH_CP PORTD.2
;
;// Cброс значений регистра
;#define MR PORTD.3
;
;// Модуль числа
;#define ABS(x) ((x) < 0 ? -(x) : (x))
;
;// Температура была запрошена.
;unsigned char TEMPERATURE_REQUESTED = 0;
;
;// Цифры для e40561
;unsigned char numbers[11] =
;{
;    //BFAGCpDE
;    0b00010100, //0
;    0b01110111, //1
;    0b01001100, //2
;    0b01000101, //3
;    0b00100111, //4
;    0b10000101, //5
;    0b10000100, //6
;    0b01010111, //7
;    0b00000100, //8
;    0b00000101, //9
;    0b11101111  //-
;};

	.DSEG
;
;unsigned char digit[4] =
;{
;    0b00000001, //разраяд 1
;    0b00001000, //разраяд 2
;    0b00000100, //разраяд 3
;    0b00000010, //разраяд 4
;};
;
;// Показать цмфру на индткаторе e40561
;void SetNumber(unsigned char number, unsigned char mask)
; 0000 0032 {

	.CSEG
_SetNumber:
; .FSTART _SetNumber
; 0000 0033     unsigned char bits;
; 0000 0034     unsigned char i = 0;
; 0000 0035 
; 0000 0036     bits = numbers[number];
	ST   -Y,R26
	RCALL __SAVELOCR2
;	number -> Y+3
;	mask -> Y+2
;	bits -> R17
;	i -> R16
	LDI  R16,0
	LDD  R30,Y+3
	SUBI R30,-LOW(_numbers)
	LD   R17,Z
; 0000 0037     bits ^= mask;
	LDD  R30,Y+2
	EOR  R17,R30
; 0000 0038 
; 0000 0039     for(i = 0; i < 8; i++)
	LDI  R16,LOW(0)
_0x6:
	CPI  R16,8
	BRSH _0x7
; 0000 003A     {
; 0000 003B           DS = (bits>>i) & 1;
	MOV  R30,R16
	MOV  R26,R17
	RCALL __LSRB12
	ANDI R30,LOW(0x1)
	BRNE _0x8
	CBI  0x12,1
	RJMP _0x9
_0x8:
	SBI  0x12,1
_0x9:
; 0000 003C           SH_CP = 1;
	SBI  0x12,2
; 0000 003D           SH_CP = 0;
	CBI  0x12,2
; 0000 003E     }
	SUBI R16,-1
	RJMP _0x6
_0x7:
; 0000 003F 
; 0000 0040     ST_CP = 1;
	SBI  0x1B,0
; 0000 0041     ST_CP = 0;
	CBI  0x1B,0
; 0000 0042 }
	RCALL __LOADLOCR2
	RJMP _0x2020001
; .FEND
;
;void SetMinus()
; 0000 0045 {
_SetMinus:
; .FSTART _SetMinus
; 0000 0046     unsigned char bits;
; 0000 0047     unsigned char i = 0;
; 0000 0048 
; 0000 0049     bits = numbers[10];
	RCALL __SAVELOCR2
;	bits -> R17
;	i -> R16
	LDI  R16,0
	__GETBRMN 17,_numbers,10
; 0000 004A 
; 0000 004B     for(i = 0; i < 8; i++)
	LDI  R16,LOW(0)
_0x13:
	CPI  R16,8
	BRSH _0x14
; 0000 004C     {
; 0000 004D           DS = (bits>>i) & 1;
	MOV  R30,R16
	MOV  R26,R17
	RCALL __LSRB12
	ANDI R30,LOW(0x1)
	BRNE _0x15
	CBI  0x12,1
	RJMP _0x16
_0x15:
	SBI  0x12,1
_0x16:
; 0000 004E           SH_CP = 1;
	SBI  0x12,2
; 0000 004F           SH_CP = 0;
	CBI  0x12,2
; 0000 0050     }
	SUBI R16,-1
	RJMP _0x13
_0x14:
; 0000 0051 
; 0000 0052     ST_CP = 1;
	SBI  0x1B,0
; 0000 0053     ST_CP = 0;
	CBI  0x1B,0
; 0000 0054 }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;// Отобразить число на индикаторе e40561
;void ShowNumber(int temp)
; 0000 0058 {
_ShowNumber:
; .FSTART _ShowNumber
; 0000 0059     unsigned char step = 0;
; 0000 005A 
; 0000 005B     // Самый левый заполняем знаком
; 0000 005C     if(temp < 0)
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	temp -> Y+1
;	step -> R17
	LDI  R17,0
	LDD  R26,Y+2
	TST  R26
	BRPL _0x1F
; 0000 005D     {
; 0000 005E         SetMinus();
	RCALL _SetMinus
; 0000 005F         PORTB = 0b00000010;
	LDI  R30,LOW(2)
	OUT  0x18,R30
; 0000 0060         delay_ms(1);
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0061         PORTB = 0b00000000;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0062     }
; 0000 0063 
; 0000 0064     // Первые 3 разрада справа заполняем числами
; 0000 0065     do
_0x1F:
_0x21:
; 0000 0066     {
; 0000 0067         if(step == 1)
	CPI  R17,1
	BRNE _0x23
; 0000 0068         {
; 0000 0069             //Младший разряд отображаем с точкой
; 0000 006A             SetNumber(ABS(temp) % 10, 0b00000100);
	LDD  R26,Y+2
	TST  R26
	BRPL _0x24
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	RCALL __ANEGW1
	RJMP _0x25
_0x24:
	LDD  R30,Y+1
_0x25:
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	ST   -Y,R30
	LDI  R26,LOW(4)
	RJMP _0x36
; 0000 006B         }
; 0000 006C         else
_0x23:
; 0000 006D         {
; 0000 006E             SetNumber(ABS(temp) % 10, 0b00000000);
	LDD  R26,Y+2
	TST  R26
	BRPL _0x28
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	RCALL __ANEGW1
	RJMP _0x29
_0x28:
	LDD  R30,Y+1
_0x29:
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	ST   -Y,R30
	LDI  R26,LOW(0)
_0x36:
	RCALL _SetNumber
; 0000 006F         }
; 0000 0070 
; 0000 0071         PORTB = digit[step];
	LDI  R26,LOW(_digit)
	ADD  R26,R17
	LD   R30,X
	OUT  0x18,R30
; 0000 0072         delay_ms(1);
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0073         PORTB = 0b00000000;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0074 
; 0000 0075         temp /= 10;
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	STD  Y+1,R30
	STD  Y+1+1,R31
; 0000 0076         step++;
	SUBI R17,-1
; 0000 0077     }
; 0000 0078     while(temp && step < 3);
	SBIW R30,0
	BREQ _0x2B
	CPI  R17,3
	BRLO _0x2C
_0x2B:
	RJMP _0x22
_0x2C:
	RJMP _0x21
_0x22:
; 0000 0079 }
	LDD  R17,Y+0
	RJMP _0x2020005
; .FEND
;
;void main(void)
; 0000 007C {
_main:
; .FSTART _main
; 0000 007D // Crystal Oscillator division factor: 1
; 0000 007E #pragma optsize-
; 0000 007F CLKPR=(1<<CLKPCE);
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 0080 CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0081 #ifdef _OPTIMIZE_SIZE_
; 0000 0082 #pragma optsize+
; 0000 0083 #endif
; 0000 0084 
; 0000 0085 // Input/Output Ports initialization
; 0000 0086 // Port A initialization
; 0000 0087 // Function: Bit2=In Bit1=In Bit0=In
; 0000 0088 DDRA=(0<<DDA2) | (0<<DDA1) | (1<<DDA0);
	LDI  R30,LOW(1)
	OUT  0x1A,R30
; 0000 0089 // State: Bit2=T Bit1=T Bit0=T
; 0000 008A PORTA=(0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 008B 
; 0000 008C // Port B initialization
; 0000 008D // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=Out
; 0000 008E DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0000 008F // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=0
; 0000 0090 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0091 
; 0000 0092 // Port D initialization
; 0000 0093 // Function: Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=In Bit0=In
; 0000 0094 DDRD=(0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(14)
	OUT  0x11,R30
; 0000 0095 // State: Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=T Bit0=T
; 0000 0096 PORTD=(0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0097 
; 0000 0098 // Timer/Counter 0 initialization
; 0000 0099 // Clock source: System Clock
; 0000 009A // Clock value: Timer 0 Stopped
; 0000 009B // Mode: Normal top=0xFF
; 0000 009C // OC0A output: Disconnected
; 0000 009D // OC0B output: Disconnected
; 0000 009E TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
	OUT  0x30,R30
; 0000 009F TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
	OUT  0x33,R30
; 0000 00A0 TCNT0=0x00;
	OUT  0x32,R30
; 0000 00A1 OCR0A=0x00;
	OUT  0x36,R30
; 0000 00A2 OCR0B=0x00;
	OUT  0x3C,R30
; 0000 00A3 
; 0000 00A4 // Timer/Counter 1 initialization
; 0000 00A5 // Clock source: System Clock
; 0000 00A6 // Clock value: Timer1 Stopped
; 0000 00A7 // Mode: Normal top=0xFFFF
; 0000 00A8 // OC1A output: Disconnected
; 0000 00A9 // OC1B output: Disconnected
; 0000 00AA // Noise Canceler: Off
; 0000 00AB // Input Capture on Falling Edge
; 0000 00AC // Timer1 Overflow Interrupt: Off
; 0000 00AD // Input Capture Interrupt: Off
; 0000 00AE // Compare A Match Interrupt: Off
; 0000 00AF // Compare B Match Interrupt: Off
; 0000 00B0 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	OUT  0x2F,R30
; 0000 00B1 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 00B2 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00B3 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00B4 ICR1H=0x00;
	OUT  0x25,R30
; 0000 00B5 ICR1L=0x00;
	OUT  0x24,R30
; 0000 00B6 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00B7 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00B8 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00B9 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00BA 
; 0000 00BB // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00BC TIMSK=(0<<TOIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<ICIE1) | (0<<OCIE0B) | (0<<TOIE0) | (0<<OCIE0A);
	OUT  0x39,R30
; 0000 00BD 
; 0000 00BE // External Interrupt(s) initialization
; 0000 00BF // INT0: Off
; 0000 00C0 // INT1: Off
; 0000 00C1 // Interrupt on any change on pins PCINT0-7: Off
; 0000 00C2 GIMSK=(0<<INT1) | (0<<INT0) | (0<<PCIE);
	OUT  0x3B,R30
; 0000 00C3 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	OUT  0x35,R30
; 0000 00C4 
; 0000 00C5 // USI initialization
; 0000 00C6 // Mode: Disabled
; 0000 00C7 // Clock source: Register & Counter=no clk.
; 0000 00C8 // USI Counter Overflow Interrupt: Off
; 0000 00C9 USICR=(0<<USISIE) | (0<<USIOIE) | (0<<USIWM1) | (0<<USIWM0) | (0<<USICS1) | (0<<USICS0) | (0<<USICLK) | (0<<USITC);
	OUT  0xD,R30
; 0000 00CA 
; 0000 00CB // USART initialization
; 0000 00CC // USART disabled
; 0000 00CD UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (0<<RXEN) | (0<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	OUT  0xA,R30
; 0000 00CE 
; 0000 00CF // Analog Comparator initialization
; 0000 00D0 // Analog Comparator: Off
; 0000 00D1 // The Analog Comparator's positive input is
; 0000 00D2 // connected to the AIN0 pin
; 0000 00D3 // The Analog Comparator's negative input is
; 0000 00D4 // connected to the AIN1 pin
; 0000 00D5 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00D6 // Digital input buffer on AIN0: On
; 0000 00D7 // Digital input buffer on AIN1: On
; 0000 00D8 DIDR=(0<<AIN0D) | (0<<AIN1D);
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 00D9 
; 0000 00DA // Global enable interrupts
; 0000 00DB #asm("sei")
	sei
; 0000 00DC 
; 0000 00DD // Инициализация датчика
; 0000 00DE ds18b20_init(0, -55, +99, DS18B20_12BIT_RES);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(201)
	ST   -Y,R30
	LDI  R30,LOW(99)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _ds18b20_init
; 0000 00DF 
; 0000 00E0 while (1)
_0x2D:
; 0000 00E1       {
; 0000 00E2             float temperature;
; 0000 00E3 
; 0000 00E4             MR = 1;
	SBIW R28,4
;	temperature -> Y+0
	SBI  0x12,3
; 0000 00E5 
; 0000 00E6             // Если температура не запрошена - запрашиваем.
; 0000 00E7             // Если температура была запрошена - читаема значение.
; 0000 00E8             if(TEMPERATURE_REQUESTED == 0)
	TST  R3
	BRNE _0x32
; 0000 00E9             {
; 0000 00EA                 ds18b20_request_temperature(0);
	LDI  R26,LOW(0)
	RCALL _ds18b20_request_temperature
; 0000 00EB                 TEMPERATURE_REQUESTED = 1;
	LDI  R30,LOW(1)
	MOV  R3,R30
; 0000 00EC             }
; 0000 00ED             else
	RJMP _0x33
_0x32:
; 0000 00EE             {
; 0000 00EF                 temperature = ds18b20_get_temperature(0);
	LDI  R26,LOW(0)
	RCALL _ds18b20_get_temperature
	RCALL __PUTD1S0
; 0000 00F0                 TEMPERATURE_REQUESTED = 0;
	CLR  R3
; 0000 00F1             }
_0x33:
; 0000 00F2 
; 0000 00F3             // Eсли датчик выдаёт больше 1000
; 0000 00F4             if (temperature > 1000)
	RCALL __GETD2S0
	__GETD1N 0x447A0000
	RCALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x34
; 0000 00F5             {
; 0000 00F6                 // Отнимаем от данных 4096
; 0000 00F7                 temperature = 4096 - temperature;
	__GETD1N 0x45800000
	RCALL __SUBF12
	RCALL __PUTD1S0
; 0000 00F8                 // И ставим знак "минус"
; 0000 00F9                 temperature =- temperature;
	RCALL __ANEGF1
	RCALL __PUTD1S0
; 0000 00FA             }
; 0000 00FB 
; 0000 00FC             // Избавляемся от дробной части,
; 0000 00FD             // Дестяки теперь дробная часть.
; 0000 00FE             ShowNumber(temperature * 10);
_0x34:
	RCALL __GETD2S0
	__GETD1N 0x41200000
	RCALL __MULF12
	RCALL __CFD1
	MOVW R26,R30
	RCALL _ShowNumber
; 0000 00FF       }
	ADIW R28,4
	RJMP _0x2D
; 0000 0100 }
_0x35:
	RJMP _0x35
; .FEND

	.CSEG
_ds18b20_select:
; .FSTART _ds18b20_select
	ST   -Y,R26
	ST   -Y,R17
	RCALL _w1_init
	CPI  R30,0
	BRNE _0x2000003
	LDI  R30,LOW(0)
	RJMP _0x2020002
_0x2000003:
	LDD  R30,Y+1
	CPI  R30,0
	BREQ _0x2000004
	LDI  R26,LOW(85)
	RCALL _w1_write
	LDI  R17,LOW(0)
_0x2000006:
	LDD  R26,Y+1
	LD   R30,X+
	STD  Y+1,R26
	MOV  R26,R30
	RCALL _w1_write
	SUBI R17,-LOW(1)
	CPI  R17,8
	BRLO _0x2000006
	RJMP _0x2000008
_0x2000004:
	LDI  R26,LOW(204)
	RCALL _w1_write
_0x2000008:
	LDI  R30,LOW(1)
	RJMP _0x2020002
; .FEND
_ds18b20_read_spd:
; .FSTART _ds18b20_read_spd
	ST   -Y,R26
	RCALL __SAVELOCR2
	LDD  R26,Y+2
	RCALL _ds18b20_select
	CPI  R30,0
	BRNE _0x2000009
	LDI  R30,LOW(0)
	RJMP _0x2020004
_0x2000009:
	LDI  R26,LOW(190)
	RCALL _w1_write
	LDI  R17,LOW(0)
	__POINTBRM 16,___ds18b20_scratch_pad
_0x200000B:
	PUSH R16
	SUBI R16,-1
	RCALL _w1_read
	POP  R26
	ST   X,R30
	SUBI R17,-LOW(1)
	CPI  R17,9
	BRLO _0x200000B
	LDI  R30,LOW(___ds18b20_scratch_pad)
	ST   -Y,R30
	LDI  R26,LOW(9)
	RCALL _w1_dow_crc8
	RCALL __LNEGB1
_0x2020004:
	RCALL __LOADLOCR2
_0x2020005:
	ADIW R28,3
	RET
; .FEND
_ds18b20_request_temperature:
; .FSTART _ds18b20_request_temperature
	ST   -Y,R26
	LD   R26,Y
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BRNE _0x2000010
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2020003
_0x2000010:
	LD   R26,Y
	RCALL _ds18b20_select
	CPI  R30,0
	BRNE _0x2000011
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2020003
_0x2000011:
	LDI  R26,LOW(68)
	RCALL _w1_write
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0x2020003:
	ADIW R28,1
	RET
; .FEND
_ds18b20_get_temperature:
; .FSTART _ds18b20_get_temperature
	ST   -Y,R26
	ST   -Y,R17
	__GETB1MN ___ds18b20_scratch_pad,4
	SWAP R30
	ANDI R30,0xF
	LSR  R30
	ANDI R30,LOW(0x3)
	MOV  R17,R30
	LDD  R26,Y+1
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BRNE _0x2000012
	__GETD1N 0xC61C3C00
	RJMP _0x2020002
_0x2000012:
	RCALL _w1_init
	MOV  R30,R17
	LDI  R26,LOW(_bit_mask_G100*2)
	LDI  R27,HIGH(_bit_mask_G100*2)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RCALL __GETW1PF
	LDS  R26,___ds18b20_scratch_pad
	LDS  R27,___ds18b20_scratch_pad+1
	AND  R30,R26
	AND  R31,R27
	RCALL __CWD1
	RCALL __CDF1
	__GETD2N 0x3D800000
	RCALL __MULF12
_0x2020002:
	LDD  R17,Y+0
	ADIW R28,2
	RET
; .FEND
_ds18b20_init:
; .FSTART _ds18b20_init
	ST   -Y,R26
	LDD  R26,Y+3
	RCALL _ds18b20_select
	CPI  R30,0
	BRNE _0x2000013
	LDI  R30,LOW(0)
	RJMP _0x2020001
_0x2000013:
	LD   R30,Y
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	ORI  R30,LOW(0x1F)
	ST   Y,R30
	LDI  R26,LOW(78)
	RCALL _w1_write
	LDD  R26,Y+1
	RCALL _w1_write
	LDD  R26,Y+2
	RCALL _w1_write
	LD   R26,Y
	RCALL _w1_write
	LDD  R26,Y+3
	RCALL _ds18b20_read_spd
	CPI  R30,0
	BRNE _0x2000014
	LDI  R30,LOW(0)
	RJMP _0x2020001
_0x2000014:
	__GETB2MN ___ds18b20_scratch_pad,3
	LDD  R30,Y+2
	CP   R30,R26
	BRNE _0x2000016
	__GETB2MN ___ds18b20_scratch_pad,2
	LDD  R30,Y+1
	CP   R30,R26
	BRNE _0x2000016
	__GETB2MN ___ds18b20_scratch_pad,4
	LD   R30,Y
	CP   R30,R26
	BREQ _0x2000015
_0x2000016:
	LDI  R30,LOW(0)
	RJMP _0x2020001
_0x2000015:
	LDD  R26,Y+3
	RCALL _ds18b20_select
	CPI  R30,0
	BRNE _0x2000018
	LDI  R30,LOW(0)
	RJMP _0x2020001
_0x2000018:
	LDI  R26,LOW(72)
	RCALL _w1_write
	LDI  R26,LOW(15)
	LDI  R27,0
	RCALL _delay_ms
	RCALL _w1_init
_0x2020001:
	ADIW R28,4
	RET
; .FEND

	.DSEG
___ds18b20_scratch_pad:
	.BYTE 0x9
_numbers:
	.BYTE 0xB
_digit:
	.BYTE 0x4

	.CSEG

	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

	.equ __w1_port=0x12
	.equ __w1_bit=0x06

_w1_init:
	clr  r30
	cbi  __w1_port,__w1_bit
	sbi  __w1_port-1,__w1_bit
	__DELAY_USW 0x3C0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x25
	sbis __w1_port-2,__w1_bit
	ret
	__DELAY_USB 0xCB
	sbis __w1_port-2,__w1_bit
	ldi  r30,1
	__DELAY_USW 0x30C
	ret

__w1_read_bit:
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x5
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x1D
	clc
	sbic __w1_port-2,__w1_bit
	sec
	ror  r30
	__DELAY_USB 0xD5
	ret

__w1_write_bit:
	clt
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x5
	sbrc r23,0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x23
	sbic __w1_port-2,__w1_bit
	rjmp __w1_write_bit0
	sbrs r23,0
	rjmp __w1_write_bit1
	ret
__w1_write_bit0:
	sbrs r23,0
	ret
__w1_write_bit1:
	__DELAY_USB 0xC8
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0xD
	set
	ret

_w1_read:
	ldi  r22,8
	__w1_read0:
	rcall __w1_read_bit
	dec  r22
	brne __w1_read0
	ret

_w1_write:
	mov  r23,r26
	ldi  r22,8
	clr  r30
__w1_write0:
	rcall __w1_write_bit
	brtc __w1_write1
	ror  r23
	dec  r22
	brne __w1_write0
	inc  r30
__w1_write1:
	ret

_w1_dow_crc8:
	clr  r30
	tst  r26
	breq __w1_dow_crc83
	mov  r24,r26
	ldi  r22,0x18
	ld   r26,y
	clr  r27
__w1_dow_crc80:
	ldi  r25,8
	ld   r31,x+
__w1_dow_crc81:
	mov  r23,r31
	eor  r23,r30
	ror  r23
	brcc __w1_dow_crc82
	eor  r30,r22
__w1_dow_crc82:
	ror  r30
	lsr  r31
	dec  r25
	brne __w1_dow_crc81
	dec  r24
	brne __w1_dow_crc80
__w1_dow_crc83:
	adiw r28,1
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,24
__MULF120:
	LSL  R19
	ROL  R20
	ROL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	BRCC __MULF121
	ADD  R19,R26
	ADC  R20,R27
	ADC  R21,R24
	ADC  R30,R1
	ADC  R31,R1
	ADC  R22,R1
__MULF121:
	DEC  R25
	BRNE __MULF120
	POP  R20
	POP  R19
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__LNEGB1:
	TST  R30
	LDI  R30,1
	BREQ __LNEGB1F
	CLR  R30
__LNEGB1F:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
