
---
layout: default
title: Project 2
---

# Project 2: Event Counter

## 1. Introduction

The project idea is to create a de-bounced push button that can increment a counter. That counter will be displayed on a seven segment display.

<br>

Its purpose is to learn more about how displays and counters work within VHDL and FPGA programming

<br>

the Main objectives are:

 - Design and implement sequential circuits in VHDL, including modulo-M counters and button
    event counters.
- Implement using configurable frequency dividers with VHDL generic and generic map.
- Implement and test counter-based applications on the Basys3 FPGA board using push buttons
    and 7-segment displays.

## 2. Design

The system has 3 blocks
- A button debouncer
- A 4 bit counter
- A 4bit/hexadecimal to 7 segment display module

The button de-bouncer checks to make sure that the buttons output is stable for 2 million clock cycles (20 ms). This ensures that increment button will not be accidentally triggered.

<br>

The 4 bit counter increments by 1 each time the button is pressed eventually returning to zero once it has been pressed 16 times

<br> 

The hex to 7 segment display module converts the incoming 4 bit data into the appropriate 7 segment output. The display is active low so to show 0 on the display would be 1000000. Each bit corresponds to a specific
bar on the 7 segment unit. 

<br>

<img width="840" height="321" alt="image" src="https://github.com/user-attachments/assets/ab22d4d8-e232-4b5b-809f-30f2362a7b30" />

In the above display it can be seen how they all connect. The de-bounce unit takes in the button press, this is then filtered and sent to the counter. The output of the counter is the 4bit/hex which is then correctly adapted to display on the 7 segment. There are a few other outputs on the block diagram such as the leds and anode. Leds lights up the rightmost corresponding LEDS on the bays3 board. Anode selects the correct digit on the 7 segment by setting it to high, each bar within the display has a common anode.


## 3. Code

Explain the key sections of your VHDL code and how they implement the required functionality.

Starting from left to right on the block diagram

--button_debounce--

<br>

This code was provided to us but put simply it monitors the increment button for any changes. When a change is noticed a count begins, every clock cycle a count variable is incremented. When count reaches the 
```
STABLE_CYLES
```
constant on 2 million - 1 it has sufficiently confirmed that the changed was intended. At this point it outputs to modMcounter

<br>

--modMcounter--

<br>

ModMcounter uses a generic statement to set the counter to 4 bits. Then every time it takes in a pulse on the clk value it increments the counter

<br>

--hex_7seg--

<br>

This simply takes in a 4 bit value on hex digit then encodes it into 7 segment display. If the value is higher then 9 it turns off all bars within the display.

```
when "0000" =>
            seg <= "1000000";
        when "0001" =>
            seg <= "1111001";
        when "0010" =>
            seg <= "0100100";
```

<br>

above shows a sample of the encoding

<br>

--count_display--

<br>

This is the top level design which combines the above 3 segments. It port maps all the inputs and outputs for each module according to the block diagram. The increment button is de-bounced while the reset is not. 

<br>




Provide links to the relevant design files:

- **Design source:** [Link]
    [clk_div.vhd](source/project2/clk_div.vhd)
    [count_display](source/project2/count_display.vhd)
    [hex_7seg](source/project2/hex_7seg.vhd)
    [modMcounter](source/project2/modMcounter.vhd)
- **Testbench:** [Link]
    [count_display_TB](source/project2/count_display_TB.vhd)
    [modMcounter_tb](source/project2/modMcounter_tb.vhd)
- **Constraints (XDC):**
    [lab7.xdc](source/project2/lab7.xdc)

Include relevant code snippets where appropriate.

## 4. Simulation

<br>

Below is the first waveform simulation. This does not have the debounced button in and is just using the clk to increment. As can be seen the counter correctly increments from 0 to 15 (F)

<img width="521" height="549" alt="Screenshot 2026-09-27 202249" src="https://github.com/user-attachments/assets/d93fadae-91dc-40f5-a9f3-b1d4e99a22c3" />

I was unable to write a correct test bench for after the button de bounce file was added. It correctly ran and incremented on board 


## 5. Hardware

Include and discuss:

- **Elaborated design:** Schematic and explanation
  
<img width="584" height="193" alt="image" src="https://github.com/user-attachments/assets/a03ce7a2-f107-4656-8964-d1119a465dea" />

- **Implementation:** Implementation results and observations
  
 <br>

 <img width="539" height="892" alt="image" src="https://github.com/user-attachments/assets/12f4245d-fe4f-4a51-b709-653788dd64ee" />

 
- **Resource utilization:** FPGA resource usage

```
Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
---------------------------------------------------------------------------------------------------------------------
| Tool Version : Vivado v.2019.2.1 (win64) Build 2729669 Thu Dec  5 04:49:17 MST 2019
| Date         : Mon Oct 26 21:37:03 2026
| Host         : 4f22101fca2b403 running 64-bit major release  (build 9200)
| Command      : report_utilization -file count_display_utilization_synth.rpt -pb count_display_utilization_synth.pb
| Design       : count_display
| Device       : 7a35tcpg236-1
| Design State : Synthesized
---------------------------------------------------------------------------------------------------------------------

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
| Slice LUTs*             |   33 |     0 |     20800 |  0.16 |
|   LUT as Logic          |   33 |     0 |     20800 |  0.16 |
|   LUT as Memory         |    0 |     0 |      9600 |  0.00 |
| Slice Registers         |   28 |     0 |     41600 |  0.07 |
|   Register as Flip Flop |   28 |     0 |     41600 |  0.07 |
|   Register as Latch     |    0 |     0 |     41600 |  0.00 |
| F7 Muxes                |    0 |     0 |     16300 |  0.00 |
| F8 Muxes                |    0 |     0 |      8150 |  0.00 |
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
| 24    |          Yes |           - |        Reset |
| 0     |          Yes |         Set |            - |
| 4     |          Yes |       Reset |            - |
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
| Bonded IOB                  |   18 |     0 |       106 | 16.98 |
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
| FDCE     |   24 |        Flop & Latch |
| LUT6     |   23 |                 LUT |
| OBUF     |   15 |                  IO |
| LUT4     |   10 |                 LUT |
| CARRY4   |    5 |          CarryLogic |
| FDRE     |    4 |        Flop & Latch |
| IBUF     |    3 |                  IO |
| LUT3     |    2 |                 LUT |
| LUT5     |    1 |                 LUT |
| LUT2     |    1 |                 LUT |
| LUT1     |    1 |                 LUT |
| BUFG     |    1 |               Clock |
+----------+------+---------------------+
```
<br>

- **Hardware testing:** Observed behaviour on the Basys3 board compared with expected functionality

The circuit worked as expected as demonstrated in class. Thankfully not doing the test bench for the debounce circuit worked out



## 6. Reflection

I experienced a few issues during this implementation. Namely the test bench for the debounce portion. I was unsure what i was doing wrong but i couldn't get the TB to run properly. My lesson learned here would just be to spend more time working and trying to understand VHDL.

I learned more about how VHDL and FPGA boards are programmed with multiple blocks. The port mapping is still a little confusing to me, but its something I can work on.
