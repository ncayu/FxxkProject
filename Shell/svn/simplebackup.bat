@echo 正在备份版本库%1......
@svnadmin dump %1 > D:/SVNbackup/%2.dump
@echo svnadmin dump %1 D:/SVNbackup/%2.dump
@echo 版本库%1成功备份到了%2
