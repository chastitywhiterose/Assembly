lda #$0
tax
tay
loop_stripe_vertical:
sta $200,x
inx
eor #$1
iny
cpy #$0
bne loop_stripe_vertical




lda #$0
tax
tay
loop_stripe_horizontal:
sta $500,x
pha ;push A to the stack
txa ;transfer X to A
clc ;clear carry flag before addition
adc #$20 ;add $20 to go down a line
tax ;transfer A back to X
pla ;pull original A back from stack
iny
eor #$1
inx
cpy #$0
bne loop_stripe_horizontal
