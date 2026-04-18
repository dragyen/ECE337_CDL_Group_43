onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Inputs /tb_rx_shift_register/clk
add wave -noupdate -expand -group Inputs /tb_rx_shift_register/n_rst
add wave -noupdate -expand -group Inputs /tb_rx_shift_register/valid_bit
add wave -noupdate -expand -group Inputs /tb_rx_shift_register/serial_in
add wave -noupdate -expand -group Inputs /tb_rx_shift_register/en
add wave -noupdate -expand -group Inputs /tb_rx_shift_register/clear
add wave -noupdate -expand -group Outputs -radix binary /tb_rx_shift_register/parallel_out
add wave -noupdate -expand -group Internal -radix binary /tb_rx_shift_register/exp_regs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {48314 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {105 ns}
