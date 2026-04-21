onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_usb_rx_tx_db/DUT/clk
add wave -noupdate /tb_usb_rx_tx_db/DUT/n_rst
add wave -noupdate /tb_usb_rx_tx_db/DUT/store_tx_data
add wave -noupdate /tb_usb_rx_tx_db/DUT/tx_data
add wave -noupdate /tb_usb_rx_tx_db/DUT/get_rx_data
add wave -noupdate /tb_usb_rx_tx_db/DUT/clear
add wave -noupdate /tb_usb_rx_tx_db/DUT/rx_data
add wave -noupdate /tb_usb_rx_tx_db/DUT/buffer_occupancy
add wave -noupdate /tb_usb_rx_tx_db/DUT/tx_packet
add wave -noupdate /tb_usb_rx_tx_db/DUT/rx_packet
add wave -noupdate /tb_usb_rx_tx_db/DUT/rx_data_ready
add wave -noupdate /tb_usb_rx_tx_db/DUT/rx_transfer_active
add wave -noupdate /tb_usb_rx_tx_db/DUT/rx_error
add wave -noupdate /tb_usb_rx_tx_db/DUT/tx_transfer_active
add wave -noupdate /tb_usb_rx_tx_db/DUT/tx_error
add wave -noupdate /tb_usb_rx_tx_db/DUT/dp_in
add wave -noupdate /tb_usb_rx_tx_db/DUT/dm_in
add wave -noupdate /tb_usb_rx_tx_db/DUT/dp_out
add wave -noupdate /tb_usb_rx_tx_db/DUT/dm_out
add wave -noupdate /tb_usb_rx_tx_db/DUT/rx_packet_data
add wave -noupdate /tb_usb_rx_tx_db/DUT/store_rx_packet_data
add wave -noupdate /tb_usb_rx_tx_db/DUT/flush
add wave -noupdate /tb_usb_rx_tx_db/DUT/tx_packet_data
add wave -noupdate /tb_usb_rx_tx_db/DUT/get_tx_packet_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {924684 ps} 0}
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
WaveRestoreZoom {0 ps} {9292500 ps}
