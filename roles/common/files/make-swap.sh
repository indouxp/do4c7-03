#!/bin/sh
###############################################################################
#
# swap$B$,$J$$>l9g$O!"(B4G swap$B$r:n@.$7!"(B/etc/fstab$B$KDI5-(B
#
###############################################################################
NAME=${0##*/}

NOW=`swapon -s |
     awk 'BEGIN{
            sum = 0;
          }
          {
            size = $3 + 0; # Size$B9T$O(B0$B$H$J$k(B
            sum += size;
          }
          END{
            print sum;
          }'`

set -eu

if [ "${NOW:?}" = "0" ]; then
  if dd if=/dev/zero of=/SWAPFILE count=4096 bs=1M; then
    mkswap /SWAPFILE && swapon /SWAPFILE
    if grep SWAPFILE /etc/fstab; then
      :
    else
      cp -p /etc/fstab /etc/fstab.bk`date '+%Y%m%d'`
      cat <<EOT >> /etc/fstab
/SWAPFILE swap swap defaults 0 0
EOT
    fi
  fi
fi
