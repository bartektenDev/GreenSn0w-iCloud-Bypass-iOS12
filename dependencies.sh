#!/usr/bin/env bash
clear
rm -rf dependencies
mkdir dependencies
cd dependencies
 /bin/bash -crm -rf libimobiledevice
mkdir libimobiledevice
cd libimobiledevice

export PATH=/usr/local/bin:$PATH
which brew > /dev/null
if [ $? -ne 0 ]; then
    echo "NO HOMEBREW. Install it from brew.sh"
    exit
    return
fi


xcode-select --install

echo " "
echo IMPORTANT: WAIT FOR COMMAND TOOLS TO INSTALL!
echo If you do not get a popup, they are already installed
read -p "Press Enter when software is installed..."

brew install libusb
brew install libtool
brew install automake
brew install curl
brew reinstall libxml2
echo 'export PATH="/usr/local/opt/libxml2/bin:$PATH"' >> ~/.zshrc
export LDFLAGS="-L/usr/local/opt/libxml2/lib"
export CPPFLAGS="-I/usr/local/opt/libxml2/include"
export PKG_CONFIG_PATH="/usr/local/opt/libxml2/lib/pkgconfig"
brew install gnutls
brew install libgcrypt
brew reinstall openssl
echo 'export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"' >> ~/.bash_profile
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
brew install pkg-config
brew link pkg-config
echo "Installing sshpass"
brew tap esolitos/ipa
brew install sshpass


echo "[*]Installing timeout fix ..."
brew install coreutils
echo "[*]Installed timeout fix! (coreutils)"

echo "[*]Installing libplist ..."
git clone https://github.com/libimobiledevice/libplist.git
cd libplist
./autogen.sh --without-cython
make
make install
cd ..

echo "[*]Installing libusbmuxd ..."
git clone https://github.com/libimobiledevice/libusbmuxd.git
cd libusbmuxd
./autogen.sh
make
make install
cd ..

echo "[*]Installing libimobiledevice ..."
git clone https://github.com/libimobiledevice/libimobiledevice.git
cd libimobiledevice
./autogen.sh --without-cython --disable-openssl
make
make install
cd ..

echo 'export PATH="/usr/local/opt/libimobiledevice/bin:/usr/local/opt/libxml2/bin:$PATH"' >> ~/.zshrc
export LDFLAGS="-L/usr/local/opt/libimobiledevice/lib -L/usr/local/lib"
export CPPFLAGS="-I/usr/local/opt/libimobiledevice/include -I/usr/local/lib"
export PKG_CONFIG_PATH="/usr/local/opt/libxml2/lib/pkgconfig"


echo "[*]Installing libideviceactivation ... "
git clone https://github.com/libimobiledevice/libideviceactivation.git
cd libideviceactivation
./autogen.sh
make
make install
cd ..

echo "[*]Installing libirecovery ... "
rm -r -f libirecovery
git clone https://github.com/libimobiledevice/libirecovery.git
cd libirecovery
./autogen.sh
make
make install
cd ..

echo "ALL DONE"
echo " "
echo "Quit Terminal to Stop Here"
read -p "Or Press Enter to fix SEND/RETRIEVE RESPONSE..."

echo "[*]Installing patched libideviceactivation by OliTheRepairDude ... "
rm -r -f libideviceactivation
git clone https://github.com/OliTheRepairDude/libideviceactivation.git
cd libideviceactivation
./autogen.sh
make 
make clean
make install
cd ..

echo " "
echo "Done! Sliver is ready to use!"
exit
return
