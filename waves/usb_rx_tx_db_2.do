onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Inputs -color Cyan /tb_usb_rx_tx_db_2/DUT/clk
add wave -noupdate -expand -group Inputs /tb_usb_rx_tx_db_2/DUT/n_rst
add wave -noupdate -expand -group Inputs /tb_usb_rx_tx_db_2/DUT/store_tx_data
add wave -noupdate -expand -group Inputs /tb_usb_rx_tx_db_2/DUT/tx_data
add wave -noupdate -expand -group Inputs -color Pink /tb_usb_rx_tx_db_2/DUT/get_rx_data
add wave -noupdate -expand -group Inputs /tb_usb_rx_tx_db_2/DUT/clear
add wave -noupdate -expand -group Inputs /tb_usb_rx_tx_db_2/DUT/tx_packet
add wave -noupdate -expand -group Inputs /tb_usb_rx_tx_db_2/DUT/dp_in
add wave -noupdate -expand -group Inputs /tb_usb_rx_tx_db_2/DUT/dm_in
add wave -noupdate -expand -group Outputs -color Magenta /tb_usb_rx_tx_db_2/DUT/rx_data
add wave -noupdate -expand -group Outputs /tb_usb_rx_tx_db_2/DUT/buffer_occupancy
add wave -noupdate -expand -group Outputs /tb_usb_rx_tx_db_2/DUT/rx_packet
add wave -noupdate -expand -group Outputs /tb_usb_rx_tx_db_2/DUT/rx_data_ready
add wave -noupdate -expand -group Outputs /tb_usb_rx_tx_db_2/DUT/rx_transfer_active
add wave -noupdate -expand -group Outputs /tb_usb_rx_tx_db_2/DUT/rx_error
add wave -noupdate -expand -group Outputs /tb_usb_rx_tx_db_2/DUT/tx_transfer_active
add wave -noupdate -expand -group Outputs /tb_usb_rx_tx_db_2/DUT/tx_error
add wave -noupdate -expand -group Outputs /tb_usb_rx_tx_db_2/DUT/dp_out
add wave -noupdate -expand -group Outputs /tb_usb_rx_tx_db_2/DUT/dm_out
add wave -noupdate -expand -group Internal /tb_usb_rx_tx_db_2/DUT/rx_packet_data
add wave -noupdate -expand -group Internal /tb_usb_rx_tx_db_2/DUT/flush
add wave -noupdate -expand -group Internal /tb_usb_rx_tx_db_2/DUT/tx_packet_data
add wave -noupdate -expand -group Internal /tb_usb_rx_tx_db_2/DUT/store_rx_packet_data
add wave -noupdate -expand -group Internal /tb_usb_rx_tx_db_2/DUT/get_tx_packet_data
add wave -noupdate -expand -group RX -color Cyan /tb_usb_rx_tx_db_2/DUT/u_usb_rx/clk
add wave -noupdate -expand -group RX /tb_usb_rx_tx_db_2/DUT/u_usb_rx/n_rst
add wave -noupdate -expand -group RX -color Yellow /tb_usb_rx_tx_db_2/DUT/u_usb_rx/dp_in
add wave -noupdate -expand -group RX -color Yellow /tb_usb_rx_tx_db_2/DUT/u_usb_rx/dm_in
add wave -noupdate -expand -group RX /tb_usb_rx_tx_db_2/DUT/u_usb_rx/buffer_occupancy
add wave -noupdate -expand -group RX /tb_usb_rx_tx_db_2/DUT/u_usb_rx/rx_data_ready
add wave -noupdate -expand -group RX /tb_usb_rx_tx_db_2/DUT/u_usb_rx/rx_transfer_active
add wave -noupdate -expand -group RX /tb_usb_rx_tx_db_2/DUT/u_usb_rx/rx_error
add wave -noupdate -expand -group RX /tb_usb_rx_tx_db_2/DUT/u_usb_rx/flush
add wave -noupdate -expand -group RX -expand -group RX/Outputs -color {Medium Slate Blue} /tb_usb_rx_tx_db_2/DUT/u_usb_rx/store_rx_packet_data
add wave -noupdate -expand -group RX -expand -group RX/Outputs /tb_usb_rx_tx_db_2/DUT/u_usb_rx/rx_packet
add wave -noupdate -expand -group RX -expand -group RX/Outputs -color {Medium Slate Blue} /tb_usb_rx_tx_db_2/DUT/u_usb_rx/rx_packet_data
add wave -noupdate -expand -group RX -color Pink /tb_usb_rx_tx_db_2/DUT/u_usb_rx/edge_det
add wave -noupdate -expand -group RX /tb_usb_rx_tx_db_2/DUT/u_usb_rx/decoded_data
add wave -noupdate -expand -group RX /tb_usb_rx_tx_db_2/DUT/u_usb_rx/valid_bit
add wave -noupdate -expand -group RX -color Coral /tb_usb_rx_tx_db_2/DUT/u_usb_rx/shift_strobe
add wave -noupdate -expand -group RX -color Cyan /tb_usb_rx_tx_db_2/DUT/u_usb_rx/new_bit
add wave -noupdate -expand -group RX /tb_usb_rx_tx_db_2/DUT/u_usb_rx/sr_clear
add wave -noupdate -expand -group RX /tb_usb_rx_tx_db_2/DUT/u_usb_rx/clear_count
add wave -noupdate -expand -group RX -color Salmon /tb_usb_rx_tx_db_2/DUT/u_usb_rx/byte_done
add wave -noupdate -expand -group RX -color Aquamarine /tb_usb_rx_tx_db_2/DUT/u_usb_rx/token_done
add wave -noupdate -expand -group RX /tb_usb_rx_tx_db_2/DUT/u_usb_rx/eop_det
add wave -noupdate -expand -group RX -color Magenta /tb_usb_rx_tx_db_2/DUT/u_usb_rx/count
add wave -noupdate -expand -group RX -radix binary /tb_usb_rx_tx_db_2/DUT/u_usb_rx/data_parallel
add wave -noupdate -expand -group RX -radix decimal /tb_usb_rx_tx_db_2/DUT/u_usb_rx/bit_count
add wave -noupdate -expand -group RX /tb_usb_rx_tx_db_2/DUT/u_usb_rx/state
add wave -noupdate -expand -group RX /tb_usb_rx_tx_db_2/DUT/u_usb_rx/pid
add wave -noupdate -expand -group RX /tb_usb_rx_tx_db_2/DUT/u_usb_rx/shift_strobe_seen
add wave -noupdate -expand -group RX /tb_usb_rx_tx_db_2/DUT/u_usb_rx/packet_size
add wave -noupdate -expand -group RX /tb_usb_rx_tx_db_2/DUT/u_usb_rx/delayed
add wave -noupdate -expand -group RX /tb_usb_rx_tx_db_2/DUT/u_usb_rx/next_delayed
add wave -noupdate -expand -group RX -expand -group CRC /tb_usb_rx_tx_db_2/DUT/u_usb_rx/crc5_valid
add wave -noupdate -expand -group RX -expand -group CRC /tb_usb_rx_tx_db_2/DUT/u_usb_rx/crc16_valid
add wave -noupdate -expand -group RX -expand -group CRC /tb_usb_rx_tx_db_2/DUT/u_usb_rx/crc5_clear
add wave -noupdate -expand -group RX -expand -group CRC /tb_usb_rx_tx_db_2/DUT/u_usb_rx/crc16_clear
add wave -noupdate -expand -group RX -expand -group CRC -color {Orange Red} /tb_usb_rx_tx_db_2/DUT/u_usb_rx/crc5_en
add wave -noupdate -expand -group RX -expand -group CRC -color {Orange Red} /tb_usb_rx_tx_db_2/DUT/u_usb_rx/crc16_en
add wave -noupdate -expand -group RX -expand -group PIPELINE /tb_usb_rx_tx_db_2/DUT/u_usb_rx/pipeline
add wave -noupdate -expand -group RX -expand -group PIPELINE /tb_usb_rx_tx_db_2/DUT/u_usb_rx/next_pipeline
add wave -noupdate -expand -group RX -group NEXT_ /tb_usb_rx_tx_db_2/DUT/u_usb_rx/next_count
add wave -noupdate -expand -group RX -group NEXT_ /tb_usb_rx_tx_db_2/DUT/u_usb_rx/next_state
add wave -noupdate -expand -group RX -group NEXT_ /tb_usb_rx_tx_db_2/DUT/u_usb_rx/next_pid
add wave -noupdate -expand -group RX -group NEXT_ /tb_usb_rx_tx_db_2/DUT/u_usb_rx/next_byte_done
add wave -noupdate -expand -group RX -group NEXT_ /tb_usb_rx_tx_db_2/DUT/u_usb_rx/next_token_done
add wave -noupdate -expand -group RX -group NEXT_ /tb_usb_rx_tx_db_2/DUT/u_usb_rx/next_shift_strobe_seen
add wave -noupdate -expand -group RX -expand -group Enables -color {Orange Red} /tb_usb_rx_tx_db_2/DUT/u_usb_rx/sr_en
add wave -noupdate -expand -group TX /tb_usb_rx_tx_db_2/DUT/u_usb_tx/tx_packet_data
add wave -noupdate -expand -group TX /tb_usb_rx_tx_db_2/DUT/u_usb_tx/tx_packet
add wave -noupdate -expand -group TX /tb_usb_rx_tx_db_2/DUT/u_usb_tx/buffer_occupancy
add wave -noupdate -expand -group TX /tb_usb_rx_tx_db_2/DUT/u_usb_tx/get_tx_packet_data
add wave -noupdate -expand -group TX /tb_usb_rx_tx_db_2/DUT/u_usb_tx/tx_transfer_active
add wave -noupdate -expand -group TX /tb_usb_rx_tx_db_2/DUT/u_usb_tx/tx_error
add wave -noupdate -expand -group TX /tb_usb_rx_tx_db_2/DUT/u_usb_tx/dm_out
add wave -noupdate -expand -group TX /tb_usb_rx_tx_db_2/DUT/u_usb_tx/dp_out
add wave -noupdate -expand -group TX -expand -group State /tb_usb_rx_tx_db_2/DUT/u_usb_tx/currentState
add wave -noupdate -expand -group TX -expand -group State /tb_usb_rx_tx_db_2/DUT/u_usb_tx/nextState
add wave -noupdate -expand -group TX /tb_usb_rx_tx_db_2/DUT/u_usb_tx/shift_en
add wave -noupdate -expand -group TX /tb_usb_rx_tx_db_2/DUT/u_usb_tx/sr_load_data
add wave -noupdate -expand -group TX /tb_usb_rx_tx_db_2/DUT/u_usb_tx/load_en
add wave -noupdate -expand -group TX /tb_usb_rx_tx_db_2/DUT/u_usb_tx/bit_pulse
add wave -noupdate -expand -group TX -color Gold /tb_usb_rx_tx_db_2/DUT/u_usb_tx/bit_counter
add wave -noupdate -expand -group TX /tb_usb_rx_tx_db_2/DUT/u_usb_tx/next_bit_counter
add wave -noupdate -expand -group TX /tb_usb_rx_tx_db_2/DUT/u_usb_tx/ones_count
add wave -noupdate -expand -group TX /tb_usb_rx_tx_db_2/DUT/u_usb_tx/next_ones_count
add wave -noupdate -expand -group TX /tb_usb_rx_tx_db_2/DUT/u_usb_tx/stuff_active
add wave -noupdate -expand -group TX /tb_usb_rx_tx_db_2/DUT/u_usb_tx/next_stuff_active
add wave -noupdate -expand -group TX -expand -group CRC /tb_usb_rx_tx_db_2/DUT/u_usb_tx/crc16
add wave -noupdate -expand -group TX -expand -group CRC /tb_usb_rx_tx_db_2/DUT/u_usb_tx/next_crc16
add wave -noupdate -expand -group TX -expand -group CRC /tb_usb_rx_tx_db_2/DUT/u_usb_tx/crc16_inv
add wave -noupdate -expand -group TX /tb_usb_rx_tx_db_2/DUT/u_usb_tx/nrzi_bit
add wave -noupdate -expand -group TX -color Magenta -radix binary /tb_usb_rx_tx_db_2/DUT/u_usb_tx/pid
add wave -noupdate -expand -group TX /tb_usb_rx_tx_db_2/DUT/u_usb_tx/pattern_state
add wave -noupdate -expand -group TX /tb_usb_rx_tx_db_2/DUT/u_usb_tx/rollover_val
add wave -noupdate -expand -group TX /tb_usb_rx_tx_db_2/DUT/u_usb_tx/serial_out
add wave -noupdate -expand -group TX /tb_usb_rx_tx_db_2/DUT/u_usb_tx/fb
add wave -noupdate -expand -group TX /tb_usb_rx_tx_db_2/DUT/u_usb_tx/dp_orig
add wave -noupdate -expand -group TX /tb_usb_rx_tx_db_2/DUT/u_usb_tx/next_dp_orig
add wave -noupdate -expand -group TX -expand -group {TX SR} -color Cyan /tb_usb_rx_tx_db_2/DUT/clk
add wave -noupdate -expand -group TX -expand -group {TX SR} /tb_usb_rx_tx_db_2/DUT/u_usb_tx/data_sr/shift_enable
add wave -noupdate -expand -group TX -expand -group {TX SR} /tb_usb_rx_tx_db_2/DUT/u_usb_tx/data_sr/load_enable
add wave -noupdate -expand -group TX -expand -group {TX SR} /tb_usb_rx_tx_db_2/DUT/u_usb_tx/data_sr/serial_in
add wave -noupdate -expand -group TX -expand -group {TX SR} /tb_usb_rx_tx_db_2/DUT/u_usb_tx/data_sr/parallel_in
add wave -noupdate -expand -group TX -expand -group {TX SR} /tb_usb_rx_tx_db_2/DUT/u_usb_tx/data_sr/serial_out
add wave -noupdate -expand -group TX -expand -group {TX SR} -radix binary /tb_usb_rx_tx_db_2/DUT/u_usb_tx/data_sr/parallel_out
add wave -noupdate -expand -group TX -expand -group {TX SR} -radix binary /tb_usb_rx_tx_db_2/DUT/u_usb_tx/data_sr/next_parallel_out
add wave -noupdate -group {Data Buffer} /tb_usb_rx_tx_db_2/DUT/u_data_buffer/clk
add wave -noupdate -group {Data Buffer} /tb_usb_rx_tx_db_2/DUT/u_data_buffer/n_rst
add wave -noupdate -group {Data Buffer} /tb_usb_rx_tx_db_2/DUT/u_data_buffer/tx_data
add wave -noupdate -group {Data Buffer} /tb_usb_rx_tx_db_2/DUT/u_data_buffer/rx_packet_data
add wave -noupdate -group {Data Buffer} /tb_usb_rx_tx_db_2/DUT/u_data_buffer/store_tx_data
add wave -noupdate -group {Data Buffer} /tb_usb_rx_tx_db_2/DUT/u_data_buffer/store_rx_packet_data
add wave -noupdate -group {Data Buffer} /tb_usb_rx_tx_db_2/DUT/u_data_buffer/get_tx_packet_data
add wave -noupdate -group {Data Buffer} /tb_usb_rx_tx_db_2/DUT/u_data_buffer/get_rx_data
add wave -noupdate -group {Data Buffer} /tb_usb_rx_tx_db_2/DUT/u_data_buffer/clear
add wave -noupdate -group {Data Buffer} /tb_usb_rx_tx_db_2/DUT/u_data_buffer/flush
add wave -noupdate -group {Data Buffer} /tb_usb_rx_tx_db_2/DUT/u_data_buffer/buffer_occupancy
add wave -noupdate -group {Data Buffer} /tb_usb_rx_tx_db_2/DUT/u_data_buffer/tx_packet_data
add wave -noupdate -group {Data Buffer} /tb_usb_rx_tx_db_2/DUT/u_data_buffer/rx_data
add wave -noupdate -group {Data Buffer} /tb_usb_rx_tx_db_2/DUT/u_data_buffer/write_ptr
add wave -noupdate -group {Data Buffer} /tb_usb_rx_tx_db_2/DUT/u_data_buffer/read_ptr
add wave -noupdate -group {Data Buffer} /tb_usb_rx_tx_db_2/DUT/u_data_buffer/next_write_ptr
add wave -noupdate -group {Data Buffer} /tb_usb_rx_tx_db_2/DUT/u_data_buffer/next_read_ptr
add wave -noupdate -group {Data Buffer} /tb_usb_rx_tx_db_2/DUT/u_data_buffer/counter
add wave -noupdate -group {Data Buffer} /tb_usb_rx_tx_db_2/DUT/u_data_buffer/next_counter
add wave -noupdate -group {Data Buffer} /tb_usb_rx_tx_db_2/DUT/u_data_buffer/full
add wave -noupdate -group {Data Buffer} /tb_usb_rx_tx_db_2/DUT/u_data_buffer/empty
add wave -noupdate -group {Data Buffer} /tb_usb_rx_tx_db_2/DUT/u_data_buffer/write_data
add wave -noupdate -group {Data Buffer} /tb_usb_rx_tx_db_2/DUT/u_data_buffer/next_write_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {18070140 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 211
configure wave -valuecolwidth 139
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
WaveRestoreZoom {17767501 ps} {18561793 ps}
