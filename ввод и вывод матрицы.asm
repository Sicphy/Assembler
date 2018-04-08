.model small
.stack 100h
 
.data
rows        dw ?
cols        dw ?
array       db 10*10 dup (?)    ;rows * cols
crlf        db 13,10,'$'
buf     db 3,0,3 dup ('$'),'$'
msgPress    db 13,10,'Press any key...$'
msgRows     db 'Input count of rows (<=10): $'
msgCols     db 'Input count of columns (<=10): $'
msgEl       db 13,10,'Input elements: ',13,10,'$'
 
 
.code
;макрос вывода на экран текстового сообщения
;str - стока для вывода
write macro  str
    push    ax
    push    dx
 
    lea     dx,str  ;адрес строки для вывода
    mov     ah,09h  ;09h функция
    int     21h
 
    pop     dx
    pop     ax
endm
 
;макрос вывода числа на экран
;вход: AX - число для вывода на экран
putdigit macro
    local lput1
    local lput2
    local exx
 
    push    ax
    push    cx
    push    -1  ;сохраним признак конца числа
    mov     cx,10   ;делить будем на 10
lput1:  xor     dx,dx   ;чистим регистр dx
    mov     ah,0                   
    div     cl  ;Делим 
    mov     dl,ah   
    push    dx  ;Сохраним цифру
    cmp al,0    ;Остался 0? 
    jne lput1   ;нет -> продолжим
    mov ah,2h
lput2:  pop dx  ;Восстановим цифру
    cmp dx,-1   ;Дошли до конца -> выход 
    je  exx
    add dl,'0'  ;Преобразуем число в цифру
    int 21h ;Выведем цифру на экран
    jmp lput2   ;И продолжим
exx:
    mov dl,' ' 
    int 21h
    pop cx
    pop     ax
endm
 
;макрос ввода числа с клавиатуры
;выход: AX - введенное число
indigit macro
    local   lin
    push    bx
    push    cx
    push    dx
 
    mov     ah,0Ah  ;буферизированный ввод
    lea     dx,buf
    int     21h
 
    xor     ax,ax
    xor     cx,cx
    ;разбор количества цифр введенного числа
    mov     cl,[buf+1]  ;количество реально введенных символов
    xor     di,di
lin:
    mov     dl,10
    mul     dl
    mov     bl,[buf+di+2]
    sub     bl,30h  ;ASCII -> число
    add     al,bl
    inc     di
    loop    lin
 
    pop dx  
    pop     cx
    pop     bx
endm
 
start:
    mov     ax,@data
    mov     ds,ax
 
    write msgRows
    indigit
    mov rows,ax
    write crlf  ;принудительно переводим курсор на след. строку
 
    write msgCols
    indigit
    mov cols,ax
    write crlf
 
    write msgEl
;ввод массива
    lea     bx,array
    mov     cx,rows
in1:    ;цикл по строкам
    push    cx
    mov     cx,cols
    mov     si,0
in2:    ;цикл по колонкам
    indigit ;макрос ввода числа
    mov     [bx][si],al
    inc     si
 
    write crlf  
    loop    in2
 
    add     bx,cols
    pop     cx
    loop    in1
 
;вывод массива на экран
    lea     bx,array
    mov     cx,rows
out1:   ;цикл по строкам
    push    cx
    mov     cx,cols
    mov     si,0
 
    write crlf  
out2:   ;цикл по колонкам
    xor     ax,ax
    mov al,[bx][si] ;Выводимое число в регисте AL
    putdigit    ;макрос вывода
    inc     si
    loop    out2
 
    add     bx,cols
    pop     cx
    loop    out1
 
;здесь расчеты
 
;press any key
    write msgPress
    mov     ah,0
        int     16h
;exit
    mov     ax,4c00h
    int     21h
end start
0