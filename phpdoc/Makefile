build:
	php doc-base/configure.php --with-lang=ja --enable-xml-details

builden:
	php doc-base/configure.php --with-lang=en --enable-xml-details

clone:
	git clone git@github.com:php/doc-base.git doc-base
	git clone git@github.com:php/doc-en.git en
	git clone git@github.com:php/doc-ja.git ja

setup:
	sudo apt install build-essential git subversion libxml2-dev libkrb5-dev libsqlite3-dev libbz2-dev libcurl4-openssl-dev libcurl4-openssl-dev libjpeg-dev libonig-dev libreadline-dev libtidy-dev libxslt-dev libzip-dev libpng-dev libssl-dev pkg-config autoconf automake
	git clone https://github.com/phpenv/phpenv.git ~/.phpenv
	git clone https://github.com/php-build/php-build ~/.phpenv/plugins/php-build
	echo "--with-pear" >> ~/.phpenv/plugins/php-build/share/php-build/default_configure_options
	exec /bin/bash -l

up:
	cd doc-base && git pull
	cd en && git pull
	cd ja && git pull
	make -j1 build
	make -j1 chk
	/usr/bin/google-chrome-stable --force-device-scale-factor=1.3 revcheck.html 2>/dev/null &
	/usr/bin/google-chrome-stable --force-device-scale-factor=1.3 https://github.com/php/doc-en/commits/master 2>/dev/null &

chk:
	php doc-base/scripts/revcheck.php ja > revcheck.html

pd: build
	phd -f xhtml -L ja -P PHP -d doc-base/.manual.xml
	/usr/bin/google-chrome-stable --force-device-scale-factor=1.3 output/php-chunked-xhtml/index.html 2>/dev/null &

chen:
	mv en en.bak
	ln -s doc-en-github en

resen:
	rm -rf en
	mv en.bak en

pden:
	php doc-base/configure.php --with-lang=en --enable-xml-details
	phd -f xhtml -L en -P PHP -d doc-base/.manual.xml
	/usr/bin/google-chrome-stable --force-device-scale-factor=1.3 output/php-chunked-xhtml/index.html 2>/dev/null &

ghpden:
	mv en en.bak
	mv doc-en-github en
	php doc-base/configure.php --with-lang=en --enable-xml-details
	phd -f xhtml -L en -P PHP -d doc-base/.manual.xml
	/usr/bin/google-chrome-stable --force-device-scale-factor=1.3 output/php-chunked-xhtml/index.html 2>/dev/null &
	mv en doc-en-github
	mv en.bak en

clean:
	rm -rf ja/*.txt
	rm -rf output
	find ja -name "*.tmp" | xargs -n 1 rm -rf
	find ja -name "*.orig" | xargs -n 1 rm -rf
	find ja -name "*.rej" | xargs -n 1 rm -rf
	find ja -name "*.patch" | xargs -n 1 rm -rf
