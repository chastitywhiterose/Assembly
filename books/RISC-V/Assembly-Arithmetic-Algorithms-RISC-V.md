# Assembly Arithmetic Algorithms

RISC-V Edition

# Preface

This book is the RISC-V edition of Assembly Arithmetic Algorithms. This is the third book in the series but it is a completely acceptable way to learn programming, even for beginners. 

The first book was for 16-bit DOS programming using Assembly. The second book was for 32-bit Linux programming using the same assembly language for Intel machines.

But the book you are reading now, is fundamentally different in nature. It uses simulators that run in any operating system

# Introduction

First, let me introduce this book by telling you what I will teach you. By the end of this book, you will have enough information to write any text-based console program in the form of a 32-bit Linux "ELF" file.

The "ELF" format is an acronym for "Executable and Linkable Format". This format is used on all modern Linux operating systems and some Unix systems like FreeBSD. The header for this format is slightly complicated, but FASM is capable of generating one for you so that you don't generally have to worry about creating it yourself.

If you are a user who prefers NASM, there are also ways to have one generated for you by the GNU linker, which is already installed on any system that has the GCC compiler. The linker does not require you to write C code because it can also link standard ELF objects created by NASM.

## Required Knowledge

To get the most out of this book, some background on the Binary and Hexadecimal numeral systems is going to be helpful, but this is not strictly required because I will be providing functions you can use in your code that will convert between decimal (base ten), binary (base two), and hexadecimal (base 16).

However, I would say that experience in at least one programming language is necessary for an understanding of terminology like "arrays", "pointers", "addresses", "integers", etc. I recommend the C Programming Language as a start. C++ is also a good starting language, but it tends to abstract details away that directly apply to Assembly Language, which is the lowest level a human can go for understanding a computer.

But I think it is perfectly okay for this Assembly language to be your introductory language for the world of computer programming. The language is simple, beautiful, and in my opinion, was designed better than Intel x86. The makers of the RISC-V architecture saw what other processors were doing and in some ways tried to avoid making the same mistakes as previous generations did.

RISC-V is a new processor type and philosophy that was created in 2010 at University of California, Berkeley. The V in its name is actually the Roman number 5. That means there were apparently those named I,II,III,VI in the past.

Many people have high hopes about this new computer architecture that is also old enough to trust. Because it is 16 years old at this time and has been standardized, there are many simulators available. This book will present two of these simulators and perhaps a passing mention of others as I learn about them myself and can provide more links.

But because RISC-V is still relatively young compared to Intel 8086 (year 1978) and ARM (year 1983), I expect that the timing of this book will be of use to people who have heard about RISC-V and wonder what it is about.

## Low Level

Low level is a term that confuses people. People think something high-level is better than low-level. In simple terms, humans consider themselves superior to machines and therefore think themselves higher or more important because of their abstract thought.

A computer thinks only in terms of numbers. A computer may not understand "high-level" abstractions such as love, religion, philosophy, etc, but that is not its job. A computer must add, subtract, multiply, and divide. These are the four arithmetic functions that many humans struggle with.

Therefore, I ask you, between a human and a computer, who is really low level or high level? In the age of Artificial Intelligence taking over human jobs and beating humans at Chess, we would all do well to take this question seriously.

I wrote this book because I think like a machine, and I hope to help others think this way because it is the best way to learn programming and control your computer by writing Assembly Language programs, or to go back to your favorite programming language with a greater understanding of why things work as they do.

## Why Linux?

Linux is a controversial operating system because most people who use a computer just use the operating system that was preinstalled on their computer when they bought it. Usually, this is Windows by Microsoft, MacOS by Apple, or ChromeOS by Google.

Therefore, most of these people don't know that other operating systems exist, unless they are programmers. I am a programmer, and I switched to Linux many years ago on a computer that formerly ran Windows XP and only had 256 megabytes of RAM. It booted up faster than Windows did, and I learned to use the terminal quickly to compile and run my C programs. My DOS background certainly helped me adjust.

The average person is not interested in learning about operating systems. They are usually also not interested in learning about number bases other than the default decimal system humans use.

This book is not for ordinary people. It is for smart people who love to learn how computers work and also to customize their computing experience in a way that only Linux allows. The source code of everything on a GNU/Linux system is available for people to modify anything they like, either by recompiling the source code or by changing a few configuration files, which are usually in a plain text format.

But to explain to the average person why I chose Linux as my primary operating system, I have two reasons.

