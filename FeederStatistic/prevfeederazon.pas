unit prevfeederazon;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, global, database, Sqlite3DS;

type

  { TfrmPreventiveFeederazonositas }

  TfrmPreventiveFeederazonositas = class(TForm)
    btnFelvitel: TButton;
    cmbMeret: TComboBox;
    cmbTipus: TComboBox;
    edtDS7i: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure btnFelvitelClick(Sender: TObject);
    procedure cmbTipusChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    procedure SetFeederSize(iftype: Integer);

  public
    { public declarations }
  end;

var
  frmPreventiveFeederazonositas: TfrmPreventiveFeederazonositas;

implementation

  uses tpmds7iazonositas, tpmsetupmain, feederpreventiv;
{ TfrmPreventiveFeederazonositas }

procedure TfrmPreventiveFeederazonositas.btnFelvitelClick(Sender: TObject);
//Feeder rögzítése a rendszerbe(csak a globális változókat kell beállítani)...
begin
    iFeederType := cmbTipus.ItemIndex;
    // ShowMessage(IntToStr(iFeederType));
    // Itt most nincs fuji,seq,vcd....ezért kell átállítani a helyes értékre:
    if (iFeederType = 2) then iFeederType := 5;

    iFeederSize := integer(cmbMeret.Items.Objects[cmbMeret.ItemIndex]);
    sFeederSize := cmbMeret.Text;

    frmPreventiveFeederazonositas.Hide;

    // Ha a TPM Setup azonosította akkor az ő ell. listáját kell megj.:
    // if (iAdmin = 4) then frmTPMSetupMain.Show;
    // if (iAdmin = 5) then frmFeederPreventiv.Show;
    // Jelölőpöttyös preventív újra aktív 2025.09.17.
    frmFeederPreventiv.Show;
end;

procedure TfrmPreventiveFeederazonositas.cmbTipusChange(Sender: TObject);
//Feeder típus váltáskor frissíteni kell a méreteket:
begin
    SetFeederSize(cmbTipus.ItemIndex);
end;

procedure TfrmPreventiveFeederazonositas.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
var
  sInfo       :String;
  iRet        :Integer;

begin
    sInfo := 'Figyelem !' + chr(13) + chr(13) +
    		'Feeder azonosítás nélkül nem kerülhet a rendszerbe!' + chr(13) +
           	'Biztos hogy ki akar lépni ?';
    iRet := MessageDlg('Kilépés azonosítás nélkül...',sInfo,mtWarning,mbYesNo,0);
    if (iRet <> mrYes) then
    begin
        CanClose := false;
        exit;
    end ;
    CanClose := true;
    frmPreventiveFeederazonositas.Hide;
    frmTPMDS7i_Azonositas.Show;


end;

procedure TfrmPreventiveFeederazonositas.FormShow(Sender: TObject);


begin
  edtDS7i.Text := DS7i;
  SetFeederSize(cmbTipus.ItemIndex);
  cmbTipus.SetFocus;

end;


procedure TfrmPreventiveFeederazonositas.SetFeederSize(iftype: Integer);
//Feeder méret beállítása:
var
  	feeder_size_dataset	:TSqlite3Dataset;
    sData								:string;
    it                  :Integer;

begin
    cmbMeret.Items.Clear;
    feeder_size_dataset := dbConnect('feeder_size','select * from feeder_size where type = ' + inttostr(iftype) + ';','id');
    Repeat
		    sData := feeder_size_dataset.FieldByName('size').AsString;
		    it := feeder_size_dataset.FieldByName('id').AsInteger;
        cmbMeret.Items.AddObject(sData,TObject(it));
		    feeder_size_dataset.Next;
    Until feeder_size_dataset.Eof;
    dbClose(feeder_size_dataset);
    cmbMeret.Update;
    cmbMeret.ItemIndex := 0;
end;

initialization
  {$I prevfeederazon.lrs}

end.

