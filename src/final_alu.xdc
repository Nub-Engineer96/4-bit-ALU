# 100 MHz clock
create_clock -period 10 -name clk [get_ports clk]

# 50 ps setup uncertainty
set_clock_uncertainty -setup 0.050 [get_clocks clk]

# 50 ps hold uncertainty
set_clock_uncertainty -hold 0.050 [get_clocks clk]

# Input delay (except clk)

# Output delay
set_output_delay -clock clk 0.050 [all_outputs]


