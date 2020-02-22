#!/bin/sh

BASE=`pwd`

generate_makefile() {
	NAME=$1
	cat << EOS > ./$NAME/Makefile
compile:
	kotlinc $NAME.kt -include-runtime -d $NAME.jar

test:
	cat test.txt | java -jar $NAME.jar

clean:
	rm -rf $NAME.jar
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
	cp $BASE/template.kt $NAME/$NAME.kt
	echo "generated $NAME.kt"
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
