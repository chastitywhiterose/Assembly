# Assembly Arithmetic Algorithms

32-bit Linux Edition

# Preface

This book is the Linux edition of Assembly Arithmetic Algorithms. The first book was for 16-bit DOS programming using Assembly. This book is for 32-bit Linux programming using the same assembly language for Intel machines.

Although the DOS book was useful, reading it first is not required to understand this book because programming for Linux is very different from what it was for DOS. Using interrupt 0x21 no longer works because the operating system is different. Instead, everything will use interrupt 0x80 because this is how the Linux kernel is called in assembly language when running on a 32-bit Linux operating system.

Keep in mind that most Linux distributions today are capable of running 32-bit or 64-bit code. The reason I am teaching 32-bit is that I know it better, and because programs using 32-bit instructions are usually smaller than the same thing written in 64-bit.

The distro I am using to write and test my examples is Debian version 12 (bookworm). It works well enough for what I do on a daily basis. These examples should Assemble on almost any distribution because the system call numbers are the same on any distro running x86 Intel because they are hardcoded into the Linux kernel.

This standard means that the information here is useful to anyone who is running Linux unless their Central Processing Unit is an ARM, RISCV, or something else. Intel is still the most popular at this time and is traditionally the same type of machine that usually runs Microsoft Windows.

So if you happen to have an old computer around with Windows that runs too slow, you might decide to install Linux on it and get started with the world of Free Software and writing your own programs. Linux is a better environment for programming in ANY language (I will explain more about that later).

# Introduction

First, let me introduce this book by telling you what I will teach you. By the end of this book, you will have enough information to write any text-based console program in the form of a 32-bit Linux "ELF" file.

The "ELF" format is an acronym for "Executable and Linkable Format". This format is used on all modern Linux operating systems and some Unix systems like FreeBSD. The header for this format is slightly complicated, but FASM is capable of generating one for you so that you don't generally have to worry about creating it yourself.

If you are a user who prefers NASM, there are also ways to have one generated for you by the GNU linker, which is already installed on any system that has the GCC compiler. The linker does not require you to write C code because it can also link standard ELF objects created by NASM.

## Required Knowledge

To get the most out of this book, some background on the Binary and Hexadecimal numeral systems is going to be helpful, but this is not strictly required because I will be providing functions you can use in your code that will convert between decimal (base ten), binary (base two), and hexadecimal (base 16).

However, I would say that experience in at least one programming language is necessary for an understanding of terminology like "arrays", "pointers", "addresses", "integers", "floating point", etc. I recommend the C Programming Language as a start. C++ is also a good starting language, but it tends to abstract details away that directly apply to Assembly Language, which is the lowest level a human can go for understanding a computer.

But specifically in this book about Linux assembly, I will make comparisons between C programs and Assembly because C is usually considered the native language of the Linux kernel. The manual pages of the system calls also show the C prototypes of the functions. Translating these into Assembly has not been easy because information on Assembly doesn't come by as easy as C or C++. I hope my book will save you the time and trouble I experienced when I first starting writing Assembly programs for Linux.

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

You can download FASM and install it by putting it in your path. The instructions for doing this depend on your operating system but it can be done on Windows, Linux, or even within a DOS operating system, which you will of course need to run the program.

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

You can assemble the example program with NASM instead of FASM if you wish. However, you will need to make a few small changed. The following is a form that will be acceptable to NASM and the GNU linker.

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

# Chapter 2: Assembler Choices

Most of the time I used the FASM assembler. It is the Flat Assembler which means it generates flat or raw binary executable files that are already to run. The information in the file includes the ELF header at the beginning and then the code and data defined by you in your program.

In chapter 1, I showed the same program using both FASM and NASM. The code is identical but the assembler directives are different. If you are using FASM, the "format ELF executable" at the start of the source is enough for FASM to auto generate what you need. This does not exist in NASM, so I have created a header file that achieves the same thing!

The contents of my custom built 32 bit ELF header is below. It can be included in any NASM program so you only need to copy paste this file once or download it from my repository.

## chaste-elf-32.nasm

```
;Chastity's Source for ELF 32-bit executable creation
;
;All data as defined in this file is based off of the specification of the ELF file format.
;I first looked at the type of file created by FASM's "format ELF executable" directive.
;It is great that FASM can create an executable file automatically. (Thanks Tomasz Grysztar, you are a true warrior!)

;However, I wanted to understand the format for theoretical use in other assemblers like NASM. Therefore, what you see here is a complete Hello World program that should work within NASM to create an executable file without using a linker. It worked perfectly on my machine running Debian Linux and NASM version 2.16.01.

;The Github repository with the spec I used is here.
;<https://github.com/xinuos/gabi>
;And this is the wikipedia article which linked me to the specification document
;<https://en.wikipedia.org/wiki/Executable_and_Linkable_Format>

;This file contains a raw binary ELF32 header created using db,dw,dd commands.
;After that, it proceeds to assemble a real "Hello World!" program

;Header for 32 bit ELF executable (with comments based on specification)

db 0x7F,"ELF" ;ELFMAGIC: 4 bytes that identify this as an ELF file. The magic numbers you could say.
db 1          ;EI_CLASS: 1=32-bit 2=64-bit
db 1          ;EI_DATA: The endianness of the data. 1=ELFDATA2LSB 2=ELFDATA2MSB For Intel x86 this is always 1 as far as I know.
db 1          ;EI_VERSION: 1=EV_CURRENT (ELF identity version 1) (which is current at time of specification Version 4.2 I was using)
db 9 dup 0    ;padding zeros to bring us to address 0x10
dw 2          ;e_type: 2=ET_EXEC (executable instead of object file)
dw 3          ;e_machine : 3=EM_386 (Intel 80386) 0x3E (AMD x86-64 architecture)
dd 1          ;e_version: 1=EV_CURRENT (ELF object file version.)

p_vaddr equ 0x8048000 ;the absolute base address where the file is loaded into memory
e_entry equ 0x8048054 ;program start running at this address (right after header)

dd e_entry    ;e_entry: the address at which the program starts running
dd 0x34       ;e_phoff: where in the file the program header offset is
db 8 dup 0    ;e_shoff and e_flags are unused in this example,therefore all zeros
dw 0x34       ;e_ehsize: size of the ELF header
dw 0x20       ;e_phentsize: size of program header which happens after ELF header
dw 1          ;e_phnum: How many program headers. Only 1 in this case
dw 0x28       ;e_shentsize: Size of a section header
dw 0          ;e_shnum number of section headers
dw 0          ;e_shstrndx: section header string index (not used here)

;That is the end of the 0x34 byte (52 bytes decimal) ELF header. Sadly, this is not the end and a program header is also required (what drunk person made this format?)

dd 1          ;p_type: 1=PT_LOAD
dd 0          ;p_offset: Base address from file (zero)
dd p_vaddr    ;p_vaddr: Virtual address in memory where the file will be.
dd p_vaddr    ;p_paddr: Physical address. Same as previous

;The file_size variable I have defined uses some trickery to get the size of the file.
;An EOF constant (End Of File) is defined at the end of the program code
;By subtracting the program virtual address from that address,
;I get the actual number of bytes of this entire program

file_size equ EOF-p_vaddr ;Place the actual size of the file using NASM address constants

dd file_size  ;p_filesz: Size of file image of the segment. Must be equal to the file size or greater
dd file_size  ;p_memsz: Size of memory image of the segment, which may be equal to or greater than file image.

dd 7           ;p_flags: permission flags: 7=4(Read)+2(Write)+1(Execute)
dd 0x1000      ;p_align; Alignment (same page alignment that FASM uses of 4096 bytes)

;important Assembler directives

use32          ;tell assembler that 32 bit code is being used
org p_vaddr    ;origin of new code begins here
```

