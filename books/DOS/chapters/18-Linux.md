# Chapter 18: Bitwise Operations for Advanced Nerds

This chapter contains information which will assist you in understanding more about how computers work, but that in general is not required for MOST programming unless you are trying to operate on individual bits.

To start out, I will describe 5 essential bitwise operations independently of any specific programming language. This is because these operations exist in every programming language I know of, including Assembly and C.

After I have explained what the bitwise operations do, I will give examples of how this can be used in Assembly language to substitute for addition and subtraction! You might wonder why you would do this. The fact is that you don't need to but it is a fun trick that only advanced nerds like me do for a special challenge.

## The Bitwise Operations

This chapter explains 5 bitwise operations which operate on the bits of data in a computer. For the purpose of demonstration, it doesn't matter which number the bits represent at the moment. This is because the bits don't have to represent numbers at all but can represent anything described in two states. Bits are commonly used to represent statements that are ***true*** or ***false***. For the purposes of this section, the words AND, OR, XOR are in capital letters because their meaning is only loosely related to the English words they get their name from.

### Bitwise AND Operation

```
0 AND 0 == 0
0 AND 1 == 0	
1 AND 0 == 0
1 AND 1 == 1
```

Think of the bitwise AND operation as multiplication of single bits. 1 times 1 is always 1 but 0 times anything is always 0. That's how I personally think of it. I guess you could say that something is true only if two conditions are true. For example, if I go to Walmart AND do my job then it is true that I get paid.

I like to think of the AND operation as the "prefer 0" operation. It will always choose a 0 if either of the two bits is a 0, otherwise, if no 0 is available, it will choose 1.

### Bitwise OR Operation

```
0 OR 0 == 0
0 OR 1 == 1	
1 OR 0 == 1
1 OR 1 == 1
```

The bitwise OR operation can be thought of as something that is true if one or two conditions are true. For example, it is true that playing in the street will result in you dying because you got run over by a car. It is also true that if you live long enough, something else will kill you. Therefore, the bit of your impending death is always 1. 

I like to think of the OR operation as the "prefer 1" operation. It will always choose a 1 if one of the two bits is a 1, otherwise, if no 1 is available, it will choose 0.

### Bitwise XOR Operation

```
0 XOR 0 == 0
0 XOR 1 == 1	
1 XOR 0 == 1
1 XOR 1 == 0
```

The bitwise XOR operation is different because it isn't really used much for evaluating true or false. Instead, this operation returns 1 if the bits compared are different or 0 if they are the same. This means that any bit, or group of bits, XORed with itself, will always result in 0.

If you look at my XOR chart above, you will see that using XOR of any bit with a 1 causes the result to be the opposite of the original bit.

The XOR operation is the quickest way to achieve this bit inversion. If you have a setting that you want to switch on or off, you can toggle it by XORing that bit with 1.

While the AND, OR, XOR operations can work in the context of individual bits, or groups of them, the next operations, the bit shifts, only make sense in the context of a group of bits. At minimum, you will be operating on 8 bits at a time because a byte is the lowest addressable size of memory.

### Bitwise Left and Right Shift Operations

Consider the case of the following 8 bit binary value:

00001000

This would of course represent the number 8 because a 1 is in the 8's place value. We can left shift or right shift.

```
00001000 ==  8 : is the original byte

00010000 == 16 : original left shift 1
00000100 ==  4 : original right shift 1
```

That is really all there is to shifts. They can be used to multiply or divide by a power of two. In some cases, this can be faster than using the mul and div instructions described in chapter 6.

## Example 00: Fake Add

The following example shows how it is possible to write an addition routine using a combination of the AND,XOR,SHL operations. In this case, the numbers are shown in decimal to be easier for most people to see that the addition is correct.

```
format ELF executable

main:

mov dword [radix],10
mov dword [int_width],1

mov edi,1987
mov esi,39

mov eax,edi
call putint
call putline
mov eax,esi
call putint
call putline

fake_add:
mov eax,edi
xor edi,esi
and esi,eax
shl esi,1
jnz fake_add

mov eax,edi
call putint
call putline
mov eax,esi
call putint
call putline

mov eax,1
mov ebx,0
int 0x80

include 'chastelib32.asm'
```

