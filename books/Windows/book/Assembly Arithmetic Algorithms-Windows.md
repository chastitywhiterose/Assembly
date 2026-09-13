# Assembly Arithmetic Algorithms

32 and 64 bit Windows Edition

# Preface

This book is the Windows edition of Assembly Arithmetic Algorithms. The first book was for 16-bit DOS programming using Assembly. The second book was for 32-bit Linux programming using the same assembly language for Intel machines. But this book is very different than those because it is for Windows users who don't know anything about DOS or Linux.

I suspect most people fall into this category because Windows comes preinstalled on almost any PC you would buy in a store. Although I am old enough to have experienced DOS, and autistic enough use Linux for everything since my teenage days, I am aware that most people will never both trying other operating systems.

Although I use Linux for most things, I had to buy a laptop with Windows on it to use specific software required by Full Sail University when I was an online student. Since I have it, I decided I might as well try out some assembly language on it and learn how it works so I can pass the knowledge on to other people who are not ready to leave Windows but ARE ready to try learning assembly language.

At the time of this writing, most Windows systems use the x86-64 Intel architecture which can run 32-bit or 64-bit code. Because of this, I have decided to include code samples for both modes and explain the differences between them.

I highly suspect people don't even know what it means for something to be 32 or 64 bits. Understanding this requires knowing that a bit is a **BI**nary digi**T** and explaining the binary numeral system.

If you are someone who likes to learn the math behind how computers work, but still cannot or don't want to switch to Linux, this book will act as a bridge to test the waters of Assembly language and the control it offers you as a programmer. Programming in Assembly language is not a task for complete computer programming beginners. I do recommend having some C or C++ experience before jumping into this book, but I have tried my best not to assume knowledge of any prior languages when writing my explanations.


# Introduction

In this short book, I plan to teach you the basics of Assembly language for Intel Central Processing Units and you will learn how to make small programs that run on the Windows operating system. Theoretically, these programs should be compatible with Windows version 7, 8, 10, and 11. My only OS to test with is Windows 11 which is on the laptop I am writing this on.

There is one myth that I need to break before I can teach you how to get started programming on Windows. This book will not use an IDE (Interactive Development Environment). I consider IDEs to be evil because they hide the details of how things work. You WILL be entering commands at a terminal which is called the "Command Prompt" or the executable file at:

```
"C:\WINDOWS\system32\cmd.exe"
```

This program is the modern descendant of the original command.com from DOS. Windows may no longer be compatible with DOS but MS-DOS was a Microsoft product and Windows originally started as a program that can in DOS. Therefore, common commands such as "dir", "mkdir, "copy", "del", "rename", "type" and "exit" still work the same as they did on DOS.

Because the Assembler I will be using is FASM, which includes an IDE, you don't technically have to use the command line the way I will teach you, but you are cheating yourself if you don't become comfortable with basic commands in a terminal/console.

There is a common lie that Windows is point and click whereas Linux requires running commands at a terminal. Technically neither of these are true. The actual truth is that a PROGRAMMER must know how to use the command line on ANY operating system to achieve full power in controlling their own operating system or the building of their own programs.

But don't worry, you don't need to have been born in 1987 or grow up reading MS-DOS manuals to learn these commands. I will give you all the commands you need and you will still be pointing and clicking your way through the Windows file explorer a lot when going to your specific folder or directory (these two words mean the exact same thing in this context).

The best part is that you can use any text editor you like. However, I recommend either the default Notepad so you don't have to install an extra tool, or perhaps installing Notepad++ to benefit from syntax highlighting.

# Chapter 1: The First Program

Before you can write Windows programs in Assembly language, you will need the FASM Assembler. Be sure to download the Windows version from here:

<https://flatassembler.net/>

The file will probably be named something similar to "fasmw17335.zip"

You will need to extract the files in the zip archive and place them somewhere convenient for you. I placed them in my root C drive directory.

```
C:\fasm
```

Here is an easy way to test and see if the files are correctly located.

Using the command "dir c:\fasm" should return the results of the following files:

```
 Volume in drive C is Windows-SSD
 Volume Serial Number is D43F-B788

 Directory of c:\fasm

08/20/2026  04:00 AM    <DIR>          .
08/20/2026  04:00 AM    <DIR>          EXAMPLES
08/20/2026  04:00 AM           118,272 FASM.EXE
08/20/2026  04:00 AM           529,038 FASM.PDF
08/20/2026  04:00 AM           161,280 FASMW.EXE
08/20/2026  04:00 AM    <DIR>          INCLUDE
08/20/2026  04:00 AM             1,820 LICENSE.TXT
08/20/2026  04:00 AM    <DIR>          SOURCE
08/20/2026  04:00 AM    <DIR>          TOOLS
08/20/2026  04:00 AM            17,640 WHATSNEW.TXT
               5 File(s)        828,050 bytes
               5 Dir(s)   5,106,724,864 bytes free
```

For this book, we will mostly be concerned with FASM.EXE and the INCLUDE directory. I also recommend reading the FASM.PDF file because it is where I learned how to use the FASM Assembler.

The next step is to (temporarily) set your path variables so that you can assemble your source files no matter which folder/directory you happen to be in. Once you have chosen your location to begin coding, you will want to run two commands to set the "path" and "include" variables. I usually place them in a short batch file named fasmpath.bat for convenience.

## fasmpath.bat

```
set path=C:\fasm
set include=C:\fasm\INCLUDE
```

Whether you type those two commands or just place them in a batch file and enter "fasmpath" to execute the script, either way, your paths will be set until you close your console/terminal window. Then all changes will revert to whatever your system defaults were.

