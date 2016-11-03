## courier-imap CRAM-MD5 認証設定

ここでは、courier-imap に CRAM-MD5 認証を設定する方法を説明する。  
以下の手順により、UNIX のユーザ認証と、IMAP の認証を切り離すことができる

### 前提

courier-imap, courier-authdaemon, sasl がインストールされていること

### 手順

1. /etc/courier/imapd の CAPABILITY を以下のように設定する

```
IMAP_CAPABILITY="IMAP4rev1 UIDPLUS CHILDREN NAMESPACE THREAD=ORDEREDSUBJECT THREAD=REFERENCES SORT QUOTA AUTH=CRAM-MD5 AUTH=LOGIN IDLE"
```

2. /etc/courier/authdaemonrc に、 authmodulelist として、 userdb を設定

```
authmodulelist="authuserdb"
```

3. /etc/courier/userdb を作成

```
sudo userdb "user@example.com" set home=/home/user uid=1000 gid=1000
sudo userdbpw -hmac-md5 | sudo userdb "user@example.com" set imap-hmac-md5pw
sudo makeuserdb
```

4. courier-imap を再起動

```
sudo service courier-imap-ssl restart
sudo service courier-authdaemon restart
```

### 認証のデバッグ

/etc/courier/authdaemonrc の `DEBUG_LOGIN` を 2 に設定すると、syslog にパスワードも含めたデバッグログが吐かれる (取り扱い注意)
