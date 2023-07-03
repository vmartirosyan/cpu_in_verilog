# cpu_in_verilog
An 8-bit CPU design in Verilog.

The CPU has 6 8-bit GPRs - r0 - r5, one 8-bit input port, one 8-bit output port and a program counter.

The CPU supports 4 types of operations with the following instruction prefix:

 - Immediates - prefix 00
 - Copy data  - prefix 01
 - ALU ops    - prefix 10
 - Conditions - prefix 11

The rest of the instruction is interpreted based on the prefix.

Immediate - loads the remaining 6 bits of the instruction into the r0 register: r0 <= instruction[5:0];
    Example: 00_001000 - loads the value 8 into r0 register.
    
Copy instruction - instruction bits [5:3] represent the source, and bits [2:0] represent the destination address according to the following scheme:
    000 - r0
    001 - r1
    010 - r2
    011 - r3
    100 - r4
    101 - r5
    110 - not used // no direct copy from/to progam counter is supported
    111 - in/out depending on src/dst position.

    Example: 01_001_111 - copies the value of r1 to output port.

ALU instruction - instruction bits [2:0] represent the ALU operation to be executed on r1 and r2 according to the following scheme. The result is stored in r3.

    000 - Addition
    001 - Subtruction
    010 - Logical And
    011 - Logical Or
    100 - Logical XOr
    101 - Logical Not (on first operand).

    Example: 10_000010 - calculates the logical And operation on r1 and r2 and stores the result to r3.

Conditional instruction - instruction bits [2:0] represent the condition to be checked on r3. If the condition is true, then the value of program counter will be overwritten by the value of r0. Here are the conditions with their codes:

    000 - Equal to 0
    001 - Not equal to 0
    010 - Greater than 0
    011 - Less than 0
    100 - Greater or equal to 0
    101 - Less than or equal to 0
    110 - Always true
    111 - Always false

    Example: 11_000_100 - checks if r3 is greater or equal to 0.
