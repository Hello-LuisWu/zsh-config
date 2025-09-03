export LANG=zh_CN.UTF-8
#### 配置目录 #####
#### 配置目录优化版 ####
ZSHCONF_DIR="${HOME}/.zshconf"  # 使用变量存储路径
SUB_DIRS=("config" "plugins")    # 存储子目录数组

if [[ ! -d "${ZSHCONF_DIR}" ]]; then
    echo "➔ 检测到 ${ZSHCONF_DIR} 目录不存在，正在创建目录结构..."

    # 使用循环创建子目录，方便后续扩展
    mkdir -p "${ZSHCONF_DIR}"
    for dir in "${SUB_DIRS[@]}"; do
        mkdir -p "${ZSHCONF_DIR}/${dir}"
        echo "✓ 创建子目录: ${ZSHCONF_DIR}/${dir}"
    done

    echo "✅ 目录结构创建完成"
fi
export zps=~/.zshconf/plugins
export zcg=~/.zshconf/config

#####################
# plugin install
#####################

##### autopair config #####
if [[ ! -d $zps/zsh-autopair ]]; then
    git clone https://gitee.com/hello-luiswu/zsh-autopair.git $zps/zsh-autopair
fi
source $zps/zsh-autopair/autopair.zsh
autopair-init

if [[ ! -d $zps/zsh-completions ]]; then
  git clone https://gitee.com/hello-luiswu/zsh-completions.git $zps/zsh-completions
fi
source $zps/zsh-completions/zsh-completions.plugin.zsh

if [[ ! -d $zps/zsh-autosuggestions ]]; then
   git clone https://gitee.com/hello-luiswu/zsh-autosuggestions.git $zps/zsh-autosuggestions
fi
source $zps/zsh-autosuggestions/zsh-autosuggestions.zsh

if [[ ! -d $zps/zsh-syntax-highlighting ]]; then
   git clone https://gitee.com/hello-luiswu/zsh-syntax-highlighting.git $zps/zsh-syntax-highlighting
fi
source $zps/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

##### fzf-tab config #####
# 启用补全系统
autoload -Uz compinit && compinit
setopt share_history # 启用历史记录共享，跨多个终端共享历史
zstyle ':completion:*' menu no  # 显示补全菜单
zstyle ':completion:*:descriptions' format '[%d]' # 设置补全项的描述格式，以支持分组显示
zstyle ':completion:*' list-prompt %SScrolling active: %p%% ... %v%r%T # 启用按需加载补全（如 git，docker）
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 启用自动补全的行为（忽略大小写）
zstyle ':fzf-tab:*' switch-group '<' '>' # 使用 `<` 和 `>` 切换补全分组（例如，文件 / 目录 / 命令等分组）
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath' # 当使用 `cd` 命令补全目录时，使用 `eza` 命令（类似 `ls`）预览目录内容
zstyle ':completion:*' file-sort name # 补全时，文件排序规则：按名称排序
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:down,btab:up,enter:accept  # 自定义 fzf 的按键绑定，让 Tab 向下选择
zstyle ':fzf-tab:*' prompt '⚡'  # 在 fzf-tab 提示中显示 ⚡ 字符
zstyle ':fzf-tab:*' search-keys 'ctrl-r'  # 启用 `ctrl-r` 作为搜索键
# 启用历史命令自动补全（建议打开）
setopt hist_ignore_all_dups  # 忽略历史中的重复命令
setopt share_history          # 多终端共享历史

if [[ ! -f $zcg/git-completion.zsh ]]; then
    sh -c 'curl -fLo $zcg/git-completion.zsh --create-dirs \
        https://gitee.com/hello-luiswu/git/raw/master/contrib/completion/git-completion.zsh'
fi
zstyle ':completion:*:*:git:*' script $zcg/git-completion.zsh

if [[ ! -d $zps/fzf-tab ]]; then
   git clone https://gitee.com/hello-luiswu/fzf-tab.git $zps/fzf-tab
fi
source $zps/fzf-tab/fzf-tab.zsh

#######################
# config
#######################
if [[ ! -f $zcg/sudo.zsh ]]; then
    sh -c 'curl -fLo $zcg/sudo.zsh --create-dirs \
        https://gitee.com/hello-luiswu/zsh-config/raw/master/.zshconf/config/sudo.zsh'
fi
source $zcg/sudo.zsh

if [[ ! -f $zcg/vimode.zsh ]]; then
    sh -c 'curl -fLo $zcg/vimode.zsh --create-dirs \
        https://gitee.com/hello-luiswu/zsh-config/raw/master/.zshconf/config/vimode.zsh'
fi
source $zcg/vimode.zsh

##############################
# keymapings
##############################
# zsh 原生历史搜索
bindkey '^[[A' history-search-backward  # 向上箭头（↑）
bindkey '^[[B' history-search-forward   # 向下箭头（↓）

