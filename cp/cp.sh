#!/bin/bash

BASE=`pwd`

start() {
	NAME=$1
    EXT=$2

	if [ -z $NAME ]; then
		echo "project name is empty!"
		exit 1
	fi
	if [ -d ./$NAME ]; then
		echo "project $NAME already exists"
		exit 1
	fi

    echo "ext: $EXT"
    if [[ $EXT == cxx* || $EXT == c++* ]]; then
        EXTVER="c++17"
        if [[ $EXT == cxx* ]]; then
            VER=${EXT#cxx}
        fi
        if [[ $EXT == c++* ]]; then
            VER=${EXT#c++}
        fi
        if [[ $VER == "17" ]]; then
            EXTVER="c++17"
        fi
        echo "cxx version: $EXTVER"
        EXT="cxx"
    fi
	mkdir -p $NAME
	cp $BASE/template.$EXT $NAME/template.$EXT
	echo "generated $NAME/template.$EXT"
	cp $BASE/cp_${EXT}_template.sh $NAME/cp.sh
	echo "generated $NAME/cp.sh"

    # とりあえず4問分作る
	cd $NAME
    sed -i -e "s/c++14/$EXTVER/g" cp.sh
    ./cp.sh gen a
    ./cp.sh gen b
    ./cp.sh gen c
    ./cp.sh gen d

	# ブランチのディレクトリに移動し、シェルを新たに
	# 起動することで、明示的にディレクトリを移動する
    cd a
	exec /bin/bash
}

delete() {
	TARGET_DIR=$1
	if [ -z $TARGET_DIR ]; then
		echo "project name is empty!"
		exit 1
	fi
	if [ ! -d ./$TARGET_DIR ]; then
		echo "No such project: $TARGET_DIR"
		exit 1
	fi
	rm -rf $TARGET_DIR
}

usage() {
	echo "usage: $0 [gen] [project or problem name] [ext]"
	echo "usage: $0 [del] [project or problem name]"
	exit 1;
}

if [ $# -lt 1 ]; then
	usage
fi

CMD=$1
NAME=$2
EXT=${3:-cxx}

case $CMD in
gen)
	start $NAME $EXT
	;;
del*)
	delete $2
	;;
*)
	usage
esac
