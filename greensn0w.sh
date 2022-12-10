

#@ios_euphoria GreenSn0w
# iOS 12 iCloud Bypass

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

#ideviceactivation deactivate
#ideviceactivation state

sleep 1

echo '(1/8) Mounting filesystem as read-write'
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@localhost -p 4444 mount -o rw,union,update / > /dev/null 2>&1

echo '(2/8) Unloading original mobileactivationd'
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@localhost -p 4444 'launchctl unload /System/Library/LaunchDaemons/com.apple.mobileactivationd.plist' > /dev/null 2>&1

sleep 2

echo '(3/8) Removing original mobileactivationd'
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@localhost -p 4444 rm /usr/libexec/mobileactivationd > /dev/null 2>&1

echo '(4/8) Running uicache (this can take a few seconds)'
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@localhost -p 4444 uicache --all > /dev/null 2>&1

sleep 2

echo '(5/8) Copying patched mobileactivationd'
sshpass -p 'alpine' scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -P 4444 ./mobileactivationd_12_5_1_patched root@localhost:/usr/libexec/mobileactivationd > /dev/null 2>&1

echo '(6/8) Changing patched mobileactivationd access permissions'
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@localhost -p 4444 chmod 755 /usr/libexec/mobileactivationd > /dev/null 2>&1

#echo 'Hiding baseband...'
#sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@localhost -p 4444 mv /usr/local/standalone/firmware/Baseband /usr/local/standalone/firmware/Baseband2 > /dev/null 2>&1

#echo 'Restoring baseband...'
#sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@localhost -p 4444 mv /usr/local/standalone/firmware/Baseband2 /usr/local/standalone/firmware/Baseband > /dev/null 2>&1

echo '(7/8) Loading patched mobileactivationd'
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@localhost -p 4444 launchctl load /System/Library/LaunchDaemons/com.apple.mobileactivationd.plist & killall Setup > /dev/null 2>&1

echo '(8/8) Respringing'
sshpass -p 'alpine' ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null root@localhost -p 4444 killall backboardd > /dev/null 2>&1

sleep 10

#ideviceactivation state

# Kill iproxy
kill %1 > /dev/null 2>&1

echo 'Done!'

echo ''
osascript -e 'display alert "iCloud Bypass Success!" message "Enjoy your unlocked device :)"'
echo ''
sleep 1

    break

  fi

  osascript -e 'display alert "Bypass Failed" message "Try re-jailbreaking again..."'
  break

  sleep 1

done
