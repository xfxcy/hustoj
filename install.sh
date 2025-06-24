#!/bin/bash
IN_SCREEN=no
if echo "$TERM"|grep "screen" ; then
        IN_SCREEN=yes;
fi

if [ "$IN_SCREEN" == "no" ] ;then
        echo "not in screen";
        apt update
        if ! apt install screen -y  ; then
                echo " 自动更新进程或其他工具锁定了apt目录，安装无法继续，请终止相关进程或重启后操作。"
                echo " apt locked , stop auto update proccess and try again"
                exit
        fi
        chmod +x $0
        screen bash $0 $*
else
        echo "in screen";
        OSID=`lsb_release -is | tr 'UDC' 'udc'`
        OSRS=`lsb_release -rs`
        INSTALL="install-$OSID$OSRS.sh"
        URL="https://github.com/xfxcy/hustoj/raw/master/hustoj.tar.gz"
        wget -O "$INSTALL" "$URL"
        chmod +x "$INSTALL"

        
        ALIPING=`LANG=c ping -c 5 mirrors.aliyun.com|grep ttl| awk -F= '{print $4}'|awk '{print $1*1000}'|sort -n|head -1`
        NEPING=`LANG=c ping -c 5 mirrors.163.com    |grep ttl| awk -F= '{print $4}'|awk '{print $1*1000}'|sort -n|head -1`
        echo "aliyun:$ALIPING"
        echo "netease:$NEPING"
        if [ "$ALIPING" -gt "$NEPING" ] ; then
                echo "163 is faster"
                sed -i 's/aliyun/163/g'  "./$INSTALL"
        else
                echo "aliyun is faster"
        fi

        "./$INSTALL"
        sleep 60;
fi

config="/home/judge/etc/judge.conf"
VIRTUAL="/var/www/virtual/"
SERVER=`cat $config|grep 'OJ_HOST_NAME' |awk -F= '{print $2}'`
USER=`cat $config|grep 'OJ_USER_NAME' |awk -F= '{print $2}'`
PASSWORD=`cat $config|grep 'OJ_PASSWORD' |awk -F= '{print $2}'`
DATABASE=`cat $config|grep 'OJ_DB_NAME' |awk -F= '{print $2}'`
PORT=`cat $config|grep 'OJ_PORT_NUMBER' |awk -F= '{print $2}'`
cd /home/judge/src/web/
wget https://github.com/xfxcy/hustoj/raw/master/hello.tar.gz
tar xzf hello.tar.gz
chown www-data -R hello
clear
reset
echo "xfxcy nb"
