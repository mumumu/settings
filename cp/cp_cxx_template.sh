#!/bin/sh

BASE=`pwd`

generate_makefile() {
	NAME=$1
	cat << EOS > ./$NAME/Makefile
compile:
	g++ -std=c++14 $NAME.cxx

test:
	cat test.txt | ./a.out

clean:
	rm -rf ./a.out

open:
	vim $NAME.cxx test.txt
EOS
}

start() {
	NAME=$1
	if [ -z $NAME ]; then
		echo "project name is empty!"
		exit 1
	fi
	if [ -d ./$NAME ]; then
		echo "project $NAME already exists"
		exit 1
	fi
	mkdir -p $NAME
	echo "------------------"
	echo "mkdir $NAME"
	cp $BASE/template.cxx $NAME/$NAME.cxx
	echo "generated $NAME.cxx"
	touch $NAME/test.txt
	echo "generated test.txt"
	generate_makefile $NAME
	echo "generated Makefile"
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

if [ $# -lt 1 ]; then
	echo "usage: $0 [gen|del] [project or problem name]"
	exit 1;
fi

CMD=$1
case $CMD in
gen)
	start $2
	;;
del*)
	delete $2
	;;
*)
	echo "usage: $0 [gen|del] [project or problem name]"
esac
