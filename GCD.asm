Include Irvine32.inc

.data
    prompt1 BYTE 'Enter first number：',0
    prompt2 BYTE 'Enter second number：',0
    prompt3 BYTE 'Greatest common divisor is ：',0

    A DWORD ?
    B DWORD ?
    result DWORD  ?

.code
main PROC
;輸入第一個數字：
    mov	  edx, OFFSET prompt1	    ;用offset獲取顯示語的偏移地址，並存入EDX中
    call  WriteString               ;呼叫WriteString,將顯示語以字串形式顯示出來
    call  readInt
    mov   A,eax
;輸入第二個數字：
    mov	  edx, OFFSET prompt2
    call  WriteString
    call  readInt
    mov   B, eax
;呼叫演算法：
    mov   edx, OFFSET prompt3
    call  WriteString
    call  method		        ;呼叫輾轉相除函式，求兩個數字的最大公約數
;顯示結果：
    mov   eax, result			;將結果result存放入EAX中
    call  Display               ;呼叫Display函式，輸出結果
    
method PROC			    ;輾轉相除函式  用於求最大公約數的方法
    mov  eax, A
    mov  ebx, B
    cmp  eax, ebx			;比較EAX與EBX 
    JNB  L1				    ;EAX大於或等於EBX，則跳轉到L1
    mov  B, eax				;若上一步為否，則：交換位置，避免除數大於被除數
    mov  A, ebx

L1:
    mov  eax, A				;已交換/預設不變（滿足條件時），保證了A > B
    mov  ebx, B
    mov  edx, 0				;初始化EDX為0
    div  ebx				;A%B，兩個數字相除，餘數自動存入EDX中
    cmp  edx, 0				;比較EDX與0
    JE   L_End				;JE指令為等於跳轉。若餘數為0，則找到了最終的最大公約數，跳轉到L_End
    mov  eax, B				;若上一步餘數不為0，則將 除數B 放入 EAX 中
    mov  A, eax				;再把原除數B，通過EAX傳遞給A，作為用作下一次操作的 被除數
    mov  B, edx				;再把EDX內的餘數，賦給B，作為下一次操作的 除數 （從而再次保證了A > B）
    jmp	 L1

L_End:
    mov result, ebx
    ret
method  ENDP

Display PROC            ;用於被呼叫，顯示結果
    call  WriteInt			;呼叫writeInt,輸出數字
    call  crlf
    ret
Display ENDP

main ENDP
END  main