Next, here is a short program which properly includes the header above.

## main.asm

```
%include 'chaste-elf-32.nasm'

mov eax,4   ; invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
mov ebx,1   ; write to the STDOUT file
mov ecx,msg ; pointer/address of string to write
mov edx,13  ; number of bytes to write
int 80h

mov eax,1   ; function SYS_EXIT (kernel opcode 1 on 32 bit systems)
mov ebx,0   ; return 0 status on exit - 'No Errors'
int 80h

msg db 'Hello World!',0Ah,0

EOF equ $ ; End Of File label
```

This program uses the "%include" directive to include the header file. This file will automatically create the header file needed to run the program by the operating system.

The "EOF equ $" is required at the end because this makes an "EOF" label equal to the current address. The header uses the EOF label to tell it how big the file is. The size of the file must be hard coded into the header.

Linux is very strict and picky about what it will load. It doesn't just load any random file like DOS does. But if you actually assemble and run this program, it will work flawlessly.

The following makefile was written for assembling and running in one "make" command. I highly recommend GNU make so you can make use of it and save yourself typing each command.

## NASM makefile

```
main-nasm:
	nasm main.asm
	chmod +x main
	./main
```

Although this works, you might wonder why I went to the trouble of writing this header file to be used with NASM. The following are my reasons:

1. FASM is better, but not always available on every operating system.
2. NASM is written in C and ported to more platforms
3. Writing the header manually allows me full control and understanding of the process.

I believe item 3 is most important because if I was to just allow FASM to generate the header and not know what it was doing, I would not be the KIND OF PERSON who writes assembly language. It is much better to program in C or C++ if you just want to get programs working and don't care about what is happening behind the scenes.

In fact, I will prove this with one more example. This next program does the exact same thing except that it uses the GNU assembler (also called GAS) and linker.

## GNU Assembler

The GNU Assembler is automatically installed on systems that have the GCC compiler, which uses it as part of the process of transforming C programs into executable code. The compiler normally creates an assembly file, assembles it, and then deletes the source.

However, you can supply your own assembly code. The following is one I wrote that behaves the same as the NASM program above.

I must warn you though, GAS uses the AT&T syntax which uses a different order of operands. For example, the destination register is on the right and the source address or number is on the left. This is opposite of FASM and NASM source code which uses the Intel Style.

History Note:

Intel made the 8086 Central Processing Unit and its descendants, but AT&T (yes the phone company) was responsible for the C programming language and UNIX. Because of this, they made their own style of writing assembly that is used by some C compiler systems to this day.


## main.s

```
# Using Linux System calls for 32-bit
# Tested with GNU Assembler on Debian 12 (bookworm)
# Writes a message to standard output with Linux system calls

.global _start

.text

_start:

mov    $0xD,%edx # copy number of bytes to edx
mov    $msg,%ecx # address of string to output
mov    $0x1,%ebx # file handler 1 is stdout
mov    $0x4,%eax # system call 4 is write
int    $0x80

mov    $0x1,%eax      # system call 1 is exit
mov    $0x0,%ebx      # we want to return code 0
int    $0x80          # end program with system call

.data        # must declare data section for mutable memory

msg:
.ascii "Hello World!\n"
```

I have created a makefile for this program as well. I use the gcc command because it automatically calls "as" and "ld" for us. The arguments I used are for tricking it into not including the C standard library. Remember, GAS was designed to process the output of assembly created from a C compiler and they didn't plan on us writing our own, partly because the syntax is a lot harder to understand than Intel style used by FASM and NASM.

## GAS makefile

```
main-gas:
	gcc -nostdlib -nostartfiles -nodefaultlibs -static main.s -o main -m32
	./main
```

To sum up this chapter, you have the choice of at least 3 assemblers to use when getting started with Intel Assembly language for Linux Operating Systems. Here is a breakdown

- FASM: Easy to use and does a lot of work for you.
- NASM: Portable and reliable but does not make headers for you.
- GASM: Exists almost everywhere a C compiler is but uses a hard to read syntax!

I will be using FASM for the rest of this book because I have the most experience with it and it is available for Linux. It was also written in assembly and is much faster than the other two assemblers I have mentioned.

There are many more assemblers for Intel processors but I will not be covering them unless requested by readers in the future.

Congratulations! If you have followed the book this far, you now know enough to get "Hello World!" on the screen in Assembly language for 3 different assemblers. The following chapters will cover more advanced ways of printing strings and integers using the FASM assembler, but can be translated into other assemblers if you learn the subtle differences between them.