##############################
# starts
##############################
# 启动shell 检查有没有安装fzf
if ! command -v fzf &>/dev/null; then
    echo "fzf 未安装，正在安装..."

    # 判断操作系统
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS 安装 fzf
        if command -v brew &>/dev/null; then
            brew install fzf
        else
            echo "未检测到 Homebrew，请先安装 Homebrew: https://brew.sh/"
            exit 1
        fi
    elif [[ -f /etc/os-release ]]; then
        # 读取 Linux 发行版信息
        . /etc/os-release
        case "$ID" in
            ubuntu|debian)
                sudo apt update && sudo apt install -y fzf
                ;;
            arch|manjaro)
                sudo pacman -Sy --noconfirm fzf
                ;;
            fedora)
                sudo dnf install -y fzf
                ;;
            *)
                echo "未知 Linux 发行版 ($ID)，使用 Git 方式安装 fzf..."
                git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
                ~/.fzf/install
                ;;
        esac
    else
        echo "无法检测操作系统类型，请手动安装 fzf: https://github.com/junegunn/fzf"
        exit 1
    fi
fi
# 检查 starship 是否安装
if ! command -v starship &>/dev/null; then
    echo "starship 未安装，正在安装..."

    # 判断操作系统
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS 安装 starship
        if command -v brew &>/dev/null; then
            brew install starship
        else
            echo "未检测到 Homebrew，请先安装 Homebrew: https://brew.sh/"
            exit 1
        fi
    elif [[ -f /etc/os-release ]]; then
        # 读取 Linux 发行版信息
        . /etc/os-release
        case "$ID" in
            ubuntu|debian)
                sudo apt update && sudo apt install -y starship
                ;;
            arch|manjaro)
                sudo pacman -Sy --noconfirm starship
                ;;
            fedora)
                sudo dnf install -y starship
                ;;
            *)
                echo "未知 Linux 发行版 ($ID)，尝试使用官方安装方式..."
                curl -sS https://starship.rs/install.sh | sh
                ;;
        esac
    else
        echo "无法检测操作系统类型，请手动安装 starship: https://starship.rs/"
        exit 1
    fi
fi
# 判断 ~/.config/starship.toml 是否存在
if [[ ! -f ~/.config/starship.toml ]]; then
    starship preset pastel-powerline -o ~/.config/starship.toml
fi
eval "$(starship init zsh)" # starship
# 检查 zoxide 是否安装
if ! command -v zoxide &>/dev/null; then
    echo "zoxide 未安装，正在安装..."

    # 判断操作系统
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS 安装 zoxide
        if command -v brew &>/dev/null; then
            brew install zoxide
        else
            echo "未检测到 Homebrew，请先安装 Homebrew: https://brew.sh/"
            exit 1
        fi
    elif [[ -f /etc/os-release ]]; then
        # 读取 Linux 发行版信息
        . /etc/os-release
        case "$ID" in
            ubuntu|debian)
                sudo apt update && sudo apt install -y zoxide
                ;;
            arch|manjaro)
                sudo pacman -Sy --noconfirm zoxide
                ;;
            fedora)
                sudo dnf install -y zoxide
                ;;
            *)
                echo "未知 Linux 发行版 ($ID)，尝试使用官方安装方式..."
                curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
                ;;
        esac
    else
        echo "无法检测操作系统类型，请手动安装 zoxide: https://github.com/ajeetdsouza/zoxide"
        exit 1
	fi
fi
eval "$(zoxide init zsh)"

alias ..="cd .."
alias c="clear"
alias q="exit"
alias rm="rm -rf"
alias cp="cp -ri"
alias mkdir="mkdir -p"
alias mk="mkdir"
alias i="fastfetch"
alias l="eza -la --icons --header --inode --time-style=long-iso"
alias ll="eza -l --icons --header --tree --time-style=long-iso --ignore-glob=.git --ignore-glob=.DS_Store"
alias ls="eza -a --icons"
alias re="source ~/.zshrc"
alias ga="git add ."
alias gc="git commit"
alias gl="git pull"
alias gp="git push"
alias gd="git diff"
alias gs="git status"
alias gw="git switch"
alias gb="git branch"
alias gk="git clone --depth 1"
alias gho='git config --global http.proxy http://127.0.0.1:7890 && git config --global https.proxy http://127.0.0.1:7890'
alias ghc='git config --global --unset http.proxy && git config --global --unset https.proxy'
alias gg="lazygit"
alias n="nvim"
alias v="vim"
alias zz="nvim ~/.zshrc"
alias geg="git config --global --edit"
alias gel="git config --local --edit"
alias gedit="git config --global core.editor vim"
alias gname="git config --global user.name LuisWu"
alias gmail="git config --global user.email 1014150883@qq.com"




export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
