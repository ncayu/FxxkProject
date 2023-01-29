import time

from datetime import datetime

"""
开发程序时，经常需要获取两个代码位置在执行时的时间差，比如，我们想知道某个函数执行大概耗费了多少时间，就可以使用time.time()来做
"""

before = time.time()

print(time.localtime(time.time()))   #作用是格式化时间戳为本地的时间
print(time.strftime('%Y-%m-%d %H:%M:%S',time.localtime(time.time())))
# func1() #运行的程序
time.sleep(5) # 延迟20秒执行

after = time.time()

print(f"调用func1，花费时间{after-before}")

# 得到当前时间
str(datetime.now())

time1 = datetime.now().strftime('%Y-%m-%d ** %H:%M:%S')

print(time1)

'''
得到类似这样的字符串：‘2018-06-30 23:10:08.911420’

如果要指定输出的时间格式，可以像下面这样
'''

'''
1、Python的time模块

import time

print(time.time())  #输出的是时间戳
print(time.localtime(time.time()))   #作用是格式化时间戳为本地的时间
# 最后用time.strftime()方法，把刚才的一大串信息格式化成我们想要的东西

print(time.strftime('%Y-%m-%d',time.localtime(time.time()))) 
'''