set lib_dir /pkgs/synopsys/2020/32_28nm/SAED32_EDK/lib

# Risc V
set top_design ExampleRocketSystem
set add_ios 0
set pad_design 0
set design_size { 1850 1380 } 
set design_io_border 10
set dc_floorplanning 1
set rtl_list [list ../rtl/$top_design.sv ]
set slow_corner "ss0p75v125c ss0p95v125c_2p25v ss0p95v125c"
set fast_corner "ff0p95vn40c ff1p16vn40c_2p75v ff1p16vn40c"
set synth_corners $slow_corner
set synth_corners_target "ss0p75v125c" 
set synth_corners_slow $slow_corner
set synth_corners_fast $fast_corner
set slow_metal Cmax_125
set fast_metal Cmax_125

#set lib_types "stdcell_hvt stdcell_rvt stdcell_lvt sram"
set lib_types "$lib_dir/io_std/db_nldm $lib_dir/sram/db_nldm $lib_dir/pll/db_nldm"
set ndm_types "$lib_dir/stdcell_rvt/ndm $lib_dir/stdcell_hvt/ndm $lib_dir/stdcell_lvt/ndm $lib_dir/sram/ndm $lib_dir/io_std/ndm  $lib_dir/pll/ndm"
set lib_types_target "$lib_dir/stdcell_rvt/db_nldm $lib_dir/stdcell_lvt/db_nldm"

# Get just the main standard cells, srams
#set sub_lib_type "saed32?vt_ saed32sram_"
set sub_lib_type "saed32?vt_ saed32sram_ saed32io_wb_ saed32pll_"
set sub_lib_type_target "saed32?vt_"

set lef_types [list $lib_dir/stdcell_hvt/lef \
$lib_dir/stdcell_rvt/lef \
$lib_dir/stdcell_lvt/lef \
$lib_dir/sram/lef/ \
$lib_dir/io_std/lef \
$lib_dir/pll/lef \
]

set sub_lef_type "saed32nm_?vt_*.lef saed32sram.lef saed32_io_wb_all.lef saed32_PLL.lef"

set mwlib_types [list $lib_dir/stdcell_hvt/milkyway \
$lib_dir/stdcell_rvt/milkyway \
$lib_dir/stdcell_lvt/milkyway  \
$lib_dir/io_std/milkyway \
$lib_dir/sram/milkyway $lib_dir/pll/milkyway \
 ]
set sub_mwlib_type "saed32nm_?vt_* SRAM32NM saed32io_wb_* SAED32_PLL_FR*"

#set topdir /u/$env(USER)/PSU_RTL2GDS
set topdir [ lindex [ regexp -inline "(.*)\(syn\|pt\|apr\)" [pwd] ] 1 ]

# Set number of cores to use.  Be cautious with this.  If a machine is loaded, it is faster to use 1 cpu than 
# multiple cpu on a loaded machine
if {[info exists synopsys_program_name]} {
        if { $synopsys_program_name == "dc_shell" } {
           set_host_options -max_cores 4
        } 
        if { $synopsys_program_name == "icc2_shell" } {
           set_host_options -max_cores 4
        }
} elseif {[get_db root: .program_short_name] == "innovus"} {
  setMultiCpuUsage -localCpu 4 
} elseif {[get_db root: .program_short_name] == "genus"} {
  set_db / .max_cpus_per_server 4 
}

set innovus_enable_manual_macro_placement 1
set enable_dft 0

set FCL 0
set split_constraints 0
