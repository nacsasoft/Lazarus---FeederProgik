unit tpmsetupmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, global, database, Sqlite3DS, crt;

type

  { TfrmTPMSetupMain }

  TfrmTPMSetupMain = class(TForm)
    btnRogzites: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    cmbHibakodok: TComboBox;
    edtDs7i: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure btnRogzitesClick(Sender: TObject);
    procedure CheckBox1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure CheckBox2KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure CheckBox3KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure CheckBox4KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure CheckBox5KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure CheckBox6KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure CheckBox7KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure EllenorzesSpace(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }

  public
    { public declarations }
  end;

var
  frmTPMSetupMain: TfrmTPMSetupMain;

implementation

uses login, prevfeederazon, tpmds7iazonositas;

{ TfrmTPMSetupMain }

procedure TfrmTPMSetupMain.FormShow(Sender: TObject);
var
  myDataset:  TSqlite3Dataset;
  sData:      String;
  i:          Integer;
  tch:        TCheckBox;

begin
    //Hibakód lista feltöltése :
    cmbHibakodok.Clear;
    myDataset := dbConnect('error_codes','select * from error_codes;','id');
    cmbHibakodok.Items.Add('Az adagoló megfelelő állapotban van');
		Repeat
        sData := myDataset.FieldByName('e_code').AsString + ' - ' + myDataset.FieldByName('e_desc').AsString;
        cmbHibakodok.Items.AddObject(sData,TObject(myDataset.FieldByName('id').AsInteger));
        myDataset.Next;
    Until myDataset.Eof;
    dbClose(myDataset);
    cmbHibakodok.Update;
    cmbHibakodok.ItemIndex := 0;

    edtDs7i.Text := DS7i;
    for i := 0 to 6 do
    begin
        tch := (GroupBox2.Controls[i] as TCheckBox);
        tch.Checked := false;
        tch.Visible := true;
        //tch.OnKeyPress := @TfrmTPMSetupMain.EllenorzesSpace;
    end;

    //ellenörző lista beállítása a feedertípusnak megfelelően:
    case iFeederType of
      0:  CheckBox3.Caption := 'Talp ellenörzése';            //S_F_HS
      1:  CheckBox3.Caption := 'Omega profil ellenörzése';    //X
      5:  begin
            //Hover Davis:
            CheckBox3.Caption := 'Talp ellenörzése';
            CheckBox7.Checked := true;
            CheckBox7.Visible := false;
          end;

    end;

    CheckBox1.SetFocus();

end;

procedure TfrmTPMSetupMain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
    CanClose := true;
    frmTPMSetupMain.Hide;
		frmTPMDS7i_Azonositas.Show;
end;

procedure TfrmTPMSetupMain.btnRogzitesClick(Sender: TObject);
var
  myDataset                                     :TSqlite3Dataset;
  iHibakod,iPrev,iJav,i,iLezarva,iMuszak        :Integer;
  tch                                           :TCheckBox;
  sDate, sTime                                  :string;
  ThisMoment                                    :TDateTime;

