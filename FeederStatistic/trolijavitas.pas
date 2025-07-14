unit trolijavitas;

{$mode objfpc}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, global, database, Sqlite3DS;

type

  { TfrmTroliJavitas }

  TfrmTroliJavitas = class(TForm)
    btnMegsem : TButton;
    btnOK : TButton;
    cmbLines : TComboBox;
    cmbMachines : TComboBox;
    cmbPosition : TComboBox;
    cmbTroliSorszam: TComboBox;
    edtDS7i : TEdit;
    edtKirakas_EV: TEdit;
    edtKirakas_HO: TEdit;
    edtKirakas_NAP: TEdit;
    edtOperatorName : TEdit;
    edtOperatorWD : TEdit;
    edtTroliTipus: TEdit;
    Label1 : TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label2 : TLabel;
    Label3: TLabel;
    Label4 : TLabel;
    Label5 : TLabel;
    Label6 : TLabel;
    Label7 : TLabel;
    Label8 : TLabel;
    procedure btnMegsemClick(Sender : TObject);
    procedure btnOKClick(Sender : TObject);
    procedure cmbLinesChange(Sender : TObject);
    procedure cmbTroliSorszamChange(Sender: TObject);
    procedure edtDS7iExit(Sender : TObject);
    procedure edtTroliNumberExit(Sender: TObject);
    procedure FormClose(Sender : TObject; var CloseAction : TCloseAction);
    procedure FormShow(Sender : TObject);
  private
    { private declarations }

    bUjtroli	:Boolean;		//Ha új troli felvitel akkor = true

  public
    { public declarations }
  end;

var
  frmTroliJavitas : TfrmTroliJavitas;

implementation

uses fomenu,trolimunkalap;

{ TfrmTroliJavitas }

procedure TfrmTroliJavitas.btnMegsemClick(Sender : TObject);
begin
  frmTroliJavitas.Hide;
  frmMainMenu.Show;
end;

procedure TfrmTroliJavitas.btnOKClick(Sender : TObject);
begin
  //Mezők ellenörzése, troli javítási munkalap indítása:

  if (Trim(cmbLines.Text) <> 'SETUP') then
    begin
      if (Length(edtOperatorWD.Text) > 1) and (IsStrANumber(edtOperatorWD.Text) = false) then
        begin
    	    ShowMessage('A Workday azonosító csak szám lehet!');
          edtOperatorWD.SetFocus;
          exit;
        end;
      if (Trim(edtOperatorWD.Text) = '') and (Trim(edtOperatorName.Text) = '') then
        begin
            ShowMessage('WorkDay azonosító, és az Operátor Neve mezők közül az egyik kitöltése kötelező !');
            exit;
        end;
    end;

  if (IsStrANumber(edtKirakas_EV.Text) = false) or (IsStrANumber(edtKirakas_HO.Text) = false) or
          (IsStrANumber(edtKirakas_NAP.Text) = false) then
            begin
              ShowMessage('A kirakás dátuma mezők csak számokat tartalmazhatnak!');
              edtKirakas_EV.SetFocus;
              exit;
            end;

  DS7i := edtDS7i.Text;
  iTroliNumber := integer(cmbTroliSorszam.Items.Objects[cmbTroliSorszam.ItemIndex]);
  sTroliNumber := cmbTroliSorszam.Text;
  sKirakasDatuma := edtKirakas_EV.Text + '-' + edtKirakas_HO.Text + '-' + edtKirakas_NAP.Text;


  //iTroliTipus := cmbTipus.ItemIndex;
  case edtTroliTipus.Text of
    'S' : iTroliTipus := 0;
    'HS' : iTroliTipus := 1;
    'X' : iTroliTipus := 2;
  end;

  sTroliTipus := edtTroliTipus.Text;
  sOperatorName := edtOperatorName.Text;
  sOperatorWDNum := edtOperatorWD.Text;

	if (Trim(cmbLines.Text) <> 'SETUP') then
    begin
      sLine := cmbLines.Text;
      iLineID := integer(cmbLines.Items.Objects[cmbLines.ItemIndex]);
      iMachineID := integer(cmbMachines.Items.Objects[cmbMachines.ItemIndex]);
      iTroliPosition := StrToInt(cmbPosition.Text);
    end
  else
  	begin
      sLine := cmbLines.Text;
      iLineID := integer(cmbLines.Items.Objects[cmbLines.ItemIndex]);
      iMachineID := -1;
      iTroliPosition := -1;
    end;

  writeLogMessage('Troli azonosítás OK...Felhasználó : '+userName + chr(13) +
    'DS7i = ' + edtDS7i.Text + chr(13) +
    'iTroliTipus = ' + inttostr(iTroliTipus) + chr(13) +
    'sTroliTipus = ' + sTroliTipus + chr(13) +
    'sOperatorName = ' + sOperatorName + chr(13) +
    'sOperatorWDNum = ' + sOperatorWDNum + chr(13) +
    'sLine = ' + sLine + chr(13) +
    'iLineID = ' + inttostr(iLineID) + chr(13) +
    'iMachineID = ' + inttostr(iMachineID) + chr(13) +
    'iTroliPosition = ' + inttostr(iTroliPosition));

  frmTroliJavitas.Hide;
  frmTroliMunkalap.Show;
