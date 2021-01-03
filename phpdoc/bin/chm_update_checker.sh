#!/bin/bash -e

export TZ="Asia/Tokyo"
CHM_UPDATED_DATE=`curl -Is https://phpmanualchm.s3-ap-northeast-1.amazonaws.com/php_manual_en.chm | grep Last-Modified | awk -F"Last-Modified: " "{print \\$2}"`

CHM_UPDATED_UNIXTIME=`date --date="$CHM_UPDATED_DATE" +%s`
NOW_UNIXTIME=`date +%s`

SUB_UNIXTIME=`expr $NOW_UNIXTIME - $CHM_UPDATED_UNIXTIME`
LIMIT=$((60 * 60 * 24 * 20))  # 20 days

if [ $SUB_UNIXTIME -gt $LIMIT ]; then
   echo "CRITICAL: chm file not updated over 20 days!!"
   aws s3 ls s3://phpmanualchm/
   exit 1
else
   if [ $# -eq 1 ]; then
       echo "ok: chm file updated on -> $CHM_UPDATED_DATE"
   fi
   exit 0
fi
