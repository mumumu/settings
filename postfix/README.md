## postfix smtp auth 認証設定

ここでは、Postfix に smtp auth (sasldb + CRAM-MD5) を追加する方法を説明する。

smtp auth なので、メール送信時の認証設定である点に注意。  
メールを受け取り、メールボックスに格納する場合とは、全く別物である。

courier-imap を使っていて、少しセキュアに認証設定しながら、ユーザを追加したい場合は、以下が参考になるかもしれない

https://github.com/mumumu/settings/tree/master/courier-imap

### 前提

- postfix と Cyrus SASL がインストールされていること
- Debian GNU/Linux Jessie の環境

### 手順

1. sasl のユーザを追加する

このコマンドで作成できるユーザは `username@example.com` である。  
認証にもそのユーザ名が使われる。間違っても `username` で認証しようとしてはいけない。

```
$ sudo saslpasswd2 -c -u example.com username
```

これによって、 パスワード入力後、 `/etc/sasldb` に 上記の認証情報が設定される

2. 作成したユーザ情報が設定されていることを確認する

```
$ sudo sasldblistusers2
username@example.com: userPassword
```

3. /etc/postfix/sasl/smtpd.conf を以下のように編集する

`/etc/postfix/sasl/smtpd.conf` は、Debian での Postfix 上におけるパスである。  
ディストリビューションによっては、異なる可能性がある。

`mech_list` に `PLAIN` を加えれば、認証情報を平文で流したまま、認証を行うことができる。

```
pwcheck_method: auxprop
auxprop_plugin: sasldb
mech_list: CRAM-MD5 DIGEST-MD5 
```

4. /etc/postfix/main.cf を以下のように設定する

```
smtpd_sasl_auth_enable = yes
smtpd_sasl_path = smtpd
smtpd_recipient_restrictions = 
    permit_mynetworks 
    permit_sasl_authenticated 
    reject_unauth_destination
broken_sasl_auth_clients = yes
smtpd_sasl_security_options = noanonymous,noplaintext
```

5. /etc/sasldb を chroot jail にコピーし、postfix を再起動

postfix では、デフォルトで chroot jail が有効になっている。  
なので、 `/etc/sasldb2` は jail 配下にコピーしなければならない。

```
$ ls -la /var/spool/postfix/etc/sasldb2
-rw-r----- 1 root postfix 12288 Nov  3 06:05 /var/spool/postfix/etc/sasldb2
```

```
$ sudo cp /etc/sasldb2 /var/spool/postfix/etc/sasldb2
$ sudo service postfix restart
```

### そもそもユーザを増やす動機ってあるの？

メールボックス一つに対し、複数のメールアドレスを扱いたいと思う場合は実は不要である。  
`/etc/aliases` を編集し、以下のコマンド一発で特定のメールアドレスのエイリアスを作ることができる

```
$ sudo newaliases
```

### References

- http://www.postfix.org/SASL_README.html