end;

procedure TfrmTroliJavitas.cmbLinesChange(Sender : TObject);
begin
  //Ha a setup-ból kerül ki akkor nem kell az: opwd,opnév,géptípus,oldal -adatok!
	if (Trim(cmbLines.Text) = 'SETUP') then
    begin
			edtOperatorWD.Enabled := false;
      edtOperatorName.Enabled := false;
      cmbMachines.Enabled := false;
      cmbPosition.Enabled := false;
      exit;
    end;
	edtOperatorWD.Enabled := true;
  edtOperatorName.Enabled := true;
  cmbMachines.Enabled := true;
  cmbPosition.Enabled := true;
end;

procedure TfrmTroliJavitas.cmbTroliSorszamChange(Sender: TObject);
var
  iTroliID      :integer;
  troliDataset	: TSqlite3Dataset;
  sSQL          : string;

begin
  //Kiválasztott sorszámú troli adatainak betöltése:
  iTroliID := integer(cmbTroliSorszam.Items.Objects[cmbTroliSorszam.ItemIndex]);

  sSQL := 'select * from trolley_list where id = ' + IntToStr(iTroliID) + ';';
  troliDataset := dbConnect('trolley_list',sSQL,'id');
  edtDS7i.Text := troliDataset.FieldByName('tr_ds7i').AsString;
  edtTroliTipus.Text := troliDataset.FieldByName('tr_tipus').AsString;
  dbClose(troliDataset);

end;

procedure TfrmTroliJavitas.edtDS7iExit(Sender : TObject);
var
  	troliDataset	: TSqlite3Dataset;
    sAzon					: string;	//troli azonosító
    sSQL					: string;

begin

{

  //Volt már a javítóknál ez a troli?
  //Ha igen, akkor a mezőket ki kell tölteni!
  sAzon := edtDS7i.Text;

  sSQL := 'select * from trolley_repair where tr_ds7i = "' + sAzon + '" and tr_del = 0;';
  troliDataset := dbConnect('trolley_repair',sSQL,'id');
  if (troliDataset.RecordCount = 0) then
  	begin
			//Új troli felvitele lesz...
      bUjtroli := true;
      cmbTipus.Enabled := true;
      edtTroliNumber.Enabled:=true;
      edtTroliNumber.SetFocus;
      dbClose(troliDataset);
      exit;
  	end;

  //van beallitva sorszam?
  if ((troliDataset.RecordCount > 0) and
            (trim(troliDataset.FieldByName('tr_number').AsString) = '')) then
    begin
      //nincs meg beallitva sorszam:
      edtTroliNumber.Enabled:=true;
      edtTroliNumber.SetFocus;
      dbClose(troliDataset);
      exit;
    end;

  //Ez a troli már szerepel az adatbázisban és be van allitva a sorszam is:
  troliDataset.Last;
  cmbTipus.ItemIndex := troliDataset.FieldByName('tr_type').AsInteger;
	cmbTipus.Enabled := false;
  edtTroliNumber.Text := troliDataset.FieldByName('tr_number').AsString;
  if (Trim(edtTroliNumber.Text) <> '') then edtTroliNumber.Enabled := false;
  bUjtroli := false;
  edtDS7i.Enabled := false;
  edtTroliNumber.Enabled := false;

  dbClose(troliDataset);
}
end;

procedure TfrmTroliJavitas.edtTroliNumberExit(Sender: TObject);
var
    myDataset		:TSqlite3Dataset;
  	sSQL      	:String;
    iTrNum      :Integer;