0. My former favorite OS, DOS, is really old and not suited for the modern world of gaming and programming with better text editors and compilers. Linux is as close as I can get to DOS because I can run commands the way I like, but also enjoy the benefits of a GUI environment when I want to.
1. Microsoft Windows actively sabotages programming by its forced system updates, reboots, and AI advertising forced into every part of the OS. Also, it is REALLY slow because it spends most of the CPU power spying on you and sending the data to Microsoft and the government so they can kill you as soon as you do something they don't like.


# Chapter 1: The First Program

For this chapter, I will explain give the source code of an example program that works in Linux, how to assemble it using the tools FASM or NASM, and finally, how the program works line by line.

First, here is the source code of a program that looks like nonsense but does something really cool.

```
format ELF executable

mov eax,4   ; invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
mov ebx,1   ; write to the STDOUT file
mov ecx,msg ; pointer/address of string to write
mov edx,13  ; number of bytes to write
int 80h

mov eax,1   ; function SYS_EXIT (kernel opcode 1 on 32 bit systems)
mov ebx,0   ; return 0 status on exit - 'No Errors'
int 80h

msg db 'Hello World!',0Ah,0

```

You will need an assembler. My first recommendation is FASM, the Flat Assembler.

<https://flatassembler.net/>

You can download FASM and install it by putting it in your path. The instructions for doing this depend on your operating system but it can be done on Windows, Linux, or even within a DOS operating system. You can assemble your source from any operating system but you will still need a Linux system (either real or emulated) to run the programs made from the source code in this book.

## Assemble with FASM

To assemble this program with FASM, place the source in a file named "main.asm" and run this command from a terminal opened into the same folder as the file.

`fasm main.asm`

FASM will automatically create a "main" in the ELF format that is executable. FASM understands by the command of "format ELF executable" that we intend this file to contain code that will be executed. But we are not read to run it yet. We also have to give the operating system permission to run it! The following command will do the trick.

`chmod +x main`

Now the file will have the Linux permissions to be executed. To execute the program we simple do this command:

`./main`

The dot and backslash is how you run a program that exists in the current directory. The process is the same as any other Linux command except that the "./" is not needed since they are usually in the path already when you install them with whatever package manager your Linux distribution uses.

Anyway, when you run the program, it should output

```
Hello World!
```

If you have Gnu Make installed on your Linux system (which I highly recommend), you can copy paste the following into a "makefile" to easily build and run your code just by typing "make".

## makefile for FASM users

```
main-fasm:
	fasm main.asm
	chmod +x main
	./main
```

A makefile is basically like a shell script except it has more options. For the most part, you don't need to worry about the details of how it works because I will be providing any makefiles you will need for the examples in this book. However, I have read the documentation of Gnu Make and I frequently use it to manage converting my books with Pandoc and managing updates to my Git repositories. It is a fabulous tool for any programmer because it allows setting up "rules" for commands you need to run.


## Assemble with NASM

You can assemble the example program with NASM instead of FASM if you wish. However, you will need to make a few small changes. The following is a form that will be acceptable to NASM and the GNU linker.

```
global  _start

_start:

section .text

mov eax,4   ; invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
mov ebx,1   ; write to the STDOUT file
mov ecx,msg ; pointer/address of string to write
mov edx,13  ; number of bytes to write
int 80h

mov eax,1   ; function SYS_EXIT (kernel opcode 1 on 32 bit systems)
mov ebx,0   ; return 0 status on exit - 'No Errors'
int 80h

section .data

msg db 'Hello World!',0Ah,0
```

 If you take a look at it, you will see it is the exact same program but that things are separated into ".text" and ".data" sections. This is a rule that most programs follow and it is required by the GNU linker which is very strict about which is code(.text) and which is data that will be read from or written to. Also you will see the global symbol _start which is expected by the linker.
 
The following command will make an ELF object.

`nasm -f elf32 main.asm`


The object created is not executable but you can make one that is by linking it with the GNU Linker.

`ld -m elf_i386 main.o -o main`

And finally, you can run the program in the traditional way.

`./main`

## Interrupt FAQ

I know you are probably a little bit confused at this point and have many questions such as

- What is an interrupt?
- What is a system call?
- Why do you write your numbers in hexadecimal?
- What is a register?

An interrupt is where your code passes control to the operating system which has loaded code to run various functions. Only the Linux kernel has authority to access devices like the console and file system. By placing the right numbers in the right registers and calling interrupt 0x80, we let the kernel "interrupt" our program and then display the data using the information we have given it. Obviously the writers of the kernel know more than I do and chose which registers are used in which functions.

