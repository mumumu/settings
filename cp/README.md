## 競技プログラミング用、コマンドラインツール

cp.sh によって、競技プログラミングに必要なテンプレを生成

### 1. テンプレート生成

template.cxx を元に、プロジェクトを生成する  
ディレクトリ `project_name` を生成し、そこに Makefile と `project_name.cxx` を生成する

```
$ ./cp.sh gen [project_name]
```

### 2. プロジェクト削除

ディレクトリ `project_name` を削除

```
$ ./cp.sh del [project_name]
```

## Makefile の機能

cp.sh によって生成される Makefile の機能は以下の通り

### project\_name.cxx をコンパイルする

```
make
``` 

### cxx ファイルに cout がひとつだけ入っているかをチェックする

```
make lint
``` 
