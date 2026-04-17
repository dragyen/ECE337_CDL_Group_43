onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_data_buffer/DUT/clk
add wave -noupdate /tb_data_buffer/DUT/n_rst
add wave -noupdate /tb_data_buffer/DUT/tx_data
add wave -noupdate /tb_data_buffer/DUT/rx_packet_data
add wave -noupdate /tb_data_buffer/DUT/store_tx_data
add wave -noupdate /tb_data_buffer/DUT/store_rx_packet_data
add wave -noupdate /tb_data_buffer/DUT/get_tx_packet_data
add wave -noupdate /tb_data_buffer/DUT/get_rx_data
add wave -noupdate /tb_data_buffer/DUT/clear
add wave -noupdate /tb_data_buffer/DUT/flush
add wave -noupdate /tb_data_buffer/DUT/buffer_occupancy
add wave -noupdate /tb_data_buffer/DUT/tx_packet_data
add wave -noupdate /tb_data_buffer/DUT/rx_data
add wave -noupdate /tb_data_buffer/DUT/write_ptr
add wave -noupdate /tb_data_buffer/DUT/read_ptr
add wave -noupdate /tb_data_buffer/DUT/next_write_ptr
add wave -noupdate /tb_data_buffer/DUT/next_read_ptr
add wave -noupdate /tb_data_buffer/DUT/counter
add wave -noupdate /tb_data_buffer/DUT/next_counter
add wave -noupdate /tb_data_buffer/DUT/full
add wave -noupdate /tb_data_buffer/DUT/empty
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {12040 ps} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {467250 ps}
