#!/bin/sh
#
# This file was part of WDTV Tools (http://wdtvtools.sourceforge.net/).
# Copyright (C) 2009 Elmar Weber <wdtv@elmarweber.org>
#
# adaptation to wdhdsync by Denis Roio <jaromil@dyne.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or 
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# assembly script for application images
                 
appname=wdhdsync
imagefile=./$appname.app.bin
loopdir=./$appname.app.loop

# create and fill in appdir
appdir=$appname.app

sudo rm -rf $appdir $imagefile $loopdir

mkdir -p $appdir
mkdir -p $appdir/bin
mkdir -p $appdir/etc/init.d

cp -v src/netcat $appdir/bin &&
cp -v src/broadcaster $appdir/bin &&
strip $appdir/bin/* &&
cp -v scripts/*-sync.sh $appdir/bin &&
cp -v scripts/S88wdhdsync $appdir/etc/init.d &&
cp -v README $appdir &&

sudo chown -R root:root $appdir

dd if=/dev/zero of=$imagefile bs=1K count=500 &&
/sbin/mkfs.ext3 -F $imagefile &&
/sbin/tune2fs -c 0 -i 0 $imagefile &&
mkdir -p $loopdir &&
sudo mount -o loop $imagefile $loopdir &&
cp -a $appdir/* $loopdir/ &&
sudo rm -rf $loopdir/lost+found &&
sudo chown root:root -R $loopdir &&
sudo umount $loopdir &&
sudo rm -rf $loopdir $appdir && 
sudo /sbin/fsck.ext3 $imagefile


