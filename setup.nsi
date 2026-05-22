; ============================================================
; FastPic 看图工具 - NSIS 安装脚本
; ============================================================

!include "MUI2.nsh"
!include "FileFunc.nsh"
!include "nsDialogs.nsh"

; --- 基本信息 ---
!define PRODUCT_NAME "FastPic 看图工具"
!define PRODUCT_VERSION "1.0.0"
!define PRODUCT_PUBLISHER "FastPic"
!define PRODUCT_EXE "fastpic.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\FastPic"
!define PRODUCT_DIR_REGKEY "Software\FastPic"
!define SOURCE_DIR "C:\FastPicBuild\source"
!define ICON_FILE "C:\FastPicBuild\assets\fastpic.ico"
!define WIZARD_BMP "C:\FastPicBuild\assets\wizard.bmp"
!define HEADER_BMP "C:\FastPicBuild\assets\header.bmp"

; --- 输出设置 ---
OutFile "C:\FastPicBuild\FastPic_Setup_${PRODUCT_VERSION}.exe"
InstallDir "$PROGRAMFILES64\FastPic"
InstallDirRegKey HKLM "${PRODUCT_DIR_REGKEY}" "InstallDir"
RequestExecutionLevel admin
SetCompressor /SOLID lzma
SetCompressorDictSize 64

; --- 版本信息 ---
VIProductVersion "${PRODUCT_VERSION}.0"
VIAddVersionKey "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey "ProductVersion" "${PRODUCT_VERSION}"
VIAddVersionKey "CompanyName" "${PRODUCT_PUBLISHER}"
VIAddVersionKey "FileDescription" "${PRODUCT_NAME} 安装程序"
VIAddVersionKey "FileVersion" "${PRODUCT_VERSION}"
VIAddVersionKey "LegalCopyright" "Copyright (C) 2026 ${PRODUCT_PUBLISHER}"

; --- 图标设置 ---
Icon "${ICON_FILE}"
UninstallIcon "${ICON_FILE}"

; --- MUI 界面设置 ---
!define MUI_ICON "${ICON_FILE}"
!define MUI_UNICON "${ICON_FILE}"
!define MUI_ABORTWARNING
!define MUI_LANGDLL_ALLLANGUAGES

; 安装向导左侧大图 (164x314 BMP)
!define MUI_WELCOMEFINISHPAGE_BITMAP "${WIZARD_BMP}"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "${WIZARD_BMP}"

; 安装向导顶部小图 (150x57 BMP)
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "${HEADER_BMP}"
!define MUI_HEADERIMAGE_RIGHT

; 欢迎页面
!define MUI_WELCOMEPAGE_TITLE "欢迎使用 ${PRODUCT_NAME}"
!define MUI_WELCOMEPAGE_TEXT "本向导将引导您完成 ${PRODUCT_NAME} 的安装。$\r$\n$\r$\n建议关闭其他应用程序后再继续安装。"

; 安装目录页面
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES

; 安装完成页面
!define MUI_FINISHPAGE_RUN "$INSTDIR\${PRODUCT_EXE}"
!define MUI_FINISHPAGE_RUN_TEXT "立即运行 ${PRODUCT_NAME}"
!define MUI_FINISHPAGE_SHOWREADME "$INSTDIR\create_shortcut.vbs"
!define MUI_FINISHPAGE_SHOWREADME_TEXT "创建桌面快捷方式"
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
!insertmacro MUI_PAGE_FINISH

; 卸载页面
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; --- 语言 ---
!insertmacro MUI_LANGUAGE "SimpChinese"

; --- 安装属性 ---
Name "${PRODUCT_NAME}"
BrandingText "${PRODUCT_NAME} ${PRODUCT_VERSION}"
ShowInstDetails show
ShowUnInstDetails show
CRCCheck on

; ============================================================
; 安装段
; ============================================================
Section "主程序" SEC01
  SectionIn RO

  SetOutPath "$INSTDIR"

  ; 打包所有文件
  File /nonfatal "${SOURCE_DIR}\*.dll"
  File /nonfatal "${SOURCE_DIR}\*.dat"
  File /nonfatal "${SOURCE_DIR}\*.manifest"
  File "${SOURCE_DIR}\${PRODUCT_EXE}"

  ; 创建卸载程序
  WriteUninstaller "$INSTDIR\uninst.exe"

  ; 创建桌面快捷方式辅助脚本（完成页面复选框调用）
  FileOpen $4 "$INSTDIR\create_shortcut.vbs" w
  FileWrite $4 'Set WshShell = WScript.CreateObject("WScript.Shell")'
  FileWriteByte $4 13
  FileWriteByte $4 10
  FileWrite $4 'desktop = WshShell.SpecialFolders("Desktop")'
  FileWriteByte $4 13
  FileWriteByte $4 10
  FileWrite $4 'Set shortcut = WshShell.CreateShortcut(desktop & "\${PRODUCT_NAME}.lnk")'
  FileWriteByte $4 13
  FileWriteByte $4 10
  FileWrite $4 'shortcut.TargetPath = "$INSTDIR\${PRODUCT_EXE}"'
  FileWriteByte $4 13
  FileWriteByte $4 10
  FileWrite $4 'shortcut.IconLocation = "$INSTDIR\${PRODUCT_EXE},0"'
  FileWriteByte $4 13
  FileWriteByte $4 10
  FileWrite $4 'shortcut.Save'
  FileWriteByte $4 13
  FileWriteByte $4 10
  FileWrite $4 'Set fso = CreateObject("Scripting.FileSystemObject")'
  FileWriteByte $4 13
  FileWriteByte $4 10
  FileWrite $4 'fso.DeleteFile WScript.ScriptFullName'
  FileWriteByte $4 13
  FileWriteByte $4 10
  FileClose $4
