FK_MIPS:
    .data
garbage:    .asciiz     "*"
    

str_table_big:  .asciiz     "Alpha","Bravo","Charlie","Delta","Echo","Foxtrot","Golf","Hotel",
        "India","Juliet","Kilo","Lima","Mike","November","Oscar","Papa","Quebec","Romeo","Sierra","Tango",
        "Uniform","Victor","Whisky","X-ray","Yankee","Zulu"
str_table_small: .asciiz    "alpha","bravo","charlie","delta","echo","foxtrot","golf","hotel",
        "india","juliet","kilo","lima","mike","november","oscar","papa","quebec","romeo","sierra","tango",
        "uniform","victor","whisky","x-ray","yankee","zulu"
offest_str:   .word   0,6,12,20,26,31,39,44,50,56,63,68,73,78,87,93,98,105,111,118,124,
        132,139,146,152,159

number_table:   .asciiz     "zero","First","Second","Third","Fourth","Fifth","Sixth","Seventh","Eight","Ninth"
offest_num:    .word    0,5,11,18,24,31,37,43,51,57,63

boundary:   .word   48,57,65,90,97,122


str_buffer:     .space  40      #这段空间用来放置输进来的东西。Byte为单位。

    .text
    .globl main     #网上学的，只是为了防止对main的重复声明。

main:
step_start:
    la $s4,boundary
    li $v0,8
    la $a0,str_buffer
    li $a1,39
    syscall     #设置好参数，开始读入
    li $t0,0    #清零设置。主要是忘了MIPS的符号扩展指令了。
    lb $t0,($a0)   #现在t0里面储存了第一个输入的ascii码

    lw $t1,($s4)   #接下来的几个数字分别储存了0-9和A-Z的范围。
    lw $t2,4($s4)
    lw $t3,8($s4)
    lw $t4,12($s4)
    lw $t5,16($s4)
    lw $t6,20($s4)

    bge $t0,$t1,step1
    j processing_not
step1:
    bgt $t0,$t2,step2
    j processing_number 
step2:
    bge $t0,$t3,step3
    j processing_not
step3:
    bgt $t0,$t4,step4
    j processing_char_big
step4:
    bge $t0,$t5,step5
    j processing_not
step5:
    bgt $t0,$t6,processing_not
    j processing_char_small

processing_number:
    li $v0,4
    addi $t1,$t0,-48
    sll $s0,$t1,2
    la $t2,offest_num
    add $s1,$s0,$t2   #Now the address is in $s1
    lw $t4,($s1)   #Now the offset address is in $t4
    la $t3,number_table
    add $a0,$t3,$t4 #Now a0 have the correst address
    syscall
    j step_start

processing_char_big:    #Need to processing the value of 
    li $v0,4
    addi $t1,$t0,-65
    sll $s0,$t1,2
    la $t2,offest_str
    add $s1,$s0,$t2   #Now the address is in $s1
    lw $t4,($s1)   #Now the offset address is in $t4
    la $t3,str_table_big
    add $a0,$t3,$t4 #Now a0 have the correst address
    syscall
    j step_start

processing_char_small:  
    li $v0,4
    addi $t1,$t0,-97
    sll $s0,$t1,2
    la $t2,offest_str
    add $s1,$s0,$t2   #Now the address is in $s1
    lw $t4,($s1)   #Now the offset address is in $t4
    la $t3,str_table_small
    add $a0,$t3,$t4 #Now a0 have the correst address
    syscall
    j step_start

processing_not:     #跳转输出或者结束。
    li $t5,63
    beq $t0,$t5,step_exit
    li $v0,4
    la $a0,garbage
    syscall
    j step_start
step_exit:
    li $v0,10
    syscall