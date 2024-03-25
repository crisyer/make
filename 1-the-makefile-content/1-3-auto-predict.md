1. 初见识自动推导
edit : $(objects)
	cc -o edit $(objects)
main.o : main.c defs.h
	cc -c main.c
kbd.o : kbd.c defs.h command.h
	cc -c kbd.c
command.o : command.c defs.h command.h
	cc -c command.c
display.o : display.c defs.h buffer.h
	cc -c display.c
insert.o : insert.c defs.h buffer.h
	cc -c insert.c
search.o : search.c defs.h buffer.h
	cc -c search.c
files.o : files.c defs.h buffer.h command.h
	cc -c files.c
utils.o : utils.c defs.h
	cc -c utils.c
clean :
	rm edit $(objects)

如上,我们发现了,每一处.o 都是由 cc -c *.c来生成的.
make可以有自动推导的功能,
	1. 遇到 *.o,就会自动匹配 对应的 .c
	2. 如果目标是 .o,那么 recipe就是 cc -c *.c
举例
main.o 依赖 main.c \ defs.h
因为 
	1. main.c已经被推导了, 
	2. 又因为目标是.o,所以recipe就是 cc -c *.c
于是由原来的
main.o : main.c defs.h
	cc -c main.c
可以简写为

main.o : defs.h

所以上述的可以写成如下:

objects = main.o kbd.o command.o display.o \
insert.o search.o files.o utils.o

edit : $(objects)
	cc -o edit $(objects)
main.o : defs.h
kbd.o : defs.h command.h
command.o : defs.h command.h
display.o : defs.h buffer.h
insert.o : defs.h buffer.h
search.o : defs.h buffer.h
files.o : defs.h buffer.h command.h
utils.o : defs.h
.PHONY : clean
clean :
	rm edit $(objects)

上述的phony表示,clean是一个伪目标

2. 自动推导的另外一种风格
既然我们都可以自动推导了,那么我看到那堆 .o 和 .h 的依赖就有点不爽，那么多的重复
的 .h ，能不能把其收拢起来，好吧，没有问题，这个对于 make 来说很容易，谁叫它提供了自动推导命
令和文件的功能呢？来看看最新风格的 makefile 吧。

objects = main.o kbd.o command.o display.o \
insert.o search.o files.o utils.o

edit : $(objects)
	cc -o edit $(objects)
$(objects) : defs.h
kbd.o command.o files.o : command.h
display.o insert.o search.o files.o : buffer.h
.PHONY : clean
clean :
	rm edit $(objects)

这种风格的makefile,和上述的不同在于,它首先将所有文件都要链接的 defs.h都连接了一遍,然后再各取所需.
之前的风格是,生成 .o 所需要的.c依赖是哪些? 
现在的风格是, 某个.c 文件被哪些.o所依赖?
(慎用,我觉得非常不清晰)

3. 清空clean
每个 Makefile 中都应该写一个清空目标文件（.o ）和可执行文件的规则，这不仅便于重编译，也很
利于保持文件的清洁。这是一个“修养”（呵呵，还记得我的《编程修养》吗）。一般的风格都是：
clean:
	rm edit $(objects)
更为稳健的做法是：
.PHONY : clean
clean :
	-rm edit $(objects)

前面说过，.PHONY 表示 clean 是一个“伪目标”。
而在 rm 命令前面加了一个小减号的意思就是，也许某些文件出现问题，但不要管，继续做后面的事。
当然，clean 的规则不要放在文件的开头，不然，这就会变成 make 的默认目标，相信谁也不愿意这样。
不成文的规矩是——“clean 从来都是放在文件的最后”。
上面就是一个 makefile 的概貌，也是 makefile 的基础，下面还有很多 makefile 的相关细节，准备好
了吗？准备好了就来。






