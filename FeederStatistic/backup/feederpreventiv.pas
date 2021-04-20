unit feederpreventiv;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls;

type

  { TfrmFeederPreventiv }

  TfrmFeederPreventiv = class(TForm)
    btnKilepLezarasNelkul: TButton;
    btnMunkalapLezarasa: TButton;
    CheckBox1: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox16: TCheckBox;
    CheckBox17: TCheckBox;
    CheckBox18: TCheckBox;
    CheckBox19: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox20: TCheckBox;
    CheckBox21: TCheckBox;
    CheckBox25: TCheckBox;
    CheckBox26: TCheckBox;
    CheckBox27: TCheckBox;
    CheckBox28: TCheckBox;
    CheckBox29: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox30: TCheckBox;
    CheckBox31: TCheckBox;
    CheckBox32: TCheckBox;
    CheckBox33: TCheckBox;
    CheckBox36: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    edtDS7i: TEdit;
    edtFeederSize: TEdit;
    edtFeederType: TEdit;
    edtKarbantarto: TEdit;
    grbS_F_HS_Feladatok: TGroupBox;
    grbX_Feladatok: TGroupBox;
    grbHD_Feladatok: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Shape2: TShape;
    Shape3: TShape;
    Shape4: TShape;
    procedure btnKilepLezarasNelkulClick(Sender: TObject);
    procedure btnMunkalapLezarasaClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  frmFeederPreventiv: TfrmFeederPreventiv;

implementation

uses global,database, Sqlite3DS, fomenu;

{ TfrmFeederPreventiv }

procedure TfrmFeederPreventiv.FormShow(Sender: TObject);
var
  i         :Integer;
  tch       :TCheckBox;

begin
  //mezők kitöltése:
  edtDS7i.Text := DS7i;
  edtFeederSize.Text := sFeederSize;
  edtKarbantarto.Text := userName;
  if (iFeederType = 0) then edtFeederType.Text := 'SIEMENS S,F,HS';
  if (iFeederType = 1) then edtFeederType.Text := 'SIEMENS X';
	//if (iFeederType = 2) then edtFeederType.Text := 'FUJI';
  //if (iFeederType = 3) then edtFeederType.Text := 'RLI';
  //if (iFeederType = 4) then edtFeederType.Text := 'VCD-SEQ';
  if (iFeederType = 5) then edtFeederType.Text := 'Hover Davis';

  //Feeder típushoz tartozó group box -megjelenítése:
  grbS_F_HS_Feladatok.Visible := false;
  grbX_Feladatok.Visible := false;
  grbHD_Feladatok.Visible := false;

  if (iFeederType = 0) then grbS_F_HS_Feladatok.Visible := true;
  if (iFeederType = 1) then grbX_Feladatok.Visible := true;
  if (iFeederType = 5) then grbHD_Feladatok.Visible := true;

  for i := 0 to 11 do
    begin
        tch := (grbS_F_HS_Feladatok.Controls[i] as TCheckBox);
        tch.Checked := false;
    end;
  for i := 0 to 8 do
    begin
        tch := (grbX_Feladatok.Controls[i] as TCheckBox);
        tch.Checked := false;
    end;
  for i := 0 to 9 do
    begin
        tch := (grbHD_Feladatok.Controls[i] as TCheckBox);
        tch.Checked := false;
    end;

end;

procedure TfrmFeederPreventiv.FormCloseQuery(Sender: TObject; var CanClose: boolean);
var
   iRet:  integer;
   sInfo: string;

begin
    sInfo := 'Figyelem !' + chr(13) + chr(13) +
    		'Ha most kilép, a munkalap tölésre kerül !' + chr(13) +
           	'Biztos hogy ki akar lépni ?';
    iRet := MessageDlg('Kilépés lezárás nélkül...',sInfo,mtWarning,mbYesNo,0);
    if (iRet <> mrYes) then
    begin
        CanClose := false;
        exit;
    end ;
    CanClose := true;
		frmMainMenu.Show;

end;

procedure TfrmFeederPreventiv.btnKilepLezarasNelkulClick(Sender: TObject);
begin
    //Kilépés munkalap lezárása nélkül :
    frmFeederPreventiv.Close;
end;

