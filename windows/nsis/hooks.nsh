; Coucou NSIS hooks — override the default install directory so the
; installer creates its own folder rather than dropping files directly
; into %LOCALAPPDATA%\Coucou.
;
; Tauri calls these macros at fixed points in the generated installer:
;   - nsisInstallHook  : before files are written
;   - nsisUninstallHook: before files are removed

!macro nsisInstallHook
  ; currentUser mode: install into %LOCALAPPDATA%\Programs\Coucou
  ; This runs before Tauri writes any files, so $INSTDIR is still mutable.
  StrCpy $INSTDIR "$LOCALAPPDATA\Programs\Coucou"
!macroend

!macro nsisUninstallHook
  ; nothing extra on uninstall
!macroend
