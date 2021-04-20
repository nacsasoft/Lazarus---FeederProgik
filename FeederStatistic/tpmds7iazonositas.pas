unit tpmds7iazonositas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, global, database, Sqlite3DS, strutils, DateUtils;

type

  { TfrmTPMDS7i_Azonositas }

  TfrmTPMDS7i_Azonositas = class(TForm)
    btnAzonositas: TButton;
    edtDs7i: TEdit;
    edtHaviOsszes: TEdit;
    edtMuszakbanEllenorzott: TEdit;
    edtEvesOsszes: TEdit;
    edtUserAltalEllenorzott: TEdit;
    edtUserName: TEdit;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    lblHonapbanEllenorzott: TLabel;
    lblUserNameAltalEllenorzott: TLabel;
    lblUserNameAltalEllenorzott1: TLabel;
    Shape1: TShape;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    procedure btnAzonositasClick(Sender: TObject);
    procedure edtDs7iKeyPress(Sender: TObject; var Key: char);
    procedure edtWDSzamKeyPress(Sender: TObject; var Key: char);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmTPMDS7i_Azonositas: TfrmTPMDS7i_Azonositas;

implementation

uses tpmsetupmain,prevfeederazon, login;

{ TfrmTPMDS7i_Azonositas }

procedure TfrmTPMDS7i_Azonositas.FormShow(Sender: TObject);
var
  sYear,sMonth,sMonthStart,sMonthEnd,sDate,sTime  :string;
  sMuszakStart,sMuszakEnd,sMuszakSQL,sYesterday   :string;
  iMuszak,iHH                                     :integer;
  myDataset                                       :TSqlite3Dataset;

