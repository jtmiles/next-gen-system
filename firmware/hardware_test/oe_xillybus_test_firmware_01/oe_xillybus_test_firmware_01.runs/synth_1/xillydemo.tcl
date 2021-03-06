# 
# Synthesis run script generated by Vivado
# 

set_param gui.test TreeTableDev
debug::add_scope template.lib 1
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000

create_project -in_memory -part xc7k325tffg900-2
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir /home/oe/Desktop/oe_xillybus_test_firmware_01/oe_xillybus_test_firmware_01.cache/wt [current_project]
set_property parent.project_path /home/oe/Desktop/oe_xillybus_test_firmware_01/oe_xillybus_test_firmware_01.xpr [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
add_files -quiet /home/oe/Desktop/oe_xillybus_test_firmware_01/oe_xillybus_test_firmware_01.runs/fifo_8x2048_synth_1/fifo_8x2048.dcp
set_property used_in_implementation false [get_files /home/oe/Desktop/oe_xillybus_test_firmware_01/oe_xillybus_test_firmware_01.runs/fifo_8x2048_synth_1/fifo_8x2048.dcp]
add_files -quiet /home/oe/Desktop/oe_xillybus_test_firmware_01/oe_xillybus_test_firmware_01.runs/fifo_32x512_synth_1/fifo_32x512.dcp
set_property used_in_implementation false [get_files /home/oe/Desktop/oe_xillybus_test_firmware_01/oe_xillybus_test_firmware_01.runs/fifo_32x512_synth_1/fifo_32x512.dcp]
add_files -quiet /home/oe/Desktop/oe_xillybus_test_firmware_01/oe_xillybus_test_firmware_01.runs/pcie_k7_vivado_synth_1/pcie_k7_vivado.dcp
set_property used_in_implementation false [get_files /home/oe/Desktop/oe_xillybus_test_firmware_01/oe_xillybus_test_firmware_01.runs/pcie_k7_vivado_synth_1/pcie_k7_vivado.dcp]
read_verilog -library xil_defaultlib {
  /home/oe/Desktop/oe_xillybus_test_firmware_01/oe_xillybus_test_firmware_01.srcs/sources_1/imports/xillybus-eval-kintex7-1.2d/verilog/src/xillydemo.v
  /home/oe/Desktop/oe_xillybus_test_firmware_01/oe_xillybus_test_firmware_01.srcs/sources_1/imports/xillybus-eval-kintex7-1.2d/verilog/src/xillybus.v
  /home/oe/Desktop/oe_xillybus_test_firmware_01/oe_xillybus_test_firmware_01.srcs/sources_1/imports/xillybus-eval-kintex7-1.2d/verilog/src/xillybus_core.v
  /home/oe/Desktop/oe_xillybus_test_firmware_01/oe_xillybus_test_firmware_01.srcs/sources_1/imports/xillybus-eval-kintex7-1.2d/vivado-essentials/pcie_k7_8x.v
  /home/oe/Desktop/oe_xillybus_test_firmware_01/oe_xillybus_test_firmware_01.srcs/sources_1/imports/xillybus-eval-kintex7-1.2d/vivado-essentials/pcie_k7_8x_pipe_clock.v
  /home/oe/Desktop/oe_xillybus_test_firmware_01/oe_xillybus_test_firmware_01.srcs/sources_1/imports/xillybus-eval-kintex7-1.2d/vivado-essentials/pcie_k7_vivado_pipe_clock.v
}
set_property edif_extra_search_paths /home/oe/Downloads/xillybus-eval-kintex7-1.2d/core [current_fileset]
read_xdc /home/oe/Desktop/oe_xillybus_test_firmware_01/oe_xillybus_test_firmware_01.srcs/constrs_1/imports/vivado-essentials/xillydemo.xdc
set_property used_in_implementation false [get_files /home/oe/Desktop/oe_xillybus_test_firmware_01/oe_xillybus_test_firmware_01.srcs/constrs_1/imports/vivado-essentials/xillydemo.xdc]

catch { write_hwdef -file xillydemo.hwdef }
synth_design -top xillydemo -part xc7k325tffg900-2
write_checkpoint xillydemo.dcp
catch { report_utilization -file xillydemo_utilization_synth.rpt -pb xillydemo_utilization_synth.pb }
