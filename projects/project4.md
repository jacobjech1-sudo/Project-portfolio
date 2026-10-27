
---
layout: default
title: Project 4
---

# Project 4: Digital Waveform Synthesizer

## 1. Introduction

The idea of the project is to build a wave form generator that is capable of generating Sine,Square and Triangle waves. It can be used to test filter response. 

Main objectives: 

- Generate waveform samples using lookup tables (ROM) and digital logic.
- Develop reusable designs using subprograms, libraries, and packages
- Design and implement a multi-waveform generator on FPGA
- Implement waveform selection using digital control inputs
- Output digital values through PMOD ports to external DAC and view the analog out signal

## 2. Design

So the system has 2 major parts. The wave_gen design file and the wave_package library

The wave_package library handles all the building of each wave type. It holds the table for each one.

<br>

The wave_gen design file is what actually chooses the wave type and pulls from its respective table. 

<br>

They connect through various function calls for each wavetype
```
sine_table,triangle_table,square_table
```

Include a labelled block diagram showing the system architecture.

## 3. Code

Explain the key sections of your VHDL code and how they implement the required functionality.

First I will start with the wave_package as its easier to explain the wave_gen file with that context.

--wave_package--

<br>

It starts with 4 constant declarations:

```
constant addr_bits : integer range 1 to 30 := 8;
    constant data_bits : integer range 1 to 31 := 8;
    subtype addr_range is integer range 0 to 2**addr_bits - 1;
    constant max_address: integer := 2**addr_bits - 1;
```
These define the amount of distinct values that the waveform will be built from. In this case there are 256 diffrent positions within each cycle

next are prototype function declarations

```
function sine_rom return ROM_type;
function triangle_rom return ROM_type;
function square_rom return ROM_type;
```
These allow the functions to be built later. They are all rom_type's which create read only memory within the FPGA board

Each function is structured in the same way and the only thing that changes is the way the data is processed

```
function square_rom return ROM_type is
          variable square_table : rom_type;
          variable angle : real;
          variable square_scaled : real;
    begin
         for i in addr_range loop
		    --4. write VHDL expression for angle, given by angle = i * (2 * PI/ 2 ^ addr_bits). Note that i must be typecast to real. 
                    --you can see the next statement below to get an idea of how to use the operations.
                    
                    angle := real(i) / (2.0**addr_bits);

              if angle < 0.5 then
                    square_scaled := 2.0**data_bits - 1.0;
             else
                    square_scaled := 0.0;

                end if;
                
                square_table(i) := to_unsigned(integer(round(square_scaled)), data_bits);
           end loop;
       return square_table;
    end ;
```

<br>

Above is the square wave function. There are three variables declared, one table rom_type and 2 real's. 

Next a for loop is created with the max value of addr_range. This means it will calculate a amplitude for each sample. 

within the for loop an calculated angle. This shows how far through the cycle you are. The sine function has a slightly altered line which i will explain later.

Then there is a little bit of logic to decide whether its in the first or second half of the cycle, for the square and triangle wave this is important. specifically for the square wave, If it is less then half way then the amplitude will be at its maximum value. If it is over half then it will be at its minimum.

finally each value is rounded, converted to an integer and placed in its respective table

<br>

The triangle wave is slightly different as under halfway through the value will be increasing and over half it will decrease as seen below

```
 if angle < 0.5 then
                    triangle_scaled := 2.0*angle* (2.0**data_bits - 1.0);
             else
                    triangle_scaled := (2.0 - 2.0 * angle) * (2.0**data_bits - 1.0);
```
<br>

The Sine wave is the most different as its current position through the cycle must be in radians.

<br>

```
angle := real(i)*(2.0 * MATH_PI / (2.0**addr_bits));
sin_scaled := (1.0 + sin(angle)) * (2.0**data_bits - 1.0) / 2.0;
```

<br>

<br>

--Wave_gen--

<br>

The wave gen file has multiple signals declared, one table and one vector for each wave type. An address signal to keep track of its progress through the cycle of a wave.
lastly a 2 bit selector to control which wave is currently selected (intuitive!)

<br>

```
signal addr: integer range 0 to max_address;
	  --2. declare a signal sine_table of type ROM_type
	  signal sine_table : ROM_type;
	  signal triangle_table : ROM_type;
	  signal square_table : ROM_type;
       
	   
      signal sine_vector: std_logic_vector(data_bits - 1 downto 0);
      signal triangle_vector: STD_LOGIC_VECTOR(data_bits - 1 downto 0);
      signal square_vector: STD_LOGIC_VECTOR(data_bits - 1 downto 0);
      signal selected : std_logic_vector(data_bits - 1 downto 0);
```

next each wave table is defined and stored

<br>

Now for the fun part. During every rising clk edge each wave vector pulls its amplitude from its table based on the current positon in the cycle (addr)

<br>

