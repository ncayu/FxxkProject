## linux出现高cpu进程排查方法

### 1.查看cpu占用情况
```bash
top
top -p 程序pid

M
```

### 2.查看线程级别的cpu占用情况

```
方法一
ps H -eo user,pid,ppid,tid,time,%cpu,cmd --sort=%cpu | grep 进程号

方法二
top -H -p 进程号

-H  :Threads-mode operation
-p  :Monitor-PIDs
```

### 3.将问题定位到代码行级别？

```
gstack/pstack（c/c++程序）

命令：

gstack/pstack 进程号


jstack（java程序）

命令：

jstack 进程号
```
