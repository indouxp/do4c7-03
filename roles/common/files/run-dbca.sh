#!/bin/sh
###############################################################################
#
# dbcaによるサイレントインストール
#
###############################################################################
NAME=${0##*/}

export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=${ORACLE_BASE}/product/12.1.0/db_1
export PATH=${ORACLE_HOME}/bin:$PATH:$HOME/bin
export LD_LIBRARY_PATH=$ORACLE_HOME/lib
export ORACLE_SID=orcl
export NLS_LANG=Japanese_japan.al32utf8
export LC_ALL=ja_JP.utf8

dbca \
  -silent \
  -createDatabase \
  -templateName New_Database.dbt \
  -gdbName orcl \
  -sid orcl \
  -sysPassword orclorcl \
  -systemPassword orclorcl \
  -datafileDestination /oradata \
  -recoveryAreaDestination $ORACLE_BASE/recovery_area \
  -characterSet "AL32UTF8" \
  -nationalCharacterSet "AL16UTF16"
RC=$?
if [ "${RC:?}" -ne "0" ]; then
  logger local0.err "${NAME:?}: dbca fail. rc=${RC:?}."
  exit ${RC:?}
fi
exit 0
