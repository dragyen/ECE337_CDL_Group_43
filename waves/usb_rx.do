onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Inputs /tb_usb_rx/clk
add wave -noupdate -expand -group Inputs /tb_usb_rx/n_rst
add wave -noupdate -expand -group Inputs /tb_usb_rx/dp_in
add wave -noupdate -expand -group Inputs /tb_usb_rx/dm_in
add wave -noupdate -expand -group Inputs /tb_usb_rx/buffer_occupancy
add wave -noupdate -expand -group Outputs /tb_usb_rx/rx_data_ready
add wave -noupdate -expand -group Outputs /tb_usb_rx/rx_transfer_active
add wave -noupdate -expand -group Outputs /tb_usb_rx/rx_error
add wave -noupdate -expand -group Outputs /tb_usb_rx/flush
add wave -noupdate -expand -group Outputs /tb_usb_rx/store_rx_packet_data
add wave -noupdate -expand -group Outputs /tb_usb_rx/rx_packet
add wave -noupdate -expand -group Outputs /tb_usb_rx/rx_packet_data
add wave -noupdate -group {Internal TB} /tb_usb_rx/cur_line
add wave -noupdate -group {Internal TB} /tb_usb_rx/tb_test_num
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/edge_det
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/decoded_data
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/valid_bit
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/shift_strobe
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/crc5_en
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/crc16_en
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/crc5_valid
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/crc16_valid
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/crc5_clear
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/crc16_clear
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/sr_en
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/sr_clear
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/clear_count
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/byte_done
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/token_done
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/eop_det
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/count
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/next_count
add wave -noupdate -expand -group {DUT Internal} -radix binary /tb_usb_rx/DUT/data_parallel
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/bit_count
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/state
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/next_state
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/pid
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/next_pid
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/next_byte_done
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/next_token_done
add wave -noupdate -expand -group {DUT Internal} /tb_usb_rx/DUT/packet_size
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {45367 ps} 0}
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
WaveRestoreZoom {0 ps} {329048 ps}
