unit reportsnoadmin ;

{$mode objfpc}{$H+}

interface

uses
  Classes , SysUtils , sqlite3ds , db , FileUtil , LResources , Forms ,
  Controls , Graphics , Dialogs , StdCtrls , ExtCtrls , LR_Class , LR_DBSet ,
  global ;

type

  { TfrmReportsNoAdmin }

  TfrmReportsNoAdmin = class(TForm)
      btnJavFeedersTol: TButton ;
      btnKivFeederJavitasai: TButton ;
      cmbFeederType: TComboBox ;
      Datasource1: TDatasource ;
      edtJavFeedersIg: TEdit ;
      edtKivFeederJavIg: TEdit ;
      edtJavFeedersTol: TEdit ;
      edtKivFeederJavDS7i: TEdit ;
      edtKivFeederJavTol: TEdit ;
      frDBDataSet1: TfrDBDataSet ;
      frReport1: TfrReport ;
      GroupBox1: TGroupBox ;
      GroupBox2: TGroupBox ;
      GroupBox4: TGroupBox ;
      Label1: TLabel ;
      Label2: TLabel ;
      Label3: TLabel ;
      Label4: TLabel ;
      Label5: TLabel ;
      Label7: TLabel ;
      Shape1: TShape ;
      Sqlite3Dataset1: TSqlite3Dataset ;
      procedure btnJavFeedersTolClick(Sender: TObject) ;
      procedure btnKivFeederJavitasaiClick(Sender: TObject) ;
      procedure cmbFeederTypeChange(Sender: TObject) ;
      procedure FormClose(Sender: TObject ; var CloseAction: TCloseAction) ;
      procedure FormShow(Sender: TObject) ;
      procedure frReport1GetValue(const ParName: String ; var ParValue: Variant
          ) ;
  private
    { private declarations }
  public
    { public declarations }
  end ; 

var
  frmReportsNoAdmin: TfrmReportsNoAdmin ;

implementation

uses fomenu;

{ TfrmReportsNoAdmin }

procedure TfrmReportsNoAdmin.FormClose(Sender: TObject ;
    var CloseAction: TCloseAction) ;
begin
    frmReportsNoAdmin.Hide;
    frmMainMenu.Show;
end;

procedure TfrmReportsNoAdmin.FormShow(Sender: TObject) ;
var
	sDate:	string;
begin
	//globális változók :
    iFeederType := 0;

    //Mezők beállítása :
    sDate := FormatDateTime('YYYY-MM-DD',Now); //'2010-04-25'
    edtJavFeedersIg.Text := sDate;
    edtJavFeedersTol.Text := sDate;
    edtKivFeederJavDS7i.Text := '';
	edtKivFeederJavIg.Text := sDate;
    edtKivFeederJavTol.Text := sDate;

end;

procedure TfrmReportsNoAdmin.frReport1GetValue(const ParName: String ;
    var ParValue: Variant) ;
begin
    if (ParName = 'cNAME') then ParValue := userName;
    //Javított feederek :
    if (ParName = 'sJAVITOTTFEEDEREKTITLE') then
    	ParValue := 'Javított ' + cmbFeederType.Text + ' adagolók';
    if (ParName = 'sTOL') then ParValue := edtJavFeedersTol.Text;
	if (ParName = 'sIG') then ParValue := edtJavFeedersIg.Text;

    //Adott feeder (ds7i) javításai az adott időszakban :
	if (ParName = 'sADOTTFEEDERNOADMINTITLE') then
    	ParValue := cmbFeederType.Text + ' adagoló javításai';
    if (ParName = 'sTOL2') then ParValue := edtJavFeedersTol.Text;
	if (ParName = 'sIG2') then ParValue := edtJavFeedersIg.Text;

end;

procedure TfrmReportsNoAdmin.btnJavFeedersTolClick(Sender: TObject) ;
var
	sSQL,sTol,sIg:	string;
