# 感谢Job Vranish (https://spin.atomicobject.com/2016/08/26/makefile-c-projects/)
TARGET_EXEC := final_program

BUILD_DIR := ./build
SRC_DIRS := ./src

# 找到我们要编译的所有C和C++文件
# 请注意 * 表达式两边的单引号。 否则Make会在那里错误地展开。
SRCS := $(shell find $(SRC_DIRS) -name '*.cpp' -or -name '*.c' -or -name '*.s')

# 每个C/C++文件的字符串替换。
# 例如，hello.cpp变成./build/hello.cpp.o
OBJS := $(SRCS:%=$(BUILD_DIR)/%.o)

# 字符串替换(不带%的后缀版本)。
#例如，./build/hello.cpp.o变成./build/hello.cpp.d
DEPS := $(OBJS:.o=.d)

# ./src中的每个文件夹将需要传递给GCC，以便它可以找到头文件
INC_DIRS := $(shell find $(SRC_DIRS) -type d)
# 为INC_DIRS添加前缀。所以moduleA会变成-ImoduleA。GCC会理解-I标志
INC_FLAGS := $(addprefix -I,$(INC_DIRS))

# -MMD和-MP标志一起为我们生成Makefiles！
# 这些文件将有.d而不是.o作为输出。
CPPFLAGS := $(INC_FLAGS) -MMD -MP

# 最后一个构建步骤。
$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
	$(CC) $(OBJS) -o $@ $(LDFLAGS)

# C源代码的构建步骤
$(BUILD_DIR)/%.c.o: %.c
	mkdir -p $(dir $@)
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

# C++源代码构建步骤
$(BUILD_DIR)/%.cpp.o: %.cpp
	mkdir -p $(dir $@)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@


.PHONY: clean
clean:
	rm -r $(BUILD_DIR)

# 包含.d makefiles。 
# 前面的 - 抑制缺少makefile的错误。 
# 最初，所有的.d文件都将丢失，我们不希望出现这些错误。
-include $(DEPS)