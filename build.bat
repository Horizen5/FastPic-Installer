@echo off
chcp 65001 >nul
echo ========================================
echo   FastPic 看图工具 - 安装包编译脚本
echo ========================================
echo.

:: 检查 NSIS 是否安装
where makensis >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未找到 makensis.exe，请先安装 NSIS 3.12+
    echo 下载地址: https://nsis.sourceforge.io/Download
    pause
    exit /b 1
)

:: 检查脚本文件
if not exist "setup.nsi" (
    echo [错误] 未找到 setup.nsi
    pause
    exit /b 1
)

:: 检查源文件目录
if not exist "source\fastpic.exe" (
    echo [错误] 未找到 source\fastpic.exe，请将程序文件放入 source 目录
    pause
    exit /b 1
)

:: 检查图标文件
if not exist "assets\fastpic.ico" (
    echo [警告] 未找到 assets\fastpic.ico，将使用默认图标
)

echo [信息] 开始编译...
echo.

:: 编译
makensis /INPUTCHARSET UTF8 setup.nsi

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo   编译成功！
    echo ========================================
    echo.
    echo 输出文件: FastPic_Setup_1.0.0.exe
    echo.
) else (
    echo.
    echo ========================================
    echo   编译失败！请检查错误信息。
    echo ========================================
    echo.
)

pause