A helpful reference I use to remind myself which call numbers to use for interrupts/syscalls is here:

<https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/#x86-32-bit>

Although that reference is for Chromium-OS, it is Linux based and so the information is valid. It is only a brief reference and I will be explaining more as this book continues.

The reason the interrupts and other numbers in my code are in hexadecimal is because most assembly language books and tutorials use them. Hexadecimal is objectively more convenient because it can be more easily converted to and from binary. For now just remember that interupt 80h is actually 128 decimal and for some reason was chosen as the interrupt number for Linux on Intel systems. I have chosen to stick mostly with hexadecimal for this book because it will be relevant later on when I show you other tools which can be used if you understand hexadecimal!

A register is a special variable that exists on a specific CPU type. DOS, Windows, and most Linux operating systems run on an Intel 8086 compatible CPU. I will explain the registers and their functions.

## The General Purpose Registers

There are 8 general purpose registers.

- EAX: The Accumulator Register
- EBX: The Base Register
- ECX: The Count Register
- EDX: The Data Register
- ESI: The Source Index
- EDI: the Destination index
- EBP: The Base Pointer
- ESP: The Stack Pointer

If you read the DOS version of this book, you will notice these are the same names as the 8 general 16-bit registers except prefixed with an E. The E stands for Extended. You can still access the 8 and 16 bit registers, for example AX is still the lower half of EAX and is divided into the 8 bit registers AH and AL. I still frequently use these in 32 bit code.

These registers are "general" in that they can do many things, but they each have more "specific" uses also. 

In my source code, I use lowercase for the names of instructions and registers, but for this section, I listed them in capital letters because they are actually acronyms named for their purpose according to what Intel had in mind when making the 8086 and above Central Processing Units.

Most of the time, I stick with only EAX,EBX,ECX,EDX when writing my programs. If I need an extra registers, I will use EBP,ESI,EDI. There are special instructions for them but these are outside the scope of what I am trying to teach with this book.

You might wonder, why isn't there EX,FX,...YX,ZX? Perhaps in a perfect world there should have been, but they probably didn't want to spend the extra money on having extra registers for all 26 letters of the alphabet.

In the next chapter I will show you a few other ways to assemble the program from this chapter using NASM and GAS. I will also be explaining the pros and cons of executable files compared to linkable ELF objects.

# Chapter 2: Simulator Choices

There are two simulators I personally use and test my code against. Both of them are Free Software and available to download from their Github repositories. I will offer some information about them so you can choose which to use when following along with this book.


## RARS

RARS is a port of the MARS simulator for MIPS processors. It is written in Java and is downloadable as a 

<https://github.com/rarsm/rars>

This book favors RARS because it is easy to use and is reliable enough to use from any operating system. It also supports a lot of system calls and is the simulator I learned to use first. Because it runs using Java, you must have the Java Runtime installed. However, since Java can be installed and run on any operating system, you can be sure that it will work no matter whether your host operating system is Windows, Linux, or Mac.

On my system, I usually have the file named "rars.jar" in my home directory. This allows me to run my source file like this:

```
java -jar ~/rars.jar main.s
```

Because ~ is a shortcut for the home directory, this allows me to run it from whichever directory I happen to be in that contains my source file, which in this case is named "main.s".

## riscemu

Riscemu is a simulator written in Python. It does not have as many system calls built in but it is a good option for people who have Python installed but cannot, or don't want to install Java.

<https://github.com/AntonLydike/riscemu>

Running a source file with riscemu is even easier that with RARS.

```
riscemu main.s
```

In my experience, riscemu also launches faster than RARS does, mostly just because RARS requires Java to load the whole virtual machine before it starts. Because riscemu is written in Python, and Python is written in C, it is only natural that it might be faster.

## Why use a simulator?

You might be wondering why I am recommending using these simulators rather than a real assembler for a real machine with an operating system. There are 3 reasons.

- I don't have a computer with a RISC-V processor.
- Simulators can be used by more people because they don't require buying new hardware.
- No "risk" in trying out this new RISC based machine.

In short, I use these simulators or emulators for the same reason I used DOSBox in the DOS version of Assembly Arithmetic Algorithms.

An emulator allows people to learn the language a Central Processing Unit uses before they have invested time or money into learning it. This means no investment or sacrifice from you.

In fact, you might decide to forget learning RISC-V Assembly and learn Java or Python instead. Even so, I wrote this book so that I can share what a beautiful language the RISC-V Assembly language is and why I enjoy coding in it.