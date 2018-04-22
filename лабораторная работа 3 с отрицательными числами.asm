.model small 
.data
array       dw 3*3 dup (0)
arrayOfSum  dw 3 dup (0)
tempArray   db 6 duo (?)
crlf        db 13,10,'$'
;buf         db 3,0,3 dup ('$'),'$'
msgPress    db 13,10,'Press any key...$'
input_string       db 13,10,'Input elements: ',13,10,'$' 
buf1	db 13,10,10 dup('$')
 
.stack 256 
.code 

write macro  str
    push    ax
    push    dx
 
    lea     dx,str  
    mov     ah,09h  
    int     21h
 
    pop     dx
    pop     ax
endm
 


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

indigit	proc	
	push dx		
	push si
	push di
	push bx      
	xor ax, ax   
	xor di,di
	xor si, si
	xor bx, bx
	xor dx,dx
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
	pop bx	
	pop di		
	pop si
	pop dx
	ret
buf 	db 8, 10 dup(0)	
indigit	endp



 putdigit proc	
    push cx
    push dx
    push bx
    test    ax, ax
    jns     doIt
       
    mov  cx, ax
    mov     ah, 02h
    mov     dl, '-'
    int     21h
    mov  ax, cx
    neg     ax   
    
doIt:
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
	pop bx		
	POP dx
	POP cx
	RET
 putdigit endp
 
start:
    mov     ax,@data
    mov     ds,ax
    mov     es,ax
 
    write input_string
                  
    ;input matrix              
    lea     bx,array
    mov     cx,3
in1:    
    push    cx
    mov     cx,3
    mov     si,0
in2:   
    call indigit 
    mov     [bx][si],ax
    add     si,2
 
    write crlf  
    loop    in2
 
    add     bx,6
    pop     cx
    loop    in1
                    
    ;output matrix                
    lea     bx,array
    mov     cx,3
out1:   
    push    cx
    mov     cx,3
    mov     si,0
 
    write crlf  
out2:   
    xor     ax,ax
    mov ax,[bx][si]
    lea di,buf1+2  
    call putdigit
	lea dx,buf1+2
	mov ah,9
	int 21h   
    add     si, 2
    loop    out2
 
    add     bx,6
    pop     cx
    loop    out1         
    
    ;string sum
    
    
    mov     cx,3
    xor     di,di 
    xor     dx,dx
     
    
sum1:      
    lea     bx,array 
    add     bx,dx
    push    dx            
    push    cx
    mov     cx,3
    mov     si,0  
    xor     ax,ax 
  
sum2:   
    
    xor     dx,dx
    mov     dx,[bx][si] 
    add     ax,dx     
    add     si,2
    loop    sum2
                
                
    pop     cx
    pop     dx
    add     dx,6
    lea     bx,arrayOfSum
    mov     [bx][di],ax
    add     di,2     
    loop    sum1   
    
    lea bx, arrayOfSum
    mov si,0
    mov cx,3
    
    ;vivod massiva summ
    write crlf
    
    write crlf  
out5:   
    xor     ax,ax
    mov ax,[bx][si] 
    lea di,buf1+2  
    call putdigit
	lea dx,buf1+2
	mov ah,9
	int 21h     
    add     si,2
    loop    out5
 
       
       
    ;sort    

    mov cx, 3   
    mov si, 0
    
sort:
           
    push si
    lea bx, arrayOfSum            
    mov ax,[bx][si]
    mov di,si
    mov dx,si
    push cx   
    
find_smallest:
            
   
    dec cx
    jcxz change_arrayOfSum  
    add di,2
    cmp ax,[bx][di]
    jg changing 
    cmp ax,[bx][di]
    jle find_smallest    
    
changing:
    
    mov ax,[bx][di]
    mov dx,di
    jmp find_smallest
                            
              
change_arrayOfSum:  
      
    mov di, dx
    mov dx,[bx][si]
    mov [bx][si],ax
    mov [bx][di],dx 
    
    lea bx, array
    mov cx, 3
                           
    
change_array:
    
    mov dl, 3
    mov ax,di
    mul dl
    mov di,ax
    mov ax,si
    mul dl
    mov si,ax

changing_array:
    
                                
    mov ax,[bx][di]
    mov dx,[bx][si]
    mov [bx][di], dx
    mov [bx][si], ax
    add si,2
    add di,2
    loop changing_array  
    
             
    pop cx 
    dec cx
    pop si
    add si,2
    mov dx, cx  
    cmp dx, 1
    je end_sort
    jmp sort        

        
  
end_sort:  
     
    ;vivod otsorivonnogo massiva summ
     
    lea bx, arrayOfSum
    mov si,0
    mov cx,3
    
    write crlf
    
    write crlf  
out6:   
    xor     ax,ax  
    mov ax,[bx][si]
    lea di,buf1+2  
    call putdigit
	lea dx,buf1+2
	mov ah,9
	int 21h  
    add     si,2    
    loop    out6      
    
  ;output new matrix
    
    write crlf
                     
    lea     bx,array
    mov     cx,3
out3:   
    push    cx
    mov     cx,3
    mov     si,0
 
    write crlf  
out4:   
    xor     ax,ax     
    mov     ax,[bx][si]
    lea     di,buf1+2  
    call putdigit
	lea     dx,buf1+2
	mov     ah,9
	int     21h     
    add     si,2
    loop    out4
 
    add     bx,6
    pop     cx
    loop    out3         
    
                                    
 
    ;press any key
    write msgPress
    mov     ah,0
        int     16h
;exit
    mov     ax,4c00h
    int     21h
end start
0