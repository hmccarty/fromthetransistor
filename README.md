# From transistor to the web

Decided to explore George's famous [ttow curriculum](https://github.com/geohot/fromthetransistor).

## Section 1

### The Transistor

Much like the cell is to life, the transistor is the basic building block of computation.

Transistors can either act as a switch or amplifier.

The majority of modern transistors are MOSFETs(metal oxide semiconductor field effect transistors). They have three contact points: source, gate and drain.

As a switch, current applied through the gate allows current to flow from the source to the drain:

![MOSFET](/assets/MOSFET.png)

From its application as a switch, we can see how simple logic gates can be built:

![AND Gate](/assets/AND-Gate.png)

![OR Gate](/assets/OR-Gate.png)

### FPGA (Field Programmable Gate Array)

FPGAs are ICs capable of being configured "in the field".

They are often comprised of logic blocks, which contain:
- Two 3-input LUTs
- Full adder
- D-type flip-flop

This is shown graphically:

![FPGA Cell](/assets/FPGA-Cell.png)

### FPGA Components

LUTs (a.k.a. lookup tables) are essentially truth tables. They are implemented using a LUT-mask, describe combinatorial logic using bits stored in SRAM.

An example of a 4-input LUT is shown below:
![LUT circuit](/assets/LUT-circuit.png)

As you can see above, FPGA's essentially implement a 4-input LUT using two 3-input LUTs.

To understand how the LUT-mask is stored, lets look at SRAM.

SRAM (Static Random-Access Memory) is volatile memory that uses latches to store bits. SRAM is often used as a computer's main cache.

SRAM is comprised of cells which store individual bits. Cells can be made using 6 MOSFETS:

![SRAM-Cell](/assets/SRAM-Cell.png)

While WL (word line) is 0, the cell will act in standby mode. Preserving whatever previous bit was asserted.

When WL is 1, the cell can be read by measuring BL or changed by asserting BL and BL'. In practice parasitic capacitance makes it hard to read directly from BL, so instead a difference between BL and BL' are measured.

A FA (full adder) circuit implements binary addition, while accounting for carry-in and carry-out.

The circuit is as shown below:

![FULL-Adder](/assets/FULL-Adder.png)

The truth table for a full adder is:

![FULL-Adder-TT](/assets/FULL-Adder-TT.png)

DFFs (D-Type Flip Flop) are often known as data or delay flip-flops. They work by outputting (Q) the input bit (D) on the clock's next rising edge (CLK).

### FPGA Logic Cell Function

An FPGA logic cell can be configured using internal MUXs. The middle MUX can decide whether to sum the 3-input LUT outputs or use the 4-input LUT output. The right MUX can then decide whether the logic cell acts synchronously or asynchronously.  

The overall behaviour of an FPGA is determined using an HDL (hardware description language), such as Verilog.

### Emulating an FPGA

We'll be emulating an FPGA using Verilator, which converts Verilog to C++.

We can install Verilator using `apt-get`:
```
sudo apt-get update
sudo apt-get install verilator
```

## Section 2

### Blinking an LED
```
verilator -Wall --cc --exe --build main.cpp led.v
```

### UART
```
verilator -Wall --cc --exe --trace --build main.cpp led.v
```