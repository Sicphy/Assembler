
.model small
.data
str1	db 13,10,'input first number: $'
str2	db 13,10, 'input second number: $'
crlf        db 13,10,'$'
n1	dw 0
n2	dw 0
buf1	db 13,10,10 dup('$')
.stack 256
.code
start:       

          
write macro  str
    push    ax
    push    dx
 
    lea     dx,str  
    mov     ah,09h  
    int     21h
 
    pop     dx
    pop     ax   
    
endm

	mov ax,@data	
	mov ds,ax
	mov es,ax
	;mov dx, offset str1
	call InputNumber
	mov n1,ax
	;mov dx, offset str2
	call InputNumber
	mov n2,ax
	add ax,n1
    lea di,buf1+2  
	write crlf
	call printdec
	lea dx,buf1+2
	mov ah,9
	int 21h
	mov ax,n2	
    lea di,buf1+2  
	write crlf
	call printdec
	lea dx,buf1+2
	mov ah,9
	int 21h 	
	
ex:	mov ax,4c00h	
	int 21h
          

          

str2dw	proc
	push bx
	push dx
	push si
	xor bx,bx
	xor dx,dx	
@lp1:	xor ax,ax
	lodsb	
	test al,al	
	jz @ex
	cmp al,'-'	
	jnz @m1
	mov bx,1
	jmp @lp1
@m1:	cmp al,'9'	
	jnbe @lp1
	cmp al,'0'      
	jb @lp1
	sub ax,'0'	
	shl dx,1
	add ax, dx
	shl dx, 2
	add dx, ax	
	jmp @lp1
@ex:	test bx,bx	
	jz @ex1
	neg dx	
@ex1:	mov ax,dx
	pop si
	pop dx
	pop bx
	ret
str2dw	endp

InputNumber	proc	
	push dx		
	push si
	push di
	;mov ah,9
	
	;int 21h
	xor ax, ax   
	xor di,di
	xor si, si
	xor bx, bx
	xor dx,dx
	xor cx,cx
	;xor sp,sp
	xor bp,bp
	mov ah,0ah	
	mov dx,offset buf
	int 21h		
	mov di,offset buf+1
	mov al,[di]	
	mov ah,0
	inc di	
	mov si,di		
	add di,ax                              
	mov [di],byte ptr 0   
	call str2dw	
	pop di		
	pop si
	pop dx
	ret
buf 	db 8, 10 dup(0)	
InputNumber	endp



printdec proc	
    test    ax, ax
    jns     doIt
       
    mov  cx, ax
    mov     ah, 02h
    mov     dl, '-'
    int     21h
    mov  ax, cx
    neg     ax   
    
doIt:	push cx
	push dx
	push bx
	mov bx,10	
	XOR CX,CX	
@@m1:	XOR dx,dx
	DIV bx		
	PUSH DX		
	INC CX
	TEST AX,AX
	JNZ @@m1
@@m2:	POP AX
	ADD AL,'0'	
	STOSb		
	LOOP @@m2
	xor ax,ax
	add al, ' '
	STOSb   
	xor ax,ax
	add al, 'a'
	STOSb 
	pop bx		
	POP dx
	POP cx
	RET
printdec endp


end start 



end