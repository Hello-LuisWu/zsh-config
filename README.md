# zsh-config

## 介绍
zsh 单独配置

## 环境配置：

### 安装 zsh

#### macOS 安装 zsh
```sh
brew install zsh
```

#### Ubuntu 安装 zsh

```
sudo apt install -y zsh
```

#### Arch (manjaro) 安装 zsh

```
sudo pacman -Sy zsh
```

#### Rocky linux

```
dnf -y install zsh
```

---

#### zsh 设置

##### 查看系统已有的 shell

```
cat /etc/shells
```

**输出结果：**

```
/bin/sh
/bin/bash
/usr/bin/bash
/bin/rbash
/usr/bin/rbash
/usr/bin/sh
/bin/dash
/usr/bin/dash
/bin/zsh
/usr/bin/zsh
```
以上输出结果可以看到已经有 zsh 了

##### 切换默认 shell

**执行命令：**

```shell
chsh -s /bin/zsh
```

**注意**：Rocky linux 切换命令为：

```shell
# root 是你当前的用户名
usermod -s /bin/zsh root
```


重启系统！

##### 查看当前使用的 shell

**执行命令：**

```
echo $SHELL
```

**输出结果：**

```
/bin/zsh
```

以上输出结果可以看到，默认的 shell 已经变成了 zsh 

---

### 安装 git 

安装 OhMyZsh 的过程中会从 Github 克隆 OhMyZsh 相关文件，所以必须安装 git

#### macOS

```sh
brew install git
```

#### Ubuntu

```sh
sudo apt-get -y install git
```

#### Arch(Manjaro)

```sh
sudo pacman -Sy git
```

---

## Github 无法访问

**解决raw.githubusercontent.com无法访问:** 

```sh
sudo sh -c 'echo "185.199.108.133 raw.githubusercontent.com" >> /etc/hosts'
```
或者下载 steam++ 挂代理

## 下载 .zshrc 配置文件

如果你原本就有 `.zshrc` 文件，建议先备份一下：

```sh
cp ~/.zshrc ~/.zshrc.bak
```

将 `.zshrc` 文件下载到你的 `~/` 目录下：

```sh
# 使用 curl 下载
curl -o ~/.zshrc https://gitee.com/hello-luiswu/zsh-config/raw/master/.zshrc

# 或者使用 wget 下载
wget -O ~/.zshrc https://gitee.com/hello-luiswu/zsh-config/raw/master/.zshrc
```

完成如上步骤重启终端或者 运行命令 `source ~/.zshrc`