up:
	svn up
	make -j1 build
	make -j1 chk
	/usr/bin/google-chrome-stable --force-device-scale-factor=1.3 revcheck.html

chk:
	php doc-base/scripts/revcheck.php ja > revcheck.html

build:
	php doc-base/configure.php --with-lang=ja --enable-xml-details

pd: build
	phd -f xhtml -L ja -P PHP -d doc-base/.manual.xml
    
clean:
	rm -rf output
