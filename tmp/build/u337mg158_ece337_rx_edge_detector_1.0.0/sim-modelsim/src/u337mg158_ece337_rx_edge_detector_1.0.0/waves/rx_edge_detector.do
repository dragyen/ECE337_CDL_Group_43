onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Inputs /tb_rx_edge_detector/clk
add wave -noupdate -expand -group Inputs /tb_rx_edge_detector/n_rst
add wave -noupdate -expand -group Inputs -color Pink /tb_rx_edge_detector/dp_in
add wave -noupdate -expand -group Inputs /tb_rx_edge_detector/dm_in
add wave -noupdate -expand -group Outputs -color Magenta /tb_rx_edge_detector/edge_det
add wave -noupdate -expand -group Internal -color Gold /tb_rx_edge_detector/DUT/ed/dual/sync_out
add wave -noupdate -expand -group Internal -color Gold /tb_rx_edge_detector/DUT/ed/dual/ff2
add wave -noupdate -expand -group Internal /tb_rx_edge_detector/DUT/ed/dual/ff1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {29766 ps} 0}
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
WaveRestoreZoom {0 ps} {111300 ps}
