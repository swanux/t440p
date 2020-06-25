# Information

This guide is compatible with Linux/Mac systems. Follow the steps below.
**Note:** I am NOT responsible for any harm you cause to your device. This guide is provided "as-is" and all steps taken are done at your own risk.

### What works:
- Power management/sleep
- Brightness/Volume Control
- Battery Information
- Audio (from internal speaker, dock and headphone jack) (?)
- USB Ports, Built-in Camera
- Graphics Acceleration
- FaceTime/iMessage
- Automatic OS updates
- Trackpoint/Touchpad (gestures and scrolling included)
- Dock USB & Display ports

### Known problems:
- Ultra Dock problems (sleep/shutdown causes kernel panic and reboot when docked)
- WiFi and Bluetooth

### Solutions/Fixes:
- For WiFi/Bluetooth you have to buy a macOS compatible network card (or you can use USB adapters). Otherwise you can check this guide (not sure if it works) -> [Check here](https://notthebe.ee/2019/06/11/airport/)
- You'll need to have an unlocked BIOS -> [Check here](https://notthebe.ee/2020/06/17/Removing-the-Wi-Fi-Whiteslit-on-Haswell-Thinkpads-T440p-W540-T540-etc/) (or ask for help on bios mods, Dudu2002 recommended)

### Dependencies
* p7zip
* python
* bash
* git
* 16GB or bigger USB drive

# Create bootable USB

## Preparation
* Make sure you have all the mentioned dependencies, then clone/download this repository.
* Also make sure that you've enough free space and a good internet connection

## Follow the steps below
1. Plug in your USB drive, and identify it (ie. with `lsblk`)
2. Go into the downloaded folder, and execute `macos_usb.sh`
3. Wait until script executes
4. Identify the EFI partition of your USB stick (again with `lsblk`, usually it's 200MB')
5. Mount it with: `sudo mount /dev/sd? /mnt/` on Linux
6. Copy EFI folder from this repo to /mnt/
7. Unmount EFI partition : `sudo umount /mnt/` on Linux
8. Unmount the USB drive and unplug it

# Install macOS (Mojave/Catalina)

1. After you followed the guide above and have your USB drive ready to go, we can reboot the machine. When you reboot, enter into the BIOS to change some settings. On the T440p, you can do this by hitting `Enter` at the Lenovo boot screen.
2. Once in the BIOS, make sure you change the following settings. `Disable Security Chip`, `Disable Anti Theft Module`, and `Disable TPM`. Basically, disable all of the "security" features. Make sure Secure boot and other features like that are off. These features will affect how macOS sleeps.
3. Now, reboot into macOS and select the USB drive inside of OpenCore.
4. Boot into macOS and install onto your hard drive. I recommend using an SSD.
5. After this is done, reboot the computer and let it sit. Mine rebooted a few times on its own to go through some final installation procedures.
6. Once you see the "region selection" screen, you are good to proceed.
7. Create your user account and everything else, but do not sign in with your iCloud account. If it asks you to connect to a network, select the option that says do not connect and press continue. We will connect it later.
8. After you've booted, copy the EFI folder from the USB drive to the system EFI partition

# Post-Installation/Optional fixes

### FHD Screen

If you have done the full HD (1920x1080) screen mod , it is recommended that you install [One Key HiDPI](https://github.com/xzhih/one-key-hidpi "One Key HiDPI").  This will mimic the "retina" display feature that many of Apple's newer laptops come with.

### UltraBay HDD (In case it doesn't work by default')

If you are using a HDD or SSD in place of the normal optical drive, you will need to install AHCIPortInjector.kext and AppleAHCIPort.kext into `Library/Extensions`.

`AHCIPortInjector.kext` fixes the `Disk not initialized` issue (disk cannot be read). `AppleAHCIPort.kext` fixes the disk being detected as an external drive (instead of internal).

### Setting up Apple services (In case they don't work by default')
I recommend following [This guide](https://www.tonymacx86.com/threads/an-idiots-guide-to-imessage.196827/) to get these features working.

### Getting audio working

In order to get audio to work, there are a few simple steps we need to follow. This has been tested and working on High Sierra and Catalina. Special Thanks to this guide [Here](https://www.tonymacx86.com/threads/guide-lenovo-thinkpad-t440p.233282/) for help in getting this to work. By default, speaker audio should work, but audio via the headhpone jack does not. Follow the steps below to get it working.


1. First, copy the .zip file called `alc_fix.zip` inside the foldr `Audio Stuff` to the desktop.
2. Open terminal and type `cd desktop/alc_fix`, then hit enter.
3. Then, type `./install.sh` and press enter.
4. The provided `config.plist` has already been configured to inject *Audio Layout* ID `28`. This enables the headphone jack to work.
5. Restart and enjoy your audio from the headphone jack!

### Customizing About This Mac

In order to customize the About This Mac section, I recommend you follow the guide [Here](https://github.com/Haru-tan/Hackintosh-Things/blob/master/AboutThisMacMojave.md "Here").
