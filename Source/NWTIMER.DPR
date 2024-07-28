program nwtimer;
{$R CURSORS.RES}

uses
  Windows,
  Messages,ShellApi;

var
  WinClass: TWndClassA;
  Inst, Handle,  Button1, Button2, Button3, mailto, Edit1,Label1,Label2 : Integer;
  Msg: TMsg;
  hFont: Integer;
  FHandle : THandle;
  SysMenu : hMenu;
  WinDir  : Array[0..63] of Char;
  FindData: TWin32FindData;
  Refresh : Integer;
  NetWatchFile : File;
  NetWatchPath : String;
  ss : string;





procedure ShowAbout;
 begin
  PostMessage(Handle, WM_USER + 1, 0, 0);
  MessageBox(Handle, PChar('Netwatch Timer™'#13'—————————————————                                            '#13'Program is written by Programmer®. '#13'Source code is compiled with Delphi 2.0'#13'Last compile date: 2000.04.30'#13#13'email: mat@elzab.com.pl'),'About', MB_OK or MB_ICONINFORMATION or MB_RIGHT );
  SetFocus(Button2);
 end;



var
 MsgboxHwnd: HWND;
 NewIcon : THandle;



function WindowProc(hWnd, uMsg,wParam,	lParam: Integer): Integer; stdcall;
begin

  if (lParam = mailto) and (uMsg = WM_COMMAND) then  ShellExecute(GetDesktopWindow(), 'open', PChar('mailto:mat@elzab.com.pl?Subject='), nil, nil, SW_SHOWNORMAL);

  if (lParam = Button2) and (uMsg = WM_COMMAND) then ShowAbout;

  if (lParam = Button3) and (uMsg = WM_COMMAND) then
   begin
    MsgboxHwnd := FindWindow(PChar('NW_CLASS'), nil);
    if MsgBoxHwnd=0 then WinExec('netwatch.exe',SW_SHOW)
     else
      begin
       SendMessage(MsgBoxHwnd,WM_Close,0,0);
       WinExec('netwatch.exe',SW_SHOW);
      end;;
    SetForegroundWindow(Handle);


   end;

  if (lParam = Button1) and (uMsg = WM_COMMAND) then
   begin
     Repeat
      MsgboxHwnd := FindWindow(PChar('NW_CLASS'), nil);
      if MsgBoxHwnd<>0 then SendMessage(MsgBoxHwnd,WM_Close,0,0);
     until MsgboxHwnd=0;

     AssignFile(NetWAtchFile,NetWatchPath);
     Reset(NetWAtchFile,1);
     Seek(NetWAtchFile,$357F);
     GetWindowText(Edit1,PChar(ss),20);
     val(ss,Refresh,hFont);
     BlockWrite(NetWAtchFile,Refresh,2);
     CloseFile(NetWAtchFile);
     str(Refresh,ss);
     SetWindowText(Edit1,PChar(ss));

    SetWindowLong(button1,GWL_STYLE,WS_DISABLED or WS_VISIBLE or WS_CHILD or BS_PUSHLIKE or BS_TEXT);
    SetFocus(Edit1);

   end;




  if (uMsg=WM_COMMAND) and (lParam=Edit1) then
   begin
    if wParam=67108864 then
     begin
      SetWindowLong(button1,GWL_STYLE,WS_VISIBLE or WS_CHILD);
      SetFocus(button1);
      SetFocus(Edit1);
     end;
   end;




 if uMsg=WM_USER+1 then
  begin
   MsgboxHwnd := FindWindow(MAKEINTRESOURCE(WC_DIALOG), 'About');
    if (MsgboxHwnd <> 0) then
       begin
    	SetDlgItemText(Msgboxhwnd,ID_CANCEL,'Close');
    	NewIcon := LoadIcon(hinstance,'MAINICON');
    	If Newicon <> 0 Then SendDlgItemMessage(Msgboxhwnd,10,STM_SETICON,NewIcon,0);
       end;
  end;

 if wParam = 666 then ShowAbout;

  if uMsg = WM_DESTROY then Halt;

  Result := DefWindowProc(hWnd, uMsg, wParam, lParam);


end;

begin
  { ** Register Custom WndClass ** }
  Inst := hInstance;

  with WinClass do
  begin
    style              := CS_CLASSDC or CS_PARENTDC;
    lpfnWndProc        := @WindowProc;
    hInstance          := Inst;
    hbrBackground      := color_btnface + 5;
    lpszClassname      := 'NETWATCHTIMERCLASS';
    hCursor            := LoadCursor(0, IDC_ARROW);
  end; { with }
  RegisterClass(WinClass);

  Handle:=FindWindow('NETWATCHTIMERCLASS',nil);
  if Handle<>0 then
   begin
    SetForegroundWindow(Handle);
    Halt;
   end;

  Handle := CreateWindowEx(WS_EX_WINDOWEDGE, 'NETWATCHTIMERCLASS', 'Netwatch Timer',
                           WS_VISIBLE or WS_CAPTION or WS_SYSMENU,
                           (GetSystemMetrics(SM_CXSCREEN) div 2)-152, GetSystemMetrics(SM_CYSCREEN) div 2-50, 305, 131, 0, 0, Inst, nil);


  { ** Create a button ** }
  Button1 := CreateWindow('Button', 'Set Timer', WS_VISIBLE or WS_CHILD or BS_PUSHLIKE or BS_TEXT,
                           216, 40, 75, 25, handle, 0, Inst, nil);


  Button2 := CreateWindow('Button', 'About', WS_VISIBLE or WS_CHILD or BS_PUSHLIKE or BS_TEXT,
                           216, 8, 75, 25, handle, 0, Inst, nil);

  Button3 := CreateWindow('Button', 'Test', WS_VISIBLE or WS_CHILD or BS_PUSHLIKE or BS_TEXT,
                           216, 72, 75, 25, handle, 0, Inst, nil);

  label1 := Createwindow('Static', '', WS_VISIBLE or WS_CHILD or SS_LEFT,
               8, 12, 176, 43, Handle, 0, Inst, nil);

  label2 := Createwindow('Static', '', WS_VISIBLE or WS_CHILD or SS_LEFT,
               8, 72, 161, 33, Handle, 0, Inst, nil);

  mailto := Createwindow('Static', '', WS_VISIBLE or WS_CHILD or SS_NOTIFY,
               40, 40, 90, 13, Handle, 0, Inst, nil);



  Edit1 := CreateWindowEx(WS_EX_CLIENTEDGE, 'Edit', '', WS_CHILD or WS_VISIBLE or ES_NUMBER or
                          WS_BORDER, 150, 70, 50, 22, Handle, 0, Inst, nil);


  { ** Create Font Handle ** }
  hFont := CreateFont(-11, 0, 0, 0, 400, 0, 1, 0, DEFAULT_CHARSET,
                      OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY,
                      DEFAULT_PITCH or FF_DONTCARE, 'Arial'); //MS Sans Serif
  SendMessage(mailto, WM_SETFONT, hFont, 0);

  hFont := CreateFont(-11, 0, 0, 0, 400, 0, 0, 0, DEFAULT_CHARSET,
                      OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, DEFAULT_QUALITY,
                      DEFAULT_PITCH or FF_DONTCARE, 'Arial'); //MS Sans Serif

  SendMessage(label1, WM_SETFONT, hFont, 0);
  SendMessage(label2, WM_SETFONT, hFont, 0);
  SendMessage(button1, WM_SETFONT, hFont, 0);
  SendMessage(button2, WM_SETFONT, hFont, 0);
  SendMessage(button3, WM_SETFONT, hFont, 0);

  SetClassLong(mailto,GCL_HCURSOR,LoadCursor(hInstance, pChar('HAND')));


  SysMenu := GetSystemMenu(Handle, False);
  DeleteMenu(SysMenu, SC_SIZE, mf_ByCommand);
  DeleteMenu(SysMenu, SC_MINIMIZE, mf_ByCommand);
  DeleteMenu(SysMenu, SC_MAXIMIZE, mf_ByCommand);
  DeleteMenu(SysMenu, 2, MF_BYPOSITION);
  DeleteMenu(SysMenu, 0, MF_BYPOSITION);
  AppendMenu(SysMenu, MF_SEPARATOR,0, #0);
  AppendMenu(SysMenu, mf_ByCommand, 666, '&About NetWatch Timer...');
  ModifyMenu(SysMenu, sc_Move, mf_ByCommand, sc_move, 'Move window');
  ModifyMenu(SysMenu, sc_Close, mf_ByCommand, sc_Close, '&Close program'#9'Alt+F4');




  SetClassLong(Handle,GCL_HICON,LoadIcon(hInstance,'MAINICON'));
  SetWindowText(mailto, 'mat@elzab.com.pl');
  SetWindowText(label1, 'Program adjust internal time refresh for netwatch.exe in Windows 98. email: ');
  SetWindowText(label2, 'Refresh time in milliseconds: (optimal value is 1000 ms)');


  SetFocus(Edit1);
  UpdateWindow(Handle);


  GetWindowsDirectory(Addr(WinDir),63);

  NetWatchPath:=concat(windir,'\netwatch.exe');

  FHandle := FindFirstFile(PChar(NetWatchPath), FindData);
  if FHandle = INVALID_HANDLE_VALUE then
   begin
    SetWindowLong(button1,GWL_STYLE,WS_DISABLED or WS_VISIBLE or WS_CHILD or BS_PUSHLIKE or BS_TEXT);
    SetWindowLong(button3,GWL_STYLE,WS_DISABLED or WS_VISIBLE or WS_CHILD or BS_PUSHLIKE or BS_TEXT);
    SetWindowLong(Edit1,GWL_STYLE,WS_DISABLED or WS_VISIBLE or WS_CHILD or BS_PUSHLIKE or BS_TEXT);
    MessageBox(handle,'Can`t find NETWATCH.EXE in windows directory.','Find Error',mb_ok or MB_ICONWARNING);
    ShowWindow(handle,SW_HIDE);
    SetFocus(Button2);
    ShowWindow(handle,SW_RESTORE);
   end else
    begin
     Repeat
      MsgboxHwnd := FindWindow(PChar('NW_CLASS'), nil);
      if MsgBoxHwnd<>0 then SendMessage(MsgBoxHwnd,WM_Close,0,0);
     until MsgboxHwnd=0;

     AssignFile(NetWAtchFile,NetWatchPath);
     Reset(NetWAtchFile,1);
     Seek(NetWAtchFile,$357F);
     BlockRead(NetWAtchFile,Refresh,2);
     CloseFile(NetWAtchFile);
     str(Refresh,ss);
     SetWindowText(Edit1,PChar(ss));

    end;
  { ** Message Loop ** }
  while(GetMessage(Msg, Handle, 0, 0)) do
  begin
    TranslateMessage(msg);
    DispatchMessage(msg);
  end; { with }
end.
