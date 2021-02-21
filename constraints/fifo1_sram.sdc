
create_clock -name "wclk" -period 6.0 -waveform {0.0 3.0} wclk
# 0.07 ns is fairly typical for pll jitter plus other jitter.
set_clock_uncertainty -setup 0.07 wclk
set_clock_uncertainty -hold 0.01 wclk
set_clock_transition 0.1 wclk

create_clock -name "rclk" -period 3.0 -waveform {0.0 1.5} rclk
set_clock_uncertainty -setup 0.07 rclk
set_clock_uncertainty -hold 0.01 rclk
set_clock_transition 0.1 rclk

#Add the new clock.  Make it 1/2 the wclk period since it is called wclk2x
create_clock -name "wclk2x" -period 3.0 -waveform {0.0 1.5} wclk2x
set_clock_uncertainty 0.07 -setup wclk2x
set_clock_uncertainty 0.01 -hold wclk2x
set_clock_transition 0.1 wclk2x

# Add input/output delays in relation to related clocks
# Can tell the related clock by doing report_timing -group INPUTS  or -group OUTPUTS after using group_path
# External delay should be some percentage of clock period.
# Tune/relax if violating; most concerned about internal paths.
set_input_delay 0.011 wdata_in* -clock wclk2x
set_input_delay 0.012 winc -clock wclk
set_input_delay 0.012 rinc -clock rclk
set_output_delay 0.013 rdata* -clock rclk
set_output_delay 0.014 {rempty } -clock rclk
set_output_delay 0.015 { wfull } -clock wclk
# This port does not seem to need to be constrained with the way the library works.
# I constrained anyway and did to multiple clocks.
# I understand you probably wouldn't know that part.
set_input_delay 0.16 rrst_n -clock rclk
set_input_delay 0.16 rrst_n -clock wclk -add_delay
set_input_delay 0.16 rrst_n -clock wclk2x -add_delay

# I like set_driving_cell to a std cell from the library.  set_drive works to.
#set_driving_cell -lib_cell INVX1_HVT [all_inputs]
set_drive 0.001 [all_inputs ]
# Make a guess for now.  A real value would normally be given.
set_load 0.5 [all_outputs]

#group_path -name INTERNAL -from [all_clocks] -to [all_clocks ]
group_path -name INPUTS -from [ get_ports -filter "direction==in&&full_name!~*clk*" ]
group_path -name OUTPUTS -to [ get_ports -filter "direction==out" ]

