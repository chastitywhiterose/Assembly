# Chapter 5: Integer Sequences and Their Application in Learning

To be a programmer in any language, a person needs more than information. There must be a motivation for something you want to make. The challenge is that when you are a beginner, it can be easy to get discouraged because you won't be making anything big or impressive to other people at the start. All you have to work with in most programming languages is displaying text and numbers.

Later on, you can learn to use third-party libraries or native APIs for your operating system. However, what I have always disliked is that the internals of how they work are hidden or obfuscated so that you don't know how they work.

But if you love math as I do, you will never have a problem testing your ability by writing small programs to print integer sequences. In this chapter, I will be sharing 3 of my favorite sequences.

- [Fibonacci numbers](https://oeis.org/A000045)
- [Powers of 2](https://oeis.org/A000079)
- [Prime Numbers](https://oeis.org/A000040)

If you have the ebook edition of this book, you will be able to click the links above and learn more about these sequences. Either way, I will show you the code that makes printing these sequences easy. even in Assembly Language

## Fibonacci numbers

```
org 100h
main:

mov word [radix],10
mov word [int_width],1

mov ax,0
mov bx,1

Fibonacci:

call putint
add ax,bx
push ax
mov ax,bx
pop bx
cmp ax,1000
jb Fibonacci

mov ax,4C00h
int 21h

include 'chastelib16.asm'
```

When executed, that program will output the following sequence

```
0
1
1
2
3
5
8
13
21
34
55
89
144
233
377
610
987
```

Just by looking at it, hopefully you see the pattern. Each number is the sum of the previous two numbers. The loop in this program needed to swap the numbers in ax and bx each time before the next add. Technically, there are two other ways I could have achieved it. I could have used ecx as a temporary storage. I also could have used the xchg instruction, which does the same thing, but the stack provided me a convenient way of doing it. We only needed to save the ax register before it was overwritten with bx, then we popped into bx the pushed ax from earlier. None of these methods is more correct than any other, but I tend to favor simplicity and therefore am limiting the type of instructions I use. I also think that using a third register or even another memory location is acceptable for something like this. Still, since the stack is already used for function calls and is an expected part of Assembly, there is no reason not to use it, especially when we only need to save one register.

## Powers of 2

```
org 100h
main:

mov word [radix],10
mov word [int_width],1
mov [int_newline],0

mov cx,0

mov [array],byte 1

powers_of_two:

;this section prints the digits
mov bx,[length]
array_print:
dec bx
mov ax,0
mov al,[array+bx]
call putint
cmp bx,0
jnz array_print
call putline

;this section adds the digits
mov dl,0
mov bx,0
array_add:
mov ax,0
mov al,[array+bx]
add al,al
add al,dl
mov dl,0
cmp al,10
jb less_than_ten

sub al,10
mov dl,1

less_than_ten:
mov [array+bx],al
inc bx
cmp bx,[length]
jnz array_add

cmp dl,0
jz carry_is_zero

mov [array+bx],1
inc [length]

carry_is_zero:

;keeps track of how many times the loop has run
add cx,1
cmp cx,64
jna powers_of_two

mov ax,4C00h
int 21h

length dw 1
array db 32 dup 0

include 'chastelib16.asm'
```

The above program will display the powers of two. This sequence is 1,2,4,8,16,32,64,128,256, etc., all the way until 18446744073709551616, which is two to the 64th power. You will notice that this is far beyond 32768, which was as high as the powers of two program from chapter 3 was. Normally, we could never achieve this in 16-bit DOS mode if we were dealing with native 16-bit integers. Fortunately, there is a method called Arbitrary Precision Arithmetic.

As fancy as that sounds, it is really just using an array of bytes as if they were decimal digits. These lines define variables for the array and the length of the array.

```
length dw 1
array db 32 dup 0
```

The "length" starts at 1, and the total size of the array is 32 bytes, initialized to zero. These variables form the boundaries of several different loops in the program. This loop is what displays the current used parts of the array.

```
;this section prints the digits
mov bx,[length]
array_print:
dec bx
mov ax,0
mov al,[array+bx]
call putint
cmp bx,0
jnz array_print
call putline
```

The bx register is set to the current value of length, which will be 1 at the start of the program. Then, bx is decremented so that it is 1 less than the length. Remember, arrays range from 0 to the length minus 1 in Assembly, just like would be the case in C and other languages.

During this loop, while bx is not 0, we set ax to 0 and then load al (the lower half of ax), with the byte at the address of the array plus the number in the bx register. We call the putint function on this value to print the number in al.

The newline is not printed during this loop because of the following line near the beginning.

```
mov [int_newline],0
```

By turning the newlines off that putint would normally print, we gain control of exactly when we want to. I created another small function named "putline" which prints a newline when I call it. Here is the source code of the putline function.

```
line db 0Dh,0Ah,0

putline:
push ax
mov ax,line
call putstring
pop ax
ret
```

After the currently used digits in the array are printed, another loop begins that adds the digits to themselves. Each one is loaded into al, then al is added to itself. The ld register, which is initialized to 0, is the "carry" variable. If the result of al+al is less than 10, we jump to the "less_than_ten:" label and write the new digit back to the array in that index. If, however, the digit in al is 10 or above, we have to subtract 10 and then set dl (our carry) to 1 so that the next digit we add to itself will also have the carry added to it.

```
;this section adds the digits
mov dl,0
mov bx,0
array_add:
mov ax,0
mov al,[array+bx]
add al,al
add al,dl
mov dl,0
cmp al,10
jb less_than_ten

sub al,10
mov dl,1

less_than_ten:
mov [array+bx],al
inc bx
cmp bx,[length]
jnz array_add
```

The process of this loop is basically the same way we would add the digits of numbers on paper. However, since we are adding the number to itself, the process is greatly simplified.

But perhaps the final piece of this powers of two program that needs a special mention is the part that expands how many digits are displayed by incrementing the length if a carry of 1 still remains. If the final digit processed had a result of 10 or greater, the carry in dl would have been set to 1, but there would not be a digit to add this to.

```
cmp dl,0
jz carry_is_zero

mov [array+bx],1
inc [length]

carry_is_zero:
```

We set the byte at "array+bx" to 1 and then increment the length variable so that the new digit becomes permanently part of the list of bytes that is displayed and added to itself, plus the carry from each previous digit addition.

The total number of bytes declared for the array in the program was 32 with the statement "array db 32 dup 0". So the loop would stop working if we went beyond this limit. However, it is reasonable to say that if we wanted to, we could get away with reassembling with 30,000 bytes and display powers of two with that many digits. We would still be far under the limit of the 64 kilobyte memory limit for a ".com" program in DOS.

I hope I haven't lost you with my explanation of the arbitrary precision Powers of 2 program. The original version was written in my first programming language, QBASIC, and was the first time I had successfully learned how to use arrays.

At 14 years old, I was learning the concepts of arrays and memory addresses for the first time. I remember a very helpful user on the Network54 QBASIC forum explained it over and over again until I understood.

The syntax of the Assembly version of the Powers of 2 algorithm may look strange. Still, it follows all the same steps as the original QBASIC program and the C version, which later became part of "Chastity's Code Cookbook".

## Prime Numbers

```
org 100h
main:

mov word [radix],10
mov word [int_width],1
mov [int_newline],0

;the only even prime is 2
mov ax,2
call putint
call putspace

;fill array with zeros up to length
mov bx,0
array_zero:
mov [array+bx],0
inc bx
cmp bx,length
jb array_zero

;start by filtering multiples of first odd prime: 3
mov ax,3

primes:

;print this number because it is prime
call putint
call putspace

mov bx,ax ;mov ax to bx as our array index variable
mov cx,ax ;mov ax to cx
add cx,cx ;add cx to itself

sieve:
mov [array+bx],1 ;mark element as multiple of prime
add bx,cx ;check only multiples of prime times 2 to exclude even numbers
cmp bx,length
jb sieve

;check odd numbers until we find unused one not marked as multiple of prime
mov bx,ax
next_odd:
add bx,2
cmp [array+bx],0
jz prime_found
cmp bx,length
jb next_odd
prime_found:

;get next prime read to print in ax
mov ax,bx
cmp ax,length
jb primes

mov ax,4C00h
int 21h

include 'chastelib16.asm'

length=1000
array rb length
```

The primes program uses a method called the "Sieve of Eratosthenes". It is an ancient but very fast algorithm to implement in almost any programming language. The program can find all primes less than 1000 in less than a second.

A Sieve is a process of elimination. Imagine you have all the numbers from 0 to 100. A prime number, by definition, has only two factors: itself and 1.

The only even prime number is 2. It is the first prime number because 1 times 2 equals 2. There are only two factors. Since all even numbers like 4,6,8,10,12, etc are multiples of 2. We exclude them from the list of possible primes. The new number, which is not crossed out, is 3. We then cross out all multiples of 3. Then the next number still in the list after 3 is 5. 4 doesn't exist because we already excluded multiples of 2. 5 is our next prime number after 3 for this reason. We cross out all multiples of 5 like 10,15,20,25, etc. In fact, some of these would have already been excluded because they are multiples of 2.

In summary, the primes program has an array of 1000 bytes. We use each of these bytes as items to keep track of whether they are prime or not. Every item in the array starts as 0 (prime until proven otherwise). We print 2 because it is a known even prime. We then do the same for 3 because it is the first odd prime. Then we mark all indexes which are a multiple of 3 as 1(not prime). We then skip ahead to the next odd index, which is not marked.

The result will be 2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61. The list contains all odd numbers after 2, and some of them are excluded because they are multiples of other odd numbers.

9 is not prime because 3*3 is 9.
21 is not prime because 3*7 is 21.
And so it continues.

This prime algorithm requires a lot of memory, and so finding the first billion primes is not something that can be done in a 64 KB DOS program because of memory limitations. However, this method is fast because it uses only addition and subtraction (excluding the division used in the intstr function of my library). On a modern PC running Linux instead of DOS, it is easier to allocate gigabytes of memory and find lists of even higher primes.

## How to use these examples

My suggestion is that you download the examples in this chapter from my github repository rather than trying to type them by hand or copy past them. That way you can assemble them with FASM and run them in the DOSBox emulator to see how they work.

<https://github.com/chastitywhiterose/Assembly/tree/main/fasm/dos/AAA-DOS-book-examples/>

These programs can produce long lists of numbers and so I can't include all the output in this book. You will have to run them to get the full picture of how magnificent they are!