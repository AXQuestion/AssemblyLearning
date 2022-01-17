INCLUDE irvine32.inc

.data
WinMessage1	BYTE "                |------------------------------------------------------|",0
WinMessage2 	BYTE "                | __          __    __                                 |",0      
WinMessage3	BYTE "                | \ \        / /   |  |                                |",0     
WinMessage4	BYTE "                |  \ \  /\  / /___ |  | ____   ___   _ ___ __   ____   |",0 
WinMessage5	BYTE "                |   \ \/  \/ /  _ \|  |/  __\ / _ \ | '_  '_ \ /  _ \  |",0 
WinMessage6	BYTE "                |    \  /\  /   __||  |  /__ | (_) || | | | | |  ___|  |",0
WinMessage7	BYTE "                |     \/  \/ \____||__|\____/ \___/ |_| |_| |_|\____|  |",0
WinMessage8	BYTE "                |------------------------------------------------------|",0

p1 BYTE "The target number is lower than the currect range",0
p2 BYTE "The target number is higher than the current range",0
p3 BYTE "Congratulation! You got it.",0
congratz BYTE "Congratulation! You got it.",0
p4 BYTE "The number you guessed is invalid!",0
p5 BYTE "Please enter a number: ",0

current BYTE "Current Number Range",0
lowText BYTE "Current lowest value ",0
lowPoint DWORD ?
highText BYTE "Current highest value ",0
highPoint DWORD ?

targetNum DWORD ?

playAgain BYTE "| Play Again? Input Y for Yes, N for No: |",0
seeYouAgain BYTE "| Welp,thats all. See you again. :) |",0
inputAgain BYTE "Y","y",0

printStyle MACRO                        ;設定排版的樣式
         mov edx,OFFSET WinMessage1
         call  writeString
         call crlf
         mov edx,OFFSET WinMessage2
         call  writeString
         call crlf
         mov edx,OFFSET WinMessage3
         call  writeString
         call crlf
         mov edx,OFFSET WinMessage4
         call  writeString
         call crlf
	     mov edx,OFFSET WinMessage5
         call  writeString
         call crlf
	     mov edx,OFFSET WinMessage6
         call  writeString
         call crlf
         mov edx,OFFSET WinMessage7
         call  writeString
         call crlf
         mov edx,OFFSET WinMessage8
         call  writeString
         call crlf
ENDM

printCurRange MACRO                    ;同上,為底下的排版+輸入數字位置效果
        mov dl,33
        mov dh,10
        call gotoxy
        mov   edx,OFFSET p5
        call  WriteString
        call  Crlf 
        mov dl,33
        mov dh,15
        call gotoxy
        mov edx,OFFSET current
        call writeString
        mov dl,16
        mov dh,17
        call gotoxy
        mov edx,OFFSET lowText
        call writeString
        mov dl,25
        mov dh,19
        call gotoxy
        mov eax,lowPoint
        call writeDec
        mov dl,50
        mov dh,17
        call gotoxy
        mov edx,OFFSET highText
        call writeString
        mov dl,59
        mov dh,19
        call gotoxy
        mov eax,highPoint
        call writeDec
        mov dl,42
        mov dh,12
        call gotoxy
ENDM


.code
main PROC
    starting:
        call  clrscr            ;清除現有的樣貌並重新輸出
        printStyle
        mov   eax,100
        call  randomize
        call  randomRange       ;randomize + randomRange 達到完全亂數效果
        inc   eax
        mov   targetNum,eax
        mov   lowPoint,1
        mov   highPoint,100

    whileinput:
        printCurRange
        call ReadInt
        cmp eax,1              ;防呆機制 在1-100內
        jb L4
        cmp eax,100
        ja L4
        cmp eax,lowPoint       ;判斷是否在範圍裡
        jb L1
        cmp eax,highPoint
        ja L2
        jb inRange

        inRange:
             cmp eax,targetNum
             ja aboveNum
             jb belowNum
             je L3
        aboveNum:
            mov highPoint,eax   ;將最大範圍改為eax值
            call clrscr
            printStyle
            jmp whileInput
        belowNum:
            mov lowPoint,eax    ;將最小範圍改為eax值
            call clrscr
            printStyle
            jmp whileInput
        L1:                     ;若大於範圍
            call clrScr
            printStyle
            mov dl,19
            mov dh,14
            call gotoxy
            mov   edx , OFFSET p1
            call  WriteString
            jmp   whileinput
        
        L2:                     ;若小於範圍
            call  clrScr
            printStyle
            mov dl,19
            mov dh,14
            call gotoxy
            mov   edx , OFFSET p2
            call  WriteString
            jmp   whileinput
        
        L3:                     ;猜到正確答案
            call  clrscr
            mov dl,35
            mov dh,8
            call gotoxy
            mov   edx , OFFSET p3
            call  WriteString
            call  crlf
            jmp   break
        
        L4:                     ;若超出範圍
            call  clrScr
            printStyle
            mov dl,26
            mov dh,14
            call gotoxy
            mov   edx , OFFSET p4
            call  WriteString
            jmp   whileinput

        break:                  ;是否要重新玩 輸入"Y"或"y"
            mov dl,27
            mov dh,9
            call gotoxy
            mov   edx, OFFSET playAgain
            call  writeString
            call  readChar
            cmp   al,inputAgain
            je    starting
            cmp   al,[inputAgain+1]
            je    starting
        
        ending:                ;結束
            call  clrscr
            mov   edx, OFFSET seeYouAgain
            call  writeString
            ret
main ENDP
END main
