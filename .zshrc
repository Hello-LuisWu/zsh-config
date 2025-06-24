#### 插件目录变量 #####
export zps=~/.zsh/plugins
export zcg=~/.zsh/config


#####################
# plugin install
#####################

##### autopair config #####
source $zps/zsh-autopair/autopair.zsh
# if [[ ! -d $zps/zsh-autopair ]]; then
#   git clone https://gitee.com/hello-luiswu/zsh-autopair.git $zps/zsh-autopair
# fi
autopair-init

source $zps/zsh-completions/zsh-completions.plugin.zsh

source $zps/zsh-autosuggestions/zsh-autosuggestions.zsh

source $zps/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source $zps/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

##### fzf-tab config #####

# 启用补全系统
autoload -Uz compinit
compinit

# 启用历史记录共享，跨多个终端共享历史
setopt share_history

# 启用补全提示
zstyle ':completion:*' menu no  # 显示补全菜单

# 设置补全项的描述格式，以支持分组显示
# 例如，在补全命令时，可以看到 `[文件]` `[目录]` 这样的分组标签
# 注意：这里不能使用颜色格式（如 `%F{red}`），fzf-tab 会忽略它们
zstyle ':completion:*:descriptions' format '[%d]'

# 启用按需加载补全（如 git，docker）
zstyle ':completion:*' list-prompt %SScrolling active: %p%% ... %v%r%T

# 启用自动补全的行为（忽略大小写）
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 补全时，文件排序规则：按名称排序
zstyle ':completion:*' file-sort name

# 自定义 `fzf` 的参数（`fzf-flags`）
# 这里设置了：
# - `--color=fg:1,fg+:2`：定义前景色
# - `--bind=tab:down,btab:up,enter:accept`：让 `Tab` 键上下选择
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:down,btab:up,enter:accept  # 自定义 fzf 的按键绑定，让 Tab 向下选择

# 设置 fzf-tab 提示的颜色和样式（可自定义）
zstyle ':fzf-tab:*' prompt '⚡'  # 在 fzf-tab 提示中显示 ⚡ 字符
zstyle ':fzf-tab:*' search-keys 'ctrl-r'  # 启用 `ctrl-r` 作为搜索键

# 启用历史命令自动补全（建议打开）
setopt hist_ignore_all_dups  # 忽略历史中的重复命令
setopt share_history          # 多终端共享历史

# 定义函数：仅在加载 fzf-tab 时检查并安装 fzf
# --------------------------------------------------
function _check_and_install_fzf_for_fzf_tab() {
  # 如果 fzf 已存在，直接返回
  command -v fzf &>/dev/null && return 0

  echo "检测到 fzf-tab 需要 fzf，但 fzf 未安装，正在安装..."

  # 根据操作系统选择安装方式
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS 使用 Homebrew
    if ! command -v brew &>/dev/null; then
      echo "错误：Homebrew 未安装，请先安装 Homebrew (https://brew.sh/)" >&2
      return 1
    fi
    brew install fzf
  elif [[ -f /etc/os-release ]]; then
    # 解析 Linux 发行版
    . /etc/os-release
    case "$ID" in
      ubuntu|debian)
        sudo apt update && sudo apt install -y fzf ;;
      arch|manjaro)
        sudo pacman -Sy --noconfirm fzf ;;
      fedora)
        sudo dnf install -y fzf ;;
      *)
        # 未知发行版使用 Git 安装
        echo "未知 Linux 发行版 $ID，尝试通过 Git 安装..."
        if ! command -v git &>/dev/null; then
          echo "错误：git 未安装，无法克隆仓库" >&2
          return 1
        fi
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install ;;
    esac
  else
    echo "无法识别的操作系统，请手动安装 fzf: https://github.com/junegunn/fzf" >&2
    return 1
  fi

  # 最终验证安装结果
  if ! command -v fzf &>/dev/null; then
    echo "fzf 安装失败，fzf-tab 将无法工作！" >&2
    return 1
  fi
}

