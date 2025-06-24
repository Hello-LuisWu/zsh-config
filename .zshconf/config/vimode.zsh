# 初始化光标样式（兼容更多终端）
function _set_cursor() {
    if [[ $KEYMAP == vicmd ]]; then
        # normal模式：实心方块
        echo -ne '\e[2 q'
    else
        # insert模式：竖线
        echo -ne '\e[6 q'
    fi
}

# 动态右侧提示符
function _update_rprompt() {
    if [[ -n $PS1 ]]; then
        if [[ $KEYMAP == vicmd ]]; then
            RPS1="%F{yellow} %f"
        else
            RPS1="%F{blue}󰺫 %f"
        fi
        zle reset-prompt
    fi
}

# 模式切换处理
function zle-keymap-select {
    _set_cursor
    _update_rprompt
    zle reset-prompt
}

# 初始化处理
function zle-line-init {
    typeset -g vi_mode=insert
    _set_cursor
    _update_rprompt
}

# 清理处理（回车执行命令后）
function zle-line-finish {
    RPS1=""
    zle reset-prompt
}

# 注册zle部件
zle -N zle-keymap-select
zle -N zle-line-init
zle -N zle-line-finish

# 绑定vi模式
bindkey -v

# 设置提示符基础格式（保留原提示风格）
PS1="%n@%m:%~%# "

# 右侧提示符初始化
RPS1="%F{blue} %f"

# 超时设置（保持模式指示稳定）
export KEYTIMEOUT=1

# 清除之前提示行的右侧内容（兼容多行提示）
precmd() {
    RPS1="%F{blue} %f"
    _set_cursor
}

# 确保执行命令后重置显示
preexec() {
    RPS1=""
    zle && zle reset-prompt
}

# 修正退格键行为
bindkey '^?' backward-delete-char


# 禁用默认的 vi-mode 提示
export VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
# 解决INSERT模式下Delete键失效问题 -------------------------------------
bindkey -M viins '^?'  backward-delete-char
bindkey -M viins '^[[3~' delete-char
bindkey '^r' history-incremental-search-backward

# 设置快捷键绑定 ------------------------------------------------------
bindkey -M vicmd 'H' vi-first-non-blank
bindkey -M vicmd 'L' vi-end-of-line
bindkey -M viins '^\\' vi-cmd-mode
