# Project 1: Car Seat Belt Warning Light

## 1. Introduction

The project idea is to create a car seat belt alarm 

<br>

Its purpose is to get a full introduction to all the systems and ideas involved in programming and FPGA device from start to finish.

<br>

the Main objectives are:

- Design a digital logic circuit for a car seat belt alarm using a traditional design approach
- execute the steps in the Xilinx Vivado design flow to implement the same circuit on FPGA

## 2. Design

The system consists of a single block of logic that turns on the light based on 4 different inputs

<br>

inputs
- Door closed
- Key in
- Person on seat
- Seat belt fastened

<br>

based on the four inputs there are 5 conditions where the warning light should be lit up

<br>

<img width="367" height="192" alt="image" src="https://github.com/user-attachments/assets/c4c78e19-b6ca-4b79-8547-c5281d884df9" />

In the above each row represents a set of specific inputs where the warning light will be on

<br>

The full truth table can be seen below

<br>

<img width="629" height="552" alt="image" src="https://github.com/user-attachments/assets/6103577d-f802-4522-9ea1-f878560d4b75" />

<br>

based on this we can create a boolean function for the output and use a Karanough map to reduce it

<br>

*for the boolean function short hands will be used to improve readability
Door closed = D
Key in = K
Person in seat = P
Seat belt fastened = S

Warning light = K + KS + KP + KPS + DKP

<br>

this can be reduce using the below Karnaugh map

<br>

<img width="263" height="234" alt="image" src="https://github.com/user-attachments/assets/c83c2281-7b7a-4967-87b3-fe9ab432180a" />

<br>

From the above we can reduce the function down to:

<br>
Warning light = D'K + KPS'

<br>

Which can be further reduced to:

<br>

Warning light = K(D' + PS')


## 6. Reflection

Unfortunately I had lost the code that i wrote for the project so everything past the design was a non-starter

I definitely got a refresher on truth tables and Karnaugh maps. Prior to losing my code i also got a introduction on how to write VHDL and how to select the correct ports in the .XDC file.