begin
  //mezők beállítása:
  edtEvesOsszes.Text := '0';
  edtHaviOsszes.Text := '0';
  edtUserAltalEllenorzott.Text := '0';
  edtMuszakbanEllenorzott.Text := '0';

  //riportok elkészítése...
  sDate := FormatDateTime('YYYY-MM-DD',Now);
  sYear := LeftStr(sDate,4) + '-01-01';
  sMonth := MidStr(sDate,6,2);
  sMonthStart := LeftStr(sDate,4) + '-' + sMonth + '-01';
  sMonthEnd := LeftStr(sDate,4) + '-' + sMonth + '-31';
  //Műszak meghatározása:
  iMuszak := 3;
  sMuszakStart := sMuszak3_Start;
  sMuszakEnd := sMuszak3_End;
  sTime := FormatDateTime('hh-nn',Now);

  //teszt....
  //sTime := '02-10';

  if (sTime >= sMuszak1_Start) and (sTime <= sMuszak1_End) then
     begin
          sMuszakStart := sMuszak1_Start;
          sMuszakEnd := sMuszak1_End;
          iMuszak := 1;
     end;
  if (sTime >= sMuszak2_Start) and (sTime <= sMuszak2_End) then
     begin
          sMuszakStart := sMuszak2_Start;
          sMuszakEnd := sMuszak2_End;
          iMuszak := 2;
     end;

  if (iMuszak = 3) then
     begin
          //iHH := StrToInt(LeftStr(sTime,2));
          if (sTime > '21-50') and (sTime < '23-59') then
             sMuszakSQL := 'tpm_outdate = "' + sDate + '" and tpm_outdate_time >= "21-50" and tpm_outdate_time <= "23-59"';
          if (sTime > '00-01') and (sTime < '05-50') then
             begin
                  sYesterday := FormatDateTime('yyyy-mm-dd',Yesterday);
                  sMuszakSQL := '(tpm_outdate = "' + sYesterday + '" and tpm_outdate_time >= "21-50" and tpm_outdate_time <= "23-59") and ';
                  sMuszakSQL := sMuszakSQL + '(tpm_outdate = "' + sDate + '" and tpm_outdate_time >= "00-01" and tpm_outdate_time <= "05-50")';
             end;
     end;


  //Éves összesítő:
  myDataset := dbConnect('feeder_tpm','SELECT * FROM feeder_tpm WHERE tpm_outdate > "' + sYear + '" and tpm_del = 0 and u_id <> -1;','id');
  if (myDataset.RecordCount > 0) then edtEvesOsszes.Text := IntToStr(myDataset.RecordCount);

  //Havi összesítő:
  lblHonapbanEllenorzott.Caption := aMonth[StrToInt(sMonth) - 1] + ' havi összesítés';
  dbUpdate(myDataset,'SELECT * FROM feeder_tpm WHERE tpm_outdate >= "' + sMonthStart +
                             '" AND tpm_outdate <= "' + sMonthEnd + '" and tpm_del = 0 and u_id <> -1;');
  if (myDataset.RecordCount > 0) then edtHaviOsszes.Text := IntToStr(myDataset.RecordCount);

  //Felhasználó által ell.:
  lblUserNameAltalEllenorzott.Caption := userName + ' által ell. feederek száma';
  dbUpdate(myDataset,'SELECT * FROM feeder_tpm WHERE tpm_outdate > "' + sYear + '" and tpm_del = 0 and u_id = '
                               + IntToStr(userDB_ID) + ';');
  if (myDataset.RecordCount > 0) then edtUserAltalEllenorzott.Text := IntToStr(myDataset.RecordCount);

  //Műszakban ellenörzött feederek:
  if (iMuszak = 3) then
     begin
          dbUpdate(myDataset,'SELECT * FROM feeder_tpm WHERE ' + sMuszakSQL + ' and tpm_del = 0 and u_id = ' + IntToStr(userDB_ID) + ';');
          if (myDataset.RecordCount > 0) then edtMuszakbanEllenorzott.Text := IntToStr(myDataset.RecordCount);
          //ShowMessage('SELECT * FROM feeder_tpm WHERE ' + sMuszakSQL + ' and tpm_del = 0 and u_id = ' + IntToStr(userDB_ID) + ';');
     end
  else
      begin

        dbUpdate(myDataset,'SELECT * FROM feeder_tpm WHERE tpm_outdate = "' + sDate + '" and tpm_outdate_muszak = ' +
                                  IntToStr(iMuszak) + ' and tpm_outdate_time >= "' + sMuszakStart + '" and tpm_outdate_time <= "' +
                                  sMuszakEnd + '" and tpm_del = 0 and u_id = ' + IntToStr(userDB_ID) + ';');
        if (myDataset.RecordCount > 0) then edtMuszakbanEllenorzott.Text := IntToStr(myDataset.RecordCount);
{
        ShowMessage('SELECT * FROM feeder_tpm WHERE tpm_outdate = "' + sDate + '" and tpm_outdate_muszak = ' +
                                  IntToStr(iMuszak) + ' and tpm_outdate_time >= "' + sMuszakStart + '" and tpm_outdate_time <= "' +
                                  sMuszakEnd + '" and tpm_del = 0 and u_id = ' + IntToStr(userDB_ID) + ';');
}
      end;



  dbClose(myDataset);

  edtUserName.Text := userName;
  edtDs7i.Text := '';
  //edtWDSzam.Text := '';
  edtDs7i.SetFocus;

end;

procedure TfrmTPMDS7i_Azonositas.btnAzonositasClick(Sender: TObject);
var
  myDataset:  TSqlite3Dataset;
  sPrev_Jav:    String;
  iRecCount:    Integer;

