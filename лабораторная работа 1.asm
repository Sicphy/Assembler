org 100h

.model tiny
.code

start: mov ah,9
       mov dx,offset message
       int 21h
ret

message db "Hello World!", 0Dh,0Ah,'$'
end start              