There is a GUI setting to permanently change the variables but I DO NOT recommend this because making a mistake can make your system completely unusable. I will explain more about this later.

Anyway, once you have a source file of a valid program, you can assemble it like this.

```
fasm main.asm
```

The file does not have to specifically be named "main.asm". It could just as well be "fartbutt.asm" or even "count-dracula.txt". You can choose whatever seems like a good name to you and adjust the commands accordingly.

But in this example, a file named "main.exe" will be created and so you just type:

```
main
```

To run it like you would any other Windows program.

To get started, I will provide the first example program that can be assembled and run under the Windows operating system. This was tested on my laptop with Windows 11 but should theoretically work on older versions as well as long as you followed my instructions so far.

Behold,the "Hello World" source file for a Windows console program.

## Hello World for 32-bit Windows

```
format PE console
entry main

include 'win32a.inc' ;include Windows 32-bit macros

main:

mov eax,main_string
call putstring


push 0             ;exit code for operating system
call [ExitProcess] ;Exit the process with code 0

main_string db 'Hello World',0x0D,0x0A,0

putstring:         ;print string pointed to by eax register

push eax
push ebx
push ecx
push edx

mov ebx,eax             ;copy eax to ebx to be used as index to the string

putstring_strlen_start: ;this loop finds the length of the string as part of the putstring function

cmp [ebx],byte 0        ;compare byte at address ebx with 0
jz putstring_strlen_end ;if comparison was zero, jump to loop end because we have found the length
inc ebx
jmp putstring_strlen_start

putstring_strlen_end:
sub ebx,eax ;subtract start pointer from current pointer to get length of string

;Windows 32-bit WriteFile system call

push 0               ;lpOverlapped = NULL
push 0               ;lpNumberOfBytesWritten = NULL
push ebx             ;nNumberOfBytesToWrite = ebx
push eax             ;lpBuffer = address of string to write
push -11             ;STD_OUTPUT_HANDLE = Negative Eleven
call [GetStdHandle]  ;Get Standard Handle for -11
push eax             ;hFile = eax (returned from GetStdHandle)
call [WriteFile]


pop edx
pop ecx
pop ebx
pop eax

ret

section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess'
```

You might wonder why it took nearly 70 lines to print a simple message. That is because unlike in C, Pascal, or BASIC, there are no printf, write, or print statements. The included putstring function is one I had to write and is not normally available unless someone like me builds it.

It does however make use of the WriteFile Windows API call. My function calculates the length of the string by finding where the zero is and then subtracting the address of the beginning from the end. Then once the length is known, the arguments to the function are pushed to the stack in the order that Microsoft wanted them to be before calling the WriteFile function.

I have no idea where the source code for this API call is because it is proprietary information and Windows is not an Open Source operating system. However, using a Windows API call like this is an extremely fast operation and it is the start of everything else this book will cover.

However, this is only the 32 bit version of the program. A 64 bit version looks more like the following.

## Hello World for 64-bit Windows

```
format PE64 console
entry main

include 'win64a.inc' ;include Windows 64-bit macros

main:

mov rax,main_string
call putstring

sub rsp,40         ;align stack (required in windows 64-bit)
mov rcx,0          ;exit code for operating system
call [ExitProcess] ;Exit the process with code 0

main_string db 'Hello World',0x0D,0x0A,0

putstring:         ;print string pointed to by rax register

push rax
push rbx
push rcx
push rdx

mov rbx,rax             ;copy eax to ebx to be used as index to the string

putstring_strlen_start: ;this loop finds the length of the string as part of the putstring function

cmp [rbx],byte 0        ;compare byte at address ebx with 0
jz putstring_strlen_end ;if comparison was zero, jump to loop end because we have found the length
inc rbx
jmp putstring_strlen_start

putstring_strlen_end:
sub rbx,rax ;subtract start pointer from current pointer to get length of string

;Windows 64-bit WriteFile system call
sub rsp,40           ;align stack for Win64 API calls
mov qword [rsp+32],0 ;lpOverlapped = NULL
mov r9,0             ;lpNumberOfBytesWritten = NULL
mov r8,rbx           ;nNumberOfBytesToWrite = rbx
mov rdx,rax          ;lpBuffer = address of string to write
mov rcx, -11         ;STD_OUTPUT_HANDLE = Negative Eleven
call [GetStdHandle]  ;Get Standard Handle for -11
mov rcx,rax          ;hFile = rax (returned from GetStdHandle)
call [WriteFile]
add rsp,40           ;restore stack now that WinAPI calls are done

pop rdx
pop rcx
pop rbx
pop rax

ret

section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess'
```

Because in both cases, the programs are identical, you might wonder which is better or the correct thing to use. Actually, they are exactly the same but using a different calling convention and register size.

You may also notice that at the bottom of the source files there is an "idata" section which includes data from the Windows kernel which is KERNEL32.DLL. Regardless of whether your code using 32 or 64 bit registers, the exact same functions from the kernel are being dynamically linked and loaded so that your program can do basic tasks.

## First 3 Windows API calls

These three functions are required for even a simple Hello World program like both of those above.

- GetStdHandle
- WriteFile
- ExitProcess

The documentation for these functions can be found on Microsoft's website but it is not very helpful for Assembly because it is written for C and C++ programming. But don't worry, I will teach you how to translate these C functions into something usable for Assembly programming. Therefore, I suggest you look at these links because they have been my primary sources.

<https://learn.microsoft.com/en-us/windows/console/getstdhandle>

<https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-writefile>

<https://learn.microsoft.com/en-us/windows/win32/api/processthreadsapi/nf-processthreadsapi-exitprocess>