# 加载 fzf-tab 插件（需手动克隆仓库）
# --------------------------------------------------
# 插件路径：~/.zsh/plugins/fzf-tab
# 安装命令（如果未安装）：
# mkdir -p ~/.zsh/plugins && git clone https://github.com/Aloxaf/fzf-tab.git ~/.zsh/plugins/fzf-tab
# --------------------------------------------------
if [ -f ~/fzf-tab/fzf-tab.zsh ]; then
  # 检查并安装 fzf
  if _check_and_install_fzf_for_fzf_tab; then
    source ~/fzf-tab/fzf-tab.zsh

    # -------------------------------
    # fzf-tab 高级配置（可选）
    # -------------------------------
    # 禁用默认补全系统
    # zstyle ':completion:*' menu no
    # 使用 tmux 弹出窗口
    zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
  else
    echo "警告：未加载 fzf-tab，依赖未满足" >&2
  fi
fi


###############
# # 启动shell 检查有没有安装fzf
# if ! command -v fzf &>/dev/null; then
#     echo "fzf 未安装，正在安装..."

#     # 判断操作系统
#     if [[ "$OSTYPE" == "darwin"* ]]; then
#         # macOS 安装 fzf
#         if command -v brew &>/dev/null; then
#             brew install fzf
#         else
#             echo "未检测到 Homebrew，请先安装 Homebrew: https://brew.sh/"
#             exit 1
#         fi
#     elif [[ -f /etc/os-release ]]; then
#         # 读取 Linux 发行版信息
#         . /etc/os-release
#         case "$ID" in
#             ubuntu|debian)
#                 sudo apt update && sudo apt install -y fzf
#                 ;;
#             arch|manjaro)
#                 sudo pacman -Sy --noconfirm fzf
#                 ;;
#             fedora)
#                 sudo dnf install -y fzf
#                 ;;
#             *)
#                 echo "未知 Linux 发行版 ($ID)，使用 Git 方式安装 fzf..."
#                 git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
#                 ~/.fzf/install
#                 ;;
#         esac
#     else
#         echo "无法检测操作系统类型，请手动安装 fzf: https://github.com/junegunn/fzf"
#         exit 1
#     fi
# fi


###############


 # sh -c 'curl -fLo $zps/git-completion.zsh --create-dirs \
      # https://gitee.com/hello-luiswu/git/raw/master/contrib/completion/git-completion.zsh'
zstyle ':completion:*:*:git:*' script ~/.git-completion.bash

source $zps/fzf-tab/fzf-tab.zsh

#######################
# config
#######################
source $zcg/sudo.zsh
source $zcg/vi-mode.zsh

##############################
# keymapings
##############################
# zsh 原生历史搜索
bindkey '^[[A' history-search-backward  # 向上箭头（↑）
bindkey '^[[B' history-search-forward   # 向下箭头（↓）

##############################
# alias settings
##############################
alias q="exit"
alias c="clear"
alias l="ls"
alias ll="ls -lAh"
alias lll="clear && ls"
alias .="cd ../"
alias .="cd ../"
alias ..="cd ../../"
alias ...="cd ../../../"
alias rm="rm -rI"
alias rm="rm -I --preserve-root" # 禁止删除 /
alias cp="cp -ri"
alias mk="mkdir -p"
alias ghttp='git config --global http.proxy http://127.0.0.1:7890'
alias ghttps='git config --global https.proxy http://127.0.0.1:7890'
alias ghs='git config --global http.proxy http://127.0.0.1:7890 && git config --global https.proxy http://127.0.0.1:7890'
alias ghc='git config --global --unset http.proxy && git config --global --unset https.proxy'
alias gname='git config --global user.name "LuisWu"'
alias gmail='git config --global user.email "1014150883@qq.com"'
alias gconf="git config --global user.name"
alias gedit="git config --global user.name"
alias gedit="git config --global core.editor"
alias gge="git config --global --edit"
alias gce="git config --local --edit"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias ge="git clone --depth 1"
alias gC="git checkout"
alias gC="git branch"
alias n="nvim"
alias v="vim"
alias zz="nvim ~/.zshrc"
alias r="source ~/.zshrc"
alias cdns='sudo killall -HUP mDNSResponder'  # 清除 DNS 缓存

##############################
# starts
##############################
eval "$(starship init zsh)" # starship
eval "$(zoxide init zsh)"
