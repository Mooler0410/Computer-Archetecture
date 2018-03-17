OMG_MIPS:
    .data
exit_signal:    .word   63  #缁撴潫绗﹀彿 锛�
stop_signal:    .word   10

str_buffer:     .space  100 #璇诲叆鐨勫瓧绗︿覆鐨勭紦鍐茬┖闂�
char_buffer:    .space  10  #璇诲叆鐨勬煡鎵惧瓧绗︾殑缂撳啿绌洪棿

str_success:    .asciiz "Success Location: "
str_fail:       .asciiz "Fail!"
str_n:          .asciiz "\n"

    .text
    .globl main

main:
    la $s5,exit_signal	
    lb $t2,($s5)    #鎶婄粨鏉熸爣蹇楋紝锛� 瀛樺湪t2涓�
    la $s5,stop_signal
    lb $t3,($s5)    #鎶婂瓧绗︿覆缁撴潫鏍囧織锛� NULL 瀛樺湪 t3涓�

    li $v0,8
    la $a0,str_buffer
    la $a1,100
    syscall
search_begin:
    la $s0,str_buffer
    li $v0,8
    li $t4,1    #t4鐢ㄤ簬璁℃暟
    la $s1,char_buffer
    la $a0,char_buffer
    la $a1,10
    syscall
    lb $t0,($s1)
    beq $t2,$t0,processing_exit     #鍒ゆ柇鏄惁瑕佺粨鏉�
loop:
    lb $t1,($s0)
    beq $t3,$t1,processing_none     #鍒板ご浜嗭紝娌℃壘鍒�
    beq $t0,$t1,processing_find
    addi $s0,$s0,1
    addi $t4,$t4,1
    j   loop 

processing_find:
    la $a0,str_success
    li $v0,4
    syscall
    move $a0,$t4
    li $v0,1
    syscall
    li $v0,4
    la $a0,str_n
    syscall
    j search_begin

processing_none:
    la $a0,str_fail
    li $v0,4
    syscall
    la $a0,str_n
    syscall
    j search_begin

processing_exit:
    la $v0,10
    syscall
