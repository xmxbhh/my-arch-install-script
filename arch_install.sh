###############################################################################################
pass()
{
whyroot			#判断是不是root
Network_check #网络流畅判断
judge_bios #判断是bios还是uefi
update_mirrorlist #更新源
read -r -p "是否跳过删除分区（Y/N）" judge
if [[ $judge =~ ^(no|n|N| ) ]]; then
	disk_delete
else
	echo "成功跳过"
fi
read -r -p "是否跳过创建分区（Y/N）" judge
if [[ $judge =~ ^(no|n|N| ) ]]; then
	disk
else
	echo "成功跳过"
fi
read -r -p "是否跳过格式化并挂载分区（Y/N）" judge
if [[ $judge =~ ^(no|n|N| ) ]]; then
	format_partitions
else
	echo "成功跳过"
fi
read -r -p "是否跳过挂载分区（Y/N）" judge
if [[ $judge =~ ^(no|n|N| ) ]]; then
	mount_partitions
else
	echo "成功跳过"
fi
install_baseSystem #安装系统
generate_fstab  #设置自动挂载
configure_system #配置时间地址
configure_hostname
configure_username
configrue_bootloader #安装引导
configrue_networkmanager #安装网络管理程序
shengka #声卡安装
xianka #显卡安装
desktop #桌面安装
}
###############################################################################################
update_mirrorlist(){
        tmpfile=$(mktemp --suffix=-mirrorlist)
        url="https://www.archlinux.org/mirrorlist/?country=CN&protocol=http&protocol=https&ip_version=4"
        curl -so ${tmpfile} ${url}
        sed -i 's/^#Server/Server/g' ${tmpfile}
        mv -f ${tmpfile} /etc/pacman.d/mirrorlist;
        pacman -Syy --noconfirm
}

Network_check()
{
    #超时时间
    local timeout=1
    #目标网站
    local target=www.baidu.com
    #获取响应状态码
    local ret_code=`curl -I -s --connect-timeout ${timeout} ${target} -w %{http_code} | tail -n1`
    if [ "x$ret_code" = "x200" ]; then
        #网络畅通
        echo -e "\033[36mNetwork: connected \033[0m"
    else
        #网络不畅通
	echo -e "\033[31m The network is not smooth, please check the network settings \033[0m"
    fi
    return 0
}
whyroot(){
	if [ `whoami` == "root" ]; then					#判断是否是超级管理员运行
		echo "you system is:root"
		return 1
	else 
		echo "Please log in as root ！"
		return 0
fi
}
judge_bios()
{
ls /sys/firmware/efi/efivars >/dev/null 2>&1
if test $? != 0 ;then	
	echo "you is BIOS"
	grub="BIOS"
else
	echo "you is UEFI"
	grub="UEFI"

fi
}
disk_delete()
{
read -r -p "选择你要删除的盘 /dev/sdx (a/b/?)" disk
disk="/dev/sd$disk"
while true
do
	parted $disk print
	read -r -p "请输入要删除的分区编号 (例:1/2/3)" number
	parted $disk rm $number
	read -r -p "是否继续删除分区？ (Y/N)" judge
	if [[ $judge =~ ^(no|n|N| ) ]]; then
	echo "成功跳过"
	break
	fi
done
}
mount_partitions(){
read -r -p "选择你要挂载的盘 /dev/sdx (a/b/?)" disk
disk=/dev/sd$disk
lsblk
read -r -p "请输入你的root分区/dev/sdax (例:1/2/3)" number
mount $disk$number /mnt
mkdir /mnt/boot
read -r -p "请输入你的引导分区/dev/sdax (例:1/2/3)" number
mount $disk$number /mnt/boot
read -r -p "请输入你的交换分区/dev/sdax (例:1/2/3)" number
mkswap $disk$number
lsblk
}
disk()
{
lsblk
read -r -p "选择你要安装的盘 /dev/sdx (a/b/?)" disk
disk="/dev/sd$disk"
read -r -p "分区表你想选择什么 （MBR=msdos/GPT=gpt)" rota
echo "parted -s $disk mklabel  $rota"
parted -s $disk mklabel  $rota
read -r -p "引导分区:起始位置 结束位置 （例:1m 525m）" start end
parted -s $disk mkpart primary ext4 $start $end
read -r -p "交换分区:起始位置 结束位置 （例:525m 4800m)" start end
parted -s $disk mkpart primary linux-swap $start $end
read -r -p "root分区:起始位置 结束位置  (例:4800m 100%)" start end
parted -s $disk mkpart primary ext4 $start $end
read -r -p "如有剩余空间,是否将余下空间分为一个？(Y/N)" judge
if [[ $judge =~ ^(yes|y|Y| ) ]]; then
parted -s $disk mkpart primary ntfs $end 100%
parted -s $disk print
else
parted -s $disk print
fi
}
format_partitions(){
read -r -p "选择你要格式化的盘 /dev/sdx (例:a/b/c)" disk
disk=/dev/sd$disk
read -r -p "请输入你的root分区/dev/sdax (例:1/2/3)" number
mkfs.ext4 $disk$number
mount $disk$number /mnt
mkdir /mnt/boot
read -r -p "请输入你的引导分区/dev/sdax (例:1/2/3)" number
mkfs.vfat -F32 $disk$number
mount $disk$number /mnt/boot
read -r -p "请输入你的交换分区/dev/sdax (例:1/2/3)" number
mkswap $disk$number
swapon $disk$number
lsblk
}
arch_chroot() {
        arch-chroot /mnt /bin/bash -c "${1}"
}
install_baseSystem(){
	echo "开始安装系统"
	pacstrap /mnt base base-devel linux linux-firmware wqy-zenhei ttf-dejavu wqy-microhei adobe-source-code-pro-fonts
	pacman -Syu
}
generate_fstab(){
	echo "设置自动挂载"
        genfstab -U /mnt >> /mnt/etc/fstab
}
configure_system(){
        echo "配置系统时间,地区和语言"
        arch_chroot "ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime"
        arch_chroot "hwclock --systohc --utc"
        arch_chroot "mkinitcpio -p linux"
        echo "en_US.UTF-8 UTF-8" >> /mnt/etc/locale.gen
        echo "zh_CN.UTF-8 UTF-8" >> /mnt/etc/locale.gen
        arch_chroot "locale-gen"
        echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf
}
configure_hostname(){
read -p "Hostname [ex: archlinux]: " host_name
echo "$host_name" > /mnt/etc/hostname
arch_chroot "sed -i '/127.0.0.1/s/$/ '${host_name}'/' /etc/hosts"
arch_chroot "sed -i '/::1/s/$/ '${host_name}'/' /etc/hosts"
arch_chroot "passwd"
  }
