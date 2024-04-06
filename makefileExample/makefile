# 编译器设置
CXX := g++
CXXFLAGS := -std=c++11 -Wall -Wextra

# 目录设置
SRC_DIR := src
INC_DIR := include
BUILD_DIR := build
BIN_DIR := bin
LIB_DIR := lib
TEST_DIR := test

# 源文件和目标文件设置
SRCS := $(wildcard $(SRC_DIR)/**/*.cpp)
OBJS := $(patsubst $(SRC_DIR)/%.cpp, $(BUILD_DIR)/%.o, $(SRCS))
TARGET := $(BIN_DIR)/myprogram

# 链接时需要的动态库和静态库文件
DYN_LIBS := $(wildcard $(LIB_DIR)/*.so)
STAT_LIBS := $(wildcard $(LIB_DIR)/*.a)
LIBS := $(DYN_LIBS) $(STAT_LIBS)

# 检查库文件列表是否为空
ifeq ($(strip $(LIBS)),)
$(error No library files found in the lib directory.)
endif

# 默认目标
all: $(TARGET)

# 生成目标文件的规则
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -I$(INC_DIR) -c $< -o $@

# 链接规则
$(TARGET): $(OBJS)
	@mkdir -p $(BIN_DIR)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LIBS)

# 清理目标文件和可执行文件
clean:
	rm -rf $(BUILD_DIR) $(BIN_DIR)

# 单元测试
test:
	@cd $(TEST_DIR) && $(MAKE)

.PHONY: all clean test