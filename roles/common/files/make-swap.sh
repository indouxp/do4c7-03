#!/bin/sh
###############################################################################
#
# swapがない場合は、4G swapを作成し、/etc/fstabに追記
#
###############################################################################
NAME=${0##*/}

SWAPFILENAME=/SWAPFILE
SIZE=4096
SIZE=6144

NOW=`swapon -s |
     awk 'BEGIN{
            sum = 0;
          }
          {
            size = $3 + 0; # Size行は0となる
            sum += size;
          }
          END{
            print sum;
          }'`

set -eu

if [ "${NOW:?}" = "0" ]; then
  if dd if=/dev/zero of=/SWAPFILE count=${SIZE:?} bs=1M; then
    mkswap ${SWAPFILENAME:?} && swapon ${SWAPFILENAME:?}
    if grep ${SWAPFILENAME:?} /etc/fstab; then
      :
    else
      cp -p /etc/fstab /etc/fstab.bk`date '+%Y%m%d'`
      cat <<EOT >> /etc/fstab
${SWAPFILENAME:?} swap swap defaults 0 0
EOT
    fi
  fi
fi
