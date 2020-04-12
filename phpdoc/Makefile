build:
	php doc-base/configure.php --with-lang=ja --enable-xml-details

pd: build
	phd -f xhtml -L ja -P PHP -d doc-base/.manual.xml
    
clean:
	rm -rf output