# Chapter 3: Linux System Calls

Any book about Assembly programming for Linux is going to have to include information about system calls. This book will use what I consider the most useful of the system calls to achieve everything that the C standard library can do.

For example, we need to be able to open files, read from them,write to them,and close them. These are the 4 fundamental operations and without them, nothing would work for building text based programs and getting results. Otherwise we will never know if a program was written correctly.

The Linux kernel has hundreds of system calls. However only about 8 of them have I ever used. Each call has a number which may be different depending on which CPU type you have and what your operating system supports. Here is a command I can use to find the information on which numbers go with which function names. This will be extremely relevant.

`find /usr/include -name "unistd_*"`

On my system, that command shows 4 files.

```
/usr/include/x86_64-linux-gnu/asm/unistd_64.h
/usr/include/x86_64-linux-gnu/asm/unistd_x32.h
/usr/include/x86_64-linux-gnu/asm/unistd_32.h
/usr/include/x86_64-linux-gnu/bits/unistd_ext.h
```

Specifically, it is the file:

`/usr/include/x86_64-linux-gnu/asm/unistd_32.h`

which shows us the numbers for all the system calls in a 32 bit Linux environment. Here are a few of them.

```
#define __NR_exit 1
#define __NR_fork 2
#define __NR_read 3
#define __NR_write 4
#define __NR_open 5
#define __NR_close 6
#define __NR_waitpid 7
#define __NR_creat 8
#define __NR_link 9
#define __NR_unlink 10
#define __NR_execve 11
#define __NR_chdir 12
#define __NR_time 13
#define __NR_mknod 14
#define __NR_chmod 15
#define __NR_lchown 16
#define __NR_break 17
#define __NR_oldstat 18
#define __NR_lseek 19
#define __NR_getpid 20
#define __NR_mount 21
#define __NR_umount 22
#define __NR_setuid 23
#define __NR_getuid 24
#define __NR_stime 25
#define __NR_ptrace 26
#define __NR_alarm 27
#define __NR_oldfstat 28
#define __NR_pause 29
#define __NR_utime 30
#define __NR_stty 31
#define __NR_gtty 32
```

You may have also noticed that there is a 64 bit file with the same functions in a different order. I would have to write a separate book on the 64 bit calls because they use different registers beside different numbers.

In any case, these are the same system calls regardless of whether you are calling them from a C program or an Assembly program. In chapters 1 and 2, we have already used two system calls in our Hello World program. The EAX register was loaded with 4 for the write call and then later was loaded with 1 for the exit call to end the program.

Getting the system call numbers into EAX is easy enough but how did I know which arguments go in which registers?

As it turns out, most Linux distributions have manual pages on all these calls. To access these manual pages, you always enter "man 2 name_of_the_function". For example the write call can be obtained this way.

`man 2 write`

It is a big page to read but I do suggest reading it all for a proper understanding of how it works. Included is the C Programming Language signature for the function.

`write(int fd, const void buf[.count], size_t count);`

Notice that this takes 3 arguments. The first is the file descriptor number. In the case of standard output, it is 1. Next, it needs a pointer with bytes which will be written to standard output. The final argument is to tell it how many bytes to write from this address.

Using this information, we can form a complete program in C.

## C Hello World with Write System Call

```
#include <unistd.h>

int main(int argc, char *argv[])
{
 write(1, "Hello World!\n", 13);
 _exit(0);
}
```

 If you are on a Linux system, which you should be for learning from this book, you can use the following command to compile and run it.

```
gcc -Wall -ansi -pedantic main.c -o main && ./main
```

The reason I show a C programming example in a book about assembly is because C is the native language for the Linux operating system but all the system calls are also accessible from Assembly language as well. Look again at the C program above and then look again at the program from chapter 1.

## FASM Hello World with Write System Call

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

These two programs are the EXACT same thing written in two different languages. Also notice that the arguments for the write call are the same as in the C signature. The registers are EBX,ECX,EDX. This is because B,C,D is the order of the alphabet!

Of course this consistency is not followed past 3 arguments. After that, the order is ESI,EDI,EBP. However this is rare because most functions do not use more than 3 arguments.

The write call technically uses 4 registers because EAX must have the system call number before we call int 0x80.

This means we still have 3 registers that are not used by system calls and can be used for other purposes like holding temporary numbers we need to use later.

I often refer to this online list to help me remember which registers are used as which arguments.

https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/#x86-32-bit

It may be a reference for Chromium OS but this is still a Linux compatible system and so it is valid for all Linux distributions as long as they support 32 bit system calls. These functions we are calling are part of the Linux kernel which is actually used on all kinds of operating systems that are not called Linux. Android is a popular example.

I have explained the way that system calls work, specifically the "write" call. The "exit" call is also included because it is how you must end a program in Assembly.

But there is also the problem that system calls are inconvenient. Having to keep in my head what registers to load with what can get pretty confusing. That is why I created a function that uses the write call but manages printing strings and automatically tells the write call how long the string is.

In the next chapter, I will show you the putstring function. But remember, all of the code for input and output in a Linux system is going to require one of the system calls. Knowing when to use the system calls becomes important from the perspective of a C or Assembly programmer.

# Chapter 4: putstring

Perhaps it is God's sense of humor that I am beginning chapter 4 with a function that uses function number 4 of interrupt 0x80.

The write system call is the most useful of all the calls because it is the only way to get output from a program. You have already seen examples of this call being used in the first three chapters. However, the downside of this system call is that you must tell it exactly how many bytes of a string to write. It makes no assumptions about how long the string is.

If you are coming from a C programming background, you will know that it is a common convention that strings are an array of bytes ending in 0. I agree with this convention because it just makes sense. The byte 0 doesn't map to a printable character, and the number zero generally has the sense of "nothing" because there are no more bytes in the string to print.

It might make sense to my mind, but I have to logically get the computer to understand it. To achieve this, I will show you a C program first and then the Assembly version that does the same thing.

## C unistd putstring

