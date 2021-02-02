#!/bin/bash
# Create a bootable macOS flash drive on Linux and macOS

# The script will terminate if any subsequent command fails
set -e

function checkdep {
	# check if running on Linux or macOS
	case "$OSTYPE" in
		"linux-gnu"|"darwin"*)
			;;
		*)
			echo "This script will only run on Linux or macOS!"
			exit 1
			;;
	esac

	# check for dependencies
	for n in python dmg2img; do
 		if ! $n --help &> /dev/null; then
			echo "Please install $n"
			exit 1
		fi
	done
}

function version {
	printf '
	Press a key to select the macOS version
	Press Enter to download latest release (default)
	[M]ojave (10.14)
	[C]atalina (10.15)
	[B]ig Sur (11)

	'
	read -n 1 -p "[M/C/B] " macOS_release_name 2>/dev/tty
	echo ""
}

function download {
	case $macOS_release_name in
		[Mm])
			python Tools/macrecovery/macrecovery.py -b Mac-7BA5B2DFE22DDD8C -m 00000000000KXPG00 download
			;;
		[Cc])
			python Tools/macrecovery/macrecovery.py -b Mac-00BE6ED71E35EB86 -m 00000000000000000 download
			;;
		[Bb])
			python Tools/macrecovery/macrecovery.py -b Mac-E43C1C25D4880AD6 -m 00000000000000000 download
			;;
		*)
			clear
			version
			;;
	esac
}

function partition {
	lsblk 2>/dev/null || diskutil list
	printf "\nEnter the path to your flash drive (e.g. /dev/sdb or /dev/disk3)"
	printf "\nDOUBLE CHECK THE EXACT PATH WITH lsblk or diskutil\n"
	read -p "USB device: " flashdrive
	# Check if user specified a USB device
	if [[ "$OSTYPE" == "linux-gnu" ]]; then
		usb="$(readlink /sys/block/$(echo ${flashdrive} | sed 's/^\/dev\///') | grep -o usb)"
	elif [[ "$OSTYPE" == "darwin"* ]]; then
		usb=$(diskutil list | grep -e ".*$flashdrive.*external")
	fi
	if [ -z "$usb" ]; then
		echo "WARNING! ${flashdrive} is NOT a USB device"
		echo "Are you sure you know what you're doing?"
		read -p " [Y/N] " answer 2>/dev/tty
		if [[ ! $answer =~ ^[Yy]$ ]]; then
			echo "Abort"
			exit 0
		fi
	fi
	# Allow "Not mounted" errors etc.
	set +e
	# Destroy the GPT and partition the drive anew 
	sudo umount ${flashdrive}*
	sudo sgdisk --zap-all ${flashdrive}
	sudo sgdisk -n 0:0:+200MiB -t 0:0700 ${flashdrive}
	sudo sgdisk -n 0:0:0 -t 0:af00 ${flashdrive}
	sudo mkfs.vfat -F 32 -n "USB_EFI" ${flashdrive}1
}

function burn {
	echo "Flashing the image"
	x=$(dmg2img -l BaseSystem.dmg | grep "disk image" | grep -o -E '[0-9]+' | head -c1)
	sudo dmg2img -p ${x} -i BaseSystem.dmg -o ${flashdrive}2 -v
}



checkdep
version
download
partition
burn

echo "Success!"
echo "Don't forget to copy the EFI folder to the USB drive!"
