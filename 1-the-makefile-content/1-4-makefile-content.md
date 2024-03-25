Makefile 里有什么？
Makefile 里主要包含了五个东西：显式规则、隐式规则、变量定义、指令和注释。

1. 显式规则。显式规则说明了如何生成一个或多个目标文件。这是由 Makefile 的书写者明显指出要
生成的文件、文件的依赖文件和生成的命令。
2. 隐式规则。由于我们的 make 有自动推导的功能，所以隐式规则可以让我们比较简略地书写 Makefile，这是由 make 所支持的。
3. 变量的定义。在 Makefile 中我们要定义一系列的变量，变量一般都是字符串，这个有点像你 C 语
言中的宏，当 Makefile 被执行时，其中的变量都会被扩展到相应的引用位置上。
4. 指令。其包括了三个部分，一个是在一个 Makefile 中引用另一个 Makefile，就像 C 语言中的 include
一样；另一个是指根据某些情况指定 Makefile 中的有效部分，就像 C 语言中的预编译 #if 一样；
还有就是定义一个多行的命令。有关这一部分的内容，我会在后续的部分中讲述。
5. 注释。Makefile 中只有行注释，和 UNIX 的 Shell 脚本一样，其注释是用 # 字符，这个就像 C/C++
中的 // 一样。如果你要在你的 Makefile 中使用 # 字符，可以用反斜杠进行转义，如：\# 。

最后，还值得一提的是，在 Makefile 中的命令，必须要以 Tab 键开始。

默认的情况下，make 命令会在当前目录下按顺序寻找文件名为 GNUmakefile 、makefile 和
Makefile 的文件。在这三个文件名中，最好使用 Makefile 这个文件名，因为这个文件名在排序上靠
近其它比较重要的文件，比如 README。最好不要用 GNUmakefile，因为这个文件名只能由 GNU make ，
其它版本的 make 无法识别，但是基本上来说，大多数的 make 都支持 makefile 和 Makefile 这两种默
认文件名。
当然，你可以使用别的文件名来书写 Makefile，比如：“Make.Solaris”，“Make.Linux”等，如果要
指定特定的 Makefile，你可以使用 make 的 -f 或 --file 参数，如：make -f Make.Solaris 或 make
--file Make.Linux 。如果你使用多条 -f 或 --file 参数，你可以指定多个 makefile。

包含其他makefile
在 Makefile 使用 include 指令可以把别的 Makefile 包含进来，这很像 C 语言的 #include ，被包
含的文件会原模原样的放在当前文件的包含位置。include 的语法是：
include <filenames>...
<filenames> 可以是当前操作系统 Shell 的文件模式（可以包含路径和通配符）。
在 include 前面可以有一些空字符，但是绝不能是 Tab 键开始。include 和 <filenames> 可以用一
个或多个空格隔开。
举个例子，你有这样几个 Makefile：a.mk 、b.mk 、c.mk ，还有一个文件叫 foo.make
，以及一个变量 $(bar) ，其包含了 bish 和 bash ，那么，下面的语句：
include foo.make *.mk $(bar)
等价于：
include foo.make a.mk b.mk c.mk bish bash

make 命令开始时，会找寻 include 所指出的其它 Makefile，并把其内容安置在当前的位置。就好
像 C/C++ 的 #include 指令一样。如果文件都没有指定绝对路径或是相对路径的话，make 会在当前目
录下首先寻找，如果当前目录下没有找到，那么，make 还会在下面的几个目录下找：

1. 如果 make 执行时，有 -I 或 --include-dir 参数，那么 make 就会在这个参数所指定的目录下去
寻找。
2. 接下来按顺序寻找目录 <prefix>/include （一般是 /usr/local/bin ）、/usr/gnu/include 、
/usr/local/include 、/usr/include 。
环境变量 .INCLUDE_DIRS 包含当前 make 会寻找的目录列表。你应当避免使用命令行参数 -I 来寻
找以上这些默认目录，否则会使得 make “忘掉”所有已经设定的包含目录，包括默认目录。

如果有文件没有找到的话，make 会生成一条警告信息，但不会马上出现致命错误。它会继续载入其
它的文件，一旦完成 makefile 的读取，make 会再重试这些没有找到，或是不能读取的文件，如果还是不
行，make 才会出现一条致命信息。如果你想让 make 不理那些无法读取的文件，而继续执行，你可以在
include 前加一个减号“-”。如：
-include <filenames>...
其表示，无论 include 过程中出现什么错误，都不要报错继续执行。如果要和其它版本 make 兼容，
可以使用 sinclude 代替 -include 。

make 的工作方式
GNU 的 make 工作时的执行步骤如下：（想来其它的 make 也是类似）
1. 读入所有的 Makefile。
2. 读入被 include 的其它 Makefile。
3. 初始化文件中的变量。
4. 推导隐式规则，并分析所有规则。
5. 为所有的目标文件创建依赖关系链。
6. 根据依赖关系，决定哪些目标要重新生成。
7. 执行生成命令。
1-5 步为第一个阶段，6-7 为第二个阶段。第一个阶段中，如果定义的变量被使用了，那么，make 会
把其展开在使用的位置。但 make 并不会完全马上展开，make 使用的是拖延战术，如果变量出现在依赖
关系的规则中，那么仅当这条依赖被决定要使用了，变量才会在其内部展开。

当然，这个工作方式你不一定要清楚，但是知道这个方式你也会对 make 更为熟悉。有了这个基础，
后续部分也就容易看懂了。