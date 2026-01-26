; ================================
; Inno Setup Script for Flutter App
; ================================

[Setup]
AppName=MoodyMate
AppVersion=1.0.0
DefaultDirName={autopf}\MoodyMate
DefaultGroupName=MoodyMate
OutputDir=installer
OutputBaseFilename=MoodyMateSetup
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Tasks]
Name: "desktopicon"; Description: "Create a desktop icon"; Flags: unchecked

[Files]
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs
Source: "moodymate.ico"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\MoodyMate"; Filename: "{app}\emolog.exe"; IconFilename: "{app}\moodymate.ico"
Name: "{commondesktop}\MoodyMate"; Filename: "{app}\emolog.exe"; IconFilename: "{app}\moodymate.ico"; Tasks: desktopicon

[Run]
Filename: "{app}\emolog.exe"; Description: "Launch MoodyMate"; Flags: nowait postinstall skipifsilent
