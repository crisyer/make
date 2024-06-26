1. make 的规则是什么?
    在讲述这个 makefile 之前，还是让我们先来粗略地看一看 makefile 的规则。

    target ... : prerequisites ...
        recipe

    target
        可以是一个 object file（目标文件），也可以是一个可执行文件，还可以是一个标签（label）。对于
        标签这种特性，在后续的“伪目标”章节中会有叙述。
    prerequisites
        生成该 target 所依赖的文件和/或 target。
    recipe
        该 target 要执行的命令（任意的 shell 命令）。

    makefile 的核心:
        prerequisites中如果有一个以上的文件比target文件要新的话，recipe所定义的命令就会被执行。
        make 会比较 targets 文件和 prerequisites 文件的修改日期，如果 prerequisites 文件的日期要比 targets 文件的日期要新，或者
        target 不存在的话，那么，make 就会执行后续定义的命令。

    这里要说明一点的是，clean 不是一个文件，其冒号后什么也没有，那么，make 就不会自动去找它的依赖性，
    也就不会自动执行其后所定义的命令。要执行其后的命令，就要在 make 命令后明显得指出这个 label 的名字。
    这样的方法非常有用，我们可以在一个 makefile 中定义不用的编译或是和编译无关的命令，比如程序的打包，程序的备份，等等。

2. make 是如何工作的? (详见makefile)
    在默认的方式下，也就是我们只输入 make 命令。那么，
    1. make 会在当前目录下找名字叫“Makefile”或“makefile”的文件。
    2. 如果找到，它会找文件中的第一个目标文件（target），在上面的例子中，他会找到“edit”这个文
    件，并把这个文件作为最终的目标文件。
    3. 如果 edit 文件不存在，或是 edit 所依赖的后面的 .o 文件的文件修改时间要比 edit 这个文件新，
    那么，他就会执行后面所定义的命令来生成 edit 这个文件。
    4. 如果 edit 所依赖的 .o 文件也不存在，那么 make 会在当前文件中找目标为 .o 文件的依赖性，如
    果找到则再根据那一个规则生成 .o 文件。（这有点像一个堆栈的过程）
    5. 当然，你的 C 文件和头文件是存在的啦，于是 make 会生成 .o 文件，然后再用 .o 文件生成 make
    的终极任务，也就是可执行文件 edit 了。

    这就是整个 make 的依赖性，make 会一层又一层地去找文件的依赖关系，直到最终编译出第一个目
    标文件。在找寻的过程中，如果出现错误，比如最后被依赖的文件找不到，那么 make 就会直接退出，并
    报错，而对于所定义的命令的错误，或是编译不成功，make 根本不理。make 只管文件的依赖性，即，如
    果在我找了依赖关系之后，冒号后面的文件还是不在，那么对不起，我就不工作啦。
    通过上述分析，我们知道，像 clean 这种，没有被第一个目标文件直接或间接关联，那么它后面所定
    义的命令将不会被自动执行，不过，我们可以显示要 make 执行。即命令——make clean ，以此来清除
    所有的目标文件，以便重编译。
    于是在我们编程中，如果这个工程已被编译过了，当我们修改了其中一个源文件，比如 file.c ，那
    么根据我们的依赖性，我们的目标 file.o 会被重编译（也就是在这个依性关系后面所定义的命令），于
    是 file.o 的文件也是最新的啦，于是 file.o 的文件修改时间要比 edit 要新，所以 edit 也会被重新
    链接了（详见 edit 目标文件后定义的命令）。
    而如果我们改变了 command.h ，那么，kdb.o 、command.o 和 files.o 都会被重编译，并且，edit
    会被重链接。
