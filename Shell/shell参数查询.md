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

