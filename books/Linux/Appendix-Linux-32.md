# Appendix of System Calls for Linux 32-bit

Although the Linux kernel has hundreds of system calls, every program in my book: Assembly Arithmetic Algorithms for Linux uses only 6 of them. This appendix or reference is designed for quick searching while writing new assembly programs and for deeper understanding about these calls.

For convenience, I have repeated the table from chapter 11 of the 32-bit Linux edition.

|Number|Name |eax |ebx     |ecx   |edx   |
|------|-----|----|--------|------|------|
|1     |exit |0x01|status  |      |      |
|3     |read |0x03|fd      |buf   |count |
|4     |write|0x04|fd      |buf   |count |
|5     |open |0x05|filename|flags |mode  |
|6     |close|0x06|fd      |      |      |
|19    |lseek|0x13|fd      |offset|whence|

