.model small
.stack 100h
 
.data
rows        dw ?
cols        dw ?
array       db 3*3 dup (?)
arrayOfSum  dw 3 dup (0)
tempArray   db 6 duo (?)
crlf        db 13,10,'$'
buf     db 3,0,3 dup ('$'),'$'
msgPress    db 13,10,'Press any key...$'
input_string       db 13,10,'Input elements: ',13,10,'$'
 
 
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
 

putdigit macro
    local lput1
    local lput2
    local exx
 
    push    ax
    push    cx
    push    -1  
    mov     cx,10   
lput1:  xor     dx,dx   
    mov     ah,0                   
    div     cl   
    mov     dl,ah   
    push    dx  
    cmp al,0     
    jne lput1   
    mov ah,2h
lput2:  pop dx  
    cmp dx,-1    
    je  exx
    add dl,'0'  
    int 21h 
    jmp lput2   
exx:
    mov dl,' ' 
    int 21h
    pop cx
    pop     ax
endm
 

indigit macro
    local   lin
    push    bx
    push    cx
    push    dx
 
    mov     ah,0Ah  
    lea     dx,buf
    int     21h
 
    xor     ax,ax
    xor     cx,cx
    
    mov     cl,[buf+1] 
    xor     di,di
lin:
    mov     dl,10
    mul     dl
    mov     bl,[buf+di+2]
    sub     bl,30h  
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
 
    write input_string
                  
    ;input matrix              
    lea     bx,array
    mov     cx,3
in1:    
    push    cx
    mov     cx,3
    mov     si,0
in2:   
    indigit 
    mov     [bx][si],al
    inc     si
 
    write crlf  
    loop    in2
 
    add     bx,3
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
    mov al,[bx][si] 
    putdigit    
    inc     si
    loop    out2
 
    add     bx,3
    pop     cx
    loop    out1         
    
    ;string sum
    
    
    mov     cx,3
    mov     di,0 
    mov     dx,0
     
    
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
    mov     dl,[bx][si] 
    add     ax,dx     
    inc     si
    loop    sum2
                
                
    pop     cx
    pop     dx
    add     dx,3
    lea     bx,arrayOfSum
    mov     [bx][di],ax
    add     di,2     
    loop    sum1
    
    lea bx,arrayOfSum
    mov si, 0
    mov cx, 3   
    
    lea bx, arrayOfSum
    mov si,0
    mov cx,3
    
    ;vivod massiva summ
    write crlf
    
    write crlf  
out5:   
    xor     ax,ax
    mov al,[bx][si] 
    putdigit    
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
    mov dh, 2
    mov ax,di
    div dh
    mul dl
    mov di,ax
    mov ax,si
    div dh
    mul dl
    mov si,ax

changing_array:
    
                                
    mov ah,[bx][di]
    mov al,[bx][si]
    mov [bx][di], al
    mov [bx][si], ah
    inc si
    inc di
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
    mov al,[bx][si] 
    putdigit    
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
    mov al,[bx][si] 
    putdigit    
    inc     si
    loop    out4
 
    add     bx,3
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