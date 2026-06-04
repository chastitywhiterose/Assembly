# Chapter 6: Chastity's Intel Assembly Reference

I use a very small subset of the Intel 8086 family instruction set. This is both because I want to limit it to my small memory (my brain memory, not computer memory). If you are like me and have a tendency to forget things, then Assembly language is actually very good because there is not a lot to remember when compared to bigger high level languages like C++ or Java. And if you do forget, this chapter will function as the definitive guide for performing math using Assembly language for Linux

**Important note. All program listings in this chapter assume that you also included the putstring,intstr,and putint functions as shown in chapters 2 and 3. This can be done by including external files or just copy pasting their text after the system exit call from eax=1 and interrupt 80h. This keeps the exampled brief by not repeating functions you should already have from chapters 4 and 5.**

At the end of each example, you will see a line the reads

```
include 'chastelib32.asm'
```

The chastelib32.asm file is a file containing the functions listed in chapters 4 and 5 but also includes a lot more commentary than I have included in those chapters. For your convenience, you can download it from my repository and view the entire source code. I can't include the whole file in this book because I keep changing and improving the comments constantly.

**But** you don't need the chastelib32.asm either because you can put the required functions in a file of your choice. As long as you ***included*** them in your source after the exit call, these examples will all work.

## mov

The mov instruction copies a number from one location to another. In the FASM and NASM assemblers, the instruction always takes the form

`mov destination,source`

Think of it as "destination=source" as you would write in C. For example, in the following program which prints the number 8, we see that most of the required data is set up with mov instructions.

```
format ELF executable

main:

mov dword [radix],10
mov dword [int_width],1

mov eax,3
mov ebx,5
add eax,ebx

call putint
call putline

mov eax,1
mov ebx,0
int 80h

include 'chastelib32.asm'

```

That program also contains the call, int, and add instructions to make a program that does something useful. However, mov instructions take up the largest part of any program. Whether you are filling a register with a number, another register, or a memory location, the mov instruction is the way to do it.

## add

Next to mov, you will see that add is going to be your friend in Assembly a lot. In the previous example, we saw that 3 and 5 were added to make 8. Just like mov, add follows the same rules.

`add destination,source`

- Source is left of Destination and separated by a comma
- Source and destination can be registers and memory locations
- Source and Destination cannot both be memory location

Most instructions that take two arguments follow these same rules. Once you have mastered mov and add, you can handle almost anything in a program because you know the basic rules.

There is also the "inc" instruction which takes only one item and adds 1 to it. This is just a shorter way of saying "add Destination,1"

## sub

As its name implies, sub will subtract the Source from the Destination.

`sub destination,source`

Since it follows the same rules as mov and add (starting to see a pattern yet?), subtraction is just as easy as addition.

Just as "add" has "inc", "sub" has the "dec" instruction which subtracts 1. Adding or subtracting 1 are probably the most common thing ever done while programming in any language.

Just as a review of the mov,add,sub instructions, here is a small program to show their effect.

```
format ELF executable

main:

mov dword [radix],10
mov dword [int_width],1

mov eax,8
call putint
call putline
add eax,eax
call putint
call putline
sub eax,4
call putint
call putline

mov eax,1
mov ebx,0
int 80h

include 'chastelib32.asm'
```

That program will output the following.

```
8
16
12
```

This is because we set eax to 8, then we added eax to itself, and finally we subtracted 4 from eax. Once you think about how easy this is, read on to see how multiplication and division work.

## mul

The mul instruction is slightly different than The previous instructions. It takes only one operand which must be either a register or memory location. It multiplies eax by the value of this operand. If the value is too large to fit within the eax register, it puts the higher bits into edx.


## div

The div instruction divides eax by the operand you give it (the divisor). However, division is a tricky operation because not every number divides evenly into another. It is also more complicated by the fact that the edx register is assumed to be the upper half of the bits in the dividend while eax is the lower bits of the dividend.

I know it sounds complicated but it is easier than I can explain. I can illustrate this with a small program that multiplies and divides!

```
format ELF executable

main:

mov dword [radix],10
mov dword [int_width],1

mov eax,12
call putint
call putline
mov ebx,5
mul ebx
call putint
call putline
mov ebx,8
mov edx,0
div ebx
call putint
call putline
mov eax,edx
call putint
call putline

mov eax,1
mov ebx,0
int 80h

include 'chastelib32.asm'
```

The output of that program is this:

```
12
60
7
4
```

This is because 12 was multiplied by 5 to get 60. Then we attempted to divide 60 by 8. It goes in only 7 times (which equals 56). This means the remainder is 4, which is stored in the edx register after the division.

You may also notice in the source above that I set edx to zero before the div instruction. If this is not done, the edx might have mistakenly had another number and been interpreted as part of the dividend.

I also think some terminology about division is helpful here.

- Dividend: The number we are dividing from.
- Divisor: The number we are dividing the dividend by. AKA how many times can we subtract this number from the divisor?
- Quotient: The result of the division.
- Remainder: What is left over if the divisor could not divide perfectly into the dividend.

As much as I love math, I find some of these terms confusing when I try to explain it in English. Let's face it, I am better at Assembly Language and the C Programming Language than I am with English, but it looks like you're stuck with me because normal people are not autistic enough to care!

For a more in depth explanation of the mul and div instructions, I will include those written by Tomasz Grysztar (creator of the FASM assembler) in the official "flat assembler 1.73 Programmer's Manual"

---

*mul performs an unsigned multiplication of the operand and the accumulator. If the operand is a byte, the processor multiplies it by the contents of AL and returns the 16-bit result to AH and AL. If the operand is a word, the processor multiplies it by the contents of AX and returns the 32-bit result to DX and AX.*

