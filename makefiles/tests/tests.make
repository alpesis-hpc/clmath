# ------------------------------------------------------------------------------------------------
# directories

# sources_dir
TESTS_UTILS_DIR = $(TESTS_DIR)/$(MODULE_UTILS)
TESTS_DEVICES_DIR = $(TESTS_DIR)/$(MODULE_DEVICES)
TESTS_HOSTS_DIR = $(TESTS_DIR)/$(MODULE_HOSTS)

# build_dir
BUILD_TESTS_UTILS_DIR = $(BUILD_TESTS_DIR)/$(MODULE_UTILS)
BUILD_TESTS_DEVICES_DIR = $(BUILD_TESTS_DIR)/$(MODULE_DEVICES)
BUILD_TESTS_HOSTS_DIR = $(BUILD_TESTS_DIR)/$(MODULE_HOSTS)


# ------------------------------------------------------------------------------------------------
# sources

# utils
TESTS_UTILS_SOURCES := $(wildcard $(TESTS_DIR)/$(MODULE_UTILS)/*.c)
TESTS_UTILS_OBJECTS := $(patsubst %, $(BUILD_TESTS_UTILS_DIR)/%, $(notdir $(TESTS_UTILS_SOURCES:.c=.o)))
TESTS_UTILS_TARGETS := $(patsubst %, $(BUILD_TESTS_UTILS_DIR)/%, $(notdir $(TESTS_UTILS_OBJECTS:.o=)))

# devices
TESTS_DEVICES_SOURCES := $(wildcard $(TESTS_DIR)/$(MODULE_DEVICES)/*.c)
TESTS_DEVICES_OBJECTS := $(patsubst %, $(BUILD_TESTS_DEVICES_DIR)/%, $(notdir $(TESTS_DEVICES_SOURCES:.c=.o)))
TESTS_DEVICES_TARGETS := $(patsubst %, $(BUILD_TESTS_DEVICES_DIR)/%, $(notdir $(TESTS_DEVICES_OBJECTS:.o=)))

# hosts
TESTS_HOSTS_SOURCES := $(wildcard $(TESTS_DIR)/$(MODULE_HOSTS)/*.c)
TESTS_HOSTS_OBJECTS := $(patsubst %, $(BUILD_TESTS_HOSTS_DIR)/%, $(notdir $(TESTS_HOSTS_SOURCES:.c=.o)))
TESTS_HOSTS_TARGETS := $(patsubst %, $(BUILD_TESTS_HOSTS_DIR)/%, $(notdir $(TESTS_HOSTS_OBJECTS:.o=)))


# ------------------------------------------------------------------------------------------------
# compiler

TESTS_CFLAGS = $(CC_CFLAGS) 
TESTS_LDFLAGS = -L$(BUILD_SOURCES_DIR) -lclmath $(CC_LDFLAGS)
# TESTS_LDFLAGS = $(CC_LDFLAGS) \
#                -L$(BUILD_UTILS_DIR) -lclmath_utils \
#                -L$(BUILD_DEVICES_DIR) -lclmath_devices \
#                -L$(BUILD_HOSTS_DIR) -lclmath_hosts

# ------------------------------------------------------------------------------------------------
# complication: tests_utils

tests_utils: $(TESTS_UTILS_TARGETS)

# devices
$(BUILD_TESTS_UTILS_DIR)/% : $(BUILD_TESTS_UTILS_DIR)/%.o
	@echo "$(RED)Linking $@ $(NC)"
	$(CC) $(TESTS_CFLAGS) -o $@ $^ $(TESTS_LDFLAGS)

$(BUILD_TESTS_UTILS_DIR)/%.o : $(TESTS_UTILS_DIR)/%.c
	@echo "$(RED)Compiling $< $(NC)"
	$(CC) $(TESTS_CFLAGS) -c $< -o $@ 

# ------------------------------------------------------------------------------------------------
# complication: tests_devices

tests_devices: $(TESTS_DEVICES_TARGETS)

# devices
$(BUILD_TESTS_DEVICES_DIR)/% : $(BUILD_TESTS_DEVICES_DIR)/%.o
	@echo "$(RED)Linking $@ $(NC)"
	$(CC) $(TESTS_CFLAGS) -o $@ $^ $(TESTS_LDFLAGS)

$(BUILD_TESTS_DEVICES_DIR)/%.o : $(TESTS_DEVICES_DIR)/%.c
	@echo "$(RED)Compiling $< $(NC)"
	$(CC) $(TESTS_CFLAGS) -c $< -o $@ 

# ------------------------------------------------------------------------------------------------
# complication: tests_hosts

tests_hosts: $(TESTS_HOSTS_TARGETS)

# hosts
$(BUILD_TESTS_HOSTS_DIR)/% : $(BUILD_TESTS_HOSTS_DIR)/%.o
	@echo "$(RED)Linking $@ $(NC)"
	$(CC) $(TESTS_CFLAGS) -o $@ $^ $(TESTS_LDFLAGS)

$(BUILD_TESTS_HOSTS_DIR)/%.o : $(TESTS_HOSTS_DIR)/%.c
	@echo "$(RED)Compiling $< $(NC)"
	$(CC) $(TESTS_CFLAGS) -c $< -o $@ 


# ------------------------------------------------------------------------------------------------
# tests

run_tests_utils: tests_utils
	@echo "$(RED) run tests_utils:$(NC)"
	$(foreach test, $(TESTS_UTILS_TARGETS), \
          $(test) | grep "FAIL"; \
          echo "$(GREEN) TEST $(test)$(NC)";)
	
run_tests_devices: tests_devices
	@echo "$(RED) run tests_devices:$(NC)"
	$(foreach test, $(TESTS_DEVICES_TARGETS), \
          $(test) | grep "FAIL"; \
          echo "$(GREEN) TEST $(test)$(NC)";)	

run_tests_hosts: tests_hosts
	@echo "$(RED) run tests_hosts:$(NC)"
	$(foreach test, $(TESTS_HOSTS_TARGETS), \
          $(test) | grep "FAIL"; \
          echo "$(GREEN) TEST $(test)$(NC)";)	