SectionEnd

Section "开始菜单快捷方式" SEC02
  CreateDirectory "$SMPROGRAMS\${PRODUCT_NAME}"
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\${PRODUCT_NAME}.lnk" "$INSTDIR\${PRODUCT_EXE}" "" "$INSTDIR\${PRODUCT_EXE}" 0
  CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}\卸载 ${PRODUCT_NAME}.lnk" "$INSTDIR\uninst.exe"
SectionEnd

Section "设置为默认看图程序" SEC03
  ; === 注册应用程序 ProgID ===
  WriteRegStr HKLM "SOFTWARE\Classes\FastPic.Image" "" "FastPic 图片文件"
  WriteRegStr HKLM "SOFTWARE\Classes\FastPic.Image\DefaultIcon" "" "$INSTDIR\${PRODUCT_EXE},0"
  WriteRegStr HKLM "SOFTWARE\Classes\FastPic.Image\shell\open\command" "" '"$INSTDIR\${PRODUCT_EXE}" "%1"'

  ; === 关联所有常见图片格式 ===
  WriteRegStr HKLM "SOFTWARE\Classes\.jpg" "" "FastPic.Image"
  WriteRegStr HKLM "SOFTWARE\Classes\.jpeg" "" "FastPic.Image"
  WriteRegStr HKLM "SOFTWARE\Classes\.png" "" "FastPic.Image"
  WriteRegStr HKLM "SOFTWARE\Classes\.bmp" "" "FastPic.Image"
  WriteRegStr HKLM "SOFTWARE\Classes\.gif" "" "FastPic.Image"
  WriteRegStr HKLM "SOFTWARE\Classes\.tif" "" "FastPic.Image"
  WriteRegStr HKLM "SOFTWARE\Classes\.tiff" "" "FastPic.Image"
  WriteRegStr HKLM "SOFTWARE\Classes\.ico" "" "FastPic.Image"
  WriteRegStr HKLM "SOFTWARE\Classes\.webp" "" "FastPic.Image"
  WriteRegStr HKLM "SOFTWARE\Classes\.tga" "" "FastPic.Image"
  WriteRegStr HKLM "SOFTWARE\Classes\.psd" "" "FastPic.Image"
  WriteRegStr HKLM "SOFTWARE\Classes\.raw" "" "FastPic.Image"
  WriteRegStr HKLM "SOFTWARE\Classes\.dds" "" "FastPic.Image"

  ; === 通知 Windows 资源管理器刷新 ===
  System::Call 'shell32.dll::SHChangeNotify(i 0x8000000, i 0, p 0, p 0)'
SectionEnd

; ============================================================
; 完成页面回调 - 创建桌面快捷方式
; ============================================================
Function .onInstSuccess
FunctionEnd

; ============================================================
; 安装后写入注册表
; ============================================================
Section -Post
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "InstallDir" "$INSTDIR"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "Version" "${PRODUCT_VERSION}"

  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\${PRODUCT_EXE}" "" "$INSTDIR\${PRODUCT_EXE}"
  WriteRegStr HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\${PRODUCT_EXE}" "Path" "$INSTDIR"

  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "DisplayName" "${PRODUCT_NAME}"
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "UninstallString" '"$INSTDIR\uninst.exe"'
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "DisplayIcon" '"$INSTDIR\${PRODUCT_EXE}"'
  WriteRegStr HKLM "${PRODUCT_UNINST_KEY}" "InstallLocation" "$INSTDIR"
  WriteRegDWORD HKLM "${PRODUCT_UNINST_KEY}" "NoModify" 1
  WriteRegDWORD HKLM "${PRODUCT_UNINST_KEY}" "NoRepair" 1

  ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
  IntFmt $0 "0x%08X" $0
  WriteRegDWORD HKLM "${PRODUCT_UNINST_KEY}" "EstimatedSize" $0
SectionEnd

; ============================================================
; 卸载段
; ============================================================
Section Uninstall
  nsExec::ExecToLog 'taskkill /F /IM ${PRODUCT_EXE}'

  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
  RMDir /r "$SMPROGRAMS\${PRODUCT_NAME}"

  Delete "$INSTDIR\uninst.exe"
  Delete "$INSTDIR\*.dll"
  Delete "$INSTDIR\*.dat"
  Delete "$INSTDIR\*.manifest"
  Delete "$INSTDIR\*.vbs"
  Delete "$INSTDIR\${PRODUCT_EXE}"

  RMDir "$INSTDIR"

  DeleteRegKey HKLM "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  DeleteRegKey HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\${PRODUCT_EXE}"
  DeleteRegKey HKLM "SOFTWARE\Classes\FastPic.Image"

  System::Call 'shell32.dll::SHChangeNotify(i 0x8000000, i 0, p 0, p 0)'
SectionEnd
