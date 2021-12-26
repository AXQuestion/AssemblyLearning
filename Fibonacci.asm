;Thanks to https://github.com/parikh1bhavya/MASM/blob/master/Project02.asm for this wonderful create

;------------------------
   ;Fibonacci Training
;------------------------

Include Irvine32.inc

.data
    welcome      BYTE 'Fibonacci Numbers by Shawn',0
    askName      BYTE 'What is your name?：',0
    greeting     BYTE 'Hi, ',0
    ins1         BYTE 'How many Fibonacci numbers should I display? ',0
    ins2         BYTE 'Enter an integer in the range[1...25]: ',0
    error        BYTE 'That number was out of range, try again',0
    goodbye      BYTE 'Goodbye, ',0

    justOne      BYTE '0 1',0     ;當我的值為1
    justTwo      BYTE '0 1 1',0  ;當我的值為2
    style      BYTE ' ',0

    lowerLimit= 1
    upperLimit= 25

    Username BYTE 21 DUP(0)
    bytecount DWORD ?
    number DWORD ?

    prev1 DWORD ?
    prev2 DWORD ?
    temp  DWORD ?


.code
main PROC
    ;開頭
    mov edx, OFFSET welcome
    call writeString
    call crlf
    call crlf

    ;問使用者名
    mov edx, OFFSET askName
    call writeString
    mov edx, OFFSET Username
    mov ecx, SIZEOF Username
    call readString
    mov byteCount,eax

    ;問好
    mov edx, OFFSET greeting
    call writeString
    mov edx, OFFSET Username
    call writeString
    call crlf
    call crlf
       
userInput:          ;開始請使用者輸入
    mov edx, OFFSET ins1
    call writeString
    call crlf
    mov edx, OFFSET ins2
    call writeString
    call readInt
    mov number,eax
    cmp eax, upperlimit  ;判斷有在這個範圍裡
    jg  outOfLimit
    cmp eax, lowerlimit
    jl  outOfLimit  
    je  onlyOne          ;若輸入為1跳至onlyOne
    cmp eax,2
    je  onlyTwo          ;若輸入為2跳至onlyTwo

    ;接下來為輸入值2以上
    mov ecx,number
    sub ecx,1
    mov eax,0
    call writeDec
    mov edx, OFFSET style
    call writeString
    mov prev2,eax
    mov eax,1
    call writeDec
    call writeString
    mov prev1,eax

    fib:        ;運算&印出來的部分
        add eax,prev2
        call writeDec
        call writeString
        mov	temp, eax
	      mov	eax, prev1
	    	mov	prev2, eax
	    	mov	eax, temp
		    mov	prev1, eax
        loop fib
        jmp theEnd

outOfLimit:
    call crlf
    mov edx, OFFSET error
    call writeString
    call crlf
    jmp userInput

onlyOne:
    call crlf
    mov edx,OFFSET justOne
    call writeString
    jmp theEnd

onlyTwo:
    call crlf
    mov edx,OFFSET justTwo
    call writeString
    jmp theEnd

theEnd:
    call crlf
    call crlf
    mov edx, OFFSET goodbye   ;印出結束句子
    call writeString
    mov edx, OFFSET Username
    call writeString
    call crlf
 exit
    
main ENDP
END main