```
elsif (rising_edge (clock)) then
            if (enable = '1') then 
			    --4. sine_vector = the value in the "sine_table" at location "addr". Note data types must be matched between LHS and RHS
			    sine_vector <= STD_LOGIC_VECTOR(sine_table(addr));
			    triangle_vector <= STD_LOGIC_VECTOR(triangle_table(addr));
			    square_vector <= STD_LOGIC_VECTOR(square_table(addr));
```

After this the cycle position is increments (until it hits is max) 

<br>

Finally at the bottom is a process which handles the wave selection, this is based of the wave_sel 2 bit port

<br>

```
process (wave_sel, sine_vector, triangle_vector, square_vector)
    begin
    case wave_sel is
        when "00" => selected <= sine_vector;
        when "01" => selected <= triangle_vector;
        when "10" => selected <= square_vector;
        when others => selected <= (others => '0');
        
       end case;
       end process;
        wave_out <= selected;
       JA <= selected;
```

Provide links to the relevant design files:

- **Design source:** [Link]
- **Testbench:** [Link]
- **Constraints (XDC):** [Link]

Include relevant code snippets where appropriate.

## 4. Simulation



<img width="634" height="303" alt="image" src="https://github.com/user-attachments/assets/a8653087-f8c4-44ec-904d-2c31097ce5aa" />

I tested all 3 waves, it performed as expected (after much trial and error)


## 5. Hardware

- **Elaborated design:** Schematic and explanation
- <img width="968" height="298" alt="image" src="https://github.com/user-attachments/assets/480d90d8-bd67-4f90-b776-f6b4e59e2910" />

- **Synthesized design:** Schematic and explanation

- <img width="551" height="888" alt="image" src="https://github.com/user-attachments/assets/7c1905b0-5e59-4623-bae7-3cd32801a0cf" />

- 
- **Implementation:** Implementation results and observations

<img width="568" height="896" alt="image" src="https://github.com/user-attachments/assets/48c9c2e5-94f8-4315-8814-bcd2c7fdb324" />


- **Resource utilization:** FPGA resource usage

