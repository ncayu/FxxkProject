### ssh免密码登录配置方法

首先，说明一下我们要做的是，serverA 服务器的 usera 用户免密码登录 serverB 服务器的 userb用户。

我们先使用usera 登录 serverA 服务器

```bash
 [root@serverA ~]# su - usera
 [usera@serverA ~]$ pwd
 /home/usera
```

然后在serverA上生成密钥对

```bash
[usera@serverA ~]$ ssh-keygen -t rsa   #指定加密算法为rsa
 Generating public/private rsa key pair.
 Enter file in which to save the key (/home/usera/.ssh/id_rsa):  #保存私钥的文件全路径
 Created directory '/home/usera/.ssh'.
 Enter passphrase (empty for no passphrase):   #密码可以为空
 Enter same passphrase again:
 Your identification has been saved in /home/usera/.ssh/id_rsa.
 Your public key has been saved in /home/usera/.ssh/id_rsa.pub.  #生成公钥
 The key fingerprint is:
 39:f2:fc:70:ef:e9:bd:05:40:6e:64:b0:99:56:6e:01 usera@serverA
 The key's randomart image is:
 +--[ RSA 2048]----+
 | Eo* |
 | @ . |
 | = * |
 | o o . |
 | . S . |
 | + . . |
 | + . .|
 | + . o . |
 | .o= o. |
 +-----------------+
```

此时会在/home/usera/.ssh目录下生成密钥对

```bash
[usera@serverA ~]$ ls -la .ssh
 总用量 16
 drwx------ 2 usera usera 4096 8月 24 09:22 .
 drwxrwx--- 12 usera usera 4096 8月 24 09:22 ..
 -rw------- 1 usera usera 1675 8月 24 09:22 id_rsa
 -rw-r--r-- 1 usera usera 399 8月 24 09:22 id_rsa.pub
```

然后将公钥上传到serverB 服务器的，并以userb用户登录

```bash
[usera@portalweb1 ~]$ ssh-copy-id userb@10.124.84.20   #输入对应主机IP
 The authenticity of host '10.124.84.20 (10.124.84.20)' can't be established.
 RSA key fingerprint is f0:1c:05:40:d3:71:31:61:b6:ad:7c:c2:f0:85:3c:cf.
 Are you sure you want to continue connecting (yes/no)? yes  #提示是否继续连接，输入yes
 Warning: Permanently added '10.124.84.20' (RSA) to the list of known hosts.
 userb@10.124.84.29's password:  # 输入userb的密码，也是唯一一次
 Now try logging into the machine, with "ssh 'userb@10.124.84.20'", and check in:
 
 
 .ssh/authorized_keys
 
 
 to make sure we haven't added extra keys that you weren't expecting.

```

这个时候usera的公钥文件内容会追加写入到userb的 .ssh/authorized_keys 文件中

> 这个时候usera的公钥文件内容会追加写入到userb的 .ssh/authorized_keys 文件中

```bash
[usera@serverA ~]$ cat .ssh/id_rsa.pub
 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA2dpxfvifkpswsbusPCUWReD/mfTWpDEErHLWAxnixGiXLvHuS9QNavepZoCvpbZWHade88KLPkr5XEv6M5RscHXxmxJ1IE5vBLrrS0NDJf8AjCLQpTDguyerpLybONRFFTqGXAc/ximMbyHeCtI0vnuJlvET0pprj7bqmMXr/2lNlhIfxkZCxgZZQHgqyBQqk/RQweuYAiuMvuiM8Ssk/rdG8hL/n0eXjh9JV8H17od4htNfKv5+zRfbKi5vfsetfFN49Q4xa7SB9o7z6sCvrHjCMW3gbzZGYUPsj0WKQDTW2uN0nH4UgQo7JfyILRVZtwIm7P6YgsI7vma/vRP0aw== usera@serverA
```

查看serverB服务器userb用户下的 ~/.ssh/authorized_keys文件，内容是一样的，此处我就不粘贴图片了。

```bash
[userb@serverB ~]$ cat .ssh/authorized_keys
 ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA2dpxfvifkpswsbusPCUWReD/mfTWpDEErHLWAxnixGiXLvHuS9QNavepZoCvpbZWHade88KLPkr5XEv6M5RscHXxmxJ1IE5vBLrrS0NDJf8AjCLQpTDguyerpLybONRFFTqGXAc/ximMbyHeCtI0vnuJlvET0pprj7bqmMXr/2lNlhIfxkZCxgZZQHgqyBQqk/RQweuYAiuMvuiM8Ssk/rdG8hL/n0eXjh9JV8H17od4htNfKv5+zRfbKi5vfsetfFN49Q4xa7SB9o7z6sCvrHjCMW3gbzZGYUPsj0WKQDTW2uN0nH4UgQo7JfyILRVZtwIm7P6YgsI7vma/vRP0aw== usera@serverA
```

另外我们要注意，`.ssh目录的权限为700，其下文件authorized_keys和私钥的权限为600`。否则会因为权限问题导致无法免密码登录。我们可以看到登陆后会有known_hosts文件生成。

```bash
[useb@serverB ~]$ ls -la .ssh
 total 24
 drwx------. 2 useb useb 4096 Jul 27 16:13 .
 drwx------. 35 useb useb 4096 Aug 24 09:18 ..
 -rw------- 1 useb useb 796 Aug 24 09:24 authorized_keys
 -rw------- 1 useb useb 1675 Jul 27 16:09 id_rsa
 -rw-r--r-- 1 useb useb 397 Jul 27 16:09 id_rsa.pub
 -rw-r--r-- 1 useb useb 1183 Aug 11 13:57 known_hosts
```

这样做完之后我们就可以免密码登录了

```bash
[usera@serverA ~]$ ssh userb@10.124.84.20
```

```bash
另外，将公钥拷贝到服务器的~/.ssh/authorized_keys文件中方法有如下几种：
1、将公钥通过scp拷贝到服务器上，然后追加到~/.ssh/authorized_keys文件中，这种方式比较麻烦。scp -P 22 ~/.ssh/id_rsa.pub user@host:~/。
2、通过ssh-copy-id程序，就是我演示的方法，ssh-copyid user@host即可
3、可以通过cat ~/.ssh/id_rsa.pub | ssh -p 22 user@host ‘cat >> ~/.ssh/authorized_keys’，这个也是比较常用的方法，因为可以更改端口号。
```