procedure TfrmFeederPreventiv.btnMunkalapLezarasaClick(Sender: TObject);
var
   i,iRecCount  :Integer;
   iMuszak      :Integer;
   tch          :TCheckBox;
   bCheck       :Boolean;  //Ha = true akkor ellenörzés oké!
   myDataset    :TSqlite3Dataset;
   sDate, sTime :string;
   ThisMoment   :TDateTime;

begin
    //Munkalap lezárása:

    //Lista ellenörzése (kipipált mindent ami az adott típusú feederhez tartozik???)
    bCheck := true;
    if (iFeederType = 0) then
    begin
        for i := 0 to 11 do
          begin
              tch := (grbS_F_HS_Feladatok.Controls[i] as TCheckBox);
              if (tch.Checked = false) then bCheck := false;
          end;
    end;

    if (iFeederType = 1) then
    begin
        for i := 0 to 8 do
          begin
              tch := (grbX_Feladatok.Controls[i] as TCheckBox);
              if (tch.Checked = false) then bCheck := false;
          end;
    end;

    if (iFeederType = 5) then
    begin
        for i := 0 to 9 do
          begin
              tch := (grbHD_Feladatok.Controls[i] as TCheckBox);
              if (tch.Checked = false) then bCheck := false;
          end;
    end;

    if (bCheck = false) then
    begin
        ShowMessage('Rögzítéshez az összes feladatot ki kell jelölni!');
        exit;
    end;

    ThisMoment:=Now;
    sDate := FormatDateTime('YYYY-MM-DD',ThisMoment); //'2010-04-25';
    sTime := FormatDateTime('hh-nn',ThisMoment);

    //Műszak meghatározása:
    iMuszak := 3;
    if (sTime >= sMuszak1_Start) and (sTime <= sMuszak1_End) then iMuszak :=  1;
    if (sTime >= sMuszak2_Start) and (sTime <= sMuszak2_End) then iMuszak :=  2;

    //Adatbázis frissítés....
    //SETUP-ból jött a feeder ?? (ilyenkor csak frissíteni kell a db-t -- preventive kész)
    myDataset := dbConnect('feeder_tpm','select * from feeder_tpm where tpm_ds7i = "' + DS7i
                            + '" and tpm_preventive = 1 and tpm_lezarva = 0;','id');
    iRecCount := myDataset.RecordCount;

    if (iRecCount > 0) then
      begin
          //SETUP-ból rakták ki a feedert preventívre:
          myDataset.Edit;
          myDataset.FieldByName('tpm_date').AsString := sDate;
          myDataset.FieldByName('tpm_lezarva').AsInteger := 1;
          myDataset.Post;
          myDataset.ApplyUpdates;
          dbUpdate(myDataset,'Select * from feeder_tpm Order By id;');
      end
    else
      begin
          //Polcról vagy a termelésből került preventívre:
          dbUpdate(myDataset,'Select * from feeder_tpm Order By id;');
          with myDataset do
            begin
                Insert;
                FieldByName('u_id').AsInteger := -1;
                FieldByName('tpm_date').AsString := sDate;
                FieldByName('tpm_outdate').AsString := sDate;
                FieldByName('tpm_del').AsInteger := 0;
                FieldByName('tpm_ds7i').AsString := DS7i;
                FieldByName('tpm_type').AsInteger := iFeederType;
                FieldByName('tpm_size').AsInteger := iFeederSize;
                FieldByName('tpm_javitasra').AsInteger := 0;
                FieldByName('tpm_preventive').AsInteger := 1;
                FieldByName('tpm_hibakod').AsInteger := -1;
                FieldByName('tpm_lezarva').AsInteger := 1;
                FieldByName('prev_u_id').AsInteger := userDB_ID;
                FieldByName('tpm_date_time').AsString := sTime;
              FieldByName('tpm_outdate_time').AsString := '';
              FieldByName('tpm_date_muszak').AsInteger := iMuszak;
              FieldByName('tpm_outdate_muszak').AsInteger := 0;
                Post;
                ApplyUpdates;
            end;
      end;

    dbClose(myDataset);
    //Sikeres lezárás:
    ShowMessage('A munkalap sikeresen lezárásra került !');
    frmFeederPreventiv.Hide;
    frmMainMenu.Show;

end;

initialization
  {$I feederpreventiv.lrs}

end.