```
#include <unistd.h>

int putstring(const char *s)
{
 int count=0;      /*used to count how many bytes will be written*/
 const char *p=s;  /*pointer used to find terminating zero of string*/
 while(*p){p++;}   /*loop until zero found and immediately exit*/
 count=p-s;        /*count is the difference of pointers p and s*/
 write(1,s,count); /*the unix system call way of writing the bytes*/
 return count;     /*return how many bytes were written*/
}

int main(int argc, char *argv[])
{
 putstring("The putstring function can print any string!\n");
 _exit(0);
}
```

The program source above uses the **unistd.h** interface to the Unix Standard way of doing things. Sometimes this is referred to as POSIX. POSIX is the (Portable Operating System Interface), which is a group of standards that Linux and Unix-like systems, such as BSD (and its descendants FreeBSD, NetBSD, and OpenBSD), and even MacOS, which is actually based on Unix.

So basically, the sets of functions available, such as write, read, open, close, lseek, and exit, are part of a special Unix Standard Library that can be used on Linux and every operating system except for DOS and Windows because those have different standards set by Microsoft.

Because this book is about programming on Linux, I do promote this as the best way to go about programming on Linux. However, I also consider that my readers may be used to a more traditional C Standard Library approach to programming. Therefore, I will also show you the same thing using the fwrite function from the **stdio.h** header.

## C stdlib putstring

```
#include <stdio.h>

int putstring(const char *s)
{
 int count=0;              /*used to count how many bytes will be written*/
 const char *p=s;          /*pointer used to find terminating zero of string*/
 while(*p){p++;}           /*loop until zero found and immediately exit*/
 count=p-s;                /*count is the difference of pointers p and s*/
 fwrite(s,1,count,stdout); /*https://cppreference.com/w/c/io/fwrite.html*/
 return count;             /*return how many bytes were written*/
}

int main(int argc, char *argv[])
{
 putstring("The putstring function can print any string!\n");
 return 0;
}
```

If you compare the two C programs, you will see that they are line by line the exact same thing, except they include a different header, different functions to send the output to the terminal, and return from the main function in different ways.

The consistency in behavior is why it is easy to translate programs using Unix calls into C Standard calls and vice versa.

In any case, here is a breakdown of how the putstring function works regardless of which version you use.

A char pointer named s is passed to the function when it is called.

A count variable is created for use in telling how many bytes need to be printed. This count is initialized to 0 but will be changed later.

A pointer named p is set to the same address as s.

A short loop occurs, which checks the byte at the address at pointer p. If it is zero, the loop ends. Otherwise, p is incremented with the ++ operator. Adding 1 to a pointer means it will point to the next byte. Sooner or later, it will find that a byte is 0 because the C compiler forces any string literal inside double quotes to end in a zero byte.

The count is set to p minus s. Yes, you can subtract pointers from each other in the C language. This pointer arithmetic is the fastest way to extract the length of the string. By subtracting the start of the string (s) from the place where the 0 was found (p), we can know that it will always have the exact length of the string.

As far as the write and fwrite calls. They are the same thing, but the number of arguments and their order are slightly different. See the following links for a more accurate breakdown.

<https://man7.org/linux/man-pages/man2/write.2.html>

<https://cppreference.com/w/c/io/fwrite.html>

After the data is written, the putstring function returns the number of bytes written. You can ignore this most of the time, but it can be helpful if you need the length of the string to be saved for some operation later. Technically, the C strlen function can also be used for finding the length of a string, but there is a strategic reason I did not use that function in my implementation of putstring

The reason is that when we are coding in Assembly, C functions don't exist unless we specifically link assembly programs to the C library. I recommend against this and therefore won't teach you how to do this. More importantly, it is unnecessary because we can always write our own functions in Assembly that run much faster and do exactly what we want.

Now I have shown you two possible interfaces in C for writing a function named "putstring" that counts the length of a string and prints it to standard output. All of this effort was made so that when you see the Assembly version, you already have a basic idea of how it works, so that you won't be overwhelmed at how complicated it looks.

And don't worry, I will still be explaining more about it after the code for those who still may not get it.

## Assembly putstring

```
format ELF executable

main:

mov eax,string0
call putstring

mov eax,1 ; invoke SYS_EXIT (kernel opcode 1)
mov ebx,0 ; return 0 status on exit - 'No Errors'
int 80h

string0 db 'The putstring function can print any string!',0Ah,0

putstring:

push eax
push ebx
push ecx
push edx

mov ebx,eax

putstring_strlen_start:

cmp [ebx],byte 0
jz putstring_strlen_end
inc ebx
jmp putstring_strlen_start

putstring_strlen_end:
sub ebx,eax

mov edx,ebx ;number of bytes to write
mov ecx,eax ;pointer/address of string to write
mov ebx,1   ;write to the STDOUT file
mov eax,4   ;invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
int 80h     ;system call to write the message

pop edx
pop ecx
pop ebx
pop eax

ret
```

The Assembly program that uses putstring follows all the same logic as the two C programs earlier in this chapter.

However, you may notice that the main function appears first, and then the putstring function appears after the exit call to end the program, and also after where string 0 is defined.

Most C compilers force you to define a function before it can be called. FASM has no such restriction, and I frequently place all my data and other functions after the main function.

Because function 1 of Interrupt 0x80 is the exit call, this means the program will end and not accidentally run anything after it.

It is possible to define the functions and the data before the main function, much like you would do in the C language, but this means that you would need to do a "jmp main" instruction to skip executing those. Therefore, I reversed the order from the C convention because it saves a few bytes of space and because it protects me from running code that I didn't mean to. Writing Assembly language is very prone to error because the source typically takes more lines, and it is easier to get lost and forget what I was doing.

The putstring function is written in a way that it expects the address of the string we want to print to be placed in the eax register before it is called. I could have used any of the registers but I chose eax because 'A' is the first letter of the alphabet and so it is considered the first and most important in my code.

At the beginning and end of the putstring function, you may notice the push and pop instructions. These save and restore the values of registers to the "stack". The stack is a LIFO (Last In First Out) data structure which is useful because the registers are modified whenever we make a system call. By pushing registers in the order eax,ebx,ecx,and edx, we are saving them to a memory location which is indexed by the Stack Pointer or esp. To restore them in the proper order, we have to pop them back in the reverse order of edx,ecx,ebx,and eax.

