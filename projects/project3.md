
---
layout: default
title: Project 3
---

# Project 3: Stepper Motor Control
## 1. Introduction


The project idea is to create a stepper motor controller, Its purpose is to control a stepper motor and reverse its direction

The main objectives are:

- Design a controller for a stepper motor with direction control
- Apply finite state machine (FSM) technique to generate step pulses
- Gain familiarity with interfacing FPGA with external circuit through the PMOD connectors
- Understand the basic operation of stepper motor and drive sequences


## 2. Design

The system is designed off a mealy FSM. The Bays3 board interfaces with a ULN2003 to convert the low power logic inputs to higher power pulses which activate the motors windings in the correct sequence. 

<img width="589" height="273" alt="image" src="https://github.com/user-attachments/assets/1ef2cb9d-d1a1-4a40-8cd1-a2c51db1802c" />

The system has 2 major blocks. First A clock divider to convert the Bays3 internal clock to 500Hz and a stepper motor control block which pulses the 4 outputs to the motor in a sequence. It is all port mapped inside a top module called Stepper_Controller

<img width="672" height="214" alt="image" src="https://github.com/user-attachments/assets/8b2112e9-1c1b-41f1-a5f8-ccb5530e6297" />


## 3. Code

--Stepper Motor FSM--

The output is a 4 bit logic vector which outputs "0000", "0001", "0010", "0100", "1000" depending on which state its in (s0 to s05 respectively)

First there are 4 inputs:
  slow_clk - which controls the frequency of the motor
  reset - resets the controller
  en - enables and disables the controller putting it back into a base state (s0)
  dir - controls the direction of the motor by flipping the order of the states 

<br>

The "next state" process first checks for a rising edge on the clk, then verifies that en is high and checks the direction
After which, based on the Moore FSM it checks which state its in then assigns the next logical state. S1 -> S2 -> S3 etc 

```vhdl
IF clk'EVENT AND clk = '1' THEN
            IF en = '1' AND dir = '1' THEN --Clockwise steps
                case state is
                    when s0 => state <= s1;
                    when s1 => state <= s2;
                    when s2 => state <= s3;
                    when s3 => state <= s4;
                    when s4 => state <= s1;
                    when others => state <= s0;
                 end case;
```

There is also the output selector. This piece of code checks which state its in and assigns the correct output to Q (the output)

```vhdl
q <= "0001" when s1,
         "0010" when s2,
         "0100" when s3,
         "1000" when s4,
         "0000" when others;
```



--stepper_motor_FSM_TB--

The testbench is very simple. It port maps the inputs, flips the clk every 10 microseconds. 
It then sets en high and dir high and then waits 1 ms before flipping the direction

<br>

--clk_div--

Divides the internal clock frequency to a more usable speed

<br>

--constraints_m--
uses the V17 and V16 switches for dir and en respectively

uses button u18 for the reset

uses J1-4 as the outputs to the ULN2003

<br>

--Stepper_controller--

Port maps the Clk_div and Stepper_motor_FSM so that the work together
  

Provide links to the relevant design files:

stepper_motor_FSM.VHD 

- **Design source:** [Link]
    [stepper_motor_FSM.VHD](source/project3/stepper_motor_FSM.VHD)
- **Testbench:** [Link]
    [stepper_motor_FSM_tb.vhd](source/project3/stepper_motor_FSM_tb.vhd)


## 4. Simulation

- <img width="1053" height="267" alt="wave form" src="https://github.com/user-attachments/assets/baaa16a9-fd00-4fd4-bf54-1395379ce134" />

For this simulation the stepper motor sequence and direction change was tested. It behaved as expected with the sequence order reversing when the "dir" input flips as seen at 8.985 ms


## 5. Hardware

- **Elaborated design:**
  <img width="1203" height="414" alt="motor elaborated design" src="https://github.com/user-attachments/assets/d4e6502b-00a4-495b-b7ce-bf89724e4b66" />


## 6. Reflection

I unfortunately did not get past The elaborated design as I ran out of time and had to start working on the next project. I had created the Stepper_controller file but lost it somewhere along the way, i believe
i forgot to save it to the project file when I was closing this out for the last time. 

<br>

I had a few technical issues such as getting the clock timing wrong in my first test bench file. I found I was incorrectly setting the clock leading to the states not changing. I also had set up the "next state" port of the FSM file wrong leading to the incorrect sequence running. This was a simple fix however as i just double checked my code and adjusted the states.

<br> 

I gained knowledge on how to program state machines which came in handy on our design project. The state->next state is an interesting concept that i had fun implementing. I also learned a lot of about state machines and how to program a mealy vs moore design
