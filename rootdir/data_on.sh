#!/system/bin/sh

IP=$(ip a sh dev rmnet0 | grep rmnet0$ | busybox awk '{print $2}' | busybox cut -d'/' -f1)
VALID_IP="$(echo $IP | busybox awk -F'.' '$1 <=255 && $2 <= 255 && $3 <= 255 && $4 <= 255')"
if [ -z "$VALID_IP" ]; then
    echo "The IP address isn't valid"
else
    echo "The IP address is valid: $IP"
    ip r add default via $IP table rmnet0 && echo -n "Route added. Testing route... "
    if [ "$(ping -c 1 4.2.2.1 | grep icmp* | busybox wc -l)" -eq "1" ]; then
        echo "OK."
        exit 0
    else
        echo "KO."
        exit 1
    fi
fi