Despite the fact that most of the web pages don't tell us what we need for assembly, some of it is helpful. For example, the C function prototype the GetStdHandle is below.

## GetStdHandle Syntax

```
HANDLE WINAPI GetStdHandle(
  _In_ DWORD nStdHandle
);
```

This tells us that the function has one parameter called "nStdHandle". The values we need for it are in the table below.


For example the following table for the 3 standard handles on the GetStdHandle page is copied below.

## GetStdHandle function table

|Value|Meaning|
|-----|-------|
|-10|STD_INPUT_HANDLE|
|-11|STD_OUTPUT_HANDLE|
|-12|STD_ERROR_HANDLE|

These three "handles" are just the Windows version of what would have been called a "file descriptor" in Linux. They actual handle numbers returned from the GetStdHandle function may be different from the numbers passed as the nStdHandle. However, in all programs, the standard input, standard output, and standard error handles are supposed to exist.

For right now, we need to only consider the standard output handle because we want to display something on the screen. Because negative 11 is how the standard output handle is obtained, that is why the 32 bit putstring has these 3 lines

```
push -11            ;STD_OUTPUT_HANDLE = Negative Eleven
call [GetStdHandle] ;use the above handle
push eax            ;eax is return value of previous function
```

and the 64 bit putstring has these lines

```
mov rcx, -11        ; STD_OUTPUT_HANDLE
call [GetStdHandle] ; Get Standard Output Handle
mov rcx,rax         ; copy handle to ecx
```

In both cases, the argument -11 is passed to the GetStdHandle function. In 32 bit mode, it is pushed to the stack before the call and in 64 bit mode is is loaded into the rcx register before the call.

This may seem silly but it highlights the importance of a calling convention. If you read my DOS or Linux editions of Assembly Arithmetic Algorithms, you will see that they use a purely register based convention for all system calls.

Windows is harder because it uses a hybrid approach of sometimes using registers for function arguments and other times using specific locations on the stack relative to the stack pointer.

But you are probably asking at this point: "What is a stack?", "What is a register?", and "What is a bit?".

I will attempt to answer all these questions in the next chapter. For now, I still need to finish explaining the WriteFile and ExitProcess calls.

## WriteFile Syntax

```
BOOL WriteFile(
  [in]                HANDLE       hFile,
  [in]                LPCVOID      lpBuffer,
  [in]                DWORD        nNumberOfBytesToWrite,
  [out, optional]     LPDWORD      lpNumberOfBytesWritten,
  [in, out, optional] LPOVERLAPPED lpOverlapped
);
```

As you can see above, the WriteFile function has 5 parameters. 2 of these are optional and have been marked as NULL in my Hello World examples above. This leaves us with only 3 variables as our parameters, which are sometimes called arguments.

## WriteFile parameters

|Variable             |Meaning                   |
|---------------------|--------------------------|
|hfile                |destination file or device|
|lpBuffer             |address of byte string    |
|nNumberOfBytesToWrite|write this many bytes     |

The WriteFile function looks complicated mostly because of the optional arguments used in it. Because the Windows API expects all these arguments to be present on the stack (32-bit mode) or a combination of stack and registers (64-bit mode), extra code is wasted every time we make a call to WriteFile.

It is precisely for this reason that the Hello World examples for this chapter called the WriteFile function inside a function named "putstring". The idea behind this is to have to only call this function inside another function that automatically calculates how many bytes exist before the zero byte, then gets the standard output handle with GetStdHandle, and then writes exactly that many bytes from the address pointed to by the eax or rax register before the putstring function was called.

## ExitProcess Syntax

```
VOID ExitProcess(
  [in] UINT uExitCode
);
```

The ExitProcess function is the easiest of all to use. It ends the program and therefore only needs to be called at the end. But there is a special trick it does. You pass the exit code to it that you want. This can literally be any number you like best, but the tradition is to pass 0 to say that there were zero problems in this program.

In 32-bit mode you need to only push one 32-bit number onto the stack before you call it. In 64-bit mode, you load the rcx register with the number you prefer. The best part is that you can run the following command right after the program finishes to see the error code you used.

```
echo %errorlevel%
```

Those 3 Windows API calls are all you actually need to build most programs. There are more that will be covered later, but you will need to understand some terminology that I will cover in Chapter 2 before we can proceed to more advanced things like getting user input and printing numbers.

# Chapter 2: Assembly Terminology

## Register

A variable with a fixed name that is always available to use. These come in different sizes such as "EAX" for 32-bit and "RAX" for 64-bit.

### The General Purpose Registers

There are 8 general purpose registers that exist on 32-bit Intel machines. Their names are the same as those used in 16-bit Intel machines except with the letter 'E' prefixed. Their names are acronyms that mean the following.

Register|Meaning             |
|-------|--------------------|
|EAX    |Accumulator Register|
|EBX    |Base Register       |
|ECX    |Count Register      |
|EDX    |Data Register       |
|ESI    |Source Index        |
|EDI    |Destination index   |
|EBP    |Base Pointer        |
|ESP    |Stack Pointer       |

In 64 bit mode, all of these are prefixed with an 'R' and are 64 bits in size. However, the 32 bit versions above still exist as the lower half of the 64 bit registers.

But in 64-bit mode, there are also 8 more registers which are named R8 to R15. This gives you plenty more registers to work with which in my opinion is the primary advantage of 64-bit Assembly programming. More registers is generally good because you might be doing something complicated and use them to store variables instead of saving them to memory. Because registers are faster to access than RAM, the faster programs are those that use the most registers and the least RAM.

