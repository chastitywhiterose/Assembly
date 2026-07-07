# Assembly Arithmetic Algorithms

RISC-V Edition

# Preface

This book is the RISC-V edition of Assembly Arithmetic Algorithms. This is the third book in the series but it is a completely acceptable way to learn programming, even for beginners. 

The first book was for 16-bit DOS programming using Assembly. The second book was for 32-bit Linux programming using the same assembly language for Intel machines.

But the book you are reading now, is fundamentally different in nature. It uses simulators that run in any operating system to teach a new type of Assembly language for the RISC-V (Reduced Instruction Set Computing-Generation 5) processor.

RISC-V is [important](https://riscv.org/blog/what-is-risc-v-and-why-is-it-important/) because it is a royalty free open standard. This means that as it catches on, more companies will be able to make cheaper computers because they will not have to pay royalties to the Intel or ARM companies. I guess you could say that it is Open Source Hardware, which in my opinion is the final piece we need to match the Open Source Software people like me already have been enjoying with GNU and Linux.

# Introduction

First, let me introduce this book by telling you what I will teach you. By the end of this book, you will have enough information to write small programs that will run on your machine but also allow you to bypass languages like C++, Java, or even the Bash Linux shell. Arguably, the beautiful thing about Assembly is its simplicity.

RISC-V is great because it is a Reduced Instruction Set Computing device. It has fewer instructions to learn and remember, especially when compared to Intel. It also has more registers available for use. Each of them have special purposes and conventions for how they are used. However, as the programmer, you are allowed to break these conventions because right now, your focus should be on learning it for fun!

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

## Why RISC-V

After writing 3 programming books, I decided I wanted to learn a language that offered the things I love about C and Assembly but was also new and exciting at the time. 

I first learned RISC-V from Robert Winker's book.

<https://leanpub.com/riscvassemblyprogramming>

It was also available on Leanpub and I thought his teaching style is a standard that I hope to live up to. Obviously he is more experienced and his book is probably better than mine. Even so, I wanted to do my own part to promote education about RISC-V because I want to see a world where programming is easier and computers are cheaper. As much as I love Intel machines because I grew up with them, RISC-V provided me a new learning experience that I hope others discover and enjoy as much as I have!

# Chapter 1: The First Program

For this chapter, I will explain give the source code of an example program that works in both RARS and riscemu simulators. Take a good look at it and the comments I included. I will be explaining this in detail. I also recommend you type or copy and paste this code into a text editor and save the file as "main.s" in a place on your computer that you prefer.

## Hello World

```
.data

string0: .asciz "Hello World!\n"

.text

li a0, 1       # STDOUT file number
la a1, string0 # address of string 
li a2, 13      # length of string
li a7, 64      # write call number
ecall          # environment call

li a0, 0       # status
li a7, 93      # exit
ecall          # environment call
```

There are two sections named ".data" and ".text". All variables used in the program should be defined in the .data section. The .text section is where your code starts executing. This organization scheme is required for most simulators and assemblers.

This program prints "Hello World" followed by a newline. It uses only 3 kinds of instruction and is fairly easy to follow.

- li = load integer (or immediate value)
- la = load address (a special kind of integer)
- ecall = enviroment call (or syscalls)

The reason that sometimes li is used to load a register and other times la is used is because technically, there is a limit on the size of integers that can be part of an instruction. Instructions like "la" are technically macros for multiple instructions that load upper and lower bits of a register.

But besides that, having la for memory addresses and li for regular numbers makes the code more readable in my opinion.

ecall is the how you would call the system calls of your operating system. It is the same idea as "int 0x80" was in my Linux Intel Assembly book. However, in RISC-V, there are different registers and different system call numbers than you would expect on Intel CPUs.

But more importantly, this program was written for simulators and not a real operating system. The call numbers, which are loaded into the a7 register, are specific to the RARS and riscemu simulators. In the next chapter, I will explain the differences between these two simulators and how to run the program.

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

# Chapter 3: System Calls

## System Calls for RARS and riscemu


|Name |a7 |a0    |a1 |a2   |
|-----|---|------|---|-----|
|exit |93 |status|   |     |
|read |63 |fd    |buf|count|
|write|64 |fd    |buf|count|

## Registers on RISC-V

There are a LOT more registers than there were on Intel machines. This makes using RISC-V very easy because you don't have to use memory locations as often.

|Name   |meaning/usage |
|-------|--------------|
|zero   |always = zero |
|ra     |return address|
|a0->a7 |arguments     |
|s0->s11|saved values  |
|t0->t6 |temporary     |

The zero register is just a register that always equals zero. It may seem weird but remember than RISC-V does not allow comparing a register directly with a number. Normally you need to load a number into another register. But because comparing with zero is a common operation, this zero register is available to be compared or copied any time!

The ra register is important for function calls. It is the register that keeps where you will return to when the function is done. Because of this, you will run into trouble if you try to do something else with it.

The other registers can technically be used any way you want except that those starting with 'a' are used for arguments to environment calls. For this reason, they are used more than others.

The registers that begin with 's' or 't' are technically the same but it is a convention or tradition that t0 to t6 are used for temporary cases where you need to add, subtract, multiply, or divide numbers. After you are done with them, you use them for something else and forget what you did with them last time.

The s0 to s11 registers are the most abundant and you are expected to keep things that endure most or all of the program in them. For example, you might keep a file descriptor in one of them so that you could copy it to the correct 'a' register when you need to.

Because of the fact that you cannot compare or otherwise perform math on memory addresses directly, you have to always load everything into registers. However, because RISC-V has more registers, you can also write programs that run faster because you access memory less often.