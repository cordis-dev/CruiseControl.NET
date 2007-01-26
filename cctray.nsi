; Script generated by the HM NIS Edit Script Wizard.

; HM NIS Edit Wizard helper defines
!define PRODUCT_NAME "CruiseControl.NET CCTray"
!define PRODUCT_NAME_NOSPACE "CruiseControl.NET-CCTray"
!define PRODUCT_VERSION "1.2"
!define PRODUCT_PUBLISHER "ThoughtWorks"
!define PRODUCT_WEB_SITE "http://ccnet.thoughtworks.com/"
!define PRODUCT_DIR_REGKEY "Software\Microsoft\Windows\CurrentVersion\App Paths\cctray.exe"
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"
!define PRODUCT_STARTMENU_REGVAL "NSIS:StartMenuDir"
!define PRODUCT_DEFAULT_DIR_KEY "Software\${PRODUCT_PUBLISHER}\${PRODUCT_NAME}${PRODUCT_VERSION}\InstallDir"


; Plug-ins
!addplugindir install

; MUI 1.67 compatible ------
!include "MUI.nsh"

SetCompressor lzma

; MUI Settings
!define MUI_ABORTWARNING
!define MUI_ICON "project\CCTrayLib\Green.ico"
!define MUI_UNICON "project\CCTrayLib\Green.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "install\install_logo.bmp"
!define MUI_HEADERIMAGE_RIGHT
!define MUI_COMPONENTSPAGE_SMALLDESC


; Welcome page
!insertmacro MUI_PAGE_WELCOME
; License page
!insertmacro MUI_PAGE_LICENSE "deployed\license.txt"
; Components page
!insertmacro MUI_PAGE_COMPONENTS
; Add service page
!insertmacro MUI_PAGE_DIRECTORY
; Start menu page
var ICONS_GROUP
!define MUI_STARTMENUPAGE_NODISABLE
!define MUI_STARTMENUPAGE_DEFAULTFOLDER "CCTray"
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "${PRODUCT_UNINST_ROOT_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "${PRODUCT_UNINST_KEY}"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "${PRODUCT_STARTMENU_REGVAL}"
!insertmacro MUI_PAGE_STARTMENU Application $ICONS_GROUP
; Instfiles page
!insertmacro MUI_PAGE_INSTFILES
; Finish page
Var FinishMessage
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_WELCOMEFINISHPAGE_CUSTOMFUNCTION_INIT PrepareFinishPageMessage
!define MUI_FINISHPAGE_TEXT $FinishMessage
!define MUI_FINISHPAGE_RUN "$INSTDIR\ccTray.exe"
!insertmacro MUI_PAGE_FINISH

; Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES

; Language files
!insertmacro MUI_LANGUAGE "English"

; MUI end ------

Name "${PRODUCT_NAME} ${PRODUCT_VERSION}"
OutFile "dist\${PRODUCT_NAME_NOSPACE}-${PRODUCT_VERSION}-Setup.exe"
InstallDir "$PROGRAMFILES\CCTray"
InstallDirRegKey HKLM "${PRODUCT_DEFAULT_DIR_KEY}" ""
ShowInstDetails show
ShowUnInstDetails show

Section "CCTray" SEC_CCTRAY
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer
  File "deployed\cctray\*"

  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  CreateDirectory "$SMPROGRAMS\$ICONS_GROUP"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\CCTray.lnk" "$INSTDIR\ccTray.exe"
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section "CCTray desktop shortcut" SEC_DESKTOP
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer

  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  CreateShortCut "$DESKTOP\CCTray.lnk" "$INSTDIR\ccTray.exe"
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section "CCTray start menu shortcut" SEC_STARTUPGROUP
  SetOutPath "$INSTDIR"
  SetOverwrite ifnewer

  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  CreateShortCut "$SMPROGRAMS\Startup\CCTray.lnk" "$INSTDIR\ccTray.exe"
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section -AdditionalIcons
  SetOutPath $INSTDIR
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
  WriteIniStr "$INSTDIR\${PRODUCT_NAME}.url" "InternetShortcut" "URL" "${PRODUCT_WEB_SITE}"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Website.lnk" "$INSTDIR\${PRODUCT_NAME}.url"
  CreateShortCut "$SMPROGRAMS\$ICONS_GROUP\Uninstall.lnk" "$INSTDIR\uninst.exe"
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\uninst.exe"
  WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\cctray.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\cctray.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "${PRODUCT_WEB_SITE}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  WriteRegStr HKLM "${PRODUCT_DEFAULT_DIR_KEY}" "" "$INSTDIR"
SectionEnd

; Section descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_CCTRAY} "The system tray applet for remotely monitoring and triggering builds managed by CruiseControl.NET."
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_DESKTOP} "The system tray applet Desktop shortcut."
  !insertmacro MUI_DESCRIPTION_TEXT ${SEC_STARTUPGROUP} "Add the system tray applet to the Program Startup menu group."
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Function PrepareFinishPageMessage
  StrCpy $FinishMessage "$(^Name) has been installed on your computer.\r\nClick Finish to close this wizard."
FunctionEnd

Function un.onUninstSuccess
  HideWindow
  MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer."
FunctionEnd

Function un.onInit
  MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Are you sure you want to completely remove $(^Name) and all of its components?" IDYES +2
  Abort
FunctionEnd

Section Uninstall
 
  !insertmacro MUI_STARTMENU_GETFOLDER "Application" $ICONS_GROUP

  Delete "$SMPROGRAMS\$ICONS_GROUP\Uninstall.lnk"
  Delete "$SMPROGRAMS\$ICONS_GROUP\Website.lnk"
  Delete "$DESKTOP\CCTray.lnk"
  Delete "$SMPROGRAMS\$ICONS_GROUP\CCTray.lnk"
  Delete "$SMPROGRAMS\Startup\CCTray.lnk"
  
  RMDir "$SMPROGRAMS\$ICONS_GROUP"
  RMDir /r "$INSTDIR"

  DeleteRegKey ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}"
  DeleteRegKey HKLM "${PRODUCT_DIR_REGKEY}"
  SetAutoClose true
SectionEnd
