A 32-bit CPU design in Verilog.

The CPU has 15x32-bit GPRs - r0:r14, one 32-bit Input port, one 32-bit Output port and a program counter.

Instruction bits:
    Byte 3:
        31    - Indicates that Src1 is an immediate value
        30    - Indicates that Src2 is an immediate value
        29    - Reserved for future use
        28    - Reserved for future use
        27    - 0:ALU operation, 1:Conditional branch
        26:24 - ALU or conditional operation

    Byte 2:
        23:16 - Src1
    Byte 1:
        15:8  - Src2
    Byte 0:
        7:0   - Dst (In case of a conditional jump this is the register number which contains destinatin address)

The CPU supports 2 types of operations : ALU operations and conditional branches. Loading immediates and opying data around is done using ALU instructions.

ALU instruction - instruction bits [26:24] represent the ALU operation to be executed on Src1 and Src2 according to the following scheme. The result is stored in Dst.

    000 - Addition
    001 - Subtruction
    010 - Logical And
    011 - Logical Or
    100 - Logical XOr
    101 - Logical Not (on first operand).

    Example: 0000_0010_0000_0100_0000_0010_0000_0111 - calculates the logical And operation on r4 and r2 and stores the result to r7.

Conditional branching - instruction bits [26:24] represent the condition to be checked on Src1 and Src2. If the condition is true, then the value of program counter will be overwritten by the value of Dst. Here are the conditions with their codes:

    000 - Equal to 
    001 - Not equal to 
    010 - Greater than 
    011 - Less than 
    100 - Greater or equal to 
    101 - Less than or equal to 
    110 - Always true
    111 - Always false

    Example: 0000_1010_0000_0100_0000_0010_0000_0111 - checks if r4 is greater or equal to r2. In case of success, the program counter will be overwritten by the address stored in r7.

If the Src1, Src2 or Dst is a register, then values 0-14 correspond to the register number. A value of 0x0F corresponds to Input/Output port. 