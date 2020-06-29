#!/bin/bash

echo "Welcome to sd_patcher by swanux!"
echo ""
echo 'IMPORTANT!! Please make a backup of /System/Library/Extensions/AppleStorageDrivers.kext to somewhere safe (eg your Desktop) in case anything goes wrong.'
read -p "Press enter to begin..."

sudo mount -uw /
echo ""
echo "Patching plist file..."
echo ""
sudo plutil -replace IOKitPersonalities.AppleSDCardReader.Physical\ Interconnect -string External /System/Library/Extensions/AppleStorageDrivers.kext/Contents/PlugIns/AppleUSBCardReader.kext/Contents/Info.plist
sudo plutil -replace IOKitPersonalities.Apple_Internal_SD_Card_Reader_1_00.Physical\ Interconnect -string External /System/Library/Extensions/AppleStorageDrivers.kext/Contents/PlugIns/AppleUSBCardReader.kext/Contents/Info.plist
sudo plutil -replace IOKitPersonalities.Apple_Internal_SD_Card_Reader_2_00.Physical\ Interconnect -string External /System/Library/Extensions/AppleStorageDrivers.kext/Contents/PlugIns/AppleUSBCardReader.kext/Contents/Info.plist
orig=$(sudo plutil -extract IOKitPersonalities.Apple_Internal_SD_Card_Reader_1_00.idProduct xml1 -o - /System/Library/Extensions/AppleStorageDrivers.kext/Contents/PlugIns/AppleUSBCardReader.kext/Contents/Info.plist | grep "<integer>")
num1=$(echo $orig | grep -o -E '[0-9]+')
dec1=$(( 16#$num1 ))
echo $num1
echo $dec1
orig=$(sudo plutil -extract IOKitPersonalities.Apple_Internal_SD_Card_Reader_2_00.idProduct xml1 -o - /System/Library/Extensions/AppleStorageDrivers.kext/Contents/PlugIns/AppleUSBCardReader.kext/Contents/Info.plist | grep "<integer>")
num2=$(echo $orig | grep -o -E '[0-9]+')
dec2=$(( 16#$num2 ))
echo $num2
echo $dec2
orig=$(sudo plutil -extract IOKitPersonalities.Apple_Internal_SD_Card_Reader_1_00.idVendor xml1 -o - /System/Library/Extensions/AppleStorageDrivers.kext/Contents/PlugIns/AppleUSBCardReader.kext/Contents/Info.plist | grep "<integer>")
num3=$(echo $orig | grep -o -E '[0-9]+')
dec3=$(( 16#$num3 ))
echo $num3
echo $dec3
orig=$(sudo plutil -extract IOKitPersonalities.Apple_Internal_SD_Card_Reader_2_00.idVendor xml1 -o - /System/Library/Extensions/AppleStorageDrivers.kext/Contents/PlugIns/AppleUSBCardReader.kext/Contents/Info.plist | grep "<integer>")
num4=$(echo $orig | grep -o -E '[0-9]+')
dec4=$(( 16#$num4 ))
echo $num4
echo $dec4
echo "-----------------------"
echo $dec1
echo $dec3
sudo plutil -replace IOKitPersonalities.Apple_Internal_SD_Card_Reader_1_00.idProduct -integer $dec1 /System/Library/Extensions/AppleStorageDrivers.kext/Contents/PlugIns/AppleUSBCardReader.kext/Contents/Info.plist
sudo plutil -replace IOKitPersonalities.Apple_Internal_SD_Card_Reader_2_00.idProduct -integer $dec1 /System/Library/Extensions/AppleStorageDrivers.kext/Contents/PlugIns/AppleUSBCardReader.kext/Contents/Info.plist
sudo plutil -replace IOKitPersonalities.Apple_Internal_SD_Card_Reader_1_00.idVendor -integer $dec3 /System/Library/Extensions/AppleStorageDrivers.kext/Contents/PlugIns/AppleUSBCardReader.kext/Contents/Info.plist
sudo plutil -replace IOKitPersonalities.Apple_Internal_SD_Card_Reader_2_00.idVendor -integer $dec3 /System/Library/Extensions/AppleStorageDrivers.kext/Contents/PlugIns/AppleUSBCardReader.kext/Contents/Info.plist
echo ""
echo "Done!"
echo ""
echo "Updating kernel cache..."
echo ""
read -p "Press enter to begin..."
sudo chmod -R 755 /System/Library/Extensions/
sudo chown -R root:wheel /System/Library/Extensions/
sudo touch /System/Library/Extensions && sudo touch /Library/Extensions && sudo kextcache -u /
echo ""
echo "Done! Reboot and enjoy working memory card!"
echo ""
echo "If it still doesn't work, please delete the modified kext and replace with the one that you've backed up. After that, follow the manual process."