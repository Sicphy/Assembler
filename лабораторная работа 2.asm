org 100h
 
jmp start
 
string1 db 255 dup('$')   
newstr db 0ah, 0dh, '$'
instr db "enter string:",0Dh,0Ah,'$'
 
start:      mov dx,offset instr            ;instruction
            mov ah,09h    
            int 21h
                        
            mov bx,offset string1          ;vvod
            mov [bx],255
            mov dx, bx  
            mov ah,0Ah  
            int 21h
            add bl, string1[1]
            add bx, 2
            mov [bx],'$'
            
            xor dx,dx   
            xor ax,ax
 
            lea bx, string1
            add bx, 2
 
            mov si, bx  
            mov di, bx
            dec si
 
next_char:  inc si                         ;prohod po stroke
            mov al,[si]
            cmp al,' '       
            je found_the_end 
            mov al, [si]      
            cmp al,','       
            je found_the_end 
            mov al, [si]
            cmp al,'.'       
            je found_the_end 
            mov al, [si]
            cmp al,'$'
            je found_the_end
            jmp next_char
 
found_the_end:  mov dx,si                ;naiden probel ili , ili . ili $
                dec si   
                mov bx, di
 
reverse:    cmp bx, si                   ;inversia slova
            jae end
            
            mov al, [bx]
            mov ah, [si]
            
            mov [si], al
            mov [bx], ah
            
            inc bx
            dec si
            jmp reverse
 
end:        mov si,dx                   ;rezult
            inc dx
            mov bx,dx
            mov di,bx 
            mov al,[si]  
            
            mov ah,[si] 
            cmp ah,'$'
            jne next_char
                        
            mov dx, offset newstr     ;vivod riversnoi stroki
            mov ah, 09h
            int 21h
            mov dx,offset string1
            add dx,2
            mov ah, 09h
            int 21h
            
           
 
mov ah, 0
int 16h
 
ret