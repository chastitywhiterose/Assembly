# Chastity's Linux System Call Table

The following tables show the main 6 system calls that all of my programs use. 32 bit calls are accessed with "int 0x80" to call the kernel with an interrupt. 64 bit calls are accessed with the "syscall" instruction. As long as you load the right data into the registers described, you can use these calls for useful programs.

## 32-bit Intel System Calls for Linux

|Number|Name |eax |ebx     |ecx   |edx   |
|------|-----|----|--------|------|------|
|1     |exit |0x01|status  |      |      |
|3     |read |0x03|fd      |buf   |count |
|4     |write|0x04|fd      |buf   |count |
|5     |open |0x05|filename|flags |mode  |
|6     |close|0x06|fd      |      |      |
|19    |lseek|0x13|fd      |offset|whence|

## 64-bit Intel System Calls for Linux

|Number|Name |rax |rdi     |rsi   |rdx   |
|------|-----|----|--------|------|------|
|60    |exit |0x3C|status  |      |      |
|0     |read |0x00|fd      |buf   |count |
|1     |write|0x01|fd      |buf   |count |
|2     |open |0x02|filename|flags |mode  |
|3     |close|0x03|fd      |      |      |
|8     |lseek|0x13|fd      |offset|whence|

The following names for the arguments are based on the Linux manual pages for those system calls. You can access the same from any Linux distro. For example, "man 2 write" will show the C function signature for the write call.

**status** for exit call is a byte number from 0 to 255 to be returned to the operating system. Shell scripts use this to know if something went wrong when running the program. By convention, a return of 0 means no errors happened.

**fd** refers to a number which is used as a file descriptor. fd 0 is stdin and fd 1 is stdout. Other file descriptors are returned from an open call. Any fd is returned in the eax register in Assembly language. This same fd must be saved somewhere and used whenever you want to read, write, close, or lseek using the file you opened.

**buf** refers to pointer which will be read into with a read call or written from using a write call.

**count** refers to how many bytes are going to be read or written with the read or write calls.

### Values for the flags argument to open.

- O_RDONLY	     00
- O_WRONLY	     01
- O_RDWR		     02
- O_CREAT	   0100

### Values for the mode argument to open.

- S_IRWXU 00700 user (file owner) has read, write, and execute permission
- S_IRUSR 00400 user has read permission

- S_IWUSR 00200 user has write permission

- S_IXUSR 00100 user has execute permission
- S_IRWXG 00070 group has read, write, and execute permission

- S_IRGRP 00040 group has read permission

- S_IWGRP 00020 group has write permission

- S_IXGRP 00010 group has execute permission

- S_IRWXO 00007 others have read, write, and execute permission

- S_IROTH 00004 others have read permission

- S_IWOTH 00002 others have write permission

- S_IXOTH 00001 others have execute permission


**offset** is the address you want to go to in the file. It is used in the lseek call and depends on the **whence** argument

### Values for the WHENCE argument to lseek.  

- SEEK_SET 0 Seek from beginning of file.
- SEEK_CUR 1 Seek from current position.
- SEEK_END 2 Seek from end of file.

Numbers used for file flags or modes are prefixed with zeros because they are octal constants and this is how they are represented in the C Programming Language. However, in Assembly, you need to look up your Assembler's rules for octal constants. For example, in FASM, they must end with the letter 'o'.