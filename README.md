## Requirements

### 需要安装带有 rsvg 的 imagemagick 用来处理 SVG

MAC OS 下
```bash
  brew install imagemagick --with-librsvg
```

## Install

```bash
  $ gem install komic-cli
```

## Usage

```
  Commands:
    komic download URL    # 从 url 下载画册数据 (* 目前只支持豆瓣相册)
    komic mock            # 生成虚拟的画册数据])
    komic help [COMMAND]  # Describe available commands or one specific command

  Usage:
    komic mock

    Options:
    [--page-number=PAGE-NUMBER]   # 设定页数
                                  # Default: 6
    [--size=SIZE]                 # 设定尺寸
                                  # Default: 700-1024x900-1000
    [--name=NAME]                 # 设定文件夹名
                                  # Default: mock
```
