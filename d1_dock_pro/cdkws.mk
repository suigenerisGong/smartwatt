.PHONY: clean All Project_Title Project_PreBuild drv_wifi_rtl8723ds httpclient lwip mbedtls netmgr transport aoshal aos chip_d1 cli csi d1_evb debug key_mgr kv libc_stub partition posix rhino_arch rhino sec_crypto ulog uservice vfs yoc_kernel_d1 Project_Build Project_PostBuild

All: Project_Title Project_PreBuild drv_wifi_rtl8723ds httpclient lwip mbedtls netmgr transport aoshal aos chip_d1 cli csi d1_evb debug key_mgr kv libc_stub partition posix rhino_arch rhino sec_crypto ulog uservice vfs yoc_kernel_d1 Project_Build Project_PostBuild

Project_Title:
	@echo "----------Building project:[ http - BuildSet ]----------"

Project_PreBuild:
	@echo Executing Pre Build commands ...
	@cd "http" && export BOARD_PATH="C:/Users/Wan/Documents/http/__workspace_pack__/d1_evb/v7.5.1" CDKPath="D:/C-Sky/CDK" CDK_VERSION="V2.16.2" CHIP_PATH="C:/Users/Wan/Documents/http/__workspace_pack__/chip_d1/v7.5.1" ProjectPath="C:/Users/Wan/Documents/http/http/" SOLUTION_PATH="C:/Users/Wan/Documents/http/http/" aos="v7.5.1" aoshal="v7.5.1" chip_d1="v7.5.1" cli="v7.5.1" csi="v7.5.1" d1_evb="v7.5.1" debug="v7.5.1" drv_wifi_rtl8723ds="v7.4.7" httpclient="v7.5.2" key_mgr="v7.5.0" kv="v7.5.1" libc_stub="v7.5.1" lwip="v7.4.7" mbedtls="v7.4.5" netmgr="v7.4.7" partition="v7.5.0" posix="v7.6.1" rhino="v7.5.1" rhino_arch="v7.5.1" sdk_chip_d1="v7.5.1" sec_crypto="v7.5.0" transport="v7.5.0" ulog="v7.5.1" uservice="v7.5.0" vfs="v7.6.1" yoc_kernel_d1="v7.5.0" && "C:/Users/Wan/Documents/http/http/script/pre_build.sh" 
	@echo Done

drv_wifi_rtl8723ds:
	@make -r -f Obj/BuildSet/Packages/drv_wifi_rtl8723ds/v7.4.7/Makefile -j 16 -C  http 

httpclient:
	@make -r -f Obj/BuildSet/Packages/httpclient/v7.5.2/Makefile -j 16 -C  http 

lwip:
	@make -r -f Obj/BuildSet/Packages/lwip/v7.4.7/Makefile -j 16 -C  http 

mbedtls:
	@make -r -f Obj/BuildSet/Packages/mbedtls/v7.4.5/Makefile -j 16 -C  http 

netmgr:
	@make -r -f Obj/BuildSet/Packages/netmgr/v7.4.7/Makefile -j 16 -C  http 

transport:
	@make -r -f Obj/BuildSet/Packages/transport/v7.5.0/Makefile -j 16 -C  http 

aoshal:
	@make -r -f Obj/BuildSet/Packages/aoshal/v7.5.1/Makefile -j 16 -C  http 

aos:
	@make -r -f Obj/BuildSet/Packages/aos/v7.5.1/Makefile -j 16 -C  http 

chip_d1:
	@make -r -f Obj/BuildSet/Packages/chip_d1/v7.5.1/Makefile -j 16 -C  http 

cli:
	@make -r -f Obj/BuildSet/Packages/cli/v7.5.1/Makefile -j 16 -C  http 

csi:
	@make -r -f Obj/BuildSet/Packages/csi/v7.5.1/Makefile -j 16 -C  http 

d1_evb:
	@make -r -f Obj/BuildSet/Packages/d1_evb/v7.5.1/Makefile -j 16 -C  http 

debug:
	@make -r -f Obj/BuildSet/Packages/debug/v7.5.1/Makefile -j 16 -C  http 

key_mgr:
	@make -r -f Obj/BuildSet/Packages/key_mgr/v7.5.0/Makefile -j 16 -C  http 

kv:
	@make -r -f Obj/BuildSet/Packages/kv/v7.5.1/Makefile -j 16 -C  http 

libc_stub:
	@make -r -f Obj/BuildSet/Packages/libc_stub/v7.5.1/Makefile -j 16 -C  http 

partition:
	@make -r -f Obj/BuildSet/Packages/partition/v7.5.0/Makefile -j 16 -C  http 

posix:
	@make -r -f Obj/BuildSet/Packages/posix/v7.6.1/Makefile -j 16 -C  http 

rhino_arch:
	@make -r -f Obj/BuildSet/Packages/rhino_arch/v7.5.1/Makefile -j 16 -C  http 

rhino:
	@make -r -f Obj/BuildSet/Packages/rhino/v7.5.1/Makefile -j 16 -C  http 

sec_crypto:
	@make -r -f Obj/BuildSet/Packages/sec_crypto/v7.5.0/Makefile -j 16 -C  http 

ulog:
	@make -r -f Obj/BuildSet/Packages/ulog/v7.5.1/Makefile -j 16 -C  http 

uservice:
	@make -r -f Obj/BuildSet/Packages/uservice/v7.5.0/Makefile -j 16 -C  http 

vfs:
	@make -r -f Obj/BuildSet/Packages/vfs/v7.6.1/Makefile -j 16 -C  http 

yoc_kernel_d1:
	@make -r -f Obj/BuildSet/Packages/yoc_kernel_d1/v7.5.0/Makefile -j 16 -C  http 


Project_Build:
	@make -r -f http.mk -j 16 -C  http 

Project_PostBuild:
	@echo Executing Post Build commands ...
	@cd "http" && export BOARD_PATH="C:/Users/Wan/Documents/http/__workspace_pack__/d1_evb/v7.5.1" CDKPath="D:/C-Sky/CDK" CDK_VERSION="V2.16.2" CHIP_PATH="C:/Users/Wan/Documents/http/__workspace_pack__/chip_d1/v7.5.1" ProjectPath="C:/Users/Wan/Documents/http/http/" SOLUTION_PATH="C:/Users/Wan/Documents/http/http/" aos="v7.5.1" aoshal="v7.5.1" chip_d1="v7.5.1" cli="v7.5.1" csi="v7.5.1" d1_evb="v7.5.1" debug="v7.5.1" drv_wifi_rtl8723ds="v7.4.7" httpclient="v7.5.2" key_mgr="v7.5.0" kv="v7.5.1" libc_stub="v7.5.1" lwip="v7.4.7" mbedtls="v7.4.5" netmgr="v7.4.7" partition="v7.5.0" posix="v7.6.1" rhino="v7.5.1" rhino_arch="v7.5.1" sdk_chip_d1="v7.5.1" sec_crypto="v7.5.0" transport="v7.5.0" ulog="v7.5.1" uservice="v7.5.0" vfs="v7.6.1" yoc_kernel_d1="v7.5.0" && "C:/Users/Wan/Documents/http/http/script/aft_build.sh" 
	@echo Done


clean:
	@echo "----------Cleaning project:[ http - BuildSet ]----------"