With all that being said, I only use the new registers R8 and R9 in this book because they are the third and fourth arguments in the 64-bit calling convention of the Windows API. Most of the time I prefer to stick with the Accumulator Register, Base Register, Count Register, and Data Register. For this reason, there is a convention of using them in a specific way in the DOS, Linux, and Windows versions of Assembly Arithmetic Algorithms. Since this is the Windows book, you will see a lot of use of the RCX, RDX, R8, and R9 registers for the 64-bit sample programs.

## Bit

A bit is a BInary digiT. It is a number that can be 0 or 1. These are the only two numbers a bit can be but by combining multiple bits as a group, any number can be represented. Just as the decimal systems humans use only uses digits 0,1,2,3,4,5,6,7,8,9 but can represent any possible number, binary can also represent any number once you learn how it works. Explaining the Binary Numeral System will be a central feature of this book because no programmer can be successful without it.

The Binary Numeral System is essential because all computers define their data types in terms of how many bits they are. A 32 bit number can access up to 4294967296 bytes (4 Gigabytes) of memory at a time. A 64 bit number can access far more memory than you will probably ever see in a computer. 

This math is based on powers of two. Two to the power of 64 is 18446744073709551616 because it is what happens if you keep multiplying two by itself 64 times. This number is so large that I highly doubt humanity will have need of machines processing larger than 64-bits at a time.

## Stack

A stack can be many things. It can be a stack of plates, a stack of pancakes on top of plates that you are going to eat, or it can be a stack of numbers where we temporarily place numbers that are in registers and free them up to be used for other tasks. Assembly programming requires basic understanding of the stack, but Windows specifically requires using the stack in the way Microsoft wants you do. Admittedly this is less fun and more restrictive compared to DOS or Linux, but there are clever ways to break the convention.

For example, the putstring function from chapter 1 is an example of a user written function that uses the Windows API so that I don't have to manually call a Windows API function every time I need to print a string.

## It gets easier!

This is the point where most people will give up. There are so many terms to learn and it takes a lot of information to even get a small program working to display a message like "Hello World".

But despite being difficult to get started, it gets easier as you proceed. It is like playing a new game which you don't know the controls for or where your character is supposed to go next. Yes Assembly is hard, but not as hard as playing the Legend of Zelda: Ocarina of Time. Seriously, that game way more stressful than any programming language I have have used (except for Rust).

A funny example I suppose, but programming really is like playing a game where you get to create your own rules. Perhaps Minecraft would be an even better example because you start with nothing and slowly create your own tools to progress faster.

I can tell you one thing, when I started playing Minecraft, I knew nothing. Back in those early days, I had to look up the recipes in order to arrange my sticks and planks on a grid to make a sword, axe, pickaxe, or shovel. They didn't have the recipes built into the interface like they do now.

Assembly programming is actually a lot like Minecraft or Terraria because you start the game with nothing and have to slowly build your tools to make something useful. I started Assembly in 2024 and have already built a series of tools I personally use on both DOS and Linux operating systems. Through the course of this book, I will be slowly showing you how I can port everything in the Linux version of Assembly Arithmetic Algorithms to Windows.

# Chapter 3: Printing Integers

In this chapter, I will be showing two identical programs much like I did in chapter 1 with the examples of using the putstring function. However, I will be introducing new functions that all depend on the use of putstring but are used as a system for printing integers.

The first of of these new functions is intstr, which converts the number in the Accumulator Register into a string.

The second is putstring which saves(pushes) several registers to the stack, calls intstr and then putstring to print the string just created. Finally, the registers are restored(popped) to their original state before putint was called.

The basic idea is that we can print what a register contains without modifying it permanently and messing up the main loop in the program. Both of these programs contain a loop of a register starting as 1 and then adding itself to itself. Eventually this will reach an "overflow" and result in 0. This sounds strange but is a feature of fix-sized integers in computers.

Read each program and the output that follows it. It is okay if you don't understand them at first. The goal is to get something working and then explain why it works as it does later.

## putint for 32-bit Windows


```
format PE console
entry main

include 'win32a.inc'    ;includes standard Windows 32-bit definitions and macros

main:

mov eax,1
loop0:

mov dword[radix],2      ;set radix to binary
mov dword[int_width],32
call putint
call putspace
mov dword[radix],10     ;set radix to decimal (what humans read)
mov dword[int_width],10
call putint
call putline            ;print newline before the next loop

add eax,eax
cmp eax,0
jnz loop0


push 0             ;exit code for operating system
call [ExitProcess] ;Exit the process with code 0

putstring:         ;print string pointed to by eax register

push eax
push ebx
push ecx
push edx

mov ebx,eax             ;copy eax to ebx to be used as index to the string

putstring_strlen_start: ;this loop finds the length of the string as part of the putstring function

cmp [ebx],byte 0        ;compare byte at address ebx with 0
jz putstring_strlen_end ;if comparison was zero, jump to loop end because we have found the length
inc ebx
jmp putstring_strlen_start

putstring_strlen_end:
sub ebx,eax ;subtract start pointer from current pointer to get length of string

;Windows 32-bit WriteFile system call

push 0               ;lpOverlapped = NULL
push 0               ;lpNumberOfBytesWritten = NULL
push ebx             ;nNumberOfBytesToWrite = ebx
push eax             ;lpBuffer = address of string to write
push -11             ;STD_OUTPUT_HANDLE = Negative Eleven
call [GetStdHandle]  ;Get Standard Handle for -11
push eax             ;hFile = eax (returned from GetStdHandle)
call [WriteFile]


pop edx
pop ecx
pop ebx
pop eax

ret

; This is the location in memory where digits are written to by the intstr function
; The string of bytes and settings such as the radix and width are global variables defined below.

int_string db 32 dup '?' ;reserve bytes for characters string for 32-bit binary integer

int_string_end db 0 ;zero byte terminator for the integer string

radix dd 2     ;radix or base for integer output. 2=binary, 8=octal, 10=decimal, 16=hexadecimal
int_width dd 8 ;default width of integers. Extra zeros prefixed if more than 1

;this function creates a string of the integer in eax
;it uses the above radix variable to determine base from 2 to 36
;it then loads eax with the address of the string
;this means that it can be used with the putstring function

intstr:

mov ebx,int_string_end-1 ;find address of lowest digit
mov ecx,1

digits_start:

mov edx,0;
div dword [radix]
cmp edx,10
jb decimal_digit
jnb hexadecimal_digit

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

mov eax,ebx ;point eax register to this string for putstring

ret

;function to print string form of whatever integer is in eax
;The radix determines which number base the string form takes.
;Anything from 2 to 36 is a valid radix
;in practice though, only bases 2,8,10,and 16 will make sense to other programmers
;this function does not process anything by itself but calls the combination of my other
;functions in the order I intended them to be used.

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

;The utility functions below simply print a space or a newline.
;these help me save code when printing lots of strings and integers.

space db ' ',0 ;a string containing only a space

putspace:
push eax
mov eax,space
call putstring
pop eax
ret

line db 0x0D,0x0A,0 ;a string containing only a newline

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

section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess'
```

## Output of 32-bit putint program

```
00000000000000000000000000000001 0000000001
00000000000000000000000000000010 0000000002
00000000000000000000000000000100 0000000004
00000000000000000000000000001000 0000000008
00000000000000000000000000010000 0000000016
00000000000000000000000000100000 0000000032
00000000000000000000000001000000 0000000064
00000000000000000000000010000000 0000000128
00000000000000000000000100000000 0000000256
00000000000000000000001000000000 0000000512
00000000000000000000010000000000 0000001024
00000000000000000000100000000000 0000002048
00000000000000000001000000000000 0000004096
00000000000000000010000000000000 0000008192
00000000000000000100000000000000 0000016384
00000000000000001000000000000000 0000032768
00000000000000010000000000000000 0000065536
00000000000000100000000000000000 0000131072
00000000000001000000000000000000 0000262144
00000000000010000000000000000000 0000524288
00000000000100000000000000000000 0001048576
00000000001000000000000000000000 0002097152
00000000010000000000000000000000 0004194304
00000000100000000000000000000000 0008388608
00000001000000000000000000000000 0016777216
00000010000000000000000000000000 0033554432
00000100000000000000000000000000 0067108864
00001000000000000000000000000000 0134217728
00010000000000000000000000000000 0268435456
00100000000000000000000000000000 0536870912
01000000000000000000000000000000 1073741824
10000000000000000000000000000000 2147483648
```

## putint for 64-bit Windows

```
format PE64 console
entry main

include 'win64a.inc'    ;includes standard Windows 64-bit definitions and macros

main:

mov rax,1
loop0:

mov qword[radix],2      ;set radix to binary
mov qword[int_width],64
call putint
call putspace
mov qword[radix],10     ;set radix to decimal (what humans read)
mov qword[int_width],19
call putint
call putline            ;print newline before the next loop

add rax,rax
cmp rax,0
jnz loop0

sub rsp,40         ;align stack (required in windows 64-bit)
mov rcx,0          ;exit code for operating system
call [ExitProcess] ;Exit the process with code 0

putstring:         ;print string pointed to by rax register

push rax
push rbx
push rcx
push rdx

mov rbx,rax             ;copy eax to ebx to be used as index to the string

putstring_strlen_start: ;this loop finds the length of the string as part of the putstring function

cmp [rbx],byte 0        ;compare byte at address ebx with 0
jz putstring_strlen_end ;if comparison was zero, jump to loop end because we have found the length
inc rbx
jmp putstring_strlen_start

putstring_strlen_end:
sub rbx,rax ;subtract start pointer from current pointer to get length of string

;Windows 64-bit WriteFile system call
sub rsp,40           ;align stack for Win64 API calls
mov qword [rsp+32],0 ;lpOverlapped = NULL
mov r9,0             ;lpNumberOfBytesWritten = NULL
mov r8,rbx           ;nNumberOfBytesToWrite = rbx
mov rdx,rax          ;lpBuffer = address of string to write
mov rcx, -11         ;STD_OUTPUT_HANDLE = Negative Eleven
call [GetStdHandle]  ;Get Standard Handle for -11
mov rcx,rax          ;hFile = rax (returned from GetStdHandle)
call [WriteFile]
add rsp,40           ;restore stack now that WinAPI calls are done

pop rdx
pop rcx
pop rbx
pop rax

ret

; This is the location in memory where digits are written to by the intstr function
; The string of bytes and settings such as the radix and width are global variables defined below.

int_string db 64 dup '?' ;reserve bytes for characters string for 64-bit binary integer

int_string_end db 0 ;zero byte terminator for the integer string

radix dq 2     ;radix or base for integer output. 2=binary, 8=octal, 10=decimal, 16=hexadecimal
int_width dq 8 ;default width of integers. Extra zeros prefixed if more than 1

;this function creates a string of the integer in rax
;it uses the above radix variable to determine base from 2 to 36
;it then loads rax with the address of the string
;this means that it can be used with the putstring function

intstr:

mov rbx,int_string_end-1 ;find address of lowest digit
mov rcx,1

digits_start:

mov rdx,0;
div qword [radix]
cmp rdx,10
jb decimal_digit
jnb hexadecimal_digit

decimal_digit: ;we go here if it is only a digit 0 to 9
add rdx,'0'
jmp save_digit

hexadecimal_digit:
sub rdx,10
add rdx,'A'

save_digit:

mov [rbx],dl
cmp rax,0
jz intstr_end
dec rbx
inc rcx
jmp digits_start

intstr_end:

prefix_zeros:
cmp rcx,[int_width]
jnb end_zeros
dec rbx
mov [rbx],byte '0'
inc rcx
jmp prefix_zeros
end_zeros:

mov rax,rbx ;point eax register to this string for putstring

ret

;function to print string form of whatever integer is in rax
;The radix determines which number base the string form takes.
;Anything from 2 to 36 is a valid radix
;in practice though, only bases 2,8,10,and 16 will make sense to other programmers
;this function does not process anything by itself but calls the combination of my other
;functions in the order I intended them to be used.

putint: 

push rax
push rbx
push rcx
push rdx

call intstr
call putstring

pop rdx
pop rcx
pop rbx
pop rax

ret

;The utility functions below simply print a space or a newline.
;these help me save code when printing lots of strings and integers.

space db ' ',0 ;a string containing only a space

putspace:
push rax
mov rax,space
call putstring
pop rax
ret

line db 0x0D,0x0A,0 ;a string containing only a newline

;the next function which pushes rax to the stack
;moves the address of the line string and prints it with putstring
;then it pops the original value of rax back from the stack before the function returns
;this allows me to print a newline anywhere in the code without a single register changing

putline:
push rax
mov rax,line
call putstring
pop rax
ret

section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess'
```