begin
    //A belépett felhasználó által javított feederek az adott időszakban :
	sTol := trim(edtJavFeedersTol.Text);
    sIg := trim(edtJavFeedersIg.Text);
    if (sTol = '') or (sIg = '') then
    begin
    	ShowMessage('A mezők kitöltése kötelező!' + chr(13) + 'Dátumforma : ÉÉÉÉ-HH-NN (pl.: 2005-04-21)');
        exit;
    end ;
    sSQL := 'select r_date,ds7i,r_comment from repair,users ';
    sSQL := sSQL + 'where r_del = 0 and r_end = 1 and ';
    sSQL := sSQL + 'users.id = u_id and u_id = '+ IntToStr(userDB_ID) +' and ';
    sSQL := sSQL + '(r_date >= "' + sTol + '" and r_date <= "' + sIg + '") ';
    sSQL := sSQL + ' and r_type = '+ IntToStr(iFeederType);
    sSQL := sSQL + ' order by r_date;';
    //ShowMessage(sSQL);
    try
	Sqlite3Dataset1.FileName := dbPath;
    Sqlite3Dataset1.TableName := 'repair';
	Sqlite3Dataset1.SQL := sSQL;
    Sqlite3Dataset1.Active := true;
    if (Sqlite3Dataset1.RecordCount = 0) then
    begin
    	ShowMessage('Az adott időszakban nem volt javitott adagoló.');
		Sqlite3Dataset1.Active := false;
        exit;
    end ;
	frReport1.FileName := sReportsPath+'javitottfeederek.lrf';
    frReport1.LoadFromFile(sReportsPath+'javitottfeederek.lrf');
    frReport1.ShowReport;
    Sqlite3Dataset1.Active := false;
    except
    	ShowMessage('Hiba történt a riport készítése közben!' + chr(13) + 'Kérem ellenőrizze a dátum megadásokat!' +
        chr(13) + chr(13) + 'A helyes dátumformátum : ÉÉÉÉ-HH-NN (pl.: 2005-04-21)');
        exit;
    end ;
end;

procedure TfrmReportsNoAdmin.btnKivFeederJavitasaiClick(Sender: TObject) ;
var
	tDS7i,sSQL,sTol,sIg:	string;
begin
	//DS7i alapján kiválasztott feeder javításai az adott időszakra :
    tDS7i := trim(edtKivFeederJavDS7i.Text);
    if (IsStrANumber(tDS7i) = false) then
    begin
    	ShowMessage('A DS7i azonosító csak számot tartalmazhat !');
    	exit;
    end ;
    if (tDS7i = '') then
    begin
    	ShowMessage('A DS7i azonosító megadása kötelező !');
      	exit;
    end;
	sTol := trim(edtKivFeederJavTol.Text);
    sIg := trim(edtKivFeederJavIg.Text);
    if (sTol = '') or (sIg = '') then
    begin
    	ShowMessage('A mezők kitöltése kötelező!' + chr(13) + 'Dátumforma : ÉÉÉÉ-HH-NN (pl.: 2005-04-21)');
        exit;
    end ;
    sSQL := 'select r_date,r_comment from repair,users ';
    sSQL := sSQL + 'where r_del = 0 and r_type = 0 and r_end = 1 and ';
    sSQL := sSQL + 'users.id = u_id and u_id = '+ IntToStr(userDB_ID) +' and ds7i = "'+ tDS7i +'" and ';
    sSQL := sSQL + '(r_date >= "' + sTol + '" and r_date <= "' + sIg + '") ';
    sSQL := sSQL + ' and r_type = '+ IntToStr(iFeederType);
    sSQL := sSQL + ' order by r_date;';
    ShowMessage(sSQL);
    try
	Sqlite3Dataset1.FileName := dbPath;
    Sqlite3Dataset1.TableName := 'repair';
	Sqlite3Dataset1.SQL := sSQL;
    Sqlite3Dataset1.Active := true;
    if (Sqlite3Dataset1.RecordCount = 0) then
    begin
    	ShowMessage('A '+ tDS7i +' azonosítóju feeder nem volt az adott időszakban javítva.');
		Sqlite3Dataset1.Active := false;
        exit;
    end ;
	frReport1.FileName := sReportsPath+'adottfeeder_noadmin.lrf';
    frReport1.LoadFromFile(sReportsPath+'adottfeeder_noadmin.lrf');
    frReport1.ShowReport;
    Sqlite3Dataset1.Active := false;
    except
    	ShowMessage('Hiba történt a riport készítése közben!' + chr(13) + 'Kérem ellenőrizze a dátum megadásokat!' +
        chr(13) + chr(13) + 'A helyes dátumformátum : ÉÉÉÉ-HH-NN (pl.: 2005-04-21)');
        exit;
    end ;

end;

procedure TfrmReportsNoAdmin.cmbFeederTypeChange(Sender: TObject) ;
begin
    //Feeder típus váltás történt :
    iFeederType := cmbFeederType.ItemIndex;
end;

initialization
  {$I reportsnoadmin.lrs}

end.

