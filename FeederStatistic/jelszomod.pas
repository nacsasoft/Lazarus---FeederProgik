unit jelszomod;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, global, database, sqlite3ds;

type

  { TfrmJelszomod }

  TfrmJelszomod = class(TForm)
    btnModosit: TButton;
    btnMegsem: TButton;
    edtUjJelszo: TEdit;
    edtUjJelszoUjra: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    procedure btnMegsemClick(Sender: TObject);
    procedure btnModositClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject) ;
  private
    { private declarations }
    myDataset:          TSqlite3Dataset;

  public
    { public declarations }
  end; 

var
  frmJelszomod: TfrmJelszomod;

implementation

{ TfrmJelszomod }
uses login;

procedure TfrmJelszomod.btnMegsemClick(Sender: TObject);
begin
     frmJelszomod.Hide;
     frmLogin.Show;
end;

procedure TfrmJelszomod.btnModositClick(Sender: TObject);
var
   newpass,newpass2,ssql: string;
begin
     //Jelszómódosítás...
     newpass:=edtUjJelszo.Text;
     newpass2:=edtUjJelszoUjra.Text;

     if (newpass <> newpass2) then
     begin
          ShowMessage('Az új jelszavak nem egyeznek !');
          exit;
     end;

     if ((Trim(newpass) = '') and (Trim(newpass2) = '')) then
     begin
          ShowMessage('A jelszó mezők nem lehetnek üresek !');
          exit;
     end;

     dbUpdate(myDataset,'Select * from users Where id=' + IntToStr(userDB_ID));
     myDataset.Edit;
     myDataset.FieldByName('u_pass').AsString := EncodePWDEx(newpass);
     myDataset.Post;
     myDataset.ApplyUpdates;
     dbUpdate(myDataset,'Select * from users Order By u_name;');
     ShowMessage('A jelszó módosítás sikerült !');
     dbClose(myDataset);
     frmJelszomod.Hide;
     frmLogin.Show;

end;

procedure TfrmJelszomod.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
     dbClose(myDataset);
     frmJelszomod.Hide;
     frmLogin.Show;
end;

procedure TfrmJelszomod.FormCreate(Sender: TObject) ;
begin
     edtUjJelszo.Text:='';
     edtUjJelszoUjra.Text:='';
     myDataset := dbConnect('users','Select * from users WHERE u_del=0 Order By u_name;','id');
end;

initialization
  {$I jelszomod.lrs}

end.

