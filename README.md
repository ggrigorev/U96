# U96

This repo is about Xilinx Vivado, Vitis, and Lab tools applicable to Avnet evaluation board Ultra96 based on UltraScale+ MPSoC XZU3EG. 

## References: 

https://www.youtube.com/watch?v=NzWcRGjhfF8  
https://www.hackster.io/news/hello-world-on-the-ultra96-using-vitis-89a06b18fa3a  
https://github.com/wknitter/ultra96v2_0
https://www.96boards.org/documentation/consumer/ultra96/ultra96-v2/getting-started/
https://www.hackster.io/mohammad-hosseinabady2/ultra96v2-linux-based-platform-in-xilinx-vitis-2020-1-06f226
https://github.com/josh-macfie/Ultra96_Blink
https://github.com/bombadil7/ultra96_blinky
https://github.com/paulwood15/Ultra96v2-Blinky
https://github.com/Avnet/Ultra96-PYNQ?CMP=GL-Avnet-E14-cross-sell

https://www.we-online.com/icref/en/xilinx/XCZU3-SBVA484B-ZU3EG-FPGA  #looks pretty simular to U96v2

## Problems: 

How to configure Xilinx FPGA from Linux in runtime  

https://forum.rocketboards.org/t/how-to-program-fpga-from-hps-de10-nano/1278/4  
https://rocketboards.org/foswiki/Documentation/GSRD131ProgrammingFPGA  


## How to reload FPGA from petalinux on-fly 
#### - https://www.youtube.com/watch?v=bsgXwXsNMPU  #good video!
#### - https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841847/Solution+ZynqMP+PL+Programming
#### - 4Memories: 
    echo 0 > /sys/class/fpga_manager/fpga0/flags  
    pushd /lib/firmware  
    echo <fpga stream file converted to BIN firmat>.BIN > /sys/class/fpga_manager/fpga0/firmware  
    popd  



## ULTRA96v2 board Resources:
### Board Info and Design files @avnet. There is no SW reference here :(
https://www.avnet.com/wps/portal/us/products/avnet-boards/avnet-board-families/ultra96-v2/
### Board Info and Design files @element14. There is SW (BSP) reference here in "Reference Design" :)
https://www.element14.com/community/docs/DOC-95649 
### ULTRA96v2 BSP for petalinux (use ultra96v2_oob_2020_1.bsp)
#### - this is actually tar.gz and can be unpacked as is for any reason
#### - direct link may not work: go through element14 "Reference design"
https://avtinc.sharepoint.com/teams/ET-Downloads/Shared%20Documents/Forms/AllItems.aspx?id=%2Fteams%2FET%2DDownloads%2FShared%20Documents%2Fprojects%2Fpublic%5Frelease&p=true&originalPath=aHR0cHM6Ly9hdnRpbmMuc2hhcmVwb2ludC5jb20vOmY6L3QvRVQtRG93bmxvYWRzL0VpYUJ6ZkRrRHI5Sm8yT1FONTJ6b1FzQkQxUkdEcUJIdDVtYTEwSjFzVWloVXc_cnRpbWU9T0o0Tl9zUHIyRWc  
 
Pulse Width Modulator PWM_w_Int IP https://github.com/Avnet/hdl



## Petalinux resources
### Installer (use petalinux-v2020.1-final-installer.run)
https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/embedded-design-tools.html
### Petalinux docs
https://www.xilinx.com/support/documentation/sw_manuals/xilinx2020_2/ug1144-petalinux-tools-reference-guide.pdf


## Petalinux projectflow
### 1. Install base installer (passed)
bash petalinux-v2020.1-final-installer.run --dir $INSTALL_PATH --platform "arm aarch64"

### 2. Source petalinux settings  (passed)
cd $INSTALL_PATH  
source settings.sh  
echo $PETALINUX  #make sure this is set as $INSTALL_PATH  

### 3. Create petalinux project using BSP  (passed)
petalinux-create --type project --name $PROJ -s $BSP_PATH/ultra96v2_oob_2020_1.bsp  
cd $PROJ  

### 4. Create petalinux project config  (passed)
#### - enable FPGA Manager!!!  
#### - see build/config.log for issue details  
petalinux-config  
#### petalinux config for FPGA Manager:
  - CONFIG_SUBSYSTEM_DTB_OVERLAY=y  
  - CONFIG_SUBSYSTEM_FPGA_MANAGER=y  

### 5. Build petalinux project (not passed yet)
####  - see build/build.log for issue details
petalinux-build  #does a lot of downloads from http://petalinux.xilinx.com/sswreleases  

### 6. Create petalinux boot files (not tried yet)
petalinux-package --boot --u-boot --format BIN  

### 7. Copy boot files to SD-card (not tried yet)
cp pre-built/linux/images/BOOT.BIN  /media/sd/mmcblk0p1  
cp pre-built/linux/images/image.ub  /media/sd/mmcblk0p1  
cp pre-built/linux/images/boot.scr  /media/sd/mmcblk0p1  

### 8. add bitstream to a prebuild package (not tried yet)
petalinux-package --prebuilt --fpga <FPGA bitstream>  
 


## Petalinux issues resolution (I faced when I try petalinux on Fedora 33) 
 
### 1.You may need to install some packets for this. E.g.: 
  sudo dnf install ncurses-devel.x86_64  
  sudo dnf install ncurses-compat-libs  
  sudo dnf install zlib*686 #sic! 32 bit vertion is required  
 
### 2. petalinux-build ERROR: Failed to Extract Yocto SDK 
  see $PROJ/build/config.log for details - some utilities can be missed and should be instaled  
 
### 3. ERROR:  OE-core's config sanity checker detected a potential misconfiguration. 
    Either fix the cause of this error or at your own risk disable the checker (see sanity.conf).  
    Following is the list of potential problems / advisories:  
    Failed to create a file in SSTATE_DIR: Permission denied.  
#### You could try using /home/training/git/avnet/petalinux/projects/cache/sstate_2020.1/aarch64/ in SSTATE_MIRRORS rather than as an SSTATE_CACHE. 
    sudo mkdir -p /home/training/git/avnet/petalinux/projects/cache/sstate_2020.1/aarch64/  
    sudo chown -R vgoussev.vgoussev /home/training  
#### IMPORTANT: You may try to fix the pathes DL_DIR and SSTATE_DIR in $PROJ/project-spec/meta-user/conf/petalinuxbsp.conf  
    - this works!  
 