If you run it, you will see that the correct result of 2026 which is 1987+39. These are the values we set the edi and esi registers to before simulating addition with these fancy bitwise operations that make even seasoned programmers run scared.

But how does this monstrosity of a program work? You see the AND operation keeps track of whether both bits in each place value are 1 or not. If they both are, this means that we have to "carry" those bits as we would do in an ordinary binary addition. We store the carry in the esi register and then left shift it once each time in the loop. The loop continues until esi equals zero and there are no more bits to invert with XOR.

The fact that it works is easy to work out in my head but I don't blame you if you can't visualize it. However, this shows the power of what bit operations can do, even though you will probably never need to do this.

## Example 01: Fake Sub

In case the fake addition example above wasn't enough for you, here is a slightly modified example that does a fake subtraction operation using the same operations. Try it out and you will see that it subtracts 38 from 2025 and gets the original 1987.

```
format ELF executable

main:

mov dword [radix],10
mov dword [int_width],1

mov edi,2026
mov esi,39

mov eax,edi
call putint
call putline
mov eax,esi
call putint
call putline

fake_sub:
xor edi,esi
and esi,edi
shl esi,1
jnz fake_sub

mov eax,edi
call putint
call putline
mov eax,esi
call putint
call putline

mov eax,1
mov ebx,0
int 0x80

include 'chastelib32.asm'
```

I will try to explain how this works. You see, we first XOR the edi register with the esi register. Then, we AND esi with the new value of edi. This means that the bits in the current place value will only both be 1 if those bits were 0 in edi and then were inverted to 1 by the XOR with esi. This means that at the start of the loop, destination bit=0 and source bit=1. 0 minus 1 means that we need to "borrow" (I hate that term because it is really stealing because we never give it back). We left shift esi as usual and then we keep XORing the new borrow in esi until it is zero.

Also, you may have noticed that I never used the "cmp" instruction to compare si with zero in this examples. This is because the zero flag is automatically updated with most operations. In fact there are places in my standard library of functions (chastelib) where it wasn't strictly required to compare with "cmp" but I added it for clarity so I could read my code and more easily remember what I was doing.

But let's face it, the examples in this chapter are purely for showing off how advanced my knowledge of the binary numeral system and manipulating bits in ways no reasonable person should ever attempt. I must admit, it would be great for an obfuscated code contest to make a program with code that is unreadable to most humans.

And while I am on the subject of making unreadable code, why stop at simulating addition and subtraction? I can do multiplication and division too!

## Example 10 Fake Mul

```
format ELF executable

main:

mov dword [radix],10
mov dword [int_width],1

mov edi,6
mov esi,7

mov eax,edi
call putint
call putline
mov eax,esi
call putint
call putline

fake_mul:
mov eax,0
fake_mul_add_loop:
cmp esi,0
jz fake_mul_add_loop_end
test esi,1
jz skip_add
add eax,edi
skip_add:
shl edi,1
shr esi,1
jmp fake_mul_add_loop
fake_mul_add_loop_end:
mov edi,eax

mov eax,edi
call putint
call putline

mov eax,1
mov ebx,0
int 0x80

include 'chastelib32.asm'
```

This fake multiplication uses eax as a temporary variable to store the sum of repeated addition. Each time through the loop, we test the low bit of esi (source register) and add edi (destination register). Each time we double edi by left shifting it once while right shifting esi once.

To test the low bit of esi, this example uses an instruction that has not been presented in this book. However, this is one of those times when it should be used because it is the easiest way to test for a bit.

```
test esi,1
```

This tests the lowest bit of the esi register. If the low bit (ones place) is 0, then the jump if zero command will skip past the part where we add edi to eax.

The purpose of the bit shifts is to reduce the number of times we have to add edi to eax. Because 6 and 7 are the values we use, the loop will execute and exactly these results will happen.

eax starts as 0 but at the end of each cycle, eax, edi, and esi will be these values.

|cycle|eax|edi|esi|
|-----|---|---|---|
|0    |6  |6  |7  |
|1    |18 |12 |3  |
|2    |42 |24 |1  |

In short, because esi was 7 and was represented as 111 in binary, because it is the sum of 4+2+1, then the result of 42 is the sum of:

(4*6)+(2*6)+(1*6)

Because of this optimized algorithm, it took only 3 loop cycles instead of the usual 7 cycles if we had just added 6 to eax 7 times. The speed won't be much for such a small number as 42 but for larger numbers, this is the kind of optimization I would want.

## Example 11 Fake Div

For the final example, I have prepared the long division algorithm. I always wondered why they called it long division, but now that I wrote this 70 line long program just to divide 256 by 10, I finally understand.

Despite its complexity, it follows the same method that humans use for doing long division. We extract the bits from high to low positions from the dividend (edi) and shift them into the low bits of a temporary number (ebx). If this number is large enough (not below divisor) then we subtract the divisor. Each time, we save the resulting bit in the quotient (eax). 0 means the number was too small to subtract the divisor and 1 means it was big enough to subtract the divisor.

Because this is a 32 bit system, the "fake_div_sub_loop" needs to execute exactly 32 times. For this purpose, ecx was chosen as a counter. By initializing it to 1 and left shifting it each time, it will loop 32 times until ecx will be 0 when an overflow happens and the bit is lost.

The eax,ebx,and ecx registers are pushed and popped in this example, despite not being part of a function call. This is to signal that their purpose was temporary and because of the complexity, I thought it would be a good convention to follow for clarity that they are not the final return values.

```
format ELF executable

main:

mov dword [radix],10
mov dword [int_width],1

mov edi,256
mov esi,10

mov eax,edi
call putint
call putline
mov eax,esi
call putint
call putline

fake_div:
;save registers used in the long division algorithm
push eax
push ebx
push ecx
mov eax,0
mov ebx,0
mov ecx,1
cmp esi,0
jz fake_div_sub_loop_end ;div by 0 invalid
fake_div_sub_loop:
cmp ecx,0
jz fake_div_sub_loop_end
shl eax,1
shl ebx,1
test edi,edi ;test edi with itself to check sign bit
jns skip_or  ;skip copy of sign bit if it was 0
or ebx,1     ;store a 1 in low bit of ebx based on sign
skip_or:
shl edi,1

;skip subtraction if ebx is below esi
cmp ebx,esi
jb skip_sub 
sub ebx,esi
or eax,1
skip_sub:

shl ecx,1
jmp fake_div_sub_loop
fake_div_sub_loop_end:

;send results to correct registers and clean up
mov edi,eax ;copy quotient to edi
mov esi,ebx ;copy remainder to esi
;restore registers to their original values
pop ecx
pop ebx
pop eax

mov eax,edi
call putint
call putline

mov eax,esi
call putint
call putline

mov eax,1
mov ebx,0
int 0x80

include 'chastelib32.asm'
```

The results of the fake division program are here:

```
256
10
25
6
```

The program correctly divides 256 by 10 which is 25 but with a remainder of 6. Although this program is probably the most difficult to understand, it gives the correct results.

Which can only mean that the long division algorithm I have in my autistic head works because I used to perform these operations on paper a lot and I know the process so well that I created this example.

## Will I need to know these Algorithms?

Believe it or not, there may be times when you will need to use these algorithms. There are some older processors which don't have multiplication and division instructions. For Intel processors, you can already use the real mul and div instructions.

But I have a feeling that somewhere in the hardware of those instructions on the Intel CPUs, they probably work a lot like the algorithms I wrote for this chapter.

When I promised you Assembly Arithmetic Algorithms, I was not joking. I have spent 26 years learning computer programming and I always liked to learn everything whether other people considered it practical or profitable.