*div performs an unsigned division of the accumulator by the operand. The dividend (the accumulator) is twice the size of the divisor (the operand), the quotient and remainder have the same size as the divisor. If divisor is byte, the dividend is taken from AX register, the quotient is stored in AL and the remainder is stored in AH. If divisor is word, the upper half of dividend is taken from DX, the lower half of dividend is taken from AX, the quotient is stored in AX and the remainder is stored in DX.*

---

Perhaps you can see that Assembly language is nothing more than a fancy calculator, except better. This is because there is no question which order the operations take place in. There is no need for mnemonics like *"Please excuse my dear Aunt Sally"* to remind us *"Parentheses, Exponents, Multiplication and Division (from left to right), and Addition and Subtraction"*.


There are still two more instructions before we can construct loops in Assembly programs.

## cmp

The cmp instruction compares two operands but does not do any math with them. They remain unchanged but modify flags in the processor that allow us to jump based on certain conditions.

## jmp

The jmp instruction jumps to another location regardless of any conditions. It has a family of other jump instructions that jump only if certain conditions are true. In fact many of them have multiple names for the same operation. For example je and jz both jump if the two numbers compared would be zero if they were subtracted. This would only be true if they are the same.

Here is a small chart or table for the conditional jumps I use in my programs.

## Conditional Jumps Table

|Instruction|Meaning|
|-------|-------------|
|je/jz  |jump if equal|
|ja     |jump if above|
|jb     |jump if below|
|jne/jnz|jump if not equal|
|jna    |jump if not above|
|jnb    |jump if not below|

Aside from those main 6 conditional jumps that I have memorized, there also exists jl(jump if less) and jg(jump if greater). However, they are for signed/negative numbers which I have not covered. Personally I don't agree with the way negative numbers are represented in computers but I know that understanding the context of signed vs unsigned is important for more complex programs. Once again, I recommend the FASM programmers manual for details that I have excluded for the purpose of keeping this book short.


The following program can print a message telling you whether eax is less than , equal to, or more than ebx. Upon this foundation all the conditional jumps in my programs and functions are based.


```
format ELF executable
main:

mov dword [radix],10
mov dword [int_width],1

mov eax,5
mov ebx,8
cmp eax,ebx
jb less
je same
ja more

less:
mov eax,string_less
jmp the_end
same:
mov eax,string_same
jmp the_end
more:
mov eax,string_more
jmp the_end

the_end:
call putstring

mov eax,1
mov ebx,0
int 80h

string_less db 'eax is less than ebx',0Ah,0
string_same db 'eax is the same as ebx',0Ah,0
string_more db 'eax is more than ebx',0Ah,0

include 'chastelib32.asm'
```

Personally, I think that the system of conditional jumps makes a lot of sense. Other programming languages such as BASIC and C have "goto" statements that work like this. For example, `if(eax<ebx){goto less;}`.

Modern programming languages tend to discourage use of goto or not allow it at all. However, these languages are still using jumps I have described in this section because it is required by the hardware. Both "if" and "while" statements are written by using the conditional jump statements most relevant to what you are trying to do.

The only thing I have found difficult about jumps in assembly is remembering which acronym means which condition. However, since I created the chart in this chapter, now I can refer to it and you can too! As long as I keep these main six types of conditions in my head, and am working with unsigned numbers, I can write almost any assembly program from scratch.

## push/pop

The push and pop instructions are something you have already seen in my code. They operate on what is called the "stack". Basically, when you push something, it is like pushing a box of cereal onto a shelf at Walmart. The last item pushed is at the front and will be the first item a customer sees. This is what is called a Last In First Out.

Not only is the stack useful for saving the value of registers temporarily as I do, but without it, it would not be possible to have callable functions. When you call a function with "call", it is the same as a "jmp" to that location except that it pushes the address where the program was before the call. The "ret" instruction returns to the location that called the function and then proceeds to instructions after it.

The sp register, as I mentioned in chapter 1, is the stack pointer. Every time you push a value, it stores it at the address the stack pointer is pointing to and then subtracts the size of the native dword size. For example, this is always 16 bits in the context of DOS programming for 16 bit .com files. This means that you can use it with the other registers to save their value for later.

In the next chapter, I will show a useful example of the push and pop instructions and explain a little bit more about this.

## Take it slow

I know I hit you with a lot of information in this chapter, but trust me, I am intentionally leaving out a lot because I don't want this book to be the size of the Intel® 64 and IA-32 Architectures Software Developer Manuals.

<https://www.intel.com/content/www/us/en/developer/articles/technical/intel-sdm.html>

There are hundreds of instructions for Intel machines and yet if you combine the instructions I have described in this chapter with the "call","int", and "ret" instructions required for calling functions for input and output, you will see that it is possible to write almost any program I want with these instructions.

I am sharing what I have learned from reading the Intel Manuals and the API references available for DOS so that you don't have to spend as much time figuring these things out as I did. What I can tell you, though, is that the result was worth it because I have been able to write programs to accomplish tasks faster than my C programs could. At the same time, the Assembly versions took longer to write than the C versions did. This is the price I must pay to have high performing code.

Also, there are some bitwise instructions by the names of AND,OR,XOR,NOT,SHL,SHR that are sometimes useful for making programs faster and smaller. However, these only make sense in the context of the Binary Numeral System and I suspect that the average reader of this book does not have the 25 years of experience in Binary math that I do.

I will be explaining more about these operations in a later chapter because they help a lot when trying to optimize programs for size and speed. However they can make programming LOOK complicated and scare away potentially great new programmers who are just trying to learn to apply the 4 regular arithmetic operations of addition, subtraction, multiplication, and division which apply to all number bases.
