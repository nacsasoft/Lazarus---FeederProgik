unit felhasznalok ;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs ,
  sqlite3ds, db, DBGrids, DbCtrls, global, StdCtrls, database;

type

  { TfrmFelhasznalok }

  TfrmFelhasznalok = class(TForm)
    btnHelp: TButton ;
    btnNewUser: TButton ;
    cmbAdmin: TComboBox ;
    Datasource1: TDatasource ;
    DBGrid1: TDBGrid ;
    DBNavigator1: TDBNavigator ;
    edtName: TEdit ;
    edtWDNum: TEdit;
    edtPass1: TEdit ;
    edtPass2: TEdit ;
    GroupBox1: TGroupBox ;
    Label5: TLabel ;
    Label6: TLabel ;
    Label7: TLabel ;
    Label8: TLabel ;
    Label9: TLabel;
    Sqlite3Dataset1: TSqlite3Dataset ;
    procedure btnHelpClick(Sender: TObject) ;
    procedure btnNewUserClick(Sender: TObject) ;
    procedure FormClose(Sender: TObject ; var CloseAction: TCloseAction) ;
    procedure FormShow(Sender: TObject) ;
  private
    { private declarations }

  public
    { public declarations }
  end ; 

var
  frmFelhasznalok: TfrmFelhasznalok;

implementation

{ TfrmFelhasznalok }
uses fomenu;

procedure TfrmFelhasznalok.FormShow(Sender: TObject) ;
begin
     //vezérlők beállítása...
     with Sqlite3Dataset1 do
     begin
          FileName:=dbPath;
          AutoIncrementKey:=true;
          PrimaryKey:='id';
          SaveOnClose:=true;
          SaveOnRefetch:=true;
          TableName:='users';;
          SQL:='SELECT * FROM users ORDER BY id';
          Active:=true;
          Open;
          First;
     end; //end of with

     //dbgrid fejléc beállítása :
     DBGrid1.Columns[0].Title.Caption := 'ID';
     DBGrid1.Columns[1].Title.Caption := 'Név';
     DBGrid1.Columns[2].Title.Caption := 'Kártyaszám';
     DBGrid1.Columns[3].Title.Caption := 'Admin?';
     DBGrid1.Columns[4].Title.Caption := 'Jelszó';
     DBGrid1.Columns[5].Title.Caption := 'Törölve';
     DBGrid1.Refresh;

     edtName.Text := '';
     edtPass1.Text := '';
     edtPass2.Text := '';
     cmbAdmin.ItemIndex := 0;
end;

procedure TfrmFelhasznalok.FormClose(Sender: TObject ; var CloseAction: TCloseAction) ;
begin
     Sqlite3Dataset1.Active := false;
     frmFelhasznalok.Hide;
     frmMainMenu.Show;
end;

procedure TfrmFelhasznalok.btnHelpClick(Sender: TObject) ;
var sHelp: string;
begin
     //segítség....
     sHelp := 'Segítség a használathoz !' + chr(13) + chr(13);
     sHelp := sHelp + 'Felhasználó törlése : ' + chr(13);
     sHelp := sHelp + 'Felhasználó kiválasztása után a szerkesztés gombra kell ' + chr(13);
     sHelp := sHelp + 'kattintani, majd a "Törölve" mezőben lévő adatot 1-re módosítani.  ' + chr(13);
     ShowMessage(sHelp);
end;

procedure TfrmFelhasznalok.btnNewUserClick(Sender: TObject) ;
var
  myDataset:             TSqlite3Dataset;

begin
    //Új felhasználó felvitele....
		if ((trim(edtName.Text) = '') or (trim(edtPass1.Text) = '') or (trim(edtPass2.Text) = '')) then
    begin
      ShowMessage('Minden mező kitöltése kötelező !');
      exit;
    end;
    myDataset := dbConnect('users','Select * from users WHERE u_del=0 Order By u_name;','id');
		myDataset.Append;
		myDataset.FieldByName('u_name').AsString := edtName.Text;
    myDataset.FieldByName('u_card').AsString := trim(edtWDNum.Text);
    myDataset.FieldByName('u_perm').AsInteger := cmbAdmin.ItemIndex;
    myDataset.FieldByName('u_pass').AsString := EncodePWDEx(edtPass1.Text);
    myDataset.FieldByName('u_del').AsInteger := 0;
    myDataset.Post;
    myDataset.ApplyUpdates;
    dbUpdate(myDataset,'Select * from users Order By u_name;');
		dbClose(myDataset);
    edtName.Text := '';
    edtPass1.Text := '';
    edtPass2.Text := '';

    Sqlite3Dataset1.Close;
    Sqlite3Dataset1.SQL := 'SELECT * FROM users ORDER BY id';
    Sqlite3Dataset1.Open;
    Sqlite3Dataset1.First;
    DBGrid1.Refresh;

    edtName.Text := '';
    edtPass1.Text := '';
    edtPass2.Text := '';
    edtWDNum.Text := '';
    cmbAdmin.ItemIndex := 0;

    ShowMessage('Az új felhasználó felvitele megtörtént !');
end;

initialization
  {$I felhasznalok.lrs}

end.