## Output of 64-bit putint program

```
0000000000000000000000000000000000000000000000000000000000000001 0000000000000000001
0000000000000000000000000000000000000000000000000000000000000010 0000000000000000002
0000000000000000000000000000000000000000000000000000000000000100 0000000000000000004
0000000000000000000000000000000000000000000000000000000000001000 0000000000000000008
0000000000000000000000000000000000000000000000000000000000010000 0000000000000000016
0000000000000000000000000000000000000000000000000000000000100000 0000000000000000032
0000000000000000000000000000000000000000000000000000000001000000 0000000000000000064
0000000000000000000000000000000000000000000000000000000010000000 0000000000000000128
0000000000000000000000000000000000000000000000000000000100000000 0000000000000000256
0000000000000000000000000000000000000000000000000000001000000000 0000000000000000512
0000000000000000000000000000000000000000000000000000010000000000 0000000000000001024
0000000000000000000000000000000000000000000000000000100000000000 0000000000000002048
0000000000000000000000000000000000000000000000000001000000000000 0000000000000004096
0000000000000000000000000000000000000000000000000010000000000000 0000000000000008192
0000000000000000000000000000000000000000000000000100000000000000 0000000000000016384
0000000000000000000000000000000000000000000000001000000000000000 0000000000000032768
0000000000000000000000000000000000000000000000010000000000000000 0000000000000065536
0000000000000000000000000000000000000000000000100000000000000000 0000000000000131072
0000000000000000000000000000000000000000000001000000000000000000 0000000000000262144
0000000000000000000000000000000000000000000010000000000000000000 0000000000000524288
0000000000000000000000000000000000000000000100000000000000000000 0000000000001048576
0000000000000000000000000000000000000000001000000000000000000000 0000000000002097152
0000000000000000000000000000000000000000010000000000000000000000 0000000000004194304
0000000000000000000000000000000000000000100000000000000000000000 0000000000008388608
0000000000000000000000000000000000000001000000000000000000000000 0000000000016777216
0000000000000000000000000000000000000010000000000000000000000000 0000000000033554432
0000000000000000000000000000000000000100000000000000000000000000 0000000000067108864
0000000000000000000000000000000000001000000000000000000000000000 0000000000134217728
0000000000000000000000000000000000010000000000000000000000000000 0000000000268435456
0000000000000000000000000000000000100000000000000000000000000000 0000000000536870912
0000000000000000000000000000000001000000000000000000000000000000 0000000001073741824
0000000000000000000000000000000010000000000000000000000000000000 0000000002147483648
0000000000000000000000000000000100000000000000000000000000000000 0000000004294967296
0000000000000000000000000000001000000000000000000000000000000000 0000000008589934592
0000000000000000000000000000010000000000000000000000000000000000 0000000017179869184
0000000000000000000000000000100000000000000000000000000000000000 0000000034359738368
0000000000000000000000000001000000000000000000000000000000000000 0000000068719476736
0000000000000000000000000010000000000000000000000000000000000000 0000000137438953472
0000000000000000000000000100000000000000000000000000000000000000 0000000274877906944
0000000000000000000000001000000000000000000000000000000000000000 0000000549755813888
0000000000000000000000010000000000000000000000000000000000000000 0000001099511627776
0000000000000000000000100000000000000000000000000000000000000000 0000002199023255552
0000000000000000000001000000000000000000000000000000000000000000 0000004398046511104
0000000000000000000010000000000000000000000000000000000000000000 0000008796093022208
0000000000000000000100000000000000000000000000000000000000000000 0000017592186044416
0000000000000000001000000000000000000000000000000000000000000000 0000035184372088832
0000000000000000010000000000000000000000000000000000000000000000 0000070368744177664
0000000000000000100000000000000000000000000000000000000000000000 0000140737488355328
0000000000000001000000000000000000000000000000000000000000000000 0000281474976710656
0000000000000010000000000000000000000000000000000000000000000000 0000562949953421312
0000000000000100000000000000000000000000000000000000000000000000 0001125899906842624
0000000000001000000000000000000000000000000000000000000000000000 0002251799813685248
0000000000010000000000000000000000000000000000000000000000000000 0004503599627370496
0000000000100000000000000000000000000000000000000000000000000000 0009007199254740992
0000000001000000000000000000000000000000000000000000000000000000 0018014398509481984
0000000010000000000000000000000000000000000000000000000000000000 0036028797018963968
0000000100000000000000000000000000000000000000000000000000000000 0072057594037927936
0000001000000000000000000000000000000000000000000000000000000000 0144115188075855872
0000010000000000000000000000000000000000000000000000000000000000 0288230376151711744
0000100000000000000000000000000000000000000000000000000000000000 0576460752303423488
0001000000000000000000000000000000000000000000000000000000000000 1152921504606846976
0010000000000000000000000000000000000000000000000000000000000000 2305843009213693952
0100000000000000000000000000000000000000000000000000000000000000 4611686018427387904
1000000000000000000000000000000000000000000000000000000000000000 9223372036854775808
```

