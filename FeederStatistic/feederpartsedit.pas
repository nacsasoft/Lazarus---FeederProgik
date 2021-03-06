unit feederpartsedit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  DBGrids, DbCtrls, sqlite3ds, db, global, StdCtrls;

type

  { TfrmFeederPartsEdit }

  TfrmFeederPartsEdit = class(TForm)
    btnAddPart: TButton;
    cmbFeederType: TComboBox;
    Datasource1: TDatasource;
    DBGrid1: TDBGrid;
    edtP_name: TEdit;
    edtP_ordernum: TEdit;
    edtP_cost: TEdit;
    GroupBox1: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Sqlite3Dataset1: TSqlite3Dataset;
    procedure btnAddPartClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    procedure setDBControlls();
  public
    { public declarations }
  end; 

var
  frmFeederPartsEdit: TfrmFeederPartsEdit;

implementation

{ TfrmFeederPartsEdit }
uses fomenu,database;

procedure TfrmFeederPartsEdit.FormShow(Sender: TObject);
begin
     setDBControlls;
end;

procedure TfrmFeederPartsEdit.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
     Sqlite3Dataset1.Active := false;
     frmFeederPartsEdit.Hide;
     frmMainMenu.Show;
end;

procedure TfrmFeederPartsEdit.btnAddPartClick(Sender: TObject);
var
   pname,pordernum,pcost: string;
   cf:                    real;
   myDataset:             TSqlite3Dataset;


begin
     //Alkatrész felvitele a db-be :
     pname:=edtP_name.Text;
     pordernum:=edtP_ordernum.Text;
     pcost:=edtP_cost.Text;
     if ((trim(pname)='') or (trim(pordernum)='') or (trim(pcost)='')) then
     begin
          ShowMessage('Minden mező kitöltése kötelező!');
          exit;
     end;
     try
        cf := StrToFloat(pcost);
     except
           ShowMessage('Az ár-mező csak számot tartalmazhat!');
           exit;
     end;

     //írás a db-be :
     myDataset := dbConnect('parts','SELECT * FROM parts ORDER BY id;','id');
      with myDataset do
        begin
            Insert;
            FieldByName('p_name').AsString:=pname;
          	FieldByName('p_cost').AsFloat:=cf;
          	FieldByName('p_del').AsInteger:=0;
          	FieldByName('p_type').AsInteger:=cmbFeederType.ItemIndex;
          	FieldByName('p_ordernum').AsString:=pordernum;
            Post;
            ApplyUpdates;
        end;
      dbClose(myDataset);

      setDBControlls;
      DBGrid1.Refresh;

end;

procedure TfrmFeederPartsEdit.setDBControlls();
begin
     //vezérlők beállítása...
     Sqlite3Dataset1.FileName := dbPath;
     Sqlite3Dataset1.TableName := 'parts';
     Sqlite3Dataset1.SQL := 'SELECT id,p_name,p_ordernum,p_cost,p_type,p_del FROM parts ORDER BY id';
     Sqlite3Dataset1.PrimaryKey:='id';
     Sqlite3Dataset1.Active := true;
     Sqlite3Dataset1.Last;
     Sqlite3Dataset1.Refresh;
     //dbgrid fejléc beállítása :
     DBGrid1.Columns[0].Title.Caption := 'ID';
     DBGrid1.Columns[1].Title.Caption := 'Név';
     DBGrid1.Columns[2].Title.Caption := 'Rendelési szám';
     DBGrid1.Columns[3].Title.Caption := 'Ár (EUR)';
     DBGrid1.Columns[4].Title.Caption := 'Típus';
     DBGrid1.Columns[5].Title.Caption := 'Törölve';
     DBGrid1.Refresh;
     //Mezők beállítása :
     edtP_cost.Text:='';
     edtP_ordernum.Text:='';
     edtP_name.Text:='';
     //cmbFeederType.Text:='Siemens';
end;

initialization
  {$I feederpartsedit.lrs}

end.

