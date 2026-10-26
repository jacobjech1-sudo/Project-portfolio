
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

Explain the overall system design, including the major functional blocks and how they interact.

The system is designed off a mealy FSM. The Bays3 board interfaces with a ULN2003 to convert the low power logic inputs to higher power pulses which activate the motors windings in the correct sequence. 

<img width="589" height="273" alt="image" src="https://github.com/user-attachments/assets/1ef2cb9d-d1a1-4a40-8cd1-a2c51db1802c" />

The system has 2 major blocks. First A clock divider to convert the Bays3 internal clock to 500Hz and a stepper motor control block which pulses the 4 outputs to the motor in a sequence. It is all port mapped inside a top module called Stepper_Controller

<img width="672" height="214" alt="image" src="https://github.com/user-attachments/assets/8b2112e9-1c1b-41f1-a5f8-ccb5530e6297" />


## 3. Code

Explain the key sections of your VHDL code and how they implement the required functionality.

--Stepper Motor FSM--

The output is a 4 bit logic vector which outputs "0000", "0001", "0010", "0100", "1000" depending on which state its in (s0 to s05 respectively)

First there are 4 inputs:
  slow_clk - which controls the frequency of the motor
  reset - resets the controller
  en - enables and disables the controller putting it back into a base state (s0)
  dir - controls the direction of the motor by flipping the order of the states 

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

--clk_div--

Divides the internal clock frequency to a more usable speed

--constraints_m--
uses the V17 and V16 switches for dir and en respectively

uses button u18 for the reset

uses J1-4 as the outputs to the ULN2003

--Stepper_controller--

Port maps the Clk_div and Stepper_motor_FSM so that the work together
  

Provide links to the relevant design files:

stepper_motor_FSM.VHD 

- **Design source:** [Link]
- **Testbench:** [Link]
- **Constraints (XDC):** [Link]



## 4. Simulation

- <img width="1053" height="267" alt="wave form" src="https://github.com/user-attachments/assets/baaa16a9-fd00-4fd4-bf54-1395379ce134" />

For this simulation the stepper motor sequence and direction change was tested. It behaved as expected with the sequence order reversing when the "dir" input flips as seen at 8.985 ms


## 5. Hardware

Include and discuss:

- **Elaborated design:** Schematic and explanation
- **Synthesized design:** Schematic and explanation
- **Implementation:** Implementation results and observations
- **Resource utilization:** FPGA resource usage
- **Hardware testing:** Observed behaviour on the Basys3 board compared with expected functionality

Include screenshots, tables, or photographs where appropriate.

## 6. Reflection

Discuss:

- Technical challenges encountered and how they were resolved
- What you learned from the project
- How the work relates to digital design concepts and theory covered in the course