```
Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
---------------------------------------------------------------------------------------------------------
| Tool Version : Vivado v.2019.2.1 (win64) Build 2729669 Thu Dec  5 04:49:17 MST 2019
| Date         : Mon Oct 26 23:57:58 2026
| Host         : 4f22101fca2b403 running 64-bit major release  (build 9200)
| Command      : report_utilization -file wavegen_utilization_synth.rpt -pb wavegen_utilization_synth.pb
| Design       : wavegen
| Device       : 7a35tcpg236-1
| Design State : Synthesized
---------------------------------------------------------------------------------------------------------

Utilization Design Information

Table of Contents
-----------------
1. Slice Logic
1.1 Summary of Registers by Type
2. Memory
3. DSP
4. IO and GT Specific
5. Clocking
6. Specific Feature
7. Primitives
8. Black Boxes
9. Instantiated Netlists

1. Slice Logic
--------------

+-------------------------+------+-------+-----------+-------+
|        Site Type        | Used | Fixed | Available | Util% |
+-------------------------+------+-------+-----------+-------+
| Slice LUTs*             |   52 |     0 |     20800 |  0.25 |
|   LUT as Logic          |   52 |     0 |     20800 |  0.25 |
|   LUT as Memory         |    0 |     0 |      9600 |  0.00 |
| Slice Registers         |   42 |     0 |     41600 |  0.10 |
|   Register as Flip Flop |   42 |     0 |     41600 |  0.10 |
|   Register as Latch     |    0 |     0 |     41600 |  0.00 |
| F7 Muxes                |   12 |     0 |     16300 |  0.07 |
| F8 Muxes                |    6 |     0 |      8150 |  0.07 |
+-------------------------+------+-------+-----------+-------+
* Warning! The Final LUT count, after physical optimizations and full implementation, is typically lower. Run opt_design after synthesis, if not already completed, for a more realistic count.


1.1 Summary of Registers by Type
--------------------------------

+-------+--------------+-------------+--------------+
| Total | Clock Enable | Synchronous | Asynchronous |
+-------+--------------+-------------+--------------+
| 0     |            _ |           - |            - |
| 0     |            _ |           - |          Set |
| 0     |            _ |           - |        Reset |
| 0     |            _ |         Set |            - |
| 0     |            _ |       Reset |            - |
| 0     |          Yes |           - |            - |
| 0     |          Yes |           - |          Set |
| 42    |          Yes |           - |        Reset |
| 0     |          Yes |         Set |            - |
| 0     |          Yes |       Reset |            - |
+-------+--------------+-------------+--------------+


2. Memory
---------

+----------------+------+-------+-----------+-------+
|    Site Type   | Used | Fixed | Available | Util% |
+----------------+------+-------+-----------+-------+
| Block RAM Tile |    0 |     0 |        50 |  0.00 |
|   RAMB36/FIFO* |    0 |     0 |        50 |  0.00 |
|   RAMB18       |    0 |     0 |       100 |  0.00 |
+----------------+------+-------+-----------+-------+
* Note: Each Block RAM Tile only has one FIFO logic available and therefore can accommodate only one FIFO36E1 or one FIFO18E1. However, if a FIFO18E1 occupies a Block RAM Tile, that tile can still accommodate a RAMB18E1


3. DSP
------

+-----------+------+-------+-----------+-------+
| Site Type | Used | Fixed | Available | Util% |
+-----------+------+-------+-----------+-------+
| DSPs      |    0 |     0 |        90 |  0.00 |
+-----------+------+-------+-----------+-------+


4. IO and GT Specific
---------------------

+-----------------------------+------+-------+-----------+-------+
|          Site Type          | Used | Fixed | Available | Util% |
+-----------------------------+------+-------+-----------+-------+
| Bonded IOB                  |   21 |     0 |       106 | 19.81 |
| Bonded IPADs                |    0 |     0 |        10 |  0.00 |
| Bonded OPADs                |    0 |     0 |         4 |  0.00 |
| PHY_CONTROL                 |    0 |     0 |         5 |  0.00 |
| PHASER_REF                  |    0 |     0 |         5 |  0.00 |
| OUT_FIFO                    |    0 |     0 |        20 |  0.00 |
| IN_FIFO                     |    0 |     0 |        20 |  0.00 |
| IDELAYCTRL                  |    0 |     0 |         5 |  0.00 |
| IBUFDS                      |    0 |     0 |       104 |  0.00 |
| GTPE2_CHANNEL               |    0 |     0 |         2 |  0.00 |
| PHASER_OUT/PHASER_OUT_PHY   |    0 |     0 |        20 |  0.00 |
| PHASER_IN/PHASER_IN_PHY     |    0 |     0 |        20 |  0.00 |
| IDELAYE2/IDELAYE2_FINEDELAY |    0 |     0 |       250 |  0.00 |
| IBUFDS_GTE2                 |    0 |     0 |         2 |  0.00 |
| ILOGIC                      |    0 |     0 |       106 |  0.00 |
| OLOGIC                      |    0 |     0 |       106 |  0.00 |
+-----------------------------+------+-------+-----------+-------+


5. Clocking
-----------

+------------+------+-------+-----------+-------+
|  Site Type | Used | Fixed | Available | Util% |
+------------+------+-------+-----------+-------+
| BUFGCTRL   |    1 |     0 |        32 |  3.13 |
| BUFIO      |    0 |     0 |        20 |  0.00 |
| MMCME2_ADV |    0 |     0 |         5 |  0.00 |
| PLLE2_ADV  |    0 |     0 |         5 |  0.00 |
| BUFMRCE    |    0 |     0 |        10 |  0.00 |
| BUFHCE     |    0 |     0 |        72 |  0.00 |
| BUFR       |    0 |     0 |        20 |  0.00 |
+------------+------+-------+-----------+-------+


6. Specific Feature
-------------------

+-------------+------+-------+-----------+-------+
|  Site Type  | Used | Fixed | Available | Util% |
+-------------+------+-------+-----------+-------+
| BSCANE2     |    0 |     0 |         4 |  0.00 |
| CAPTUREE2   |    0 |     0 |         1 |  0.00 |
| DNA_PORT    |    0 |     0 |         1 |  0.00 |
| EFUSE_USR   |    0 |     0 |         1 |  0.00 |
| FRAME_ECCE2 |    0 |     0 |         1 |  0.00 |
| ICAPE2      |    0 |     0 |         2 |  0.00 |
| PCIE_2_1    |    0 |     0 |         1 |  0.00 |
| STARTUPE2   |    0 |     0 |         1 |  0.00 |
| XADC        |    0 |     0 |         1 |  0.00 |
+-------------+------+-------+-----------+-------+


7. Primitives
-------------

+----------+------+---------------------+
| Ref Name | Used | Functional Category |
+----------+------+---------------------+
| FDCE     |   42 |        Flop & Latch |
| LUT6     |   32 |                 LUT |
| OBUF     |   16 |                  IO |
| LUT5     |   13 |                 LUT |
| MUXF7    |   12 |               MuxFx |
| MUXF8    |    6 |               MuxFx |
| LUT4     |    6 |                 LUT |
| IBUF     |    5 |                  IO |
| LUT3     |    3 |                 LUT |
| LUT2     |    2 |                 LUT |
| LUT1     |    2 |                 LUT |
| BUFG     |    1 |               Clock |
+----------+------+---------------------+
```

- **Hardware testing:** Observed behaviour on the Basys3 board compared with expected functionality

I unfortunately never got the chance to test it in class but i believe it would've worked perfectly

## 6. Reflection

Discuss:

I experienced a lot of issues during this project. It mostly revolved around the spider web of wave signal types and tables. I had to incrementally test a few dozen times after i finished the code as i kept changing one file and not updating the other correctly.

I learned just how much blood sweat and tears goes into FPGA programming. I Also learned a lot about how digital wave forms are generated, It makes sense that its done via lookup tables, just not how i expected. In addition I learned about programming libraries

This is very closely connected to all my classes as being able to generate and manipulate wave forms is critical to so many fields. 
