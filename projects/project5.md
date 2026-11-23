# Project 5 – Embedded Systems – Audio Project

**Application:** [Application name]  
**Group members:** Laith Karmout
**Microcontroller:** RP2040  

## Project Overview
We have chosen to add a reverb component to our audio project. Reverb is a lingering sound similar to an echo where sound waves bounce and scatter around a room. Reverb is a popular audio effect in modern music. * will update later with more concrete details off how we completed the effect

## System Design
- **Main hardware:** [Microcontroller, I²S microphone, DAC/amplifier, speaker, other parts]
<br>
  
- **Audio data flow:** The audio signal will first enter the system through the microphone. The microphone and pi will communicate using the protocol I2S. A protocol made specifically for audio transmission. From there the microcontroller will process the incoming data, add our reverb component and send it to the MAX98357A amplifier board. The MAX98357A contains a class D amplifier as well as a DAC. Lastly the speaker will connect directly to the amplifier board for audio playback

<br>

 <img width="408" height="203" alt="image" src="https://github.com/user-attachments/assets/36b0a1a7-d2d1-4e17-ab71-3cc91c93897b" />


## Weekly Development
Update each page along with weekly milestone demonstration.

| Week | Milestone | Documentation |
|---|---|---|
| 1 | System Design and Environment Setup | [Week 1](project5/week1.md) |
| 2 | Audio Interface Development | [Week 2](project5/week2.md) |
| 3 | Audio Sampling and Basic DSP | [Week 3](project5/week3.md) |
| 4 | Application Development | [Week 4](project5/week4.md) |
| 5&6 | Integration and Testing | [see info below] |

## Final System and Results
- **Final functionality:** [Briefly describe what works in the completed system.]
- **Key test results:** [Summarize the main findings and link to detailed evidence.]
- **Limitations:** [Identify any remaining issues.]

## Final Deliverables
- **Demonstration video:** [Link to video]
- **Source code:** [Link to code folder]
- **Hardware diagrams:** [Link to diagrams]
- **Supporting documentation and test results:** [Link to files]

> Keep descriptions brief and link to supporting evidence. A separate formal report is not required. The VHDL/FPGA documentation instructions for Projects 1–4 do not apply to this project.