begin
{
  //Kilepeskor megnezzuk hogy a ds7i mezo ki lett-e mar toltve, ha igen akkor
  //ennyi, ha nem akkor ki kell keresni a sorszamhoz tartozo ds7i azonositot....
  if (Trim(edtDS7i.Text) <> '') or (Trim(edtTroliNumber.Text) = '') then exit;

  //ds7i kikereses:
   try
    iTrNum := StrToInt(edtTroliNumber.Text);
  except
    On Exception do
    begin
      ShowMessage('A Troli sorszám mező csak számot tartalmazhat!');
      edtTroliNumber.SetFocus;
      exit;
    end;
  end;
  sSQL := 'select * from trolley_repair where tr_number = ' + IntToStr(iTrNum) + ' and tr_del = 0;';
  myDataset := dbConnect('trolley_repair',sSQL,'id');
  if (myDataset.RecordCount < 1) then exit; //nincs ds7i...
  myDataset.Last;
  edtDS7i.Text := myDataset.FieldByName('tr_ds7i').AsString;
  cmbTipus.ItemIndex := myDataset.FieldByName('tr_type').AsInteger;
	cmbTipus.Enabled := false;
  edtDS7i.Enabled := false;
  edtTroliNumber.Enabled := false;
  bUjtroli := false;
  dbClose(myDataset);
}
end;

procedure TfrmTroliJavitas.FormClose(Sender : TObject;
  var CloseAction : TCloseAction);
begin
	frmTroliJavitas.Hide;
  frmMainMenu.Show;
end;

procedure TfrmTroliJavitas.FormShow(Sender : TObject);
var
    myDataset		:TSqlite3Dataset;
  	sData				:String;

begin
  //Mezők beállítása:
  edtDS7i.Text := '';
  edtDS7i.Enabled := false;
  //edtTroliNumber.Text := '';
  //edtTroliNumber.Enabled:=true;
  //cmbTipus.Enabled := true;
	//cmbTipus.ItemIndex := 0;
  edtOperatorName.Text := '';
  edtOperatorWD.Text := '';
  cmbPosition.ItemIndex := 0;
  edtKirakas_EV.Text := FormatDateTime('YYYY',Now);
  edtKirakas_HO.Text := FormatDateTime('MM',Now);
  edtKirakas_NAP.Text := FormatDateTime('DD',Now);

  writeLogMessage('Troli azonosítás start...Felhasználó : '+userName);

  //sorok feltöltése :
  cmbLines.Clear;
  myDataset := dbConnect('line','SELECT * FROM sorok where torolve = 0;','name');
  if (myDataset.RecordCount > 0) then
  begin
      Repeat
        	sData := myDataset.FieldByName('name').AsString;
          cmbLines.Items.AddObject(sData,TObject(myDataset.FieldByName('id').AsInteger));
          myDataset.Next;
      Until myDataset.Eof;
      myDataset.First;
      cmbLines.ItemIndex := 0;
	end;

  //géptípusok feltöltése :
	cmbMachines.Clear;
  dbUpdate(myDataset,'SELECT * FROM machines where torolve = 0 order by m_name;');
  if (myDataset.RecordCount > 0) then
  begin
      Repeat
        	sData := myDataset.FieldByName('m_name').AsString;
          cmbMachines.Items.AddObject(sData,TObject(myDataset.FieldByName('id').AsInteger));
          myDataset.Next;
      Until myDataset.Eof;
      myDataset.First;
      cmbMachines.ItemIndex := 0;
	end;

  //Troli sorszámok feltöltése :
	cmbTroliSorszam.Clear;
  dbUpdate(myDataset,'SELECT * FROM trolley_list order by tr_sorszam;');
  if (myDataset.RecordCount > 0) then
  begin
      Repeat
        	sData := myDataset.FieldByName('tr_sorszam').AsString;
          cmbTroliSorszam.Items.AddObject(sData,TObject(myDataset.FieldByName('id').AsInteger));
          myDataset.Next;
      Until myDataset.Eof;
      myDataset.First;
      cmbTroliSorszam.ItemIndex := 0;
      edtTroliTipus.Text := myDataset.FieldByName('tr_tipus').AsString;
      edtDS7i.Text := myDataset.FieldByName('tr_ds7i').AsString;
	end;

  edtOperatorWD.Enabled := true;
  edtOperatorName.Enabled := true;
  //cmbTipus.Enabled := true;
  cmbMachines.Enabled := true;
  cmbPosition.Enabled := true;

  dbClose(myDataset);

end;

initialization
  {$I trolijavitas.lrs}

end.

