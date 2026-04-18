onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Inputs /tb_crc_checker_5bit/clk
add wave -noupdate -expand -group Inputs /tb_crc_checker_5bit/n_rst
add wave -noupdate -expand -group Inputs /tb_crc_checker_5bit/serial_in
add wave -noupdate -expand -group Inputs /tb_crc_checker_5bit/crc_en
add wave -noupdate -expand -group Inputs /tb_crc_checker_5bit/crc_clear
add wave -noupdate -expand -group Inputs /tb_crc_checker_5bit/valid_bit
add wave -noupdate -expand -group Outputs /tb_crc_checker_5bit/crc_valid
add wave -noupdate -expand -group Internal /tb_crc_checker_5bit/data
add wave -noupdate -expand -group Internal /tb_crc_checker_5bit/good
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {73384474311 ps} 0}
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
WaveRestoreZoom {73384474050 ps} {73384475050 ps}
