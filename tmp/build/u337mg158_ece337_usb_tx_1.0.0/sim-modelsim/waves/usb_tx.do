onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_usb_tx/DUT/clk
add wave -noupdate /tb_usb_tx/DUT/n_rst
add wave -noupdate /tb_usb_tx/DUT/tx_packet_data
add wave -noupdate /tb_usb_tx/DUT/tx_packet
add wave -noupdate /tb_usb_tx/DUT/buffer_occupancy
add wave -noupdate /tb_usb_tx/DUT/get_tx_packet_data
add wave -noupdate /tb_usb_tx/DUT/tx_transfer_active
add wave -noupdate /tb_usb_tx/DUT/tx_error
add wave -noupdate /tb_usb_tx/DUT/dm_out
add wave -noupdate /tb_usb_tx/DUT/currentState
add wave -noupdate /tb_usb_tx/DUT/nextState
add wave -noupdate /tb_usb_tx/DUT/shift_en
add wave -noupdate /tb_usb_tx/DUT/load_en
add wave -noupdate /tb_usb_tx/DUT/bit_pulse
add wave -noupdate /tb_usb_tx/DUT/bit_counter
add wave -noupdate /tb_usb_tx/DUT/next_bit_counter
add wave -noupdate /tb_usb_tx/DUT/pid
add wave -noupdate /tb_usb_tx/DUT/pattern_state
add wave -noupdate /tb_usb_tx/DUT/rollover_val
add wave -noupdate /tb_usb_tx/DUT/serial_out
add wave -noupdate /tb_usb_tx/DUT/dp_orig
add wave -noupdate /tb_usb_tx/DUT/next_dp_orig
add wave -noupdate /tb_usb_tx/DUT/dp_orig
add wave -noupdate -divider Compare
add wave -noupdate /tb_usb_tx/prev_dp
add wave -noupdate /tb_usb_tx/DUT/dp_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6915000 ps} 0}
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
WaveRestoreZoom {6675960 ps} {7154040 ps}
