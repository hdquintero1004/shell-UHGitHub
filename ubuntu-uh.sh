#!/usr/bin/env bash

# use `lsb_release -c` para sacar el codename
# cortar en dos columnas con `cut`

# poner como repos a:
# - backports
# - proposed
# - security
# - updates

# ramas:
# - main
# - multiverse
# - resicted
# - multiverse
if [ $(whoami) != "root" ]; then
	sudo "$0"
	exit
fi

export VER=`lsb_release -c | cut -d : -f 2`

rm /etc/apt/sources.list.d/ubuntu-uh.list
SOURCES="/etc/apt"
if [ ! -d $SOURCES/sources.list.d ]; then
    mkdir $SOURCES/sources.list.d
fi

if [ -a $SOURCES/sources.list ]; then
    mv $SOURCES/sources.list $SOURCES/sources.list.disabled
fi

shopt -s nullglob
for f in /etc/apt/sources.list.d/*list ; do
	mv $f ${f}.disabled
done

cat > /etc/apt/sources.list.d/ubuntu-uh.list << END
deb http://ubuntu.uh.cu/ubuntu $VER main multiverse restricted universe
deb http://ubuntu.uh.cu/ubuntu $VER-backports main multiverse restricted universe
deb http://ubuntu.uh.cu/ubuntu $VER-proposed main multiverse restricted universe
deb http://ubuntu.uh.cu/ubuntu $VER-security main multiverse restricted universe
deb http://ubuntu.uh.cu/ubuntu $VER-updates main multiverse restricted universe
END

if [ $? -ne 0]; then
	echo "Ha ocurrido un error"
else
	apt-get update
fi

