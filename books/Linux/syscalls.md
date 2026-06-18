## 32-bit Intel System Calls for Linux

|Number|Name |ebx     |ecx   |edx   |
|------|-----|--------|------|------|
|1     |exit |status  |      |      |
|3     |read |fd      |buf   |count |
|4     |write|fd      |buf   |count |
|5     |open |filename|flags |mode  |
|6     |close|fd      |      |      |
|19    |lseek|fd      |offset|whence|

**status** for exit call is a byte number from 0 to 255 to be returned to the operating system. Shell scripts use this to know if something went wrong when running the program. By convention, a return of 0 means no errors happened.

**fd** refers to a number which is used as a file descriptor. fd 0 is stdin and fd 1 is stdout. Other file descriptors are returned from an open call. Any fd is returned in the eax register in Assembly language. This same fd must be saved somewhere and used whenever you want to read, write, close, or lseek using the file you opened.

**buf** refers to pointer which will be read into with a read call or written from using a write call.

**count** refers to how many bytes are going to be read or written with the read or write calls.

### Values for the flags argument to open.

- O_RDONLY	     00
- O_WRONLY	     01
- O_RDWR		     02
- O_CREAT	   0100

**offset** is the address you want to go to in the file. It is used in the lseek call and depends on the **whence** argument

### Values for the WHENCE argument to lseek.  

- SEEK_SET 0 Seek from beginning of file.
- SEEK_CUR 1 Seek from current position.
- SEEK_END 2 Seek from end of file.