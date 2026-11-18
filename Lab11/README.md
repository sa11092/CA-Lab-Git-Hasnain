# Open Ended Lab 11

## Task 1 · PC datapath

Use ProgramCounter.v, pcAdder.v, branchAdder.v, mux2.v, and immGen.v from
design/. Set tb_PCDatapath as the simulation top. The testbench drives
PCSrc externally to exercise both mux paths. Expected PC values are
0 → 4 → 8 → 4 → 12.

The PC stores a byte address, so sequential execution adds 4. immGen
already appends the implicit zero bit when constructing the signed B-type
byte offset. branchAdder computes PC + imm.

## Task 2 · Single-cycle processor

Add all design/*.v files and lab11.mem as Vivado design sources. Add
sim/*.v as simulation sources. Select tb_TopLevelProcessor as the simulation
top and run until completion. Set TopLevelProcessor as the synthesis top.

Instruction memory expects one 32-bit hexadecimal word per line. Byte
address 0 selects line 1, address 4 selects line 2, and so on. Both memories
cover 256 bytes, with aligned word accesses. Load from a location only
after it has been written. The register file resets to zero and x0 stays zero.

Implemented instructions are ADD, SUB, AND, OR, XOR, SLL, SRL, ADDI, LW,
SW, and BEQ. The control unit decodes BEQ and the ALU subtracts the two
register operands. PCSrc is asserted when both branch and zero are high.
PC 24 is skipped when the branch at PC 20 is taken.

| Byte PC | Instruction | Effect |
| --- | --- | --- |
| 0 | addi x1, x0, 5 | x1 = 5 |
| 4 | sw x1, 0(x0) | Memory at byte address 0 = 5 |
| 8 | lw x2, 0(x0) | x2 = 5 |
| 12 | addi x0, x0, 1 | x0 stays zero |
| 16 | beq x2, x0, +8 | Continues to PC 20 |
| 20 | beq x1, x2, +8 | Jumps to PC 28 |
| 24 | addi x1, x0, 99 | Skipped |
| 28 | add x3, x1, x2 | x3 = 10 |
| 32 | addi x0, x0, 0 | Continues to PC 36 |
| 36 | beq x0, x0, -4 | Loops back to PC 32 |

### Basys 3

For the switch-sum demo, also add board/FPGA_Top.v and switch_sum.mem as
design sources, and board/Basys3.xdc as a constraints source. Select the
Basys 3 board (or part xc7a35tcpg236-1) and set FPGA_Top as synthesis top.
Use tb_FPGA_Top to simulate the demo at an accelerated step rate.

Press and release BTNC to restart. The processor reads SW7–SW0 at byte
address 0x100 and SW15–SW8 at 0x104, adds them, and displays the sum in
binary on the LEDs. For example, SW0 and SW8 set the input bytes to 1
and 1 and light LD1 after the first update. The sum is latched when x3
is written. Hold switches steady for a full loop to read a new sum.
The processor uses a clock enable at four instructions per second while
all registers remain on the 100 MHz board clock.

The board demo follows the hardware interface in the supplied reference
project. TopLevelProcessor still exposes the worksheet's current_pc.

### Simulation from the command line

Run from this directory with Icarus Verilog installed so that the ROM
initializer can find lab11.mem.

```sh
iverilog -g2012 -s tb_PCDatapath -o task1 design/*.v sim/tb_PCDatapath.v
vvp task1
iverilog -g2012 -s tb_TopLevelProcessor -o task2 design/*.v sim/tb_TopLevelProcessor.v
vvp task2
```

To simulate the board demo from this directory:

```sh
iverilog -g2012 -s tb_FPGA_Top -o board_sim design/*.v board/FPGA_Top.v sim/tb_FPGA_Top.v
vvp board_sim
```
