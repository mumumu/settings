#!/bin/sh -x

REV=$1
git --no-pager di --name-only --cached | xargs -n 1 sed -i -e "s/EN-Revision: [A-Za-z0-9]* /EN-Revision: ${REV} /g"
