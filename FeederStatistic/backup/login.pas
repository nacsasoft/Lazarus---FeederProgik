unit login;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, global, database, sqlite3ds;

type

  { TfrmLogin }

  TfrmLogin = class(TForm)
    btnBelepes: TButton;
    btnJelszoMod: TButton;
    cmbUsers: TComboBox;
    edtJelszo: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure btnBelepesClick(Sender: TObject);
    procedure btnJelszoModClick(Sender: TObject);
    procedure edtJelszoKeyPress(Sender: TObject ; var Key: char) ;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);


  private
    { private declarations }
    loginDataset:          TSqlite3Dataset;

    function JelszoOK(): boolean;

  public
    { public declarations }
  end;

var
  frmLogin: TfrmLogin;

implementation

{ TfrmLogin }
uses fomenu,jelszomod,tabsetup,tpmsetupmain,tpmds7iazonositas;

procedure TfrmLogin.btnBelepesClick(Sender: TObject);
begin
     { Van kiválasztva felh. ? }
     if (JelszoOK() = false) then exit;
     if (iAdmin = 4) then
      begin
          //TPM Setup - setupban lecsipogás
          frmLogin.Hide;
          //frmTPMSetupMain.Show;
          frmTPMDS7i_Azonositas.Show;
          exit;
      end;
     frmLogin.Hide;
     frmMainMenu.Show;
end;

procedure TfrmLogin.btnJelszoModClick(Sender: TObject);
begin
     if (JelszoOK()) then
     begin
          frmLogin.Hide;
          frmJelszomod.Show;
     end;
end;

procedure TfrmLogin.edtJelszoKeyPress(Sender: TObject ; var Key: char) ;
var
	bRet:		boolean;
begin
	if (Key = chr(13)) then
    begin
		if (JelszoOK() = false) then exit;

    //Setupcenter megnyitása :
    if (iAdmin = 2) then
    begin
				//DS7i azonosító bekérése :
        DS7i := '';
        bRet := InputQuery('DS7i azonosító...','Kérem az adagoló DS7i azonosítóját :',DS7i);
        if (not bRet) then exit;

        //ha a bárkód olvasó a nulla helyett ö-t írna be akkor ki kell javítani 0-ra!
        DS7i := StringReplace(DS7i,'ö','0',[rfReplaceAll]);

        DS7i := trim(DS7i);
        if (IsStrANumber(DS7i) = false) then
        begin
          DS7i := '';
          ShowMessage('A DS7i azonosító csak számot tartalmazhat !');
          exit;
        end ;
        if (DS7i = '') then
        begin
          DS7i := '';
          ShowMessage('Az azonosító megadása kötelező !');
          exit;
				end;

      frmLogin.Hide;
			frmSetupCenter.Show;
      exit;
    end ;
    if (iAdmin = 4) then
      begin
          //TPM Setup - setupban találtak egy "rossz" adagolót...le kell csipogni
          frmLogin.Hide;
          //frmTPMSetupMain.Show;
          frmTPMDS7i_Azonositas.Show;
          exit;
      end;
    if (iAdmin = 5) then
      begin
        //TPM preventive:

      end;
      //dbClose(loginDataset);
     	frmLogin.Hide;
     	frmMainMenu.Show;
    end;
end;

procedure TfrmLogin.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Application.Terminate;
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
     //combo feltöltése a db-ből :
     cmbUsers.Clear;
     loginDataset := dbConnect('users','SELECT * FROM users WHERE u_del=0 ORDER BY u_name;','id');
     if (loginDataset.RecordCount > 0) then
     begin
          Repeat
                cmbUsers.Items.AddObject(loginDataset.FieldByName('u_name').AsString,
                TObject(loginDataset.FieldByName('id').AsInteger));
                loginDataset.Next;
          Until loginDataset.Eof;
          loginDataset.First;
          cmbUsers.Text:=loginDataset.FieldByName('u_name').AsString;
     end;
     edtJelszo.Text:='';
     dbClose(loginDataset);

     //Log fájl beállítása :
     sLogFile := ExtractFilePath(Application.ExeName) + ApplicationName + '.log';

     //writeLogMessage('Belépés start...');
end;


function TfrmLogin.JelszoOK(): boolean;
var
   ret: boolean;
   pass,dbpass: string;
begin
     ret := true;
     if (cmbUsers.ItemIndex < 0) then
     begin
          ShowMessage('Egy felhasználót ki kell választani !');
          ret := false;
     end;
     //jelszó ell. :
     userDB_ID := integer(cmbUsers.Items.Objects[cmbUsers.ItemIndex]);
     userName := cmbUsers.Text;
     loginDataset := dbConnect('users','Select * From users where id = '+IntToStr(userDB_ID),'id');
     sTPMSetupWDNum := loginDataset.FieldByName('u_card').AsString;
     dbpass := DecodePWDEx(loginDataset.FieldByName('u_pass').AsString);
     //ShowMessage(EncodePWDEx(edtJelszo.Text));
     //dbpass := loginDataset.FieldByName('u_pass').AsString;
     iAdmin := loginDataset.FieldByName('u_perm').AsInteger;
	 	 dbClose(loginDataset);

     //ShowMessage(IntToStr(iAdmin));

     pass := edtJelszo.Text;
     if (dbpass <> pass) then
     begin
          ShowMessage('A beírt jelszó nem helyes !');
          edtJelszo.Text:='';
          edtJelszo.SetFocus;
          ret := false;
     end;
     JelszoOK := ret;

end;


initialization
  {$I login.lrs}

end.

