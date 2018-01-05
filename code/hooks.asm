;This is free and unencumbered software released into the public domain.
;
;Anyone is free to copy, modify, publish, use, compile, sell, or
;distribute this software, either in source code form or as a compiled
;binary, for any purpose, commercial or non-commercial, and by any
;means.
;
;In jurisdictions that recognize copyright laws, the author or authors
;of this software dedicate any and all copyright interest in the
;software to the public domain. We make this dedication for the benefit
;of the public at large and to the detriment of our heirs and
;successors. We intend this dedication to be an overt act of
;relinquishment in perpetuity of all present and future rights to this
;software under copyright law.
;
;THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
;IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
;OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
;ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
;OTHER DEALINGS IN THE SOFTWARE.

;IMPORTANT(adm244): SCRATCH VERSION JUST TO GET IT UP WORKING

extern ProcessWindowAddress: qword

extern Unk3ObjectAddress: qword
extern TESConsoleObjectAddress: qword
extern GlobalScriptStateAddress: qword

extern mainloop_hook_return_address: qword
extern loadgame_start_hook_return_address: qword
extern loadgame_end_hook_return_address: qword

extern GameLoop: proc
extern LoadGameBegin: proc
extern LoadGameEnd: proc

pushregs MACRO
  push rbx
  push rbp
  push rdi
  push rsi
  push r12
  push r13
  push r14
  push r15
ENDM

popregs MACRO
  pop r15
  pop r14
  pop r13
  pop r12
  pop rsi
  pop rdi
  pop rbp
  pop rbx
ENDM

.code
  GameLoop_Hook proc
    pushregs
    call GameLoop
    popregs
    
    mov rcx, Unk3ObjectAddress
    call ProcessWindowAddress
    
    jmp [mainloop_hook_return_address]
  GameLoop_Hook endp
  
  LoadGameBegin_Hook proc
    pushregs
    
    push rcx
    mov rcx, rdx
    sub rsp, 8h
    call LoadGameBegin
    add rsp, 8h
    pop rcx
    
    popregs
    
    mov qword ptr [rsp+18h], rbx
    mov qword ptr [rsp+10h], rdx
    push rbp
    push rsi
    push rdi
    
    jmp [loadgame_start_hook_return_address]
  LoadGameBegin_Hook endp
  
  LoadGameEnd_Hook proc
    pushregs
    call LoadGameEnd
    popregs
    
    add rsp, 400h
    pop r15
    pop r14
    pop r13
    
    jmp [loadgame_end_hook_return_address]
  LoadGameEnd_Hook endp
  
  GetConsoleObject proc
    mov rax, qword ptr [TESConsoleObjectAddress]
    mov rax, qword ptr [rax]
    
    ret
  GetConsoleObject endp
  
  GetGlobalScriptObject proc
    mov rax, qword ptr [GlobalScriptStateAddress]
    mov rax, qword ptr [rax]
    
    ret
  GetGlobalScriptObject endp
end
