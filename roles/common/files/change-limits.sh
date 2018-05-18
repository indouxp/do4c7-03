#!/bin/sh
###############################################################################
#
# /etc/security/limits.confへの追記
# 未定義の場合に限り、追記を行う。
# 一度目の追記後は、コンテンツ行が0行より大きいため、なにも処理を行わない。
# 処理結果は、grep local0 /var/log/messageで確認。
#
###############################################################################
NAME=${0##*/}

LIMITS_CONF="/etc/security/limits.conf"

# コメント行以外で、空白行以外をカウント
CONTENTS_ROW=$(grep -v "#" ${LIMITS_CONF:?} | awk '{if (NF!=0){print;}}' | wc -l)
RC=$?
if [ "${RC:?}" -ne 0 ]; then
  logger local0.err "${NAME:?} grep fail. rc=${RC:?}"
  exit ${RC:?}
fi

# コメント行のみの場合
if [ "${CONTENTS_ROW:?}" -eq "0" ]; then
  # バックアップ
  cp -p ${LIMITS_CONF:?} ${LIMITS_CONF:?}.bk$(date '+%Y%m%d')
  if [ "${RC:?}" -ne "0" ]; then
    logger local0.err "${NAME:?}: cp fail. rc=${RC:?}"
    exit ${RC:?}
  fi
  # limitsの追記
  cat <<EOT >> ${LIMITS_CONF:?}
oracle soft nproc 2047
oracle hard nproc 16384
oracle soft nofile 1024
oracle hard nofile 65536
oracle soft stack 10240
oracle hard stack 32768
EOT
  RC=$?
  if [ "${RC:?}" -ne "0" ]; then
    logger local0.err "${NAME:?}: cat fail. rc=${RC:?}"
    exit ${RC:?}
  fi
fi


logger local0.info "${NAME:?} done."
exit 0
