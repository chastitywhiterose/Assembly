;this part draws vertical stripes
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

;this part makes a checkerboard
lda #$0
tax
tay
loop_checkerboard:
sta $380,x
inx
eor #$1

iny
cpy #$20
bne color_keep_checker

pha ;push A to the stack
lda #$0 ;load A with zero
tay ;transfer A to Y
pla ;pull original A back from stack
eor #$1

color_keep_checker:
cpx #$0
bne loop_checkerboard

;this part draws horizontal stripes
lda #$0
tax
tay
loop_stripe_horizontal:
sta $500,x
inx
;eor #$1

iny
cpy #$20
bne color_keep

pha ;push A to the stack
lda #$0 ;load A with zero
tay ;transfer A to Y
pla ;pull original A back from stack
eor #$1

color_keep:
cpx #$0
bne loop_stripe_horizontal
