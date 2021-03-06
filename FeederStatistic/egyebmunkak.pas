unit egyebmunkak;

{$mode objfpc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, global, sqlite3ds, database, dateutils;

type

  { TfrmEgyebMunkak }

  TfrmEgyebMunkak = class(TForm)
    btnBezar : TButton;
    Button2 : TButton;
    edtIdotartam : TEdit;
    Label1 : TLabel;
    Label2 : TLabel;
    memMunka : TMemo;
    procedure btnBezarClick(Sender : TObject);
    procedure Button2Click(Sender : TObject);
    procedure FormClose(Sender : TObject; var CloseAction : TCloseAction);
    procedure FormShow(Sender : TObject);
  private
    { private declarations }
    myDataset:             TSqlite3Dataset;


  public
    { public declarations }
  end;

var
  frmEgyebMunkak : TfrmEgyebMunkak;

implementation

{ TfrmEgyebMunkak }

uses
  fomenu;

procedure TfrmEgyebMunkak.btnBezarClick(Sender : TObject);
begin
  frmEgyebMunkak.Hide;
  frmMainMenu.Show;
end;

procedure TfrmEgyebMunkak.Button2Click(Sender : TObject);
begin
  //Egyeb munkák rögzítése az adatbázisba....
  //ShowMessage(FormatDateTime('yyyy-mm-dd / hh:nn',Now));

  if ((trim(edtIdotartam.Text) = '') or (Trim(memMunka.Text) = '')) then
  begin
    ShowMessage('Minden mező kitöltése kötelező!');
    exit;
  end;
	myDataset := dbConnect('egyeb_munkak','select * from egyeb_munkak order by id;','id');
  with myDataset do
    begin
        Insert;
        FieldByName('u_id').AsInteger := userDB_ID;
        FieldByName('s_idotartam').AsString := edtIdotartam.Text;
        FieldByName('s_munka').AsString := memMunka.Text;
				FieldByName('s_datum').AsString := FormatDateTime('yyyy-mm-dd / hh:nn',Now);
        Post;
        ApplyUpdates;
    end;
	dbClose(myDataset);
	ShowMessage('Az adatok rögzítésre kerültek az adatbázisba!');
	frmEgyebMunkak.Hide;
  frmMainMenu.Show;
end;

procedure TfrmEgyebMunkak.FormClose(Sender : TObject;
  var CloseAction : TCloseAction);
begin
	frmEgyebMunkak.Hide;
  frmMainMenu.Show;
end;

procedure TfrmEgyebMunkak.FormShow(Sender : TObject);
begin
  //Mezők törlése....
  edtIdotartam.Text := '';
  memMunka.Clear;
end;

initialization
  {$I egyebmunkak.lrs}

end.

