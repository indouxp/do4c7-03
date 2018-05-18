#!/bin/sh
###############################################################################
#
# ~/.bashrcへの追記
# 未定義の場合に限り、追記を行う。
# 一度目の追記後は、ORACLE_BASEの定義があるため、何も行わない
# 処理結果は、grep local0 /var/log/messageで確認。
#
###############################################################################

NAME=${0##*/}
BASHRC=~/.bashrc

# 変更済みの判断は、ORACLE_BASEのみ
if grep "ORACLE_BASE" ${BASHRC:?} > /dev/null; then
  logger local0.err "${NAME:?}: grep fail." 
  exit 0
fi

cat <<EOT >> ${BASHRC:?}
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=\${ORACLE_BASE}/product/12.1.0/db_1
export PATH=\${ORACLE_HOME}/bin:\$PATH:\$HOME/bin
export LD_LIBRARY_PATH=\$ORACLE_HOME/lib
export ORACLE_SID=orcl
export NLS_LANG=Japanese_japan.al32utf8
export LC_ALL=ja_JP.utf8
EOT
RC=$?
if [ "${RC:?}" -ne "0" ];then
  logger local0.err "${NAME:?}: cat fail. rc=${RC:?}" 
  exit ${RC:?}
fi
exit 0