I understand this is a lot of information that seems pointless, but that is because it requires a good understanding of pointers. Note however that other languages use the stack when you call functions but they hide this from the users. Assembly requires getting comfortable with pointers.

## Pointers vs Integers 

One thing that sometimes trips up new assembly programmers is how registers can sometimes function as pointers and other times as plain integers.

For example

```
mov eax,string0
```

Means we are moving the address of the string into the eax register. The registers starting with the letter E all store 32 bits of data. They are integers, or simply numbers. However, addresses are also numbers, and therefore it is totally normal to use the same register as both a pointer to an address and yet also use it as a regular number elsewhere.


For example

```
cmp [ebx],byte 0
```

Means we are comparing the address at ebx with 0. We know that ebx is being used as a pointer because it is in the brackets. Here, ebx functions just like "*p" does in the C version because ebx is being used as the pointer, just like p was in the C language. Notice also that it is required to include the "byte" specifier so the assembler knows we are searching for an 8-bit value (byte) instead of a 16-bit (word) or 32-bit (dword).

But I think the final best example of how integers and pointers are mixed is looking at the part of the putstring function that takes place after a zero is found.

```
sub ebx,eax ;subtract eax from ebx

mov edx,ebx ;number of bytes to write
mov ecx,eax ;pointer of string to write
mov ebx,1   ;write to the STDOUT file
mov eax,4   ;function number 4
int 80h
```

Registers eax and ebx are both used as pointers but then the usage of ebx suddenly changes. We subtract eax from ebx to get the number of bytes we need to print and then we copy ebx to edx.

This is the same as

`count=p-s;`

Was in the original C program. However, we can also think of it as

`edx=ebx-eax;'

Registers are still just special variables that can be used for anything we like. Unlike C, there is no difference between an "int" and an "int*". The C compiler will complain at you if you try to reuse the same variable as a different type. Sometimes you can convince it to let you do it anyway with typecasting.

But Assembly is the Minecraft Creative Mode of programming. There are no limitations other than those imposed on you by your operating system and hardware. To be honest

To drive home the point of why Assembly language is powerful but also dangerous, allow me to share the ancient wisdom of a programming master.

"C makes it easy to shoot yourself in the foot; C++ makes it harder, but when you do it blows your whole leg off" - Bjarne Stroustrup [Quotes](https://www.stroustrup.com/quotes.html)

And from my experience in Assembly language, I can tell you, Assembly programming is like searching for documentation on how to shoot yourself in the foot. Then Google censors your search results because it thinks you are going to self-harm. Suddenly, the government labels you a terrorist and then drops a bomb on your house until your legs are blown off, and so are everyone else's in your neighborhood.

In this chapter, I spent a lot more time explaining the behavior of the putstring function than I did in the DOS edition of this book. This function is foundational to the other functions in this book because whenever we need to print a number or an error message, the only real way to do it is to first define a string in the memory and print it using putstring. Without this function I would have to specifically count the length by hand of each function and load the registers again each time.

The purpose of creating a function in Assembly, or any other language, is to have a piece of reusable code that can be used at your convenience. It saves space when programming and also allows errors to be fixed because if the code that handles input or output is isolated in a function, then fixing that function fixes the rest of the program automatically.

Now that I have taught you the magical properties of the putstring function, I will use the next chapter to show you how I print integers in multiple bases!

# Chapter 5: intstr and putint

In the last chapter, we used a function named putstring to print strings of text. This is nice but in order to do useful things in assembly, we need to be able to print numbers.

If you are coming from the C language, you might remember the printf function and expect something similar. However, printf is not as good as what I will be showing you in both C and assembly. Printf can only print integers in base ten (decimal), eight (octal), and sixteen (hexadecimal)

Instead, I will introduce two new functions that can be used along with putstring in order to print any integer in any base from two to thirty-six. The default base is two (binary) because it is my favorite but it can be changed.

First, here is the C program that shows how these functions are written and used in C. Keep in mind that putstring is the same as it was in the last chapter. Whether you use the unistd or stdlib form of output will not matter here. However, this is a Linux book so I will be using the unistd interface with POSIX system calls from now on.

## C putint

```
#include <unistd.h>

int putstring(const char *s)
{
 int count=0;      /*used to count how many bytes will be written*/
 const char *p=s;  /*pointer used to find terminating zero of string*/
 while(*p){p++;}   /*loop until zero found and immediately exit*/
 count=p-s;        /*count is the difference of pointers p and s*/
 write(1,s,count); /*the unix system call way of writing the bytes*/
 return count;     /*return how many bytes were written*/
}

#define usl 0x100 /*usl stands for Unsigned or Universal String Length.*/
char int_string[usl+1]; /*global string which will be used to store string of integers. Size is usl+1 for terminating zero*/

/*radix or base for integer output. 2=binary, 8=octal, 10=decimal, 16=hexadecimal*/
int radix=2;
/*default minimum digits for printing integers*/
int int_width=1;

char *intstr(unsigned int i)    /*Chastity's supreme integer to string conversion function*/
{
 int width=0;                   /*the width or how many digits including prefixed zeros are printed*/
 char *s=int_string+usl;        /*a pointer starting to the place where we will end the string with zero*/
 *s=0;                          /*set the zero that terminates the string in the C language*/
 while(i!=0 || width<int_width) /*loop to fill the string with every required digit plus prefixed zeros*/
 {
  s--;                          /*decrement the pointer to go left for correct digit placing*/
  *s=i%radix;                   /*get the remainder of division by the radix or base*/
  i/=radix;                     /*divide the input by radix*/
  if(*s<10){*s+='0';}           /*fconvert digits 0 to 9 to the ASCII character for that digit*/
  else{*s=*s+'A'-10;}           /*for digits higher than 9, convert to letters starting at A*/
  width++;                      /*increment the width so we know when enough digits are saved*/
 }
 return s;                      /*return this string to be used by putstr,printf,std::cout or whatever*/
}

