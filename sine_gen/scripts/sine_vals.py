#!/usr/bin/python
import pylab
import math
import sys

# set addr bits
mem_addr_bits = 8
mem_depth = 2**mem_addr_bits
mem_max_addr = mem_depth-1

# set mem width
mem_width = 8
max_data_val = 2**mem_width-1

# set addr radix (DEC, BIN, OCT, UNS, HEX)
addr_radix = "DEC"

# set data radix (DEC, BIN, OCT, UNS, HEX)
data_radix = "DEC"

# get vals from 0 to pi/2 rounded to nearest integer
# start val, end val, step size
x = pylab.arange(0, math.pi/2, math.pi/(2*mem_depth))
y = pylab.sin(x)
pylab.plot(x,y)
#vals = [int(round(val)) for val in y[0:mem_max_addr]*max_data_val]
vals = [int(round(val)) for val in y*max_data_val/2]



##############################
# make sine.mif file
try: 
    mif_file = open("sine.mif", 'w')
except: 
    print("some issue occured when creating the \'sine.mif\' file.")

# redirect print statements to sine.mif file
sys.stdout = mif_file

print("DEPTH = ", mem_depth, ";", sep="")
print("WIDTH = ", mem_width, ";", sep="")
print("ADDRESS_RADIX = ", addr_radix, ";", sep="") 
print("DATA_RADIX = ", data_radix, ";", sep="")
print("CONTENT")
print("BEGIN")
for idx, val in enumerate(vals):
    print(idx, " : ", val+int(max_data_val/2), ";", sep="")
print("END")

mif_file.close()

##############################
# make sine_rom.sv file
try: 
    sv_file = open("sine_rom.sv", 'w')
except: 
    print("some issue occured when creating the \'sine_rom.sv\' file.")

# redirect print statements to sine_rom.sv file
sys.stdout = sv_file

print("module sine_rom( input  logic                clk,")
print("                 input  logic unsigned [7:0] addr,")
print("                 output logic unsigned [7:0] val );")
print()
print("    always_ff @(posedge clk)")
print("        case(addr)")

# print case statement vals
for idx, val in enumerate(vals):
    print("                ", idx," : val <= ", val+int(max_data_val/2), ";", sep="")

print("        endcase")
print()
print("endmodule")

sv_file.close()
