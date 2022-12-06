rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

PROJECT_NAME := Test
SOURCES := $(call rwildcard,src,*.sv)
CONSTRAINTS := $(call rwildcard,constraints,*.xdc)
FPGA_PART := "xc7a100tcsg324-1"
FPGA_PART_FOR_UPLOAD := "xc7a100t_0"
TOP_MODULE_NAME := Top
PROBE_FILE := "${PROJECT_NAME}.ltx"
FULL_PROBE_FILE := "" 
PROGRAM_FILE := "${PROJECT_NAME}.bit"
BOARD_PART := "digilentinc.com:nexys-a7-100t:part0:1.2"
NPROC := 48

generate:
	cmake -Btb/build tb/

build:
	cmake --build tb/build -j$(NPROC)

test:
	ctest --test-dir tb/build -j$(NPROC)

clean:
	rm -r tb/build

# https://docs.xilinx.com/r/en-US/ug892-vivado-design-flows-overview/Using-Non-Project-Mode-Tcl-Commands

impl:
	echo "source vivado_impl.tcl" > impl.tcl
	echo "run_impl $(FPGA_PART) $(TOP_MODULE_NAME) $(PROJECT_NAME) $(PROBE_FILE) $(BOARD_PART)" >> impl.tcl
	vivado -mode batch -source impl.tcl

upload:
	echo "source upload.tcl" > up.tcl
	echo "upload_to_fpga $(FPGA_PART_FOR_UPLOAD) $(PROBE_FILE) $(PROGRAM_FILE)" >> up.tcl
	vivado -mode batch -source up.tcl

hardware_manager:
	echo "source hardware_manager.tcl" > hwm.tcl
	echo "open_hardware_manager" >> hwm.tcl
	vivado -mode batch -source hwm.tcl