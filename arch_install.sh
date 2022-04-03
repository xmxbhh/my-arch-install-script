###############################################################################################
pass()
{
#whyroot			#判断是不是root
#Network_check #网络流畅判断
judge_bios #判断是bios还是uefi
update_mirrorlist #更新源
read -r -p "Delete partition  （Y/N）" judge
if [[ $judge =~ ^(no|n|N| ) ]]; then
	disk_delete
else
	echo "good"
fi
read -r -p "Create partition  （Y/N）" judge
if [[ $judge =~ ^(no|n|N| ) ]]; then
	disk
else
	echo "good"
fi
read -r -p "Format and mount the partition  （Y/N）" judge
if [[ $judge =~ ^(no|n|N| ) ]]; then
	format_partitions
else
	mount_partitions
fi
install_baseSystem #安装系统
generate_fstab  #设置自动挂载
configure_system #配置时间地址
configure_hostname
configure_username
user_passwd
desktop #桌面安装
configrue_bootloader #安装引导
configrue_networkmanager #安装网络管理程序
shengka #声卡安装
xianka #显卡安装
shezhi #通用配置
general_software #通用软件安装
}
###############################################################################################
shezhi()
{
	echo "[archlinuxcn]
	SigLevel = Never
	Server = http://mirrors.163.com/archlinux-cn/\$arch" >> /mnt/etc/pacman.conf
	echo 'Server = http://mirrors.163.com/archlinux/$repo/os/$arch' >> /mnt/etc/pacman.d/mirrorlist

cat >> /mnt/etc/sudoers <<- EOF
## sudoers file.
##
## This file MUST be edited with the 'visudo' command as root.
## Failure to use 'visudo' may result in syntax or file permission errors
## that prevent sudo from running.
##
## See the sudoers man page for the details on how to write a sudoers file.
##
##
## Host alias specification
##
## Groups of machines. These may include host names (optionally with wildcards),
## IP addresses, network numbers or netgroups.
# Host_Alias	WEBSERVERS = www1, www2, www3
##
## User alias specification
##
## Groups of users.  These may consist of user names, uids, Unix groups,
## or netgroups.
# User_Alias	ADMINS = millert, dowdy, mikef
##
## Cmnd alias specification
##
## Groups of commands.  Often used to group related commands together.
# Cmnd_Alias	PROCESSES = /usr/bin/nice, /bin/kill, /usr/bin/renice, \
# 			    /usr/bin/pkill, /usr/bin/top
# Cmnd_Alias	REBOOT = /sbin/halt, /sbin/reboot, /sbin/poweroff
##
## Defaults specification
##
## You may wish to keep some of the following environment variables
## when running commands via sudo.
##
## Locale settings
# Defaults env_keep += "LANG LANGUAGE LINGUAS LC_* _XKB_CHARSET"
##
## Run X applications through sudo; HOME is used to find the
## .Xauthority file.  Note that other programs use HOME to find   
## configuration files and this may lead to privilege escalation!
# Defaults env_keep += "HOME"
##
## X11 resource path settings
# Defaults env_keep += "XAPPLRESDIR XFILESEARCHPATH XUSERFILESEARCHPATH"
##
## Desktop path settings
# Defaults env_keep += "QTDIR KDEDIR"
##
## Allow sudo-run commands to inherit the callers' ConsoleKit session
# Defaults env_keep += "XDG_SESSION_COOKIE"
##
## Uncomment to enable special input methods.  Care should be taken as
## this may allow users to subvert the command being run via sudo.
# Defaults env_keep += "XMODIFIERS GTK_IM_MODULE QT_IM_MODULE QT_IM_SWITCHER"
##
## Uncomment to use a hard-coded PATH instead of the user's to find commands
# Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
##
## Uncomment to send mail if the user does not enter the correct password.
# Defaults mail_badpass
##
## Uncomment to enable logging of a command's output, except for
## sudoreplay and reboot.  Use sudoreplay to play back logged sessions.
# Defaults log_output
# Defaults!/usr/bin/sudoreplay !log_output
# Defaults!/usr/local/bin/sudoreplay !log_output
# Defaults!REBOOT !log_output
##
## Runas alias specification
##
##
## User privilege specification
##
root ALL=(ALL) ALL
## Uncomment to allow members of group wheel to execute any command
%wheel ALL=(ALL) ALL
## Same thing without a password
# %wheel ALL=(ALL) NOPASSWD: ALL
## Uncomment to allow members of group sudo to execute any command
# %sudo	ALL=(ALL) ALL
## Uncomment to allow any user to run sudo if they know the password
## of the user they are running the command as (root by default).
# Defaults targetpw  # Ask for the password of the target user
# ALL ALL=(ALL) ALL  # WARNING: only use this together with 'Defaults targetpw'
## Read drop-in files from /etc/sudoers.d
## (the '#' here does not indicate a comment)
#includedir /etc/sudoers.d
EOF

cat >> /mnt/etc/environment <<- EOF
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US
EOF

}
general_software(){
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm archlinuxcn-keyring"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm chromium"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm vlc"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm gvfs"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm gimp"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm kdenlive"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm firefox firefox-i18n-zh-cn"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm tor"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm telegram-desktop"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm virtualbox"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm python"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm python-pip"
	arch-chroot /mnt /bin/bash -c  "pip install  dbus-python"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm gedit"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm vim"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm git"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm alsa-utils"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm fcitx5 fcitx5-qt fcitx5-gtk fcitx5-configtool fcitx5-rime"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm neofetch"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm  wqy-microhei"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm yay"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm zip"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm nmap"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm v2ray qv2ray"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm wget"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm netease-cloud-music"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm  ntfs-3g gvfs-mtp gvfs"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm pavucontrol"
	arch-chroot /mnt /bin/bash -c  "yay -S --noconfirm wps-office"
	arch-chroot /mnt /bin/bash -c  "yay -S --noconfirm wps-office-mui-zh-cn"
	arch-chroot /mnt /bin/bash -c  "yay -S --noconfirm ttf-wps-fonts"
	arch-chroot /mnt /bin/bash -c  "yay -S --noconfirm redshift"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm screenkey"
	arch-chroot /mnt /bin/bash -c  "yay -S --noconfirm openssh"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm neovim"
	echo 'PermitRootLogin yes' >> /mnt/etc/ssh/sshd_config
	arch-chroot /mnt /bin/bash -c  "systemctl enable sshd.service"    #自启动ssh
	arch-chroot /mnt /bin/bash -c  "yay -S --noconfirm iwd"
	arch-chroot /mnt /bin/bash -c  "systemctl enable iwd.service"    #自启动iwdwifi连接器
}
update_mirrorlist(){
echo 'Server = http://mirrors.163.com/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist
echo "[archlinuxcn]
SigLevel = Never
Server = http://mirrors.163.com/archlinux-cn/\$arch" >> /etc/pacman.conf
        pacman -Sy archlinuxcn-keyring --noconfirm
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
read -r -p "Delete disk  /dev/sdx (a/b/?)" disk
disk="/dev/sd$disk"
while true
do
	parted $disk print
	read -r -p "Delete partition number  (例:1/2/3)" number
	parted $disk rm $number
	read -r -p "Continue to delete partition？ (Y/N)" judge
	if [[ $judge =~ ^(no|n|N| ) ]]; then
	echo "good"
	break
	fi
done
}
mount_partitions(){
lsblk
read -r -p "Select mount disk  /dev/sdx (a/b/?)" disk
disk=/dev/sd$disk
lsblk
read -r -p "Please enter your root partition /dev/sdax (例:1/2/3)" number
mount $disk$number /mnt
mkdir /mnt/boot
read -r -p "Please enter your boot partition /dev/sdax (例:1/2/3)" number
mount $disk$number /mnt/boot
read -r -p "Please enter your swap partition /dev/sdax (例:1/2/3)" number
mkswap $disk$number
lsblk
}
disk()
{
lsblk
read -r -p "select install disk /dev/sdx (a/b/?)" disk
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
lsblk
read -r -p "选择你要格式化的盘 /dev/sdx (例:a/b/c)" disk
disk="/dev/sd$disk"
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
install_baseSystem(){
	echo "Start Install system "
	pacstrap /mnt base base-devel linux linux-firmware 
	pacman -Syy
}
generate_fstab(){
	echo "Automount"
        genfstab -U /mnt >> /mnt/etc/fstab
}
configure_system(){
        echo "配置系统时间,地区和语言"
        arch-chroot /mnt /bin/bash -c "ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime"
        arch-chroot /mnt /bin/bash -c  "hwclock --systohc --utc"
        arch-chroot /mnt /bin/bash -c  "mkinitcpio -p linux"
        echo "en_US.UTF-8 UTF-8" >> /mnt/etc/locale.gen
        echo "zh_CN.UTF-8 UTF-8" >> /mnt/etc/locale.gen
        arch-chroot /mnt /bin/bash -c  "locale-gen"
        echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf
}
configure_hostname(){
read -p "Hostname [ex: archlinux]: " host_name
if [ -z "${host_name}" ];then
	host_name=archlinux
fi
echo "$host_name" > /mnt/etc/hostname
arch-chroot /mnt /bin/bash -c  "sed -i '/127.0.0.1/s/$/ '${host_name}'/' /etc/hosts"
arch-chroot /mnt /bin/bash -c  "sed -i '/::1/s/$/ '${host_name}'/' /etc/hosts"
  }
configure_username(){
	read -r -p "USERname [ex: archlinux]:" user_name
	if [ -z "${user_name}" ];then
		user_name=archlinux
	fi
	echo ${user_name} > /etc/hostname
}
user_passwd(){
	read -r -p "Please enter your ROOT password:" user_passwd
	arch-chroot /mnt /bin/bash -c "echo root:${user_passwd} | chpasswd"
	read -r -p "Whether to add a new user？  （Y/N）" judge
	#if [[ $judge =~ ^(yes|y|Y| ) ]]; then
		#read -r -p "Please enter your user name:" new_user_name
		#arch-chroot /mnt /bin/bash -c "useradd -m -g users -G wheel -s /bin/bash ${new_user_name}"
		#read -r -p "Please enter your $user password:" user_passwd
		#arch-chroot /mnt /bin/bash -c "echo ${new_user_name}:${user_passwd} | chpasswd"
	#else
		#echo "good"
	#fi
}
configrue_bootloader(){
	if [[ ${grub} == "BIOS" ]] ;then
		arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm grub -y"
		arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm efibootmgr dosfstools os-prober"
		arch-chroot /mnt /bin/bash -c  "grub-install --target=i386-pc $disk"
	else
		arch-chroot /mnt /bin/bash -c  "grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=boot" #(efi引导)
fi
arch-chroot /mnt /bin/bash -c  "grub-mkconfig -o /boot/grub/grub.cfg"
}
#安装网络管理程序
configrue_networkmanager(){
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm iw wireless_tools wpa_supplicant dialog netctl networkmanager networkmanager-openconnect rp-pppoe network-manager-applet net-tools -y"
	arch-chroot /mnt /bin/bash -c  "systemctl enable NetworkManager.service"
}
shengka(){
	    # 安装声卡驱动
	    echo
	    echo -e "\033[45;37m INSTALL ALSA-UTILS \033[0m"
	    arch-chroot /mnt /bin/bash -c "pacman -S --noconfirm alsa-utils"
}
xianka(){
	    # 安装显卡驱动
	    echo
	    echo -e "\033[45;37m INSTALL GRAPHICS DRIVER \033[0m"
	    pci_intel=`lspci -k | grep -A 2 -E "(VGA|3D)" | awk '/Intel/{print NR}'`
	    pci_amd=`lspci -k | grep -A 2 -E "(VGA|3D)" | awk '/AMD/{print NR}'`
	    pci_nvidia=`lspci -k | grep -A 2 -E "(VGA|3D)" | awk '/NVIDIA/{print NR}'`
	    if ! [[ -z ${pci_intel} ]] ; then
	        arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm intel-ucode"
	        echo "Intel graphics driver installed"
			arch-chroot /mnt /bin/bash -c "mkdir /intel"
	    fi
	    if ! [[ -z ${pci_amd} ]] ; then
	        arch-chroot /mnt /bin/bash -c "pacman -S --noconfirm amd-ucode"
	        echo "AMD graphics driver installed"
			arch-chroot /mnt /bin/bash -c "mkdir /amd"
	    fi
	    if ! [[ -z ${pci_nvidia} ]] ; then
	        arch-chroot /mnt /bin/bash -c "pacman -S --noconfirm nvidia-ucode"
	        echo "NVIDIA graphics driver installed"
			arch-chroot /mnt /bin/bash -c "mkdir /nvidia"
	    fi
}
desktop(){
echo  "======================desktop====================="
echo  "||     1 dwm: Pure Edition                      ||"
echo  "||     2 dwm: Personal modified version         ||"
echo  "||     3 GNOME+GDM: Pure Edition                ||"
echo  "||     4 KDE+SDDM:  Pure Edition                ||"
echo  "||     5 GNOME+GDM: Personal modified version   ||"
echo  "||     6 KDE+SSDM: Personal modified version    ||"
echo  "||     7 xfce+lightdm: Personal modified version||"
echo  "=================================================="
read -r -p "Select the desktop：(例:1/2/3/4/5/6/7)" desktop
case $desktop in
	1)
	arch-chroot /mnt /bin/bash -c "sudo pacman -S  --noconfirm xorg xorg-server xorg-xinit xorg-apps"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm git"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm thunar"
	arch-chroot /mnt /bin/bash -c "sudo git clone https://git.suckless.org/dwm /mydwm/dwm"
	arch-chroot /mnt /bin/bash -c "sudo git clone https://git.suckless.org/st /mydwm/st"
	arch-chroot /mnt /bin/bash -c "sudo git clone https://git.suckless.org/dmenu /mydwm/dmenu"
	arch-chroot /mnt /bin/bash -c "cd /mydwm/dwm && make"
	arch-chroot /mnt /bin/bash -c "cd /mydwm/dwm && make clean install"
	arch-chroot /mnt /bin/bash -c "cd /mydwm/st && make"
	arch-chroot /mnt /bin/bash -c "cd /mydwm/st && make clean install"
	arch-chroot /mnt /bin/bash -c "cd /mydwm/dmenu && make"
	arch-chroot /mnt /bin/bash -c "cd /mydwm/dmenu && make clean install"
	echo "fcitx5 &" >> /mnt/root/.xinitrc
	echo 'exec dwm' >> /mnt/root/.xinitrc
	#echo 'fcitx5 &' >> /mnt/home/$new_user_name/.xinitrc
	#echo 'exec dwm' >> /mnt/home/$new_user_name/.xinitrc
	;;
	2)
	arch-chroot /mnt /bin/bash -c "pacman -S  --noconfirm xorg xorg-server xorg-xinit xorg-apps"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm rofi feh picom xfce4-power-manager"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm git"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm alacritty"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm thunar"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm nerd-fonts"
	arch-chroot /mnt /bin/bash -c  "pacman -S --noconfirm conky"
	#arch-chroot /mnt /bin/bash -c "git clone https://github.com/xmxbhh/new_mydwm.git/"
	arch-chroot /mnt /bin/bash -c "git clone https://gitee.com/zuilu/new_mydwm.git"
	arch-chroot /mnt /bin/bash -c  "cp -rf /new_mydwm/* /root"
	arch-chroot /mnt /bin/bash -c  "rm -rf /new_mydwm"
	arch-chroot /mnt /bin/bash -c  "cp -rf /root/config /root/.config && rm -rf /root/config"
	arch-chroot /mnt /bin/bash -c  "cd /root/dwm && make clean install"
	arch-chroot /mnt /bin/bash -c  "cd /root/st && make clean install"
	arch-chroot /mnt /bin/bash -c  "cp /root/.config/conky/conkyrc /root/.conkyrc && rm -rf /root/.config/conky"
	echo "fcitx5 &" >> /mnt/root/.xinitrc
	echo 'exec dwm' >> /mnt/root/.xinitrc
	;;
	3)
	arch-chroot /mnt /bin/bash -c "ls"
	;;
	4)
	arch-chroot /mnt /bin/bash -c "pacman -S --noconfirm xorg"
	arch-chroot /mnt /bin/bash -c "pacman -S --noconfirm plasma sddm konsole dolphin kate ark okular spectacle"
	arch-chroot /mnt /bin/bash -c "systemctl enable sddm"
	;;
	5)
	arch-chroot /mnt /bin/bash -c "ls"
	;;
	6)
	arch-chroot /mnt /bin/bash -c "ls"
	;;
	7)
	arch-chroot /mnt /bin/bash -c "pacman -S --noconfirm xorg"
	arch-chroot /mnt /bin/bash -c "pacman -S --noconfirm xfce4 xfce4-goodies"
	arch-chroot /mnt /bin/bash -c "pacman -S --noconfirm lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings"
	arch-chroot /mnt /bin/bash -c "systemctl enable lightdm"
	;; 
	*)
	echo "抱歉暂未开发"
	arch-chroot /mnt /bin/bash -c "ls"
	;;
esac
}
#man
###############################################################################################
pass
