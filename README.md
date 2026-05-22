# FastPic 看图工具 - 安装程序

FastPic 看图工具的 NSIS 安装包脚本，支持安装、注册表写入、文件关联和设置为默认看图程序。

## 功能特性

- ✅ 安装向导（中文界面，MUI2 现代风格）
- ✅ 自定义安装向导图标和侧边栏图片
- ✅ 写入系统注册表（卸载信息、应用路径）
- ✅ 关联 13 种常见图片格式为默认看图程序
- ✅ 开始菜单快捷方式
- ✅ 可选桌面快捷方式（默认不勾选）
- ✅ 可选安装后立即运行（默认勾选）
- ✅ 完整卸载支持（清理注册表和文件）
- ✅ LZMA 压缩，生成单个 EXE 安装包

## 项目结构

```
FastPic-Installer/
├── setup.nsi              # NSIS 安装脚本（主文件）
├── assets/
│   ├── fastpic.ico        # 软件图标（多尺寸 ICO）
│   ├── wizard.bmp         # 安装向导左侧大图（164×314）
│   └── header.bmp         # 安装向导顶部小图（150×57）
├── source/                # 需要打包的程序文件
│   ├── fastpic.exe        # 主程序
│   ├── *.dll              # 依赖库
│   ├── *.dat              # 配置文件
│   └── *.manifest         # 清单文件
├── build.bat              # 一键编译脚本
└── README.md              # 说明文档
```

## 环境要求

- **NSIS 3.12+**：[https://nsis.sourceforge.io/Download](https://nsis.sourceforge.io/Download)
- **Python 3.x**（仅图标生成时需要，可选）
- **Windows 操作系统**

## 快速开始

### 1. 安装 NSIS

下载并安装 [NSIS 3.12](https://nsis.sourceforge.io/Download)，安装时选择完整安装。

### 2. 准备文件

将程序文件放入 `source/` 目录，将图标和位图放入 `assets/` 目录。

### 3. 修改配置

编辑 `setup.nsi` 顶部的配置项：

```nsi
!define PRODUCT_NAME "FastPic 看图工具"       ; 软件名称
!define PRODUCT_VERSION "1.0.0"               ; 版本号
!define PRODUCT_PUBLISHER "FastPic"           ; 发布者
!define PRODUCT_EXE "fastpic.exe"            ; 主程序文件名
!define SOURCE_DIR "source"                   ; 源文件目录（相对路径）
!define ICON_FILE "assets\fastpic.ico"        ; 图标文件
!define WIZARD_BMP "assets\wizard.bmp"        ; 向导侧边栏图片
!define HEADER_BMP "assets\header.bmp"        ; 向导顶部图片
```

### 4. 编译

**方式一：使用命令行**
```cmd
makensis setup.nsi
```

**方式二：使用一键脚本**
```cmd
build.bat
```

编译完成后，输出文件为 `FastPic_Setup_1.0.0.exe`。

## 关联的图片格式

安装时勾选"设置为默认看图程序"后，将关联以下格式：

| 格式 | 扩展名 |
|------|--------|
| JPEG | .jpg, .jpeg |
| PNG | .png |
| BMP | .bmp |
| GIF | .gif |
| TIFF | .tif, .tiff |
| ICO | .ico |
| WebP | .webp |
| TGA | .tga |
| PSD | .psd |
| RAW | .raw |
| DDS | .dds |

## 注册表操作

安装程序会写入以下注册表项：

| 注册表路径 | 用途 |
|-----------|------|
| `HKLM\Software\FastPic` | 存储安装路径和版本 |
| `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\fastpic.exe` | 应用程序路径注册 |
| `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\FastPic` | 控制面板卸载信息 |
| `HKLM\SOFTWARE\Classes\FastPic.Image` | 文件类型 ProgID |
| `HKLM\SOFTWARE\Classes\.xxx` | 各图片格式关联 |

## 自定义图标

如需更换图标，准备一个包含多尺寸（16/24/32/48px）的 ICO 文件，使用 Python 生成：

```python
from PIL import Image

img = Image.open("your_icon.png").convert("RGBA")
for size in [16, 24, 32, 48]:
    resized = img.resize((size, size), Image.LANCZOS)
    resized.save(f"icon_{size}x{size}.png")
```

然后使用 ICO 合并工具将多个 PNG 合并为一个 ICO 文件。

## License

MIT License
