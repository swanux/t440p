# Information

This guide is compatible with Linux/Mac systems. Follow the steps below.

**Note:** I'm using some less common methods to make it work, so even if you've done it many times, it worth to follow the instructions step-by-step

**ATTENTION:** I am NOT responsible for any harm you cause to your device. This guide is provided "as-is" and all steps taken are done at your own risk.

### What works:
- Power management/sleep
- Brightness/Volume Control
- Battery Information
- Audio (everything)
- USB Ports, Built-in Camera, DisplayPort
- Graphics Acceleration
- FaceTime/iMessage
- DVD Drive
- Automatic OS updates
- Trackpoint/Touchpad (gestures and scrolling included)
- Dock USB ports
- Dock DisplayPorts, HDMI, DVI and VGA

### Known problems:
- Ultra Dock problems (sleep/shutdown causes kernel panic and reboot when docked) Also for some people there may be sleep problems even without external display.
- WiFi and Bluetooth
- SD card reader

### Fixes / Workarounds:

##### WiFi and Bluetooth
- For WiFi/Bluetooth you have to buy a macOS compatible network card (or you can use USB adapters). Otherwise you can check this guide (I can confirm, it works) -> [Check here](https://notthebe.ee/2019/06/11/airport/)
- You'll need to have an unlocked BIOS -> [Check here](https://notthebe.ee/2020/06/17/Removing-the-Wi-Fi-Whiteslit-on-Haswell-Thinkpads-T440p-W540-T540-etc/) (or ask for help on bios mods, Dudu2002 recommended)

##### Dock problems
- Use your mini DP instead of the dock's display output. Keep your dock's display output free. Reference [here](/../../issues/1#issuecomment-660651049)
- To fix sleep problems when no external display is attatched to the dock, check [here](https://github.com/swanux/t440p/issues/2#issuecomment-667629213)

### Dependencies
* p7zip
* python
* bash
* git
* 10GB or bigger USB drive
* Android phone with USB cable (or compatible network card)

# Create bootable USB

### Preparation
* Make sure you have all the mentioned dependencies, then [download](https://github.com/swanux/t440p/releases) the latest release.
* Also make sure that you've enough free space and a good internet connection

### Follow the steps below
1. Plug in your USB drive
2. Go into the downloaded folder, and execute `./macos_usb.sh`
3. During execution after download you need to provide the name of your USB device from a list. **Pay attention to it's size!**
4. Wait until script executes
5. Identify the EFI partition of your USB stick (ie. with `lsblk`, usually it's 200M') **Note:** usually it's mounted automatically, it's name is `USB_EFI`
6. Mount it with: `sudo mount /dev/sd? /mnt/` on Linux (**only if needed**)
7. Extract GenSMBIOS, open a terminal, cd into its folder and execute `./GenSMBIOS.command`
8. **IMPORTANT!** Decide which EFI version would you like to use.
    - AirportNetworkCard: You have an Apple Airport card with an adapter built in
    - Debug: You would like to see debug information (it has everything inside it)
    - OtherNetworkCard: You have neither airport nor intel card
    - USBTethering: You have no macOS compatible card, but you have a smartphone to share internet
9. Choose option **2**, then drag the **Config.plist** from the chosen **EFI** folder into the terminal.
10. Choose option **3**, and type `MacbookPro11,1 1`. When ready, press `q` to exit. **Note:** If you need more explanation, check the PDF file.
11. Copy **EFI** folder and **SoundFix.zip** file to the root directory of `USB_EFI`
12. Unmount the USB drive and unplug it

# Installation

### Prepare BIOS

The bios must be properly configured prior to installing MacOS.

In Security menu, set the following settings:
* `Security > Security Chip`: must be **Disabled**
* `Memory Protection > Execution Prevention`: must be **Enabled**
* `Internal Device Access > Bottom Cover Tamper Detection`: must be **Disabled**
* `Anti-Theft > Current Setting`: must be **Disabled**
* `Anti-Theft > Computrace > Current Setting`: must be **Disabled**
* `Secure Boot > Secure Boot`: must be **Disabled**

In Startup menu, set the following options:
* `UEFI/Legacy Boot`: **Both**
* `UEFI/Legacy Priority`: **UEFI First**
* `CSM Support`: **Yes**

Now you can go through the install.

### Install macOS (High Sierra/Mojave/Catalina)

1. Now, boot from USB and select the USB drive inside of OpenCore. (named **macOS Base System**)
	- **Note:** First boot may take up to 20 minutes
2. While booting, connect your phone via USB and turn on USB Tethering (skip if you have proper network card) **Note** If you are using your phone, do not forget to use `EFI_DEBUG`
3. Wait for macOS Utilities screen.
4. Select **Disk Utility**, select your disk, click erease, give a name and choose **APFS** with **GUID Partition Map**.
5. After done, go back, and select **Reinstall macOS**. Wait for downloading. After the it is ready, you can unplug your phone. (in case you used it)
6. After this is done, reboot the computer and let it sit. It will take a **lots** of time.
7. Once you see the `Region selection` screen, you are good to proceed.
8. Create your user account and everything else.
9. After you've booted, press **Alt+Space**, write in **settings** then press enter. Click on **Trackpad**, and **uncheck Force Click and haptic feedback**. Now your trackapd works fine.
10. **Alt+Space** again, and open **terminal**. Type `sudo diskutil mountDisk disk0s1` (where disk0s1 corresponds to the EFI partition of the main disk with the new macOS install)
11. Open Finder and copy **EFI** folder from `USB_EFI` partition to the main disk's `EFI` partition.
12. Copy **SoundFix.zip** to your Desktop and extract it. Then open the folder in terminal and run `bash install.sh` to install it. After it's done, you can delete the files if you wish.
13. Unplug the USB drive and reboot your laptop. Now you can enjoy your working installation! Optionally follow the rest of the guide.

<!--# Post-Installation-->

<!--### SD Card Reader-->

<!--0. Install Prefs Editor from [here](https://files.tempel.org/Various/OSX_Prefs_Editor/PrefsEditor.zip)-->
<!--1. Open Finder and Go to S/L/E (System/Library/Extensions) and look for **AppleStorageDriver.kext** and copy this kext to Desktop-->
<!--2. Right Click in AppleStorageDriver.kext located at Desktop and select **Show Package Contents** and navigate to **Contents > Plugins > Then find AppleUSBCardReader.kext**-->
<!--3. Right Click on AppleUSBCardReader.kext and select **Show package Contents**.-->
<!--4. Navigate to **Contents** and you'll find **Info.plist**-->
<!--5. Right Click on Info.plist and open with Xcode or Prefs Editor to edit a file.-->
<!--6. Find **IOKitPersonalities > AppleSDCardReader** and set `Physical Interconnect Location` from `USB` to `External`.-->
<!--7. Find **Apple_Internal_SD_Card_Reader_1_00** and set `Physical Interconnect` from `USB` to `External`. Then convert `idProduct` and `idVenedor` **to** Decimal **from** Hex [here](https://www.binaryhexconverter.com/hex-to-decimal-converter "here").-->
<!--8. Find **Apple_Internal_SD_Card_Reader_2_00** and set `Physical Interconnect Location` from `USB` to `External`. Then set `idProduct` and `idVenedor` to the **same, Decimal** value as in the previous step.-->
<!--9. **Rename** extension of original AppleStorageDriver.kext to **AppleStorageDriver.kext.old**-->
<!--10. **Save** the edited file and copy AppleStorageDriver.kext and paste it into /System/Library/Extensions/.-->
<!--11. Open Terminal and fix permission and rebuild the kernel cache with the following commands :-->
<!--```-->
<!--sudo mount -uw /-->
<!--sudo chmod -R 755 /System/Library/Extensions/-->
<!--sudo chown -R root:wheel /System/Library/Extensions/-->
<!--sudo touch /System/Library/Extensions && sudo touch /Library/Extensions && sudo kextcache -u /-->
<!--```-->
<!--12. Reboot and enjoy working memory card!-->

# Optional fixes/modifications

### All Fn Keys

You can use [this](https://github.com/MSzturc/ThinkpadAssistant/releases) program to make everything perfect. By default volume & brightness controlls are working, with this application everything works.

### FHD Screen

If you have done the full HD (1920x1080) screen mod, it is recommended that you install [One Key HiDPI](https://github.com/xzhih/one-key-hidpi "One Key HiDPI").  This will mimic the "retina" display feature that many of Apple's newer laptops come with.

### UltraBay HDD (In case it doesn't work by default')

If you are using a HDD or SSD in place of the normal optical drive, you will need to install AHCIPortInjector.kext and AppleAHCIPort.kext into `Library/Extensions`.

`AHCIPortInjector.kext` fixes the `Disk not initialized` issue (disk cannot be read). `AppleAHCIPort.kext` fixes the disk being detected as an external drive (instead of internal).

### Customizing About This Mac

1. Open a Finder window, select `Go` from the menu bar and choose `Go to Folder`. Enter `~/Library/Preferences` and click `Go`.
2. Locate the file named `com.apple.SystemProfiler.plist`. Create two duplicates of this file, placing one of them in your **Originals** folder and the other in your **Modified** folder.
3. Navigate to your **Modified** folder and open `com.apple.SystemProfiler.plist` using a text editor of your choice.
4. Within this file, locate a string matching the model of Mac which is currently displayed in the 'About This Mac' window and replace it with any text of your choice. For example, 'iMac (Retina 5K, 27-inch, Late 2015)' becomes 'ThinkPad T440p (13-inch, 2014)'.
5. When all desired changes have been made, select the `File` menu and choose **Save**.
6. Return to `~/Library/Preferences` and copy the `com.apple.SystemProfiler.plist` file from your **Modified** folder into this directory. Enter your password when prompted and then click `Replace`.

# Credits

Many thanks to:
* [OpenCore Team](https://github.com/acidanthera/OpenCorePkg) - For this great open-source bootloader
* [Dortania](https://dortania.github.io/OpenCore-Install-Guide/) - For this excellent guide
* [tonymacx86](https://www.tonymacx86.com/) - For the lots of avilable knowledge (even though they're banning with no reason sometimes)
* [notthebee](https://github.com/notthebee) - For lots of support for ThinkPads
* [jloisel](https://github.com/jloisel) - For his Clover configuration
* [Google](https://google.com) - For finding answers from various segments of the internet (even though they're stealing user data)

# Feedbacks
Did you find any bugs? Do you have some feature requests/new ideas? Or just some questions? Feel free to provide your feedback using [hsuite](https://github.com/swanux/hsuite) or my [website](https://swanux.github.io/feedbacks.html).
