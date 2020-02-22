#!/bin/sh

FILENAME=$1
svn add $FILENAME
svn propset svn:keywords "Id Rev Revision Date LastChangedDate LastChangedRevision Author LastChangedBy HeadURL URL" $FILENAME