configure_username(){
	read -r -p "请输入你的计算机名:" host_name
	echo ${host_name} > /etc/hostname
}
configrue_bootloader(){
	if [[ \${grub_new} == "BIOS" ]] ;then
		arch_chroot "pacman -S --noconfirm grub -y"
		arch_chroot "pacman -S --noconfirm efibootmgr dosfstools os-prober"
		arch_chroot "grub-install --target=i386-pc $disk"
	else
		arch_chroot "grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=boot" #(efi引导)
fi
arch_chroot "grub-mkconfig -o /boot/grub/grub.cfg"
}
#安装网络管理程序
configrue_networkmanager(){
	arch_chroot "pacman -S --noconfirm iw wireless_tools wpa_supplicant dialog netctl networkmanager networkmanager-openconnect rp-pppoe network-manager-applet net-tools -y"
	arch_chroot "systemctl enable NetworkManager.service"
}
shengka(){
	    # 安装声卡驱动
	    echo
	    echo -e "\033[45;37m INSTALL ALSA-UTILS \033[0m"
	    arch_chroot pacman -S --noconfirm alsa-utils
}
xianka(){
	    # 安装显卡驱动
	    echo
	    echo -e "\033[45;37m INSTALL GRAPHICS DRIVER \033[0m"
	    pci_intel=`lspci -k | grep -A 2 -E "(VGA|3D)" | awk '/Intel/{print NR}'`
	    pci_amd=`lspci -k | grep -A 2 -E "(VGA|3D)" | awk '/AMD/{print NR}'`
	    pci_nvidia=`lspci -k | grep -A 2 -E "(VGA|3D)" | awk '/NVIDIA/{print NR}'`
	    if ! [[ -z ${pci_intel} ]] ; then
	        arch_chroot pacman -S --noconfirm install-ucode
	        echo "Intel graphics driver installed"
	    fi
	    if ! [[ -z ${pci_amd} ]] ; then
	        arch_chroot pacman -S --noconfirm amd-ucode
	        echo "AMD graphics driver installed"
	    fi
	    if ! [[ -z ${pci_nvidia} ]] ; then
	        arch_chroot pacman -S --noconfirm nvidia-ucode
	        echo "NVIDIA graphics driver installed"
	    fi
}
desktop(){
 -e "
======================desktop=====================
||     1 dwm: Pure Edition                      ||
||     2 dwm: Personal modified version         ||
||     3 GNOME+GDM: Pure Edition                ||
||     4 KDE+SDDM:  Pure Edition                ||
||     5 GNOME+GDM: Personal modified version   ||
||     6 KDE+SSDM: Personal modified version    ||
==================================================
"
read -r -p "选择你想要安装的桌面编号：(例:1/2/3/4/5)" desktop
if [$desktop = 1] ;then
	arch_chroot
elif [$desktop = 2] ;then
	arch_chroot
elif [$desktop = 3] ;then
	arch_chroot
elif [$desktop = 4] ;then
	arch_chroot pacman -S --noconfirm xorg
	arch_chroot pacman -S --noconfirm plasma sddm konsole dolphin kate ark okular spectacle yay
	arch_chroot systemctl enable sddm
elif [$desktop = 5] ;then
	arch_chroot
elif [$desktop = 6] ;then
	arch_chroot 
else 
	echo "抱歉暂未开发"
fi
}
#man
###############################################################################################
pass