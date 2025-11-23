lda #$0
tax
loop_color:
sta $200,x
inx
clc
adc #$1
cmp #$0
bne loop_color