You may have noticed in the source that I included putspace and putline functions. These operations are so common when printing lists of numbers that they deserved special functions so that the eax or rax register did not need to be pushed and popped during the main function of the program.

The output of the program in both cases is the same number printed twice in two different bases. The first base is binary (radix two) which is how computers see numbers (0 or 1). The second base is decimal (radix ten) which is the number system humans teach children in school.

Perhaps the hardest barrier to entry when learning computer programming is that you have to unlearn the trash that your school teachers taught you when it comes to math. Computers work only in binary for representing numbers.

The intstr function I wrote is an algorithm to generate a string that can use any radix from 2 to 36. It is designed so that humans can read something they recognize but still get an idea of how the numbers look to a computer.

The program prints all the bits in binary followed by a space, the decimal version of the same thing, and then a newline. Keep in mind that it may not look perfect in the book you are reading right now (due to different formatting of ebook settings and paperback sizes), but if you assemble and run the program on your computer, it will look as intended for sure.

## Dependency Chain

Although this is still relatively early in the book, we already have a dependency chain of functions.

putstring depends on the Windows API WriteFile function and WriteFile depends on GetStdHandle to grab the standard output handle for displaying things to the screen.

intstr does not directly require anything but the string it produces is designed to be used with putstring. putint calls both intstr and putstring and therefore won't work if either of these functions are missing.

Sometimes in software development, you can run into what is called a "Dependency Hell" because sometimes the maker of one library will change the number of parameters in a function or change the order of them. Although this is a real danger in larger projects, you can take comfort in knowing that problems rarely happen in console programs because we are using the Windows kernel which has these functions standardized.

If even one function in the Windows kernel was changed by Microsoft, then all things on the operating system would stop working. Although theoretically it could happen, this is unlikely because Microsoft would lose even more business if everything stopped working entirely.

But regardless of what may happen, all operating systems are guaranteed to have some functions that don't change for some time because it is bad for business if all the software breaks.

There will probably be a day when Windows stops existing, but even if it does, don't worry because there is always Linux to switch to as a superior alternative! I also already wrote an [Assembly book](https://leanpub.com/assemblyarithmeticalgorithms-Linux) for Linux by the way.


# Chapter 4: Chastity's Intel Assembly Reference

I use a very small subset of the Intel 8086 family instruction set. This is both because I want to limit it to my small memory (my brain memory, not computer memory). If you are like me and have a tendency to forget things, then Assembly language is actually very good because there is not a lot to remember when compared to bigger high level languages like C++ or Java. And if you do forget, this chapter will function as the definitive guide for performing math using Assembly language for Linux

**Important note. All program listings in this chapter assume that you also included the putstring,intstr,and putint functions as shown in previous chapters. This can be done by including external files or just copy pasting their text from the 64-bit example in chapter 3.**

Inside each example, you will see a line before the main function to include a new file.

```
include 'chastelib-w64.asm'
```

