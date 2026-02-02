# Environment variables

# PATH configuration
export PATH="$HOME/go/bin:$HOME/.local/bin:$PATH"
export IS_SANDBOX=1

# Locale settings
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# AFL (American Fuzzy Lop) fuzzer settings
export AFL_DEBUG=1
export AFL_SKIP_CRASHES=1
export AFL_FAST_CAL=1
export AFL_DONT_OPTIMIZE=1

# API base URLs
export OPENAI_BASE_URL="http://192.168.31.236:3001/v1"
export ANTHROPIC_BASE_URL="http://192.168.31.236:3001"

# Tool-specific settings
export PROTOCOL_GUARD_SQLITE_DATABASE=/root/ProtocolGuard-Database/sqlite_uFTPD.db
export ENABLE_TOOL_SEARCH=true

export https_proxy="http://10.108.250.1:63333"
export http_proxy="http://10.108.250.1:63333"
