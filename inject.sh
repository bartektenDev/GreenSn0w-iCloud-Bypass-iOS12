

# @ios_euphoria GreenSn0w Injection Payload
# iOS 12 iCloud Bypass Tethered No Signal

#stop asking me if i want to fucking save the damn key
rm -rf ~/.ssh/known_hosts

# Change the current working directory
cd "`dirname "$0"`"

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" > /dev/null 2>&1
    echo ''
fi

# Check for sshpass, install if we don't have it
if test ! $(which sshpass); then
    echo "Installing sshpass..."
    brew install esolitos/ipa/sshpass > /dev/null 2>&1
    echo ''
fi

# Check for iproxy, install if we don't have it
if test ! $(which iproxy); then
    echo "Installing iproxy..."
    brew install libimobiledevice > /dev/null 2>&1
    echo ''
fi

sleep 1

echo ''

echo 'Starting iproxy...'

# Run iproxy in the background
iproxy 4444:44 > /dev/null 2>&1 &

sleep 2

while true ; do
  result=$(ssh -p 4444 -o BatchMode=yes -o ConnectTimeout=1 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@localhost echo ok 2>&1 | grep Connection)

  if [ -z "$result" ] ; then

echo "Mounting..."
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -p 4444 "root@localhost" 'mount -o rw,union,update /'
echo "Mounted!"

echo "Unlock Permissions 2 on skip setup file..."
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -p 4444 "root@localhost" 'chflags nouchg /private/var/mobile/Library/Preferences/com.apple.purplebuddy.plist'
echo "Unlocked Permissions 2 on skip setup file done!"

echo "Deleting (setup info) /private/var/mobile/Library/Preferences/com.apple.purplebuddy.plist..."
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -p 4444 "root@localhost" 'rm -rf /private/var/mobile/Library/Preferences/com.apple.purplebuddy.plist'
echo "Deleted (setup info) /private/var/mobile/Library/Preferences/com.apple.purplebuddy.plist!"

echo "Pushing skip setup file..."
sshpass -p 'alpine' scp -rP 4444 -o StrictHostKeyChecking=no ./uploadAFTER_ACTIVATION/com.apple.purplebuddy.plist root@localhost:/private/var/mobile/Library/Preferences/com.apple.purplebuddy.plist
echo "Pushed skip setup file!"

echo "Permissions 1 on skip setup file..."
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -p 4444 "root@localhost" 'chmod 755 /private/var/mobile/Library/Preferences/com.apple.purplebuddy.plist'
echo "Permissions on skip setup file done!"

echo "Permissions 2 on skip setup file..."
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -p 4444 "root@localhost" 'chflags uchg /private/var/mobile/Library/Preferences/com.apple.purplebuddy.plist'
echo "Permissions 2 on skip setup file done!"

echo "Unloading mobileactivationd service..."
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -p 4444 "root@localhost" 'launchctl unload /System/Library/LaunchDaemons/com.apple.mobileactivationd.plist'
echo "Unloaded mobileactivationd service!"
echo ""

echo "Deleting /private/var/root/Library/Lockdown/data_ark.plist..."
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -p 4444 "root@localhost" 'rm /var/root/Library/Lockdown/data_ark.plist'
echo "Deleted /var/root/Library/Lockdown/data_ark.plist!"

echo "Pushing new /var/root/Library/Lockdown/data_ark.plist..."
sshpass -p 'alpine' scp -rP 4444 -o StrictHostKeyChecking=no ./uploadAFTER_ACTIVATION/data_ark.plist root@localhost:/var/root/Library/Lockdown/data_ark.plist
echo "Pushed /var/root/Library/Lockdown/data_ark.plist!"

echo "Permissions 3..."
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -p 4444 "root@localhost" 'chmod 755 /var/root/Library/Lockdown/data_ark.plist'
echo "Permissions 3!"

echo "Permissions 4..."
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -p 4444 "root@localhost" 'chflags uchg /var/root/Library/Lockdown/data_ark.plist'
echo "Permissions 4!"

echo "Loading mobileactivationd..."
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -p 4444 "root@localhost" 'launchctl load /System/Library/LaunchDaemons/com.apple.mobileactivationd.plist'
echo "Loaded mobileactivationd!"
echo ""

echo "Shutting down device..."
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -p 4444 "root@localhost" 'shutdown -h now'
echo "Device is shutting down..."

#ideviceactivation state

# Kill iproxy
kill %1 > /dev/null 2>&1

echo 'Done!'

echo ''
osascript -e 'display alert "💉 Payload Injected!" message "Now boot into DFU mode and run checkra1n again. Then run Make it Sn0w to bypass iCloud lock."'
echo ''
sleep 1

    break

  fi

  osascript -e 'display alert "Payload failed." message "Try re-jailbreaking again..."'
  break

  sleep 1

done
