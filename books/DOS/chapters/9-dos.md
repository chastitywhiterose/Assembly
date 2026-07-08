# Chapter 9: Bitwise Operations for Advanced Nerds

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

That is really all there is to shifts. They can be used to multiply or divide by a power of two. In some cases, this can be faster than using the mul and div instructions described in chapter 4.

## Example 0: Fake Add

The following example shows how it is possible to write an addition routine using a combination of the AND,XOR,SHL operations. In this case, the numbers are shown in decimal to be easier for most people to see that the addition is correct.

```
org 100h

main:

mov word [radix],10 ; choose radix for integer input/output
mov word [int_width],1

mov di,1987
mov si,38

mov ax,di
call putint
mov ax,si
call putint
call putline

fake_add:
mov ax,di
xor di,si
and si,ax
shl si,1
jnz fake_add

mov ax,di
call putint
mov ax,si
call putint

mov ax,4C00h
int 21h

include 'chastelib16.asm'
```

If you run it, you will see that the correct result of 2025 which is 1987+38. These are the values we set the di and si registers to before simulating addition with these fancy bitwise operations that make even seasoned programmers run scared.

But how does this monstrosity of a program work? You see the AND operation keeps track of whether both bits in each place value are 1 or not. If they both are, this means that we have to "carry" those bits as we would do in an ordinary binary addition. We store the carry in the si register and then left shift it once each time in the loop. The loop continues until si equals zero and there are no more bits to invert with XOR.

The fact that it works is easy to work out in my head but I don't blame you if you can't visualize it. However, this shows the power of what bit operations can do, even though you will probably never need to do this.

## Example 1: Fake Sub

In case the fake addition example above wasn't enough for you, here is a slightly modified example that does a fake subtraction operation using the same operations. Try it out and you will see that it subtracts 38 from 2025 and gets the original 1987.

```
org 100h

main:

mov word [radix],10 ; choose radix for integer input/output
mov word [int_width],1

mov di,2025
mov si,38

mov ax,di
call putint
mov ax,si
call putint
call putline

fake_sub:
xor di,si
and si,di
shl si,1
jnz fake_sub

mov ax,di
call putint
mov ax,si
call putint

mov ax,4C00h
int 21h

include 'chastelib16.asm'
```

I will try to explain how this works. You see, we first XOR the di register with the si register. Then, we AND si with the new value of di. This means that the bits in the current place value will only both be 1 if those bits were 0 in di and then were inverted to 1 by the XOR with si. This means that at the start of the loop, destination bit=0 and source bit=1. 0 minus 1 means that we need to "borrow" (I hate that term because it is really stealing because we never give it back). We left shift si as usual and then we keep XORing the new borrow in si until it is zero.

Also, you may have noticed that I never used the "cmp" instruction to compare si with zero in this examples. This is because the zero flag is automatically updated with most operations. In fact there are places in my standard library of functions (chastelib) where it wasn't strictly required to compare with "cmp" but I added it for clarity so I could read my code and more easily remember what I was doing.

But let's face it, the examples in this chapter are purely for showing off how advanced my knowledge of the binary numeral system and manipulating bits in ways no reasonable person should ever attempt. I must admit, it would be great for an obfuscated code contest to make a program with code that is unreadable to most humans.
