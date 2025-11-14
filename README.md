# FPGA_Lab_7

Project Description:
This project involved designing and integrating several core digital logic components into a complete system capable of detecting sequences, counting values, converting number formats, and displaying results on a seven-segment interface. The work began with developing two finite state machines to detect 4-bit sequences: a Moore machine for the pattern 1100 and a Mealy machine for the pattern 1101, allowing comparison of their structural and timing differences. A 12-bit UP counter was then implemented to generate binary values from 0 to 4095, followed by the design of a Binary-to-BCD converter using the double-dabble algorithm to transform the counter output into four BCD digits. Finally, all modules were combined in a top-level design that drives a multiplexed multi-digit seven-segment display on the Basys-3 FPGA, showing the real-time count value. This project demonstrates modular digital design, hierarchical integration, and practical FPGA implementation techniques.


Instructions:

Simulation

Add all Verilog modules and testbenches to Vivado.

Simulate each component: Moore FSM, Mealy FSM, UP counter, Binary-to-BCD, and display driver.

Verify correct state transitions, output assertions, counter increments, and BCD conversion.

Check waveform timing and ensure all modules behave as expected before integration.

Synthesis

Set Display_Top as the top module.

Add the Basys-3 XDC constraints for clock, reset, anodes, and segment pins.

Run synthesis and resolve any errors or missing modules.

Review utilization and timing warnings.

Implementation

Run implementation to map the design onto FPGA hardware.

Confirm timing closure and correct I/O pin mapping.

Generate the bitstream once implementation succeeds.

Programming & Testing

Connect and program the Basys-3 board with the generated bitstream.

Press reset and observe the seven-segment display.

Verify that the counter increments and updates the displayed digits correctly.
