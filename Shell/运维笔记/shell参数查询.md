## shell脚本参数查询

### 1.查询CPU信息

Linux系统中的CPU信息存在于/proc/cpuinfo文件中，如果想了解全部的信息，可以直接查看这个文件。
有多少个物理CPU？

```bash
cat /proc/cpuinfo | grep 'physical id' | sort | uniq |wc -l
```

有多少个虚拟CPU？

```bash
cat /proc/cpuinfo | grep ^processor | sort | uniq |wc -l
```

CPU是几个核心的？

```bash
cat /proc/cpuinfo | grep 'cpu cores' | uniq
```

打印 cpu 使用率最高的前 4 个程序：

```bash
ps -e -o "%C %c" | sort -u -k1 -r | head -5
```

获取使用虚拟内存最大的 5 个进程

```bash
ps -e -o "%z %c" | sort -n -k1 -r | head -5
```

## linux出现高cpu进程排查方法

### 1.查看cpu占用情况
```bash
top
top -p 程序pid

M
```

### 2.查看线程级别的cpu占用情况

```bash
方法一
ps H -eo user,pid,ppid,tid,time,%cpu,cmd --sort=%cpu | grep 进程号

方法二
top -H -p 进程号

-H  :Threads-mode operation
-p  :Monitor-PIDs
```

### 3.将问题定位到代码行级别？

```bash
gstack/pstack（c/c++程序）

命令：

gstack/pstack 进程号


jstack（java程序）

命令：

jstack 进程号
```