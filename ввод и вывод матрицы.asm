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
;������ ������ �� ����� ���������� ���������
;str - ����� ��� ������
write macro  str
    push    ax
    push    dx
 
    lea     dx,str  ;����� ������ ��� ������
    mov     ah,09h  ;09h �������
    int     21h
 
    pop     dx
    pop     ax
endm
 
;������ ������ ����� �� �����
;����: AX - ����� ��� ������ �� �����
putdigit macro
    local lput1
    local lput2
    local exx
 
    push    ax
    push    cx
    push    -1  ;�������� ������� ����� �����
    mov     cx,10   ;������ ����� �� 10
lput1:  xor     dx,dx   ;������ ������� dx
    mov     ah,0                   
    div     cl  ;����� 
    mov     dl,ah   
    push    dx  ;�������� �����
    cmp al,0    ;������� 0? 
    jne lput1   ;��� -> ���������
    mov ah,2h
lput2:  pop dx  ;����������� �����
    cmp dx,-1   ;����� �� ����� -> ����� 
    je  exx
    add dl,'0'  ;����������� ����� � �����
    int 21h ;������� ����� �� �����
    jmp lput2   ;� ���������
exx:
    mov dl,' ' 
    int 21h
    pop cx
    pop     ax
endm
 
;������ ����� ����� � ����������
;�����: AX - ��������� �����
indigit macro
    local   lin
    push    bx
    push    cx
    push    dx
 
    mov     ah,0Ah  ;���������������� ����
    lea     dx,buf
    int     21h
 
    xor     ax,ax
    xor     cx,cx
    ;������ ���������� ���� ���������� �����
    mov     cl,[buf+1]  ;���������� ������� ��������� ��������
    xor     di,di
lin:
    mov     dl,10
    mul     dl
    mov     bl,[buf+di+2]
    sub     bl,30h  ;ASCII -> �����
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
    write crlf  ;������������� ��������� ������ �� ����. ������
 
    write msgCols
    indigit
    mov cols,ax
    write crlf
 
    write msgEl
;���� �������
    lea     bx,array
    mov     cx,rows
in1:    ;���� �� �������
    push    cx
    mov     cx,cols
    mov     si,0
in2:    ;���� �� ��������
    indigit ;������ ����� �����
    mov     [bx][si],al
    inc     si
 
    write crlf  
    loop    in2
 
    add     bx,cols
    pop     cx
    loop    in1
 
;����� ������� �� �����
    lea     bx,array
    mov     cx,rows
out1:   ;���� �� �������
    push    cx
    mov     cx,cols
    mov     si,0
 
    write crlf  
out2:   ;���� �� ��������
    xor     ax,ax
    mov al,[bx][si] ;��������� ����� � ������� AL
    putdigit    ;������ ������
    inc     si
    loop    out2
 
    add     bx,cols
    pop     cx
    loop    out1
 
;����� �������
 
;press any key
    write msgPress
    mov     ah,0
        int     16h
;exit
    mov     ax,4c00h
    int     21h
end start
0