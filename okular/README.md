# Okular にまつわる Tips

このファイルは、Linux のデスクトップ環境 [KDE](https://kde.org) の汎用文書ビューア [Okular](https://okular.kde.org/) にまつわるスクリプトや tips を集めたものです。

個人的には、特にPDFを閲覧するのに重宝しています。

<img src="https://okular.kde.org/images/screenies/okular-main.png" width="800"/>

## Okular のスクロール速度を速くする方法

Okular は vi のキーバインドに従って文書を上下スクロールしつつ閲覧できます。とても便利なものなのですが、4K ディスプレイなどの場合、スクロール速度が合わないことがあり、しかもそれを現状は調整できません。

### 1. C++ のソースコードを書き換えてリビルドする

ひとつのやり方として、C++ のソースコードを書き換える方法があります。たとえば、Qt のスクロールプロパティの値を置き換える方法です。

https://invent.kde.org/graphics/okular/-/blob/4cd6bfd30e5f1781b3f676232fae8700d64f64dd/part/pageview.cpp#L439

言うまでもないことですが、これは Okular そのもののリビルドが必要で、Linux を動かしていたとしても多数の開発用のヘッダなどが必要です。

KDE の開発者でもない限り望ましい方法ではないでしょう。

### 2. キーリピート速度を調整する

発想を変え、スクロール速度そのものに着目するのではなく、キーを押すとスクロールする点に着目してみます。

すると、キーのリピート速度を高速化すれば、スクロールが速くなるということになります。たとえば X Window 環境では、xset コマンドを使って以下のようにします。

```
$ xset r rate 195 120
```

ただ、この方法はあらゆるアプリに効いてしまうことが欠点です。  
プログラムを閲覧する都合上、キーリピートを調整している人はそれなりにいると思われるので、人によってはアリでしょう。

## Okular で、最近見たファイルを復元する

Okular には、最近のセッションを復元する機能がありません。これはどういうことかというと、毎回アプリを開くたびに、見たいファイルをオープンし直さなければいけないということです。

複数のファイルを見つつ、Okular を常用している人にとって、これは激しく不便な仕様です。

### 1. 設定ファイルからハックする

幸いなことに、Okular には最近開いたファイルをすべてファイルに保持しています。それを取り出し、okular コマンドそのものに引数として全て指定してあげれば、すべての最近見たファイルを同時にタブで復元することができます。

最近開いたファイルをスペース区切りで出力する Python スクリプトは、たとえば下記のようになります。これの出力を、okular コマンドに指定してあげればOKです。

```python
#!/usr/bin/env python3

import configparser
import os
import re
import sys

OKULAR_CONFIG_FILE = '$HOME/.config/okularrc'
config_filepath = os.path.expandvars(OKULAR_CONFIG_FILE)

if not os.path.exists(config_filepath):
    sys.exit(0)

config_string = ''
with open(config_filepath, 'r') as f:
    config_string = os.path.expandvars('[dummy_section]\n' + f.read())

config = configparser.ConfigParser()
config.read_string(config_string)

if config.has_section('Recent Files'):
    file_items = []
    for item in config.items('Recent Files'):
        if re.match('file', item[0]):
            file_items.insert(0, item[1])
    if len(file_items) > 0:
        print(' '.join(set(file_items)))
```

### 2. upstream 側で解決する

upstream 側は当然この問題を認識しています。

長い間望まれている機能なので、解決されていそうなものですし、何度か関連のコミットが行われているのですが、最新版でも解決されていないようです。

はて。。実現は難しくなさそうなんですけどね。

https://bugs.kde.org/show_bug.cgi?id=397463
