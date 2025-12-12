# **MIPS32 5-Stage Pipelined Processor (Verilog)**

This repository contains the Verilog implementation of a MIPS32 5-stage pipelined processor along with a complete testbench. The design includes all major pipeline stages:

* Instruction Fetch (IF)

* Instruction Decode (ID)

* Execute (EX)

* Memory Access (MEM)

* Write Back (WB)

The project also includes memory initialization, register file setup, branch handling, and HALT instruction support.

## **Features**

**5-stage pipelined architecture**

* Supports ALU, immediate, load/store, branch, and halt instructions

* Dual-phase clocking (clk1, clk2)

* Pipeline registers for every stage

* Testbench included with memory preload

* Debug print for PC, instruction, and register values

* Program halts on HLT instruction

## **Supported Instructions**
**R-Type**

ADD, SUB, AND, OR, SLT, MUL

**I-Type**

ADDI, SUBI, SLTI

**Load/Store**

LW, SW

**Branch**

BEQZ, BNEQZ

**System**

HLT

## Pipeline Registers

| Stage    | Registers                                                   |
|----------|-------------------------------------------------------------|
| IF → ID  | IF_ID_IR, IF_ID_NPC                                         |
| ID → EX  | ID_EX_IR, ID_EX_A, ID_EX_B, ID_EX_Imm, ID_EX_type           |
| EX → MEM | EX_MEM_IR, EX_MEM_ALUOut, EX_MEM_B, EX_MEM_type             |
| MEM → WB | MEM_WB_IR, MEM_WB_ALUOut, MEM_WB_LMD, MEM_WB_type           |


## **Test Program Loaded in Memory**

The testbench loads the following instructions:

| Address | Instruction         | Description      |
|---------|----------------------|------------------|
| 0       | ADDI R1, R0, 10      | R1 = 10          |
| 1       | ADDI R2, R0, 20      | R2 = 20          |
| 2       | ADDI R3, R0, 25      | R3 = 25          |
| 3       | NOP                  | Pipeline delay   |
| 4       | NOP                  | Pipeline delay   |
| 5       | ADD R4, R1, R2       | R4 = 30          |
| 6       | NOP                  | Delay            |
| 7       | NOP                  | Delay            |
| 8       | ADD R5, R4, R3       | R5 = 55          |
| 9       | HLT                  | Stop execution   |

## Expected Final Register Values

| Register | Value |
|----------|--------|
| R1       | 10     |
| R2       | 20     |
| R3       | 25     |
| R4       | 30     |
| R5       | 55     |


The testbench prints TEST PASSED when the results match.


## **Future Improvements**

* Hazard detection unit

* Forwarding unit

* Separate instruction and data memory

* Cache modeling

* More MIPS instruction support
