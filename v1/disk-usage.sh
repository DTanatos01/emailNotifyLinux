#!/bin/sh
df -Ph | grep -vE '^Filesystem|tmpfs|cdrom' | awk '{ print $5,$1,$6 }' | while read output;
do
  echo $output
  used=$(echo $output | awk '{ print $1 }' | sed s/%//g)
  partition=$(echo $output | awk '{ print $2 }')
  mountpoint=$(echo $output | awk '{ print $3 }')
  restspace=$((100-$used))
  fecha=$(date | awk '{ print $2,$3,$6,$4,$5 }')
  if [ $used -ge 90]; then
    touch /root/emailcontent.txt
    echo "Hola equipo,\n\nEsta es una alerta por parte de DTanatos01 desde $(hostname)." >> /root/emailcontent.txt
    echo "\nDonde se reporta que la partición \"$partition\" con el punto de montaje \"$mountpoint\" esta usando $used%, quedando actualmente poco espacio ($restspace) el cual esta por debajo del umbral pre establecido del 10%." >> /root/emailcontent.txt
    echo "\nSaludos" >> /root/emailcontent.txt
    cat /root/emailcontent.txt | mail -s "[DTanatos01] ($fecha) Disk Space Alert $mountpoint: $used% Used On $(hostname)" correo@dominio
    rm -f /root/emailcontent.txt
  else
    echo "Partición sin problemas y dentro del umbral"
  fi
done