void putint(unsigned int i)
{
 putstring(intstr(i));
}

int main(int argc, char *argv[])
{
 int a=0;

 putstring("The putstring function can print any string!\n");
 putstring("The intstr function can convert an integer to a string!\n");
 putstring("The putint function calls intstr and putstring to print an integer\n");
 
 while(a<0x10)
 {
  putint(a);
  putstring("\n");
  a++;
 }
 
 _exit(0);
}
```

After the putstring function was defined, I defined some global variables which control the details of where the digits for integers are stored and which number base or radix will be used to convert an integer into a string. 

The width variable determines how many minimum digits are going to be printed. A width of 8 for example would mean that extra zeros would be prefixed if the number was naturally less than 8 digits. Most of the time this can be left as 1 so that only the minimum number of required digits is used.

I will admit that the intstr function which uses these variables looks quite complicated to a beginner programmer. However, this difficulty does not come from the C language.

The reason that this function is complex is because it requires the human reading it to understand the nature of number systems themselves. If you don't know about bases other than ten, you probably haven't thought about it much. In fact, most people don't even take the time to analyze the base ten system of numbers they are already using. For now, I suggest learning about the binary numeral system from other sources for clarification, though I may be including more information about it in this book later about number bases and the pros and cons of them.

The last C program I showed you will print the following text when compiled and run.

```
The putstring function can print any string!
The intstr function can convert an integer to a string!
The putint function calls intstr and putstring to print an integer
0
1
10
11
100
101
110
111
1000
1001
1010
1011
1100
1101
1110
1111
```

Naturally, I am going to show you the assembly program that does the same exact thing as the C version above.

## FASM putint

```
format ELF executable

main:

mov eax,string0
call putstring
mov eax,string1
call putstring
mov eax,string2
call putstring

mov eax,0

loop0:
call putint
call putline
inc eax
cmp eax,0x10
jnz loop0

mov eax,1 ; invoke SYS_EXIT (kernel opcode 1)
mov ebx,0 ; return 0 status on exit - 'No Errors'
int 80h

string0 db 'The putstring function can print any string!',0Ah,0
string1 db 'The intstr function can convert an integer to a string!',0Ah,0
string2 db 'The putint function calls intstr and putstring to print an integer',0Ah,0

putstring:

push eax
push ebx
push ecx
push edx

mov ebx,eax

putstring_strlen_start:

cmp [ebx],byte 0
jz putstring_strlen_end
inc ebx
jmp putstring_strlen_start

putstring_strlen_end:
sub ebx,eax

mov edx,ebx ;number of bytes to write
mov ecx,eax ;pointer/address of string to write
mov ebx,1   ;write to the STDOUT file
mov eax,4   ;invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
int 80h     ;system call to write the message

pop edx
pop ecx
pop ebx
pop eax

ret

; This is the location in memory where digits are written to by the intstr function
; The string of bytes and settings such as the radix and width are global variables defined below.

int_string db 32 dup '?' ;enough bytes to hold maximum size 32-bit binary integer

int_string_end db 0 ;zero byte terminator for the integer string

radix dd 2 ;radix or base for integer output. 2=binary, 8=octal, 10=decimal, 16=hexadecimal
int_width dd 1 ;default width of integers. Extra zeros prefixed if more than 1

;this function creates a string of the integer in eax
;it uses the above radix variable to determine base from 2 to 36
;it then loads eax with the address of the string
;this means that it can be used with the putstring function

intstr:

mov ebx,int_string_end-1 ;find address of lowest digit(just before the newline 0Ah)
mov ecx,1

digits_start:

mov edx,0;
div dword [radix]
cmp edx,10
jb decimal_digit
jae hexadecimal_digit

decimal_digit: ;we go here if it is only a digit 0 to 9
add edx,'0'
jmp save_digit

hexadecimal_digit:
sub edx,10
add edx,'A'

save_digit:

mov [ebx],dl
cmp eax,0
jz intstr_end
dec ebx
inc ecx
jmp digits_start

intstr_end:

prefix_zeros:
cmp ecx,[int_width]
jnb end_zeros
dec ebx
mov [ebx],byte '0'
inc ecx
jmp prefix_zeros
end_zeros:

mov eax,ebx ; now that the digits have been written to the string, display it!

ret

; function to print string form of whatever integer is in eax
; The radix determines which number base the string form takes.
; Anything from 2 to 36 is a valid radix
; in practice though, only bases 2,8,10,and 16 will make sense to other programmers
; this function does not process anything by itself but calls the combination of my other
; functions in the order I intended them to be used.

putint: 

push eax
push ebx
push ecx
push edx

call intstr

call putstring

pop edx
pop ecx
pop ebx
pop eax

ret

line db 0Ah,0 ;a string containing only a newline

;the next function which pushes eax to the stack
;moves the address of the line string and prints it with putstring
;then it pops the original value of eax back from the stack before the function returns
;this allows me to print a newline anywhere in the code without a single register changing

