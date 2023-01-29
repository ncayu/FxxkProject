#! /bin/bash

DIRECTORY_HOME="/data/svndata"
SVN_HOME="/data/applications/Svn/subversion1.14/bin"
SVN_reops="/data/applications/Svn/svnrepos"

for file in `ls $DIRECTORY_HOME` #注意此处这是两个反引号，表示运行系统命令
do
 if [ -d $DIRECTORY_HOME"/"$file ] #注意此处之间一定要加上空格，否则会报错
 then
	read_dir $DIRECTORY_HOME"/"$file
 else
	if [ "${file##*.}"x = "dump"x ]
	then
	  project=`echo $file`
	  projectname=`echo $(basename $file .dump)`
	  if [[ ! -d "$SVN_reops/$projectname" ]]; then
	     echo "$projectname 文件夹不存在"
	  else
 	     echo "$projectname 文件夹存在"
	     continue
      fi
	  #echo $project
	  #echo $projectname
	  create_dir="$SVN_HOME/svnadmin create $SVN_reops/$projectname"
	  echo $create_dir
      eval $create_dir
      svn_load="svnadmin load $SVN_reops/$projectname < $DIRECTORY_HOME/$project"
	  echo $svn_load
      eval $svn_load
	fi
	#echo $DIRECTORY_HOME"/"$file #在此处处理文件即可
 fi
done