begin
    //Ki van pipálva az öszes ellenörzendő feladat??
    //Ha hibás a feeder akkor nem kell kijelölni semmit....
    if (cmbHibakodok.ItemIndex = 0) then
    begin
      for i := 0 to 6 do
      begin
          tch := (GroupBox2.Controls[i] as TCheckBox);
          if (tch.Checked = false) and (tch.Visible = true) then
          begin
            ShowMessage('Rögzítéshez az összes feladatot ki kell jelölni!');
            exit;
          end;
      end;
    end;

    //writeLogMessage('feeder_tpm -tábla feltöltése...');
    ThisMoment:=Now;
    sDate := FormatDateTime('YYYY-MM-DD',ThisMoment); //'2010-04-25';
    sTime := FormatDateTime('hh-nn',ThisMoment);

    //Műszak meghatározása:
    iMuszak := 3;
    if (sTime >= sMuszak1_Start) and (sTime <= sMuszak1_End) then iMuszak :=  1;
    if (sTime >= sMuszak2_Start) and (sTime <= sMuszak2_End) then iMuszak :=  2;

    //feeder_tpm -táblába felvinni:
    try
      //Jó a feeder vagy javításra megy???
      if (cmbHibakodok.ItemIndex = 0) then
        begin
            //nem kell javítani, mehet vissza a jók közé!
            iPrev := 0;
            iJav := 0;
            iHibakod := -1;
            iLezarva := 1;
        end
      else
        begin
            //javításra megy, kell a hibakód is:
            iPrev := 0;
            iJav := 1;
            iHibakod := integer(cmbHibakodok.Items.Objects[cmbHibakodok.ItemIndex]);
            iLezarva := 0;
        end;

      myDataset := dbConnect('feeder_tpm','SELECT * FROM feeder_tpm ORDER BY id;','id');
      with myDataset do
          begin
              Insert;
              FieldByName('u_id').AsInteger := userDB_ID;
              FieldByName('tpm_date').AsString := '';
              FieldByName('tpm_outdate').AsString := sDate;
              FieldByName('tpm_del').AsInteger := 0;
              FieldByName('tpm_ds7i').AsString := DS7i;
              FieldByName('tpm_type').AsInteger := iFeederType;
              FieldByName('tpm_size').AsInteger := iFeederSize;
              FieldByName('tpm_javitasra').AsInteger := iJav;
              FieldByName('tpm_preventive').AsInteger := iPrev;
              FieldByName('tpm_hibakod').AsInteger := iHibakod;
              FieldByName('tpm_lezarva').AsInteger := iLezarva;
              FieldByName('prev_u_id').AsInteger := -1;
              FieldByName('tpm_wdnum').AsString := sTPMSetupWDNum;
              FieldByName('tpm_date_time').AsString := '';
              FieldByName('tpm_outdate_time').AsString := sTime;
              FieldByName('tpm_date_muszak').AsInteger := 0;
              FieldByName('tpm_outdate_muszak').AsInteger := iMuszak;
              Post;
              ApplyUpdates;
          end;
      dbClose(myDataset);
    except
         on E: Exception do
         begin
             dbClose(myDataset);
             //sInfo := 'TfrmTPMDS7i_Azonositas.btnAzonositas - ' + e.Message;
             //ShowMessage(sInfo);
         end;
    end;

    //ShowMessage(IntToStr(cmbHibakodok.ItemIndex));
    //ShowMessage(IntToStr(integer(cmbHibakodok.Items.Objects[cmbHibakodok.ItemIndex])));
    frmTPMSetupMain.Hide;
    frmTPMDS7i_Azonositas.Show;


end;

procedure TfrmTPMSetupMain.CheckBox1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Key = 32) then CheckBox2.SetFocus;
end;

procedure TfrmTPMSetupMain.CheckBox2KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Key = 32) then CheckBox3.SetFocus;
end;

procedure TfrmTPMSetupMain.CheckBox3KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Key = 32) then CheckBox4.SetFocus;
end;

procedure TfrmTPMSetupMain.CheckBox4KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Key = 32) then CheckBox5.SetFocus;
end;

procedure TfrmTPMSetupMain.CheckBox5KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    if (Key = 32) then CheckBox6.SetFocus;
end;

procedure TfrmTPMSetupMain.CheckBox6KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key <> 32) then exit;
  if (CheckBox7.Visible = true) then
    CheckBox7.SetFocus
  else
    btnRogzites.SetFocus;
end;

procedure TfrmTPMSetupMain.CheckBox7KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  btnRogzites.SetFocus;
end;




procedure TfrmTPMSetupMain.EllenorzesSpace(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  i:          Integer;
  tch:        TCheckBox;

begin
    if (Key <> 32) then exit;
    i := 0;
    repeat
        tch := (GroupBox2.Controls[i] as TCheckBox);
        if (tch.Checked = false) then
          begin
            //ShowMessage('OK');
            tch.Checked := true;
            if (i < 6) then
              begin
                tch := (GroupBox2.Controls[i+1] as TCheckBox);
                tch.SetFocus;
              end;
            //delay(250);
            break;
          end;
        i := i+1;
    until i = 7;
end;


initialization
  {$I tpmsetupmain.lrs}

end.