putline:
push eax
mov eax,line
call putstring
pop eax
ret
```

Although this program is longer than the C version, it is doing all of the same things. This program is very simple in terms of what it does. Here is a brief breakdown of it.

It sets eax to the address of 3 different strings and each time calls putstring to print those strings until the terminating zero is found. The putstring function was described in chapter 4 and I promise you that you will not want to forget it because it is the top link in a chain of dependencies.

Next, eax is set to 0 before a loop labeled as "loop0". During this loop, the eax register is used when calling putint to print the eax register in the default base of binary. The putline function is called next to print a newline character. The reason this is done is because eax cannot be modified inside the loop or the program would crash. Therefor I wrote a function for printing a line which changes eax temporarily but will leave it as it was so that the loop is still functioning correctly.

Next, eax is incremented with the "inc" instruction. This is the same as adding 1 to a variable as you saw in the putstring when I incremented ebx in the same way.

The next instruction of "cmp eax,0x10" compares eax with the number 16. It updates flags but does not modify anything else so that the next instruction of "jnz loop0" will operate correctly. If eax was not equal to 16 in the last comparison, then it will jump to the loop0 label.

## Side rant on condition jumps

You might wonder, why is the conditional jump called "jnz" when it means jump if not equal? Technically you can also change it to "jne" and it will still assembly and run.

The way Assembly language works is that when you compare something with "cmp", it subtracts the second number from the first number to get a result but it does not save that result. Therefore, only when eax equals 16 will the the comparison of 16 minus 16 equal zero.

I will be covering more about conditional jumps and other things in the next chapter, but for now you can consider the "jnz" to be the same as "jne" and write whichever one you like best. Similarly, you can also modify the last program to use "jb" which means jump if below. The opposite of "jb" would be "ja" which means jump if above.

## How the intstr function works

Mastery of conditional jumps is essential for the operation of the intstr function in this chapter that converts integers to strings. This function contains a loop which divides eax with "div" and the remainder is stored in edx. Depending on the value of dl (the lowest byte of edx), we need to jump to different places for different bases.

For example, if the remainder is 0 to 9, we can consider it a decimal digit. Then we have to add the ASCII value for '0' which is not the same as the number zero but is instead forty eight. Then it will display as the digit that we expect it to. However, if the digit is ten or above, then we have to represent it somehow using a convenient list of recognized symbols. Letters A to Z of the alphabet were the obvious choice when these decisions were made decades ago. Adding the ASCII value of 'A' or sixty-five works for making the digit display as something we can understand. This is how the hexadecimal system works, for example. The intstr function is my largest function so far because it has to handle all these different scenarios that can happen.

For greater understanding, I give you the following table of convenient characters for integers.

## Digit Character Table

|bin|hex|dec|character|
|---|---|---|---|
|00110000|30|048|0|
|00110001|31|049|1|
|00110010|32|050|2|
|00110011|33|051|3|
|00110100|34|052|4|
|00110101|35|053|5|
|00110110|36|054|6|
|00110111|37|055|7|
|00111000|38|056|8|
|00111001|39|057|9|
|01000001|41|065|A|
|01000010|42|066|B|
|01000011|43|067|C|
|01000100|44|068|D|
|01000101|45|069|E|
|01000110|46|070|F|
|01000111|47|071|G|
|01001000|48|072|H|
|01001001|49|073|I|
|01001010|4A|074|J|
|01001011|4B|075|K|
|01001100|4C|076|L|
|01001101|4D|077|M|
|01001110|4E|078|N|
|01001111|4F|079|O|
|01010000|50|080|P|
|01010001|51|081|Q|
|01010010|52|082|R|
|01010011|53|083|S|
|01010100|54|084|T|
|01010101|55|085|U|
|01010110|56|086|V|
|01010111|57|087|W|
|01011000|58|088|X|
|01011001|59|089|Y|
|01011010|5A|090|Z|

If you are feeling overwhelmed at the point, I don't blame you. I am hitting you with more information than most programming books attempt to teach. So far the goal has only been to get you started with functions you can use to print strings and numbers to the console. Without doing this foundational step, this book would be like a book on the C Programming Language without including how to use printf.

In Assembly, there is no printf. The programmer is responsible for printing the information by setting up registers, memory, and making system calls. This takes a lot of math and is not for the average human who doesn't like low level details.

If you're still with me, I have some good news for you. The next chapter will be a low easier! I will explaining every single assembly instruction that most programs need and each instruction will have a short example that can be copied and pasted directly from the digital versions of this book or typed by hand if you have a paperback edition.

However, those programs will use the putstring and putint functions a lot, and at some point you will thank me for spending 5 chapters on how to assemble programs that allow managing output to your Linux terminal.

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
- Divisor: The number we are dividing the dividend by. How many times does this number subtract from the dividend?
- Quotient: The result of the division.
- Remainder: What is left over if the divisor could not divide perfectly into the dividend.

As much as I love math, I find some of these terms confusing when I try to explain them in English. Let's face it, I am better at Assembly Language and the C Programming Language than I am with English, but it looks like you're stuck with me because normal people are not autistic enough to care!

Division is repeated subtraction, just as multiplication is repeated addition. Most of the time, modern CPU hardware can multiply and divide faster by the mul and div instructions than if you have manually made loops of repeating addition or subtraction, but the result would have been the same.

6502 CPUs (used for the Nintendo Entertainment System) did not have multiplication and division instructions, and so programmers really did use loops of adding and subtracting to get the results needed. On Intel CPUs, mul and div are available, and I suggest using them, but please don't forget what these operations really are.

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

Personally, I think that the Assembly system of conditional jumps makes a lot of sense. Other programming languages such as BASIC and C have "goto" statements that work like this. For example, `if(eax<ebx){goto less;}`.

Modern programming languages tend to discourage the use of goto or not allow it at all. However, these languages still use jumps I have described in this section because it is required by the hardware. Both "if" and "while" statements are written by using the conditional jump statements most relevant to what you are trying to do.

The only thing I have found difficult about jumps in assembly is remembering which acronym means which condition. However, since I created the chart in this chapter, now I can refer to it, and you can too! As long as I keep these six main types of conditions in my head and am working with unsigned numbers, I can write almost any assembly program from scratch.

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

# Chapter 7: Open and Close System Calls

In this chapter, I will be showing you two programs. One of them writes a message to a text file. The other will read a text file to find out what is inside it.

## FASM Create a New File

```
format ELF executable
main:

mov dword [radix],10
mov dword [int_width],1

;Linux system call to open a file

mov eax,5          ;invoke SYS_OPEN (kernel opcode 5)
mov ebx,filename   ;path to filename should be in eax before this function was called
mov ecx,101o       ;flags (in base 8) for open mode 0101 = 0100 (O_CREAT) + 1 (O_WRONLY)
mov edx,644o       ;permissions of the new file
int 80h            ;call the kernel

mov [filedesc],eax
call putint
mov eax,string1
call putstring

mov eax,string0    ;mov to eax the address of string to write
mov ecx,eax        ;pointer/address of string to write
call strlen        ;get length of the string in eax
mov edx,eax        ;copy length from eax to edx
mov ebx,[filedesc] ;write to the file descriptor
mov eax,4          ;invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
int 80h            ;system call to write the message

