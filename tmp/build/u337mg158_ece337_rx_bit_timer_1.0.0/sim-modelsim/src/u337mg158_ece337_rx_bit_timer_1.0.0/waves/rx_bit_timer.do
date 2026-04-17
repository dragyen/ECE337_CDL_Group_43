onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Inputs /tb_rx_bit_timer/clk
add wave -noupdate -expand -group Inputs /tb_rx_bit_timer/n_rst
add wave -noupdate -expand -group Inputs -color {Violet Red} /tb_rx_bit_timer/edge_det
add wave -noupdate -expand -group Outputs -color Gold /tb_rx_bit_timer/shift_strobe
add wave -noupdate -expand -group Internal /tb_rx_bit_timer/DUT/state
add wave -noupdate -expand -group Internal /tb_rx_bit_timer/DUT/count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {14944 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 78
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
WaveRestoreZoom {0 ps} {333042 ps}