The [chastelib-w64.asm](https://github.com/chastitywhiterose/Assembly/blob/main/fasm/aaa-windows/chapter-4/add/chastelib-w64.asm) file  contains the functions listed in chapters 1 and 2 but also includes a lot more commentary than I have included in those chapters. For your convenience, you can download it from my repository and view the entire source code of these functions. My functions provide a useful base which you can use to add,delete, or even improve upon mine. Not only do the examples in this reference chapter use them to show output, but many programs in future chapters will too.

For this chapter, I could have used either the 32-bit or 64-bit functions. I decided to stick with 64-bit mode for this and future chapters because this is a book about Arithmetic and allowing the maximum size registers for integers will serve the target audience of this book the most. Most Windows users are using 64-bit Windows systems at this time.

## mov

The mov instruction copies a number from one location to another. In the FASM and NASM assemblers, the instruction always takes the form

`mov destination,source`

Think of it as "destination=source" as you would write in C. For example, in the following program which prints the number 8, we see that most of the required data is set up with mov instructions.

```
format PE64 console
entry main

include 'win64a.inc'
include 'chastelib-w64.asm'

main:

mov qword[radix],10
mov qword[int_width],1

mov rax,3
mov rbx,5
add rax,rbx

call putint
call putline

sub rsp,40
mov rcx,0
call [ExitProcess]

section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess'

```

That program also contains the call, int, and add instructions to make a program that does something useful. However, mov instructions take up the largest part of any program. Whether you are filling a register with a number, another register, or a memory location, the mov instruction is the way to do it.

## add

Next to mov, you will see that add is going to be your friend in Assembly a lot. In the previous example, we saw that 3 and 5 were added to make 8. Just like mov, add follows the same rules.

`add destination,source`

- Destination is left of Source and separated by a comma
- Destination and Source can be registers and memory locations
- But Destination and Source cannot both be memory locations
- Source can also be a regular integer value

Most instructions that take two arguments follow these same rules. Once you have mastered mov and add, you can handle almost anything in a program because you know the basic rules.

There is also the "inc" instruction which takes only one item and adds 1 to it. This is just a shorter way of saying "add destination,1"

## sub

As its name implies, sub will subtract the Source from the Destination.

`sub destination,source`

Since it follows the same rules as mov and add (starting to see a pattern yet?), subtraction is just as easy as addition.

Just as "add" has "inc", "sub" has the "dec" instruction which subtracts 1. Adding or subtracting 1 are probably the most common thing ever done while programming in any language.

Just as a review of the mov,add,sub instructions, here is a small program to show their effect.

```
format PE64 console
entry main

include 'win64a.inc'
include 'chastelib-w64.asm'

main:

mov qword[radix],10
mov qword[int_width],1

mov rax,8
call putint
call putline
add rax,rax
call putint
call putline
sub rax,4
call putint
call putline

sub rsp,40
mov rcx,0
call [ExitProcess]

section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess'
```

That program will output the following.

```
8
16
12
```

This is because we set rax to 8, then we added rax to itself to get 16, and finally we subtracted 4 from rax which made it 12. Once you think about how easy this is, read on to see how multiplication and division work.

## mul

The mul instruction is slightly different than The previous instructions. It takes only one operand which must be either a register or memory location. It multiplies rax by the value of this operand. If the value is too large to fit within the rax register, it puts the higher bits into rdx.


## div

The div instruction divides eax by the operand you give it (the divisor). However, division is a tricky operation because not every number divides evenly into another. It is also more complicated by the fact that the rdx register is assumed to be the upper half of the bits in the dividend while rax is the lower bits of the dividend.

I know it sounds complicated but it is easier than I can explain. I can illustrate this with a small program that multiplies and divides!

```
format PE64 console
entry main

include 'win64a.inc'
include 'chastelib-w64.asm'

main:

mov qword[radix],10
mov qword[int_width],1

mov rax,12
call putint
call putline
mov rbx,5
mul rbx
call putint
call putline
mov rbx,8
mov rdx,0
div rbx
call putint
call putline
mov rax,rdx
call putint
call putline

sub rsp,40
mov rcx,0
call [ExitProcess]

section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess'
```

The output of that program is this:

```
12
60
7
4
```

This is because 12 was multiplied by 5 to get 60. Then we attempted to divide 60 by 8. It goes in only 7 times (which equals 56). This means the remainder is 4, which is stored in the rdx register after the division.

You may also notice in the source above that I set edx to zero before the div instruction. If this is not done, the rdx might have mistakenly had another number and been interpreted as part of the dividend.

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

Aside from those main 6 conditional jumps that I have memorized, there also exists jumps for signed/negative numbers which I have not not talked about yet in this book yet. A small table is below.

## Signed Number Jumps Table

|Instruction|Meaning|
|-------|-------------------|
|js     |jump if signed     |
|jns    |jump if not signed |
|jg     |jump if greater    |
|jl     |jump if less       |
|jng    |jump if not greater|
|jnl    |jump if not less   |

Personally I don't agree with the way negative numbers are represented in computers but I know that understanding the context of signed vs unsigned is important for more complex programs. Once again, I recommend the FASM programmers manual for details that I have excluded for the purpose of keeping this book short.

The Intel processors also have the "neg" instruction for converting between positive and negative. But for the most part, my programs do not use negative numbers and the first table for unsigned integer conditional jumps will be all you need.

The following program can print a message telling you whether rax is less than , equal to, or more than ebx. Upon this foundation all the conditional jumps in my programs and functions are based.


```
format PE64 console
entry main

include 'win64a.inc'
include 'chastelib-w64.asm'

main:

mov qword[radix],10
mov qword[int_width],1

mov rax,5
mov rbx,8
cmp rax,rbx
jb less
je same
ja more

less:
mov rax,string_less
jmp the_end
same:
mov rax,string_same
jmp the_end
more:
mov rax,string_more
jmp the_end

the_end:
call putstring

sub rsp,40
mov rcx,0
call [ExitProcess]

string_less db 'rax is less than rbx',0Dh,0Ah,0
string_same db 'rax is the same as rbx',0Dh,0Ah,0
string_more db 'rax is more than rbx',0Dh,0Ah,0

section '.idata' import data readable writeable

library kernel32, 'KERNEL32.DLL'

import kernel32,\
 GetStdHandle, 'GetStdHandle',\
 WriteFile, 'WriteFile',\
 ExitProcess, 'ExitProcess'
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

I am sharing what I have learned from reading the Intel Manuals and the API references available for Windows so that you don't have to spend as much time figuring these things out as I did. What I can tell you, though, is that the result was worth it because I have been able to write programs to accomplish tasks faster than my C programs could. At the same time, the Assembly versions took longer to write than the C versions did. This is the price I must pay to have high performing code.

Also, there are some bitwise instructions by the names of AND,OR,XOR,NOT,SHL,SHR that are sometimes useful for making programs faster and smaller. However, these only make sense in the context of the Binary Numeral System and I suspect that the average reader of this book does not have the 25 years of experience in Binary math that I do.

I will be explaining more about these operations in a later chapter because they help a lot when trying to optimize programs for size and speed. However they can make programming LOOK complicated and scare away potentially great new programmers who are just trying to learn to apply the 4 regular arithmetic operations of addition, subtraction, multiplication, and division which apply to all number bases.

# Chapter 5: To Be Written