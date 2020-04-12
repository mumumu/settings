build:
	php doc-base/configure.php --with-lang=ja --enable-xml-details

setup:
	sudo apt install build-essential git subversion libxml2-dev libkrb5-dev libsqlite3-dev libbz2-dev libcurl-dev libcurl4-openssl-dev libjpeg-dev libonig-dev libreadline-dev libtidy-dev libxslt-dev libzip-dev
	git clone git://github.com/phpenv/phpenv.git ~/.phpenv
	git clone https://github.com/php-build/php-build ~/.phpenv/plugins/php-build
	echo "--with-pear" >> ~/.phpenv/plugins/php-build/share/php-build/default_configure_options

up:
	svn up
	make -j1 build
	make -j1 chk
	/usr/bin/google-chrome-stable --force-device-scale-factor=1.3 revcheck.html &

chk:
	php doc-base/scripts/revcheck.php ja > revcheck.html

pd: build
	phd -f xhtml -L ja -P PHP -d doc-base/.manual.xml
    
clean:
	rm -rf ja/*.txt
	rm -rf output
	find ja -name "*.tmp" | xargs -n 1 rm -rf
	find ja -name "*.orig" | xargs -n 1 rm -rf
	find ja -name "*.rej" | xargs -n 1 rm -rf
