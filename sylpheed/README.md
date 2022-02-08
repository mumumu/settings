このディレクトリには、Sylpheed の vi keybind の patch を当てた独自バイナリをおいています。

```
$ mkdir sylpheed
$ cd sylpheed
$ apt source sylpheed
$ sudo apt build-dep sylpheed
$ sudo apt install devscripts
$ cd sylpheed-3.7.0
$ wget https://gist.githubusercontent.com/mumumu/3c3a6f7691e3fd71a82247d51ebf3852/raw/bc5f5f4aa27d38d6ba46313cfdecab85f795e61b/sylpheed_vi_keybind.patch
$ patch -p0 < sylpheed_vi_keybind.patch
$ debuild -b -uc -us
```
