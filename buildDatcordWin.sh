# Run with MozillaBuild
basedir=$(dirname "$0")
curl https://hg.mozilla.org/mozilla-central/raw-file/default/python/mozboot/bin/bootstrap.py --output bootstrap.py
python3 bootstrap.py --no-interactive
cp -rf $basedir/changed/* mozilla-unified/
# It is using nightly branding no matter what so we replace the nightly stuff with our stuff
cp -rf mozilla-unified/browser/branding/unofficial/* mozilla-unified/browser/branding/nightly/*
cd mozilla-unified
cat "ac_add_options --disable-default-browser-agent" >> mozconfig
cat "ac_add_options --enable-release" >> mozconfig
cat "ac_add_options --with-app-name=datcord" >> mozconfig
cat "ac_add_options --with-branding=browser/branding/unofficial" >> mozconfig
cat mozconfig
patch -p1 $basedir/mozilla_dirsFromLibreWolf.patch
./mach build
./mach package

# Change the setup exe
mkdir $basedir/work
cp obj-x86_64-pc-mingw32/dist/install/sea/*.exe $basedir/work/ffSetup-win64.exe
cd $basedir/work
unzip -q ffSetup-win64.exe
ls
mv core datcord
cd datcord
mv firefox.exe datcord.exe
cd ..
cp ../windows/datcord.ico datcord/
# Based on librewolf mk.py
mkdir x86-ansi
wget -q -O ./x86-ansi/nsProcess.dll https://shorsh.de/upload/we7v/nsProcess.dll
wget -q -O ./vc_redist.x64.exe https://aka.ms/vs/17/release/vc_redist.x64.exe
cp ../windows/setup.nsi .
cp ../windows/datcord.ico .
cp ../windows/banner.bmp .
makensis-3.01.exe -V1 setup.nsi
# Setup filename will be datcordSetup-win64.exe