begin
  //adatell:
    DS7i := trim(edtDs7i.Text);

    //ha a bárkód olvasó a nulla helyett ö-t írna be akkor ki kell javítani 0-ra!
    DS7i := StringReplace(edtDs7i.Text,'ö','0',[rfReplaceAll, rfIgnoreCase]);

    if (IsStrANumber(DS7i) = false) then
    begin
      DS7i := '';
      ShowMessage('A DS7i azonosító csak számot tartalmazhat !');
      edtDs7i.SetFocus;
      exit;
    end ;
    if (DS7i = '') then
    begin
      DS7i := '';
      ShowMessage('Az azonosító megadása kötelező !');
      edtDs7i.SetFocus;
      exit;
		end;

    {
    sTPMSetupWDNum := trim(edtWDSzam.Text);
    if (IsStrANumber(sTPMSetupWDNum) = false) then
    begin
      sTPMSetupWDNum := '';
      ShowMessage('Workday azonosító csak számot tartalmazhat !');
      edtWDSzam.SetFocus;
      exit;
    end ;
    if (sTPMSetupWDNum = '') then
    begin
      ShowMessage('Workday azonosító megadása kötelező !');
      edtWDSzam.SetFocus;
      exit;
		end;
    }

    //feeder_tpm -táblát meg kell nézni hogy nincs-e nyitott munkalap erről a feederről:
    //ha van akkor kiabálni kell!!
    myDataset := dbConnect('feeder_tpm','SELECT * FROM feeder_tpm WHERE tpm_ds7i = "' + DS7i + '" and tpm_lezarva = 0;','id');
    if (myDataset.RecordCount > 0) then
        begin
          sPrev_Jav := '';
          if (myDataset.FieldByName('tpm_preventive').AsInteger = 1) then sPrev_Jav := 'preventívre!';
          if (myDataset.FieldByName('tpm_javitasra').AsInteger = 1) then sPrev_Jav := 'javításra!';
          dbClose(myDataset);
          ShowMessage(DS7i + ' - azonosítóju adagoló már várakozik ' + sPrev_Jav);
          edtDs7i.Text := '';
          DS7i := '';
          edtDs7i.SetFocus;
          Exit;
        end;
    //dbClose(myDataset);

    //Ha még nincs a rendszerben a feeder akkor be kell azonosítani:
    dbUpdate(myDataset,'SELECT * FROM repair WHERE ds7i="' + DS7i + '";');
    iRecCount := myDataset.RecordCount;
    if (iRecCount > 0) then
        begin
          //Már a rendszerben lévő adatok lekérdezése:
          iFeederType := myDataset.FieldByName('r_type').AsInteger;
          iFeederSize := myDataset.FieldByName('size').AsInteger;
        end
    else
        begin
          dbUpdate(myDataset,'SELECT * FROM feeder_tpm WHERE tpm_ds7i="' + DS7i + '";');
          iRecCount := myDataset.RecordCount;
          if (iRecCount > 0) then
              begin
                iFeederType := myDataset.FieldByName('tpm_type').AsInteger;
                iFeederSize := myDataset.FieldByName('tpm_size').AsInteger;
              end;

        end;
    dbClose(myDataset);

		if (iRecCount = 0) then
        begin
          //Még nincs bennt a rendszerben:
          ShowMessage('Az adagoló még nem szerepel az adatbázisban!' + #10 + 'A megjelenő ablakban tudja rögzíteni!');
			  	frmTPMDS7i_Azonositas.Hide;
          frmPreventiveFeederazonositas.Show;
          exit;
        end;


    frmTPMDS7i_Azonositas.Hide;
    frmTPMSetupMain.Show;


end;

procedure TfrmTPMDS7i_Azonositas.edtDs7iKeyPress(Sender: TObject; var Key: char
  );
begin
    if (Key = chr(13)) then frmTPMDS7i_Azonositas.btnAzonositasClick(nil);
end;

procedure TfrmTPMDS7i_Azonositas.edtWDSzamKeyPress(Sender: TObject;
  var Key: char);
begin
    if (Key = chr(13)) then frmTPMDS7i_Azonositas.btnAzonositasClick(nil);
end;

procedure TfrmTPMDS7i_Azonositas.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  CanClose := true;
  frmTPMDS7i_Azonositas.Hide;
  frmLogin.Show;
end;

initialization
  {$I tpmds7iazonositas.lrs}

end.

