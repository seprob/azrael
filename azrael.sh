#!/bin/bash

# Check if user is root.

if [ $(id -u) -ne "0" ] # If is not logged as root.
then
   echo "[!] Your're not logged as root!"

   exit 1 # Exit with code error.
fi

# For every kernel package different than actually run and different than the newest on the list.

for kernel_package in $(dpkg --list | grep -P -o "linux-image-\d\S+" | grep -v $(uname -r | grep -P -o ".+\d") | head -n -1)
do
   version=$(dpkg -l | grep linux | grep $kernel_package | awk '{print $3}' | awk 'BEGIN{FS=OFS="."} NF--')
   packages=$(dpkg -l | grep $version | grep generic | grep -v image | awk '{print $2}')

   # For generic packages.

   for package in $packages
   do
      echo "[*] Packet removing: \"$package\"."

      dpkg -P $package
   done

   packages=$(dpkg -l | grep $version | grep extra | awk '{print $2}')

   # For extra packages.

   for package in $packages
   do
      echo "[*] Packet removing: \"$package\"."

      dpkg -P $package
   done

   packages=$(dpkg -l | grep $version | awk '{print $2}')

   # For rest packages.

   for package in $packages
   do
      echo "[*] Packet removing: \"$package\"."

      dpkg -P $package
   done
done

apt-get -f install