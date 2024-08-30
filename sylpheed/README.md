このディレクトリには、Sylpheed の vi keybind の patch を当てた、Ubuntu 向けの独自バイナリをおいています。

各ディレクトリに移動し、以下のようにすると、Docker イメージをビルドし、deb ファイルを取り出すことが出来ます。既にビルド済みバイナリも置いてあります。

```
$ cd 20.04
$ sudo docker build -t myimage/ubuntu-focal-sylpheed:1.0 .
$ sudo docker run --rm -i -v `pwd`:/tmp/mnt/ myimage/ubuntu-focal-sylpheed:1.0 /bin/sh -c "cp /tmp/*.deb /tmp/mnt/"
```

```
$ cd 24.04
$ sudo docker build -t myimage/ubuntu-noble-sylpheed:1.0 .
$ sudo docker run --rm -i -v `pwd`:/tmp/mnt/ myimage/ubuntu-noble-sylpheed:1.0 /bin/sh -c "cp /tmp/*.deb /tmp/mnt/"
```
