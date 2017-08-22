// This is a general UART design for FPGA debugging.
// You can read/write 4 registers in the design by UART.

// Author: Jianfeng An
// Date: 2017-08-21 15:07:24
// Write format: ‘h1256XXXXXXXXYYYYYYYY 
// Read  format: 'h1234XXXXXXXX
// XXXXXXXX is the read/write address of registers.
// YYYYYYYY is the write value.
// The return valude from UART is the read/write value of specified address.

// The UCF is provided for Genesys FPGA board.

