#!/bin/sh
###############################################################################
#
# /etc/sysctl.conf書き換え
# 未定義の場合に限り、追記を行う。
# 一度目の追記後は、コンテンツ行が0行より大きいため、なにも処理を行わない。
# 処理結果は、grep local0 /var/log/messageで確認。
#
###############################################################################
NAME=${0##*/}

SYSCTL_CONF="/etc/sysctl.conf"

# コメント行以外をカウント
CONTENTS_ROW=$(grep -v "#" ${SYSCTL_CONF:?} | wc -l)
RC=$?
if [ "${RC:?}" -ne 0 ]; then
  logger local0.err "${NAME:?} grep fail. rc=${RC:?}"
  exit ${RC:?}
fi

# コメント行のみの場合
if [ "${CONTENTS_ROW:?}" -eq "0" ]; then
  # バックアップ
  cp -p ${SYSCTL_CONF:?} ${SYSCTL_CONF:?}.bk$(date '+%Y%m%d')
  if [ "${RC:?}" -ne "0" ]; then
    logger local0.err "${NAME:?}: cp fail. rc=${RC:?}"
    exit ${RC:?}
  fi
  # sysctl.confの追記
  cat <<EOT >> ${SYSCTL_CONF:?}
fs.aio-max-nr = 1048576
fs.file-max = 6815744
kernel.shmall = 2097152
kernel.shmmax = 4294967295
kernel.shmmni = 4096
kernel.sem = 250 32000 100 128
net.ipv4.ip_local_port_range = 9000 65500
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048576
kernel.panic_on_oops = 1
EOT
  RC=$?
  if [ "${RC:?}" -ne "0" ]; then
    logger local0.err "${NAME:?}: cat fail. rc=${RC:?}"
    exit ${RC:?}
  fi
fi

sysctl -p
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  logger local0.err "${NAME:?}: sysctl fail. rc=${RC:?}"
  exit ${RC:?}
fi

logger local0.info "${NAME:?} done."
exit 0