mov ebx,[filedesc] ;file number to close
mov eax,6          ;invoke SYS_CLOSE (kernel opcode 6)
int 80h            ;call the kernel

mov eax,1
mov ebx,0
int 80h

filename db 'newfile.txt',0
filedesc dd 0 ; file descriptor

string0 db 'This string writes to the file.',0Ah,0
string1 db '=file descriptor',0Ah,0

;The strlen function gets the length of string in eax and returns it in eax
;This is the same algorithm used in my putstring function

strlen:

push ebx
mov ebx,eax ; copy eax to ebx. ebx will be used as index to the string

strlen_start: ; this loop finds the length of the string

cmp [ebx],byte 0 ; compare byte at address ebx with 0
jz strlen_end ; if comparison was zero, jump to loop end
inc ebx
jmp strlen_start

strlen_end:
sub ebx,eax ;subtract start pointer from current pointer to get length of string
mov eax,ebx ;copy the string length back to eax
pop ebx

ret

include 'chastelib32.asm'
```

## Syscall Reference

This link will help you understand the numbers you need to include for the open and close system calls.

<https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/#x86-32-bit>

Additionally, on most Linux systems you can see the manual pages for open and close with these commands.

```
man 2 open
man 2 close
```

The manual pages, while helpful for C programmers are not very helpful for Assembly programmers. To find out which numbers are associated with which constants, you need to file the file which contains them.

Use this command find the filename containing file control constants.

```
find /usr/include -name "fcntl-linux.h"
```

The file might be in slightly different locations on different systems, but it will contain the following values plus more that are not applicable to this chapter.

|Constant|Octal Value|
|---|---|
|O_RDONLY|00|
|O_WRONLY|01|
|O_RDWR|02|
|O_CREAT	|0100|

The next example is a bit more complicated than the last. It includes more error checking because when you are trying to open a file, there is a chance that the file doesn't exist.

This next program will attempt to open the "newfile.txt" that we created with the last one. This means that if you renamed or deleted it, then it will print an error message because it couldn't open a file that doesn't exist.

## FASM Open Existing File

```
format ELF executable
main:

mov dword [radix],10
mov dword [int_width],1

;Linux system call to open an existing file

mov eax,5          ;invoke SYS_OPEN (kernel opcode 5)
mov ebx,filename   ;path to filename
mov ecx,0          ;flags for open mode 0=O_RDONLY
mov edx,0          ;permissions irrelevant because we are opening a file that exists
int 80h            ;call the kernel

push eax           ;save eax on the stack
mov [filedesc],eax ;also copy file descriptor to memory
call putint
mov eax,string1
call putstring
pop eax            ;restore eax from the stack

cmp eax,0 ;compare eax with zero to update flags
jns cat   ;if eax is not negative/signed there was no error

;Otherwise, if it was signed, then this code will display an error message.

mov eax,file_error
call putstring

jmp the_end ;end the program because we failed at opening the file

cat:

mov edx,1            ;number of bytes to read
mov ecx,tempbyte     ;address to store the bytes
mov ebx,[filedesc]   ;move the opened file descriptor into EBX
mov eax,3            ;invoke SYS_READ (kernel opcode 3 on 32 bit systems)
int 80h              ;call the kernel

cmp eax,0
jnz print_byte ;if more than zero bytes read, proceed to display
jmp the_end ;otherwise, end the program

;this point is reached if file was read from successfully

print_byte:

mov edx,1            ;number of bytes to write
mov ecx,tempbyte     ;address of the bytes
mov ebx,1            ;write to standard out instead of the file descriptor we read from
mov eax,4            ;invoke SYS_WRITE (kernel opcode 4 on 32 bit systems)
int 80h              ;call the kernel

jmp cat

cat_end:

mov ebx,[filedesc] ;file number to close
mov eax,6          ;invoke SYS_CLOSE (kernel opcode 6)
int 80h            ;call the kernel

the_end:
mov eax,1
mov ebx,0
int 80h

tempbyte db 0
filename db 'newfile.txt',0
filedesc dd 0 ; file descriptor
file_error db 'error while opening file',0Ah,0

string1 db '=file descriptor',0Ah,0

;a function to get the length of string in eax and return the integer in eax

strlen:

mov ebx,eax ; copy eax to ebx. ebx will be used as index to the string

strlen_start: ; this loop finds the length of the string as part of the putstring function

cmp [ebx],byte 0 ; compare byte at address ebx with 0
jz strlen_end ; if comparison was zero, jump to loop end because we have found the length
inc ebx
jmp strlen_start

strlen_end:
sub ebx,eax ;subtract start pointer from current pointer to get length of string

mov eax,ebx ;copy the string length back to eax

ret

include 'chastelib32.asm'
```

Another thing you may have noticed if you assembled and ran these two programs in this chapter is that they both print the number of the file descriptor. If you see it print a huge number over 4 billion, then it is probably a negative number that indicates an error has occurred. In the program for opening an existing file, I used the "jns" instruction which means "Jump if Not Signed".

I haven't described negative numbers in this book yet because it can confuse newcomers. However, these negative numbers are used by the Linux operating system to describe errors that can happen in some system calls.

Specifically in the case of the "open" call, a file might not exist or we might not have permission to open it because it belongs to a different user. Either way, we can't open it.

This chapter may have only introduced two new programs, but it also introduced 3 system calls. I already described the write call when I used it in creating the putstring function from chapter 4. This gives us the four fundamental file functions of the Linux Kernel

|Call Name|Call Number|
|-----|---|
|read |3  |
|write|4  |
|open |5  |
|close|6  |

When I introduced the write call in chapter 4, I was writing to standard output (file descriptor 1). However, from the perspective of the Linux kernel, stdout is just a special case of a file. Standard input is file descriptor 0 and it can be used to get information from the user with the keyboard.

However, when getting user input, error checking must be carefully done, even more so than when reading from another file. This is because humans are unpredictable and you have to plan for every possible input they may produce.

Getting user input will be explained in a future chapter. For now, just look over the examples in this chapter and think about the fact that all programs are just made of system calls for reading and writing files. You can open files, write to them, read from them, and close them.


