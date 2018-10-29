#!/bin/sh

BASE=`pwd`

generate_makefile() {
	NAME=$1
	cat << EOS > ./$NAME/Makefile
compile:
	g++ -std=c++11 $NAME.cxx

lint:
	\$(eval COUT_NUM := \$(shell grep -c cout $NAME.cxx || true))
	if [ \$(COUT_NUM) -ne 1 ]; \
	then \
		echo "cout num is invalid"; \
	else \
		echo "ok" ;\
	fi

test:
	cat test.txt | ./a.out

li:
	\$(MAKE) -s lint
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
	cp $BASE/template.cxx $NAME/$NAME.cxx
	touch $NAME/test.txt
	echo "generated $NAME.cxx"
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
