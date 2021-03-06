unit reports ;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, Calendar, PopupNotifier, ExtDlgs, LR_Class,
  LR_DBSet, LR_ChBox, LR_PGrid, LR_E_CSV, LR_E_HTM, LR_E_TXT, database,
  sqlite3ds, db, global, MouseAndKeyInput, TASources, TAGraph, windows, comobj,
  fpspreadsheet, laz_fpspreadsheet, strutils, dateutils;

type

  { TfrmReports }

  TfrmReports = class(TForm)
    btn24OranBelul: TButton;
    btnAktualisSorrolKiesettAdagolok: TButton;
    btnDS7iAddFeeder: TButton;
    btnDS7iDelAllFeeder: TButton;
    btnDS7iDelSelectedFeeder: TButton;
    btnDS7iRiportEredmeny: TButton;
    btnFeedercserekSoronkent : TButton;
      btnIdoszakosAlkfelh: TButton;
      btnDS7iOsszesites: TButton;
      btnOperatorokMunkaiRiport: TButton;
      btnPreventivesekMunkaiRiport: TButton;
      btnTroliFullRiport : TButton;
      btnIdoszakosHibak: TButton;
      btnJavitokMunkai: TButton;
      btnKimennyitJavitott: TButton;
      btnEllenorzes_OK : TButton;
      btnSoronkentiKieses: TButton;
      btnTOPFeeders: TButton;
      btnRiport_min_3_javitas : TButton;
      btnEgyebMunkakRiport: TButton;
      btnMagazinFullRiport: TButton;
      chkNapiOsszesitett : TCheckBox;
      chkOsszesitett: TCheckBox;
      cmbAdagoloHibak: TComboBox;
      cmbFeederJavitok: TComboBox;
      cmbFeederType: TComboBox ;
      cmbSorok: TComboBox;
      Datasource1: TDatasource ;
      edt24OranBelulIg: TEdit;
      edt24OranBelulTol: TEdit;
      edtAktualisSorIg: TEdit;
      edtAktualisSorTol: TEdit;
      edtDS7i: TEdit;
      edtDS7iIg: TEdit;
      edtChartIg : TEdit;
      edtDS7iTol: TEdit;
      edtChartTol : TEdit;
      edtIdoszakosAlkIg: TEdit;
      edtDS7iOsszesitesIg: TEdit;
      edtDS7iOsszesitesTol: TEdit;
      edtTPMOperatorokIg: TEdit;
      edtPreventivesekIg: TEdit;
      edtTPMOperatorokTol: TEdit;
      edtPreventivesekTol: TEdit;
      edtTroliIg : TEdit;
      edtIdoszakosAlkTol: TEdit;
      edtEgyebMunkakIg: TEdit;
      edtMagazinIg: TEdit;
      edtTroliTol : TEdit;
      edtIdoszakosHibakIg: TEdit;
      edtIdoszakosHibakTol: TEdit;
      edtJavitokMunkaiIg: TEdit;
      edtJavitokMunkaiTol: TEdit;
      edtKiMennyitIg: TEdit;
      edtKiMennyitTol: TEdit;
      edtSoronkentiIg: TEdit;
      edtSoronkentiTol: TEdit;
      edtTOPIg: TEdit;
      edtTOPTol: TEdit;
      edtEgyebMunkakTol: TEdit;
      edtMagazinTol: TEdit;
      GroupBox1: TGroupBox;
      GroupBox10: TGroupBox;
      GroupBox11: TGroupBox;
      GroupBox12: TGroupBox;
      GroupBox13 : TGroupBox;
      GroupBox14 : TGroupBox;
      GroupBox15 : TGroupBox;
      GroupBox16 : TGroupBox;
      GroupBox17: TGroupBox;
      GroupBox18: TGroupBox;
      GroupBox19: TGroupBox;
      GroupBox2: TGroupBox;
      GroupBox20: TGroupBox;
      GroupBox3: TGroupBox;
      gpbTipusBeallitas: TGroupBox ;
      GroupBox4: TGroupBox;
      GroupBox5: TGroupBox;
      GroupBox6: TGroupBox;
      GroupBox7: TGroupBox;
      GroupBox8: TGroupBox;
      GroupBox9: TGroupBox;
      Label1: TLabel;
      Label10: TLabel;
      Label11: TLabel;
      Label12: TLabel;
      Label13: TLabel;
      Label14: TLabel;
      Label15: TLabel;
      Label16: TLabel;
      Label17: TLabel;
      Label18: TLabel;
      Label19: TLabel;
      Label2: TLabel;
      Label20: TLabel;
      Label21 : TLabel;
      Label22 : TLabel;
      Label23: TLabel;
      Label24: TLabel;
      Label25: TLabel;
      Label26: TLabel;
      Label27: TLabel;
      Label28: TLabel;
      Label29 : TLabel;
      Label3: TLabel;
      Label30 : TLabel;
      Label31: TLabel;
      Label32: TLabel;
      Label33: TLabel;
      Label34: TLabel;
      Label35: TLabel;
      Label36: TLabel;
      Label37: TLabel;
      Label38: TLabel;
      Label4: TLabel;
      Label5: TLabel;
      Label6: TLabel;
      Label7: TLabel ;
      Label8: TLabel;
      Label9: TLabel;
      lstDs7iAdagolok: TListBox;
      Memo1 : TMemo;
      PageControl1: TPageControl;
      rdbOsszesitett: TRadioButton;
      rdbOsszesitettJavitasokkal : TRadioButton;
      rdbOsszesitettEgyszeru: TRadioButton;
      Shape1: TShape ;
      Sqlite3Dataset1: TSqlite3Dataset ;
      TabSheet1: TTabSheet;
      tpmFeeder: TTabSheet;
      tshEgyebMunkak: TTabSheet;
      tshRiport1: TTabSheet;
      tshDS7iSzerint: TTabSheet;
      tshFeederEllenorzes : TTabSheet;
      TabSheet4 : TTabSheet;
      tshTroliRiportok : TTabSheet;
      procedure btn24OranBelulClick(Sender : TObject);
      procedure btnAktualisSorrolKiesettAdagolokClick(Sender: TObject) ;
      procedure btnDS7iAddFeederClick(Sender: TObject) ;
      procedure btnDS7iAddFeederKeyPress(Sender: TObject; var Key: char);
      procedure btnDS7iDelAllFeederClick(Sender: TObject) ;
      procedure btnDS7iDelSelectedFeederClick(Sender: TObject) ;
      procedure btnDS7iOsszesitesClick(Sender: TObject);
      procedure btnDS7iRiportEredmenyClick(Sender: TObject) ;
      procedure btnEgyebMunkakRiportClick(Sender: TObject);
      procedure btnEllenorzes_OKClick(Sender : TObject);
      procedure btnIdoszakosAlkfelhClick(Sender: TObject) ;
      procedure btnIdoszakosHibakClick(Sender: TObject) ;
      procedure btnJavitokMunkaiClick(Sender: TObject) ;
      procedure btnKimennyitJavitottClick(Sender: TObject) ;
      procedure btnFeedercserekSoronkentClick(Sender : TObject);
      procedure btnMagazinFullRiportClick(Sender: TObject);
      procedure btnOperatorokMunkaiRiportClick(Sender: TObject);
      procedure btnPreventivesekMunkaiRiportClick(Sender: TObject);
      procedure btnRiport_min_3_javitasClick(Sender : TObject);
      procedure btnSoronkentiKiesesClick(Sender: TObject) ;
      procedure btnTOPFeedersClick(Sender: TObject) ;
      procedure btnTroliFullRiportClick(Sender : TObject);
      procedure cmbFeederTypeChange(Sender: TObject) ;
      procedure edt24OranBelulIgKeyPress(Sender: TObject ; var Key: char) ;
      procedure edt24OranBelulTolKeyPress(Sender: TObject ; var Key: char) ;
      procedure edtAktualisSorIgKeyPress(Sender: TObject; var Key: char);
      procedure edtAktualisSorTolKeyPress(Sender: TObject; var Key: char);
      procedure edtDS7iKeyPress(Sender: TObject; var Key: char);
      procedure edtDS7iOsszesitesIgKeyPress(Sender: TObject; var Key: char);
      procedure edtDS7iOsszesitesTolKeyPress(Sender: TObject; var Key: char);
      procedure edtEgyebMunkakIgKeyPress(Sender: TObject; var Key: char);
      procedure edtEgyebMunkakTolKeyPress(Sender: TObject; var Key: char);
      procedure edtIdoszakosAlkIgKeyPress(Sender: TObject; var Key: char);
      procedure edtIdoszakosAlkTolKeyPress(Sender: TObject; var Key: char);
      procedure edtMagazinIgKeyPress(Sender: TObject; var Key: char);
      procedure edtMagazinTolKeyPress(Sender: TObject; var Key: char);
      procedure edtPreventivesekIgKeyPress(Sender: TObject; var Key: char);
      procedure edtPreventivesekTolKeyPress(Sender: TObject; var Key: char);
      procedure edtSoronkentiIgKeyPress(Sender: TObject; var Key: char);
      procedure edtSoronkentiTolKeyPress(Sender: TObject; var Key: char);
      procedure edtTOPIgKeyPress(Sender: TObject ; var Key: char) ;
      procedure edtTOPTolKeyPress(Sender: TObject ; var Key: char) ;
      procedure edtIdoszakosHibakIgKeyPress(Sender: TObject ; var Key: char) ;
      procedure edtIdoszakosHibakTolKeyPress(Sender: TObject ; var Key: char) ;
      procedure edtJavitokMunkaiIgKeyPress(Sender: TObject ; var Key: char) ;
      procedure edtJavitokMunkaiTolKeyPress(Sender: TObject ; var Key: char) ;
      procedure edtKiMennyitIgKeyPress(Sender: TObject ; var Key: char) ;
      procedure edtKiMennyitTolKeyPress(Sender: TObject ; var Key: char) ;
      procedure edtTOPFeedersKeyPress(Sender: TObject ; var Key: char) ;
      procedure edtTPMOperatorokIgKeyPress(Sender: TObject; var Key: char);
      procedure edtTPMOperatorokTolKeyPress(Sender: TObject; var Key: char);
      procedure edtTroliIgKeyPress(Sender: TObject; var Key: char);
      procedure edtTroliTolKeyPress(Sender: TObject; var Key: char);
      procedure FormClose(Sender: TObject ; var CloseAction: TCloseAction) ;
      procedure FormShow(Sender: TObject) ;
      procedure frReport1ExportFilterSetup(Sender: TfrExportFilter);
      procedure frReport1GetValue(const ParName : String; var ParValue : Variant);
      procedure tshDS7iSzerintShow(Sender: TObject);
      procedure tshFeederEllenorzesShow(Sender: TObject);
      procedure tshRiport1Show(Sender: TObject);
      procedure tshTroliRiportokShow(Sender: TObject);
  private
    { private declarations }
    myDataset					:TSqlite3Dataset;
    bOsszesTipus			:Boolean;
    procedure Trolijavitasok_full_riport();
		procedure KiMikorMelyiket_Mitjavitott();
    procedure ReportToExcel(ExcelLapCim: string; dsRiport: TSqlite3Dataset);
    procedure ReportPasteToExcel();

  public
    { public declarations }


  end ; 

var
  frmReports: TfrmReports ;
  sMess: string;

const
  RiportNoData = 'A riport nem tartalmaz adatokat!';
  StatusWindowText = 'Riport keszitese folyamatban...';

implementation

uses fomenu, chart1;

{ TfrmReports }

procedure TfrmReports.btnTOPFeedersClick(Sender: TObject) ;
var
	sSQL,sTol,sIg,S:	string;
  status: TStatusWindowHandle;

begin
    //TOP feederk??lts??gek - A legt??bb p??nzbe ker??lt adagol??, adott id??szakra....
    sTol := trim(edtTOPTol.Text);
    sIg := trim(edtTOPIg.Text);
    if (sTol = '') or (sIg = '') then
    begin
    	ShowMessage('A mez??k kit??lt??se k??telez??!' + chr(13) + 'D??tumforma : ????????-HH-NN (pl.: 2005-04-21)');
        exit;
    end ;
    sSQL := 'select ds7i, sum(p_cost) as ??ssz_??r, feeder_types.ft_type as T??pus, feeder_size.size as M??ret from usedparts,parts,repair,users,feeder_types,feeder_size ';
    sSQL := sSQL + 'where (repair.r_date >= "' + sTol + '" and repair.r_date <= "' + sIg +
    '") and p_id = parts.id and r_type = '+ IntToStr(iFeederType) +
    ' and r_id = repair.id and r_del = 0 and u_id = users.id and feeder_types.id = repair.r_type and feeder_size.id = repair.size ';
	  sSQL := sSQL + 'group by ds7i order by ??ssz_??r desc limit 10;';

    status := CreateStatusWindow(StatusWindowText);
    myDataset := dbConnect('parts', sSQL, 'id');
    RemoveStatusWindow(status);

    if (myDataset.RecordCount > 0) then
        ReportToExcel('TOP 10 Feederk??lts??g', myDataset)
    else
        ShowMessage(RiportNoData);

    dbClose(myDataset);

end;

procedure TfrmReports.btnTroliFullRiportClick(Sender : TObject);
var
  sSQL,sTol,sIg:	string;
  //status: TStatusWindowHandle;

begin
  //Trolikkal kapcsolatos jav??t??sok (full riport!!)
    sTol := trim(edtTroliTol.Text);
  	sIg := trim(edtTroliIg.Text);
  	if (sTol = '') or (sIg = '') then
  	begin
      ShowMessage('A mez??k kit??lt??se k??telez??!' + chr(13) + 'D??tumforma : ????????-HH-NN (pl.: 2005-04-21)');
      exit;
  	end ;
    //status := CreateStatusWindow(StatusWindowText);
    Trolijavitasok_full_riport();
    //RemoveStatusWindow(status);
    //ReportPasteToExcel();


end;

procedure TfrmReports.cmbFeederTypeChange(Sender: TObject) ;
var
	sData:	string;
begin
    //Feeder t??pus v??lt??s t??rt??nt :
    iFeederType := cmbFeederType.ItemIndex;
    //??sszes t??pusr??l kell riport ?
    if (iFeederType = 5) then
			begin
					//igen, t??pushib??k letilt??sa...
					edtIdoszakosHibakIg.Enabled := false;
          edtIdoszakosHibakTol.Enabled := false;
          cmbAdagoloHibak.Enabled := false;
					btnIdoszakosHibak.Enabled := false;
          edtSoronkentiIg.Enabled := false;
          edtSoronkentiTol.Enabled := false;
          edtAktualisSorIg.Enabled := false;
          edtAktualisSorTol.Enabled := false;
          cmbSorok.Enabled := false;
          bOsszesTipus := true;
          exit;
      end
    else
			begin
					//nem, t??pushib??k enged??lyez??se......
					edtIdoszakosHibakIg.Enabled := true;
          edtIdoszakosHibakTol.Enabled := true;
          cmbAdagoloHibak.Enabled := true;
					btnIdoszakosHibak.Enabled := true;
          edtSoronkentiIg.Enabled := true;
          edtSoronkentiTol.Enabled := true;
          edtAktualisSorIg.Enabled := true;
          edtAktualisSorTol.Enabled := true;
          cmbSorok.Enabled := true;
          bOsszesTipus := false;
      end ;

    //Adagol??hib??k combo friss??t??se :
    myDataset := dbConnect('errors','SELECT * FROM errors WHERE e_del=0 and e_type = ' + IntToStr(iFeederType),'id');
    cmbAdagoloHibak.Clear;
    if (myDataset.RecordCount > 0) then
    begin
        Repeat
        	sData := myDataset.FieldByName('e_desc').AsString;
            cmbAdagoloHibak.Items.AddObject(sData,TObject(myDataset.FieldByName('id').AsInteger));
            myDataset.Next;
        Until myDataset.Eof;
        myDataset.First;
        cmbAdagoloHibak.ItemIndex := 0;
        cmbAdagoloHibak.Refresh;
	end;

    dbClose(myDataset);
end;

procedure TfrmReports.edt24OranBelulIgKeyPress(Sender: TObject ; var Key: char ) ;
begin
    if (Key = chr(13)) then btn24OranBelulClick(Sender);
end;

procedure TfrmReports.edt24OranBelulTolKeyPress(Sender: TObject ; var Key: char ) ;
begin
    if (Key = chr(13)) then btn24OranBelulClick(Sender);
end;

procedure TfrmReports.edtAktualisSorIgKeyPress(Sender: TObject; var Key: char);
begin
     if (Key = chr(13)) then btnAktualisSorrolKiesettAdagolokClick(Sender);
end;

procedure TfrmReports.edtAktualisSorTolKeyPress(Sender: TObject; var Key: char);
begin
     if (Key = chr(13)) then btnAktualisSorrolKiesettAdagolokClick(Sender);
end;

procedure TfrmReports.edtDS7iKeyPress(Sender: TObject; var Key: char);
begin
     if (Key = chr(13)) then btnDS7iAddFeederClick(Sender);
end;

procedure TfrmReports.edtDS7iOsszesitesIgKeyPress(Sender: TObject; var Key: char
  );
begin
     if (Key = chr(13)) then btnDS7iOsszesitesClick(Sender);
end;

procedure TfrmReports.edtDS7iOsszesitesTolKeyPress(Sender: TObject;
  var Key: char);
begin
     if (Key = chr(13)) then btnDS7iOsszesitesClick(Sender);
end;

procedure TfrmReports.edtEgyebMunkakIgKeyPress(Sender: TObject; var Key: char);
begin
     if (Key = chr(13)) then btnEgyebMunkakRiportClick(Sender);
end;

procedure TfrmReports.edtEgyebMunkakTolKeyPress(Sender: TObject; var Key: char);
begin
     if (Key = chr(13)) then btnEgyebMunkakRiportClick(Sender);
end;

procedure TfrmReports.edtIdoszakosAlkIgKeyPress(Sender: TObject; var Key: char);
begin
     if (Key = chr(13)) then btnIdoszakosAlkfelhClick(Sender);
end;

procedure TfrmReports.edtIdoszakosAlkTolKeyPress(Sender: TObject; var Key: char
  );
begin
     if (Key = chr(13)) then btnIdoszakosAlkfelhClick(Sender);
end;

procedure TfrmReports.edtMagazinIgKeyPress(Sender: TObject; var Key: char);
begin
     if (Key = chr(13)) then btnMagazinFullRiportClick(Sender);
end;

procedure TfrmReports.edtMagazinTolKeyPress(Sender: TObject; var Key: char);
begin
     if (Key = chr(13)) then btnMagazinFullRiportClick(Sender);
end;

procedure TfrmReports.edtPreventivesekIgKeyPress(Sender: TObject; var Key: char
  );
begin
     if (Key = chr(13)) then btnPreventivesekMunkaiRiportClick(Sender);
end;

procedure TfrmReports.edtPreventivesekTolKeyPress(Sender: TObject; var Key: char
  );
begin
     if (Key = chr(13)) then btnPreventivesekMunkaiRiportClick(Sender);
end;

procedure TfrmReports.edtSoronkentiIgKeyPress(Sender: TObject; var Key: char);
begin
     if (Key = chr(13)) then btnSoronkentiKiesesClick(Sender);
end;

procedure TfrmReports.edtSoronkentiTolKeyPress(Sender: TObject; var Key: char);
begin
     if (Key = chr(13)) then btnSoronkentiKiesesClick(Sender);
end;

procedure TfrmReports.edtTOPIgKeyPress(Sender: TObject ; var Key: char ) ;
begin
    if (Key = chr(13)) then btnTOPFeedersClick(Sender);
end;

procedure TfrmReports.edtTOPTolKeyPress(Sender: TObject ; var Key: char ) ;
begin
    if (Key = chr(13)) then btnTOPFeedersClick(Sender);
end;

procedure TfrmReports.edtIdoszakosHibakIgKeyPress(Sender: TObject ; var Key: char) ;
begin
	if (Key = chr(13)) then btnIdoszakosHibakClick(Sender);
end;

procedure TfrmReports.edtIdoszakosHibakTolKeyPress(Sender: TObject ; var Key: char) ;
begin
    if (Key = chr(13)) then btnIdoszakosHibakClick(Sender);
end;

procedure TfrmReports.edtJavitokMunkaiIgKeyPress(Sender: TObject ; var Key: char ) ;
begin
    if (Key = chr(13)) then btnJavitokMunkaiClick(Sender);
end;

procedure TfrmReports.edtJavitokMunkaiTolKeyPress(Sender: TObject ; var Key: char) ;
begin
    if (Key = chr(13)) then btnJavitokMunkaiClick(Sender);
end;

procedure TfrmReports.edtKiMennyitIgKeyPress(Sender: TObject ; var Key: char) ;
begin
	if (Key = chr(13)) then btnKimennyitJavitottClick(Sender);
end;

procedure TfrmReports.edtKiMennyitTolKeyPress(Sender: TObject ; var Key: char) ;
begin
	if (Key = chr(13)) then btnKimennyitJavitottClick(Sender);
end;

procedure TfrmReports.edtTOPFeedersKeyPress(Sender: TObject ; var Key: char) ;
begin
    if (Key = chr(13)) then btnTOPFeedersClick(Sender);
end;

procedure TfrmReports.edtTPMOperatorokIgKeyPress(Sender: TObject; var Key: char
  );
begin
     if (Key = chr(13)) then btnOperatorokMunkaiRiportClick(Sender);
end;

procedure TfrmReports.edtTPMOperatorokTolKeyPress(Sender: TObject; var Key: char
  );
begin
     if (Key = chr(13)) then btnOperatorokMunkaiRiportClick(Sender);
end;

procedure TfrmReports.edtTroliIgKeyPress(Sender: TObject; var Key: char);
begin
     if (Key = chr(13)) then btnTroliFullRiportClick(Sender);
end;

procedure TfrmReports.edtTroliTolKeyPress(Sender: TObject; var Key: char);
begin
     if (Key = chr(13)) then btnTroliFullRiportClick(Sender);
end;

procedure TfrmReports.btnIdoszakosAlkfelhClick(Sender: TObject) ;
var
	sTol,sIg,sSQL,S:	string;
  status: TStatusWindowHandle;
begin
    //Idoszakos alkatreszfelhasznalas a nem torolt munkalapoknal :
    sTol := trim(edtIdoszakosAlkTol.Text);
    sIg := trim(edtIdoszakosAlkIg.Text);
    if (sTol = '') or (sIg = '') then
    begin
    	ShowMessage('A mez??k kit??lt??se k??telez??!' + chr(13) + 'D??tumforma : ????????-HH-NN (pl.: 2005-04-21)');
        exit;
    end ;

    sSQL := 'select p_name as Megnevez??s,p_ordernum as Rendel??si_sz??m,';
    sSQL := sSQL + 'count(p_name) as Darab, p_cost as Darab_??r, sum(p_cost) as ??ssz_??r ';
    sSQL := sSQL + 'from usedparts,parts,repair where ';
    sSQL := sSQL + '(repair.r_date >= "' + sTol + '" and repair.r_date <= "' + sIg + '") and r_del = 0';
    if (bOsszesTipus) then
    	sSQL := sSQL + ' and usedparts.p_id = parts.id and usedparts.r_id = repair.id  group by p_name;'
    else
    	sSQL := sSQL + ' and r_type = '+ IntToStr(iFeederType) +
      								' and usedparts.p_id = parts.id and usedparts.r_id = repair.id  group by p_name;';
    status := CreateStatusWindow(StatusWindowText);
    myDataset := dbConnect('repair', sSQL, 'id');
    RemoveStatusWindow(status);

    if (myDataset.RecordCount > 0) then
        ReportToExcel('Id??szakos alkatr??szfelhaszn??l??s', myDataset)
    else
        ShowMessage(RiportNoData);

    dbClose(myDataset);

end;

procedure TfrmReports.btn24OranBelulClick(Sender : TObject);
  type
    rFAdatok = record
        sDS7i							:string;		//Feeder DS7i sz??ma
        sType             :string;    //Feeder t??pusa (S,F stb.)
        sSize             :string;    //Feeder m??rete (2x8, 3x8 stb.)
        sDate1						:string;		//Els?? jav??t??s d??tuma
        sDate2						:string;		//M??sodik jav??t??s d??tuma
        sUname		        :string;		//Jav??t?? neve
        sComment					:string;		//Megjegyz??sek.....
    end ;

var
	sTol,sIg,sSQL,S :string;
  ds7i1,ds7i2,date1,date2,uname1,uname2:	string;
  tdate1,tdate2 :TDateTime;
  status: TStatusWindowHandle;
  reportDatas :array of rFAdatok;
  iCount :integer;

begin
    //24 ??r??n bel??l visszaker??lt feederek :
		sTol := trim(edt24OranBelulTol.Text);
    sIg := trim(edt24OranBelulIg.Text);
    if (sTol = '') or (sIg = '') then
    begin
    	ShowMessage('A mez??k kit??lt??se k??telez??!' + chr(13) + 'D??tumforma : ????????-HH-NN (pl.: 2005-04-23)');
        exit;
    end ;
    //St??tusz ablak megjelen??t??se :
    status := CreateStatusWindow(StatusWindowText);

    sSQL := 'SELECT repair.ds7i,repair.r_date,repair.r_comment,feeder_size.size,feeder_types.ft_type,users.u_name ';
    sSQL := sSQL + 'FROM repair,feeder_size,feeder_types,users ';
    sSQL := sSQL + 'where users.id = repair.u_id and repair.size = feeder_size.id and repair.r_type = feeder_types.id and users.u_del = 0 and ';
    sSQL := sSQL + '(repair.r_date >= "' + sTol + '" and repair.r_date <= "' + sIg + '" ';
    sSQL := sSQL + 'and repair.r_type = '+ IntToStr(iFeederType) +' and repair.r_del = 0 and repair.r_end = 1) ';
    sSQL := sSQL + 'order by repair.ds7i, repair.r_date;';

		Sqlite3Dataset1.FileName := dbPath;
    Sqlite3Dataset1.TableName := 'repair';
		Sqlite3Dataset1.SQL := sSQL;
    Sqlite3Dataset1.Active := true;
    if (Sqlite3Dataset1.RecordCount = 0) then
    begin
      //St??tusz ablak bez??r??sa:
      RemoveStatusWindow(status);
    	ShowMessage('24 ??r??n bel??l visszaker??lt adagol?? nem volt az adott id??szakban.');
			Sqlite3Dataset1.Active := false;
      exit;
    end ;

    //riport adatok kigy??jt??se, elemz??se:
    //SetLength(reportDatas,Sqlite3Dataset1.RecordCount);
    Memo1.Clear;
	  //Copy Fieldnames First
    Memo1.Lines.Add('24 ??r??n bel??l visszaker??lt adagol??k (' + cmbFeederType.Text + ')');
    S := 'DS7i' + Delim + 'Els?? jav??t??s' + Delim + 'M??sodik jav??t??s' + Delim + 'Els?? jav??t??st v??gezte';
    Memo1.Lines.Add(S);
    //iCount := 0;
    Sqlite3Dataset1.First;
    ds7i2 := Sqlite3Dataset1.FieldByName('ds7i').AsString;
    date2 := Sqlite3Dataset1.FieldByName('r_date').AsString;
    uname2 := Sqlite3Dataset1.FieldByName('u_name').AsString;
    repeat
		  with Sqlite3Dataset1 do
			  begin
          ds7i1 := ds7i2;
          date1 := date2;
          uname1 := uname2;
          Sqlite3Dataset1.Next;
          if Sqlite3Dataset1.EOF then break;
          ds7i2 := FieldByName('ds7i').AsString;
          date2 := FieldByName('r_date').AsString;
          uname2 := FieldByName('u_name').AsString;

          if LowerCase(trim(ds7i1)) = LowerCase(trim(ds7i2)) then
          begin
            tdate1 := ScanDateTime('YYYY-MM-DD',trim(date1));
            tdate2 := ScanDateTime('YYYY-MM-DD',trim(date2));
            iCount := DaysBetween(tdate1,tdate2);
            if (iCount <= 1) then
            begin
              S := '';
              S := ds7i1 + Delim + date1 + Delim + date2 + Delim + uname1;
				      Memo1.Lines.Add(S);
            end;
          end;
        end;
    until Sqlite3Dataset1.EOF;
    Sqlite3Dataset1.Active := false;

    //St??tusz ablak bez??r??sa:
    RemoveStatusWindow(status);

    Memo1.SelectAll;
	  Memo1.CopyToClipboard;

    ReportPasteToExcel();

end;

procedure TfrmReports.btnAktualisSorrolKiesettAdagolokClick(Sender: TObject) ;
var
		sTol,sIg,sSQL,S:			string;
    iKivalasztottSor:		integer;
    status: TStatusWindowHandle;
begin
		//Aktu??lis sorr??l kiesett adagol??k :
		iKivalasztottSor := Integer(cmbSorok.Items.Objects[cmbSorok.ItemIndex]);
		sTol := trim(edtAktualisSorTol.Text);
    sIg := trim(edtAktualisSorIg.Text);
    if (sTol = '') or (sIg = '') then
    begin
    		ShowMessage('A mez??k kit??lt??se k??telez??!' + chr(13) + 'D??tumforma : ????????-HH-NN (pl.: 2005-04-21)');
        exit;
    end ;

    sSQL := 'SELECT ds7i,r_date as D??tum,feeder_size.size AS M??ret,feeder_types.ft_type AS T??pus FROM repair,feeder_size,feeder_types ';
    sSQL := sSQL + 'WHERE repair.size = feeder_size.id and repair.r_type = feeder_types.id AND (repair.r_date >= "' + sTol + '" AND repair.r_date <= "' + sIg + '") AND repair.r_del = 0';
    sSQL := sSQL + ' AND line = '+ IntToStr(iKivalasztottSor) + ' ORDER BY r_date;';

    status := CreateStatusWindow(StatusWindowText);
    myDataset := dbConnect('repair', sSQL, 'id');
    RemoveStatusWindow(status);

    if (myDataset.RecordCount > 0) then
        ReportToExcel(cmbSorok.Text + '-sorr??l kiesett adagol??k', myDataset)
    else
        ShowMessage(RiportNoData);

    dbClose(myDataset);

end;

procedure TfrmReports.btnDS7iAddFeederClick(Sender: TObject) ;
var
    sDS7i_	: string;
    i				: integer;
begin
    //DS7i azonosito hozzaadasa a listahoz :
    sDS7i_ := trim(edtDS7i.Text);
    if (sDS7i_ = '') then exit;
    if (lstDs7iAdagolok.Items.IndexOf(sDS7i_) > -1) then
      begin
				ShowMessage('A ' + sDS7i_ + ' -azonos??t??t m??r tartalmazza a lista!');
        edtDS7i.SetFocus;
        exit;
      end ;
    lstDs7iAdagolok.Items.Add(sDS7i_);
    lstDs7iAdagolok.Refresh;
end;

procedure TfrmReports.btnDS7iAddFeederKeyPress(Sender: TObject; var Key: char);
begin
  if (Key = chr(13)) then btnDS7iAddFeederClick(Sender);
end;

procedure TfrmReports.btnDS7iDelAllFeederClick(Sender: TObject) ;
//var
   //iRet:  integer;
   //sInfo: string;
begin
    //DS7i lista torlese :
    //sInfo := 'Az ??sszes DS7i azonos??t?? t??r??lve lesz! ' + chr(13) + 'Biztos folytatod ?';
    //iRet := MessageDlg('Azonos??t??k t??rl??se...',sInfo,mtWarning,mbYesNo,0);
    //if (iRet = mrYes) then lstDs7iAdagolok.Clear;
    lstDs7iAdagolok.Clear;
    lstDs7iAdagolok.Refresh;
end;

procedure TfrmReports.btnDS7iDelSelectedFeederClick(Sender: TObject) ;
var
   //iRet:  integer;
   sInfo,sDS7i_: string;
begin
    //Kiv??lasztott DS7i azonos??to torlese a listabol :
		sDS7i_ := lstDs7iAdagolok.GetSelectedText;
    if (sDS7i_ = '') then exit;
		//sInfo := 'T??rl??d a ' + sDS7i_ + ' -azonos??t??t ?';
    //iRet := MessageDlg('Azonos??t?? t??rl??se...',sInfo,mtWarning,mbYesNo,0);
    //if (iRet = mrYes) then lstDs7iAdagolok.Items.Delete(lstDs7iAdagolok.ItemIndex);
    lstDs7iAdagolok.Items.Delete(lstDs7iAdagolok.ItemIndex);
    lstDs7iAdagolok.Refresh;
end;

procedure TfrmReports.btnDS7iOsszesitesClick(Sender: TObject);
var
		sTol,sIg,sSQL,S:			string;
    status: TStatusWindowHandle;
begin
     //??sszes jav??tott feeder DS7i szerint ??sszes??tve (TOP 10)
    sTol := trim(edtDS7iOsszesitesTol.Text);
    sIg := trim(edtDS7iOsszesitesIg.Text);
    if (sTol = '') or (sIg = '') then
    begin
    		ShowMessage('A mez??k kit??lt??se k??telez??!' + chr(13) + 'D??tumforma : ????????-HH-NN (pl.: 2005-04-21)');
        if (sTol = '') then edtDS7iOsszesitesTol.SetFocus
           else edtDS7iOsszesitesIg.SetFocus;
        exit;
    end ;

    status := CreateStatusWindow(StatusWindowText);

    sSQL := 'SELECT count(ds7i) as darabszam,ds7i FROM repair ';
    sSQL := sSQL + 'WHERE (repair.r_date >= "' + sTol + '" AND repair.r_date <= "' + sIg + '") AND r_type = ' + IntToStr(iFeederType) + ' AND repair.r_del = 0 ';
    sSQL := sSQL + 'GROUP BY ds7i ORDER BY darabszam desc limit 10;';

    try
		    Sqlite3Dataset1.FileName := dbPath;
        Sqlite3Dataset1.TableName := 'repair';
		    Sqlite3Dataset1.SQL := sSQL;
        Sqlite3Dataset1.Active := true;
        if (Sqlite3Dataset1.RecordCount = 0) then
        begin
            RemoveStatusWindow(status);
    		    ShowMessage('Az adott id??szakban nem volt ' + cmbFeederType.Text + ' tipus?? feeder jav??tva!');
				    Sqlite3Dataset1.Active := false;
            exit;
        end ;
        Sqlite3Dataset1.First;
        Memo1.Clear;
	      //Copy Fieldnames First
        Memo1.Lines.Add('??sszes jav??tott feeder DS7i szerint csoportos??tva' + Delim + '(' + cmbFeederType.Text + ')');
	      S := 'DS7i' + Delim + 'Darab';
        Memo1.Lines.Add(S);
	      repeat
		      with Sqlite3Dataset1 do
			      begin
      	      S := '';
              S := FieldByName('ds7i').AsString + Delim + FieldByName('darabszam').AsString + Delim;
				      Memo1.Lines.Add(S);
            end;
          Sqlite3Dataset1.Next;
        until Sqlite3Dataset1.EOF;

        Memo1.SelectAll;
	      Memo1.CopyToClipboard;
        RemoveStatusWindow(status);
	      Sqlite3Dataset1.Active := false;
        ReportPasteToExcel();
    except
        RemoveStatusWindow(status);
    		ShowMessage('Hiba t??rt??nt a riport k??sz??t??se k??zben!' + chr(13) + 'K??rem ellen??rizze a d??tum megad??sokat!' +
        chr(13) + chr(13) + 'A helyes d??tumform??tum : ????????-HH-NN (pl.: 2005-04-21)');
        Sqlite3Dataset1.Active := false;
        exit;
    end ;

end;

procedure TfrmReports.btnDS7iRiportEredmenyClick(Sender: TObject) ;

type
  rFAdatok = record
      sDS7i							:string;		//Feeder DS7i sz??ma
      sType             :string;    //Feeder t??pusa (S,F stb.)
      sSize             :string;    //Feeder m??rete (2x8, 3x8 stb.)
      sDate							:string;		//Jav??t??s d??tuma
      sE_Date						:string;		//Kirak??s d??tuma (opi ekko rakta ki)
      sUname		        :string;		//Jav??t?? neve
      sOname						:string;		//Oper??tor neve aki kirakta
      sWorks		        :string;		//Elv??gzett munk??k (r??gi lek??rdez??sek miatt...)
      sRepairs					:string;		//Elv??gzett jav??t??sok (Karcsi m??dos??t??sa miatt...)
      sMachine					:string;		//Err??l a g??pr??l esett ki
      sError						:string;		//Ezzel a hib??val rakta ki az oper??tor
      sPosition					:string;		//Err??l a helyr??l (pl.: 3/19/2)
      sParts		        :string;		//Felhaszn??lt alkatr??szek
      sComment					:string;		//Megjegyz??sek.....
      sCost							:string;		//Jav??t??si kltsg-ek
      sLine							:string;		//Err??l a sorr??l lett kirakva

  end ;
  rNincsAdat = record
    sDS7i			:string;
    sNA				:Boolean;	//ha = true akkor nincs adat ehez a ds7i-s feederhez
  end ;

var
      sTol,sIg,sSQL	        :string;
      sDS7i,sData,sCost,sWDNum         :string;
      aFeederAdatok		:array of rFAdatok;
      i,j,iRows,iActualRow,iTworkID,iPartsNum,iWorksNum,iFad,iLine,iErrNum,iMachine	:integer;
      worksDataset,partsDataset,repairDataset                      :TSqlite3Dataset;
      rPartsCost,rtCost						:double;
      iArraySize						:integer;
      sRiportTartalom, sRiportFejlec: String;

      saDS7i							:array of rNincsAdat;
      x: Integer;
  		S: String;
  		Y: String;
      status: TStatusWindowHandle;

begin
    //Adott DS7i azonos??t??val ell??tott adagol??(k) id??szakos jav??t??sai (ki,mikor,mit) :
    if (lstDs7iAdagolok.Count = 0) then
      begin
        ShowMessage('Nincsenek felv??ve adagol??k a riporthoz!');
        edtDS7i.SetFocus;
        exit;
      end ;
		sTol := trim(edtDS7iTol.Text);
    sIg := trim(edtDS7iIg.Text);
    if (sTol = '') or (sIg = '') then
    begin
    		ShowMessage('A mez??k kit??lt??se k??telez??!' + chr(13) + 'D??tumforma : ????????-HH-NN (pl.: 2005-04-21)');
        exit;
    end ;
    //St??tusz ablak megjelen??t??se :
    status := CreateStatusWindow(StatusWindowText);

    myDataset := dbConnect('works','SELECT * FROM works WHERE w_del=0;','id');
    worksDataset := dbConnect('feeder_works','select * from feeder_works','id');
    partsDataset := dbConnect('feeder_errors','select * from feeder_errors','id');
    repairDataset := dbConnect('repair','SELECT * FROM repair;','id');

    //t??mb m??ret??nek be??ll??t??sa :
    SetLength(saDS7i,lstDs7iAdagolok.Count);
    iArraySize := 0;
    for j := 0 to lstDs7iAdagolok.Count-1 do
    begin
         //A listaban levo ds7i-azonositokon v??gig kell menni...
        DS7i := lstDs7iAdagolok.Items.ValueFromIndex[j];
        sSQL := 'select * from repair ';
        sSQL := sSQL + 'where ds7i = "' + DS7i + '" and r_end = 1 and r_del = 0 ';
        sSQL := sSQL + ' and (repair.r_date >= "' + sTol + '" and repair.r_date <= "' + sIg + '") ';
			  sSQL := sSQL + ' order by repair.id;';

				dbUpdate(myDataset,sSQL);
        myDataset.First;

        saDS7i[j].sDS7i := DS7i;
        if (myDataset.RecordCount = 0) then
        begin
	        saDS7i[j].sNA := true;
	        iArraySize := iArraySize + 1;
        end
        else
        begin
           saDS7i[j].sNA := false;
      	   iArraySize := iArraySize + myDataset.RecordCount;
        end;
    end ;

    SetLength(aFeederAdatok,iArraySize);
    iActualRow := 0;
    for j := 0 to lstDs7iAdagolok.Count-1 do
    begin
         //A listaban levo ds7i-azonositokon v??gig kell menni...
    	   DS7i := saDS7i[j].sDS7i;
         if (saDS7i[j].sNA = true) then
         begin
              aFeederAdatok[iActualRow].sDS7i := DS7i;
              aFeederAdatok[iActualRow].sType := 'NA';
              aFeederAdatok[iActualRow].sSize := 'NA';
              aFeederAdatok[iActualRow].sDate := 'NA';
              aFeederAdatok[iActualRow].sE_Date := 'NA';
              aFeederAdatok[iActualRow].sUname := 'NA';
              aFeederAdatok[iActualRow].sOname := 'NA';
              aFeederAdatok[iActualRow].sWorks := 'NA';
              aFeederAdatok[iActualRow].sRepairs := 'NA';
              aFeederAdatok[iActualRow].sMachine := 'NA';
              aFeederAdatok[iActualRow].sError := 'NA';
              aFeederAdatok[iActualRow].sPosition := 'NA';
              aFeederAdatok[iActualRow].sParts := 'NA';
              aFeederAdatok[iActualRow].sComment := 'NA';
              aFeederAdatok[iActualRow].sCost := 'NA';
              aFeederAdatok[iActualRow].sLine := 'NA';
	      			iRows := 0;
              iActualRow := iActualRow + 1;
         end
         else
         begin
	      			sSQL := 'select repair.id as rep_id,repair.ds7i,repair.r_date,repair.r_comment,repair.line,';
			        sSQL := sSQL + 'repair.wd_num,repair.op_name,repair.machine,repair.position,repair.error_code,repair.e_date';
              sSQL := sSQL + ',feeder_size.size as feeder_size ,feeder_types.ft_type as feeder_type';
              sSQL := sSQL + ',users.id,users.u_name from repair, users, feeder_size, feeder_types ';
              sSQL := sSQL + 'where ds7i = "' + DS7i + '" and r_end = 1 and r_del = 0 ';
              sSQL := sSQL + ' and (repair.r_date >= "' + sTol + '" and repair.r_date <= "' + sIg + '") ';
			        sSQL := sSQL + ' and users.id = repair.u_id';
              sSQL := sSQL + ' and feeder_size.id = repair.size and feeder_types.id = repair.r_type';
              sSQL := sSQL + ' order by repair.id;';
	      			dbUpdate(repairDataset,sSQL);
              repairDataset.First;
              iRows := repairDataset.RecordCount;
         end ;

      //Feeder adatok oszegyujtese :
      if (iRows > 0) then
        begin
          Repeat
                //Aktu??lis munkalap db-id -je :
            	  iTworkID := repairDataset.FieldByName('rep_id').AsInteger;
            	  //DS7i,jav??t??,d??tum,megjegyz??s kit??lt??se :
                aFeederAdatok[iActualRow].sDS7i := DS7i;
                aFeederAdatok[iActualRow].sType := repairDataset.FieldByName('feeder_type').AsString;
                aFeederAdatok[iActualRow].sSize := repairDataset.FieldByName('feeder_size').AsString;
  			        aFeederAdatok[iActualRow].sUname := repairDataset.FieldByName('u_name').AsString;
                aFeederAdatok[iActualRow].sComment := repairDataset.FieldByName('r_comment').AsString;
                aFeederAdatok[iActualRow].sDate := repairDataset.FieldByName('r_date').AsString;
                aFeederAdatok[iActualRow].sE_Date := repairDataset.FieldByName('e_date').AsString;
				        aFeederAdatok[iActualRow].sPosition := repairDataset.FieldByName('position').AsString;

                //Oper??tor aki kirakta :
				        sWDNum := repairDataset.FieldByName('wd_num').AsString;
                dbUpdate(myDataset,'select * from dolgozok where wd_azonosito = "' +
        	        sWDNum + '";');
                if (myDataset.RecordCount < 1) then
        	        aFeederAdatok[iActualRow].sOname := 'N.A.'
                else
        	        aFeederAdatok[iActualRow].sOname := myDataset.FieldByName('name').AsString;

                //err??l a sorr??l esett ki :
                iLine := repairDataset.FieldByName('line').AsInteger;
				        dbUpdate(myDataset,'select * from sorok where id = ' + IntToStr(iLine) + ';');
                if (myDataset.RecordCount < 1) then
        	        aFeederAdatok[iActualRow].sLine := 'N.A.'
                else
        	        aFeederAdatok[iActualRow].sLine := myDataset.FieldByName('name').AsString;

                //ezzel a hib??val lett kirakva :
                iErrNum := repairDataset.FieldByName('error_code').AsInteger;
				        dbUpdate(myDataset,'select * from error_codes where id = ' + IntToStr(iErrNum) + ';');
                if (myDataset.RecordCount < 1) then
        	        aFeederAdatok[iActualRow].sError := 'N.A.'
                else
        	        aFeederAdatok[iActualRow].sError := myDataset.FieldByName('e_desc').AsString;

                //err??l a g??pr??l esett ki :
                iMachine := repairDataset.FieldByName('machine').AsInteger;
				        dbUpdate(myDataset,'select * from machines where id = ' + IntToStr(iMachine) + ';');
                if (myDataset.RecordCount < 1) then
        	        aFeederAdatok[iActualRow].sMachine := 'N.A.'
                else
        	        aFeederAdatok[iActualRow].sMachine := myDataset.FieldByName('m_name').AsString;

                //feederhez tartoz?? elv??gzett munk??k :
                dbUpdate(worksDataset,'select works.w_desc from feeder_works,works where feeder_works.r_id = '
                  + IntToStr(iTworkID) + ' and feeder_works.w_id = works.id');
                sData := '';
                iWorksNum := worksDataset.RecordCount;
                for i := 1 to iWorksNum do
                begin
                    aFeederAdatok[iActualRow].sWorks :=
                      aFeederAdatok[iActualRow].sWorks + worksDataset.FieldByName('w_desc').AsString;
                    if (i < iWorksNum) then
                      aFeederAdatok[iActualRow].sWorks := aFeederAdatok[iActualRow].sWorks + ',';
                    worksDataset.Next;
                end;

                //feederen elv??gzett jav??t??sok (Karcsi f??le m??dos??t??s....)
				        dbUpdate(worksDataset,'select repair_codes.r_desc from repair_codes,feeder_repair_codes where feeder_repair_codes.r_id = '
                  + IntToStr(iTworkID) + ' and feeder_repair_codes.r_code_id = repair_codes.id');
                sData := '';
                iWorksNum := worksDataset.RecordCount;
                for i := 1 to iWorksNum do
                begin
                    aFeederAdatok[iActualRow].sRepairs :=
                      aFeederAdatok[iActualRow].sRepairs + worksDataset.FieldByName('r_desc').AsString;
                    if (i < iWorksNum) then
                      aFeederAdatok[iActualRow].sRepairs := aFeederAdatok[iActualRow].sRepairs + ',';
                    worksDataset.Next;
                end;


                //feederbe ??p??tett alkatr??szek :
                rPartsCost := 0;
                dbUpdate(partsDataset,'select parts.p_name,parts.p_cost from usedparts,parts where usedparts.r_id = ' +
                	IntToStr(iTworkID) + ' and usedparts.p_id = parts.id;');
                sData := '';
                rPartsCost := 0;
                iPartsNum := partsDataset.RecordCount;

                if (iPartsNum > 0) then
                  begin
                     for i := 1 to iPartsNum do
                        begin
                             aFeederAdatok[iActualRow].sParts :=
                             aFeederAdatok[iActualRow].sParts + partsDataset.FieldByName('p_name').AsString;
                             try
                                rtCost := partsDataset.FieldByName('p_cost').AsFloat;
                             except
                                rtCost := 0;
                             end;
                             rPartsCost := rPartsCost + rtCost;
                             if (i < iPartsNum) then
		        					        aFeederAdatok[iActualRow].sParts := aFeederAdatok[iActualRow].sParts + ',';
                             partsDataset.Next;
                        end;
                  end;


                if (rPartsCost <= 0) then aFeederAdatok[iActualRow].sCost := '0.0';
                if (rPartsCost > 0) then aFeederAdatok[iActualRow].sCost := FloatToStr(rPartsCost);

								iActualRow := iActualRow + 1;
                repairDataset.Next;

          	Until repairDataset.Eof;

        end ;
    end ;

    dbClose(partsDataset);
    dbClose(worksDataset);
    dbClose(myDataset);


    //riport a memo-ba!
    iFad := Length(aFeederAdatok);

    Memo1.Clear;
    Memo1.Lines.Add('Ds7i alapj??n megadott adagol??k full riport');
      {Riport form??tum :
          sDS7i							:string;		//Feeder DS7i sz??ma
          sDate							:string;		//Jav??t??s d??tuma
          sE_Date						:string;		//Kirak??s d??tuma (opi ekko rakta ki)
          sUname		        :string;		//Jav??t?? neve
          sOname						:string;		//Oper??tor neve aki kirakta
          sWorks		        :string;		//Elv??gzett munk??k (r??gi lek??rdez??sek miatt...)
          sRepairs					:string;		//Elv??gzett jav??t??sok (Karcsi m??dos??t??sa miatt...)
          sMachine					:string;		//Err??l a g??pr??l esett ki
          sError						:string;		//Ezzel a hib??val rakta ki az oper??tor
          sPosition					:string;		//Err??l a helyr??l (pl.: 3/19/2)
          sParts		        :string;		//Felhaszn??lt alkatr??szek
          sComment					:string;		//Megjegyz??sek.....
          sCost							:string;		//Jav??t??si kltsg-ek
          sLine							:string;		//Err??l a sorr??l lett kirakva
      }
    sRiportFejlec := 'S.Sz.' + Delim + 'DS7i' + Delim + 'Jav??t??s d??tuma' + Delim + 'Kirak??s d??tuma' + Delim
      	+ 'Feederjav??t??' + Delim + 'Oper??tor neve' + Delim + 'Elv??gzett munk??k (r??gi)' + Delim
        + 'Elv??gzett jav??t??sok (??j)' + Delim
        + 'Alkatr??sz(ek)' + Delim + 'Megjegyz??sek (feederjav??t??kt??l)' + Delim
        + 'K??lts??g (EUR)' + Delim + 'Feeder csere oka' + Delim + 'Sor' + Delim
        + 'G??p' + Delim + 'Poz??ci??' + Delim + 'M??ret' + Delim + 'T??pus';

    Memo1.Lines.Add(sRiportFejlec);

    for i := 0 to iFad-1 do
        begin
          sRiportTartalom := '';
          sRiportTartalom := IntToStr(i+1)
              + Delim + aFeederAdatok[i].sDS7i
              + Delim + aFeederAdatok[i].sDate
              + Delim + aFeederAdatok[i].sE_Date
              + Delim + aFeederAdatok[i].sUname
              + Delim + aFeederAdatok[i].sOname
              + Delim + aFeederAdatok[i].sWorks
              + Delim + aFeederAdatok[i].sRepairs
              + Delim + aFeederAdatok[i].sParts
              + Delim + aFeederAdatok[i].sComment
              + Delim + aFeederAdatok[i].sCost
              + Delim + aFeederAdatok[i].sError
              + Delim + aFeederAdatok[i].sLine
              + Delim + aFeederAdatok[i].sMachine
              + Delim + aFeederAdatok[i].sPosition
              + Delim + aFeederAdatok[i].sSize
              + Delim + aFeederAdatok[i].sType;
          Memo1.Lines.Add(sRiportTartalom);
        end;

    Memo1.SelectAll;
    Memo1.CopyToClipboard;

    //St??tusz ablak bez??r??sa:
    RemoveStatusWindow(status);

    ReportPasteToExcel();

end;

procedure TfrmReports.btnEgyebMunkakRiportClick(Sender: TObject);
//Feederjavitok egyeb munkainak riportalasa...
var
		sSQL,sTol,sIg,S:	string;
    status: TStatusWindowHandle;

begin
		sTol := trim(edtEgyebMunkakTol.Text);
    sIg := trim(edtEgyebMunkakIg.Text);
    if (sTol = '') or (sIg = '') then
    begin
    		ShowMessage('A mez??k kit??lt??se k??telez??!' + chr(13) + 'D??tumforma : ????????-HH-NN (pl.: 2005-04-21)');
        exit;
    end ;

    status := CreateStatusWindow(StatusWindowText);

    sSQL := 'select egyeb_munkak.*,users.u_name from egyeb_munkak, users ';
    sSQL := sSQL + 'where users.id = egyeb_munkak.u_id ';
    sSQL := sSQL + 'and (s_datum >= "' + sTol + '" and s_datum <= "' + sIg + '") ';
    sSQL := sSQL + ' order by users.u_name;';

    try
		    Sqlite3Dataset1.FileName := dbPath;
        Sqlite3Dataset1.TableName := 'egyeb_munkak';
		    Sqlite3Dataset1.SQL := sSQL;
        Sqlite3Dataset1.Active := true;
        if (Sqlite3Dataset1.RecordCount = 0) then
        begin
            RemoveStatusWindow(status);
    		    ShowMessage('Az adott id??szakban nem volt egy??b jav??t??s.');
				    Sqlite3Dataset1.Active := false;
            exit;
        end ;
        Sqlite3Dataset1.First;
        Memo1.Clear;
	      //Copy Fieldnames First
        Memo1.Lines.Add('Feeder jav??t??k egy??b munk??i...');
	      S := 'N??v' + Delim + 'D??tum' + Delim + 'Elv??gzett munka' + Delim + 'Id??tartam (??ra)';
        Memo1.Lines.Add(S);
	      repeat
		      with Sqlite3Dataset1 do
			      begin
      	      S := '';
              S := FieldByName('u_name').AsString + Delim + FieldByName('s_datum').AsString + Delim
                + FieldByName('s_munka').AsString + Delim + FieldByName('s_idotartam').AsString;
				      Memo1.Lines.Add(S);
            end;
          Sqlite3Dataset1.Next;
        until Sqlite3Dataset1.EOF;

        Memo1.SelectAll;
	      Memo1.CopyToClipboard;
	      Sqlite3Dataset1.Active := false;
        RemoveStatusWindow(status);
        ReportPasteToExcel();
    except
        RemoveStatusWindow(status);
    		ShowMessage('Hiba t??rt??nt a riport k??sz??t??se k??zben!' + chr(13) + 'K??rem ellen??rizze a d??tum megad??sokat!' +
        chr(13) + chr(13) + 'A helyes d??tumform??tum : ????????-HH-NN (pl.: 2005-04-21)');
        Sqlite3Dataset1.Active := false;
        exit;
    end ;
end;

procedure TfrmReports.btnEllenorzes_OKClick(Sender : TObject);
//A kirakott feederek ellen??rz??se megt??rt??nt, temp t??bl??b??l ki lehet t??r??lni a kapcsol??d?? adatokat!
var
	sSQL,sInfo:		string;
  iRet:					integer;
begin
    sInfo := 'Figyelem !' + chr(13) + chr(13) +
    		'Biztos hogy t??r??lni akarja az adatokat ?';
    iRet := MessageDlg('Adatok t??rl??se...',sInfo,mtWarning,mbYesNo,0);
    if (iRet = mrNo) then exit;

    sSQL := 'delete from temp where iInfo1 = 1;';
		myDataset := dbConnect('temp',sSQL,'id');
  	dbClose(myDataset);
    ShowMessage('Az adatok t??rl??se megt??rt??nt!');
end;

procedure TfrmReports.btnIdoszakosHibakClick(Sender: TObject) ;
var
		sTol,sIg,sSQL,S:	string;
    iRepairId,iOsszJavitas:		integer;
    status: TStatusWindowHandle;

begin
    //??ltal??nos - Id??szakos feederhib??k :
    iRepairId := Integer(cmbAdagoloHibak.Items.Objects[cmbAdagoloHibak.ItemIndex]);
		sTol := trim(edtIdoszakosHibakTol.Text);
    sIg := trim(edtIdoszakosHibakIg.Text);
    if (sTol = '') or (sIg = '') then
    begin
    	ShowMessage('A mez??k kit??lt??se k??telez??!' + chr(13) + 'D??tumforma : ????????-HH-NN (pl.: 2005-04-21)');
      exit;
    end ;

    status := CreateStatusWindow(StatusWindowText);

		sSQL := 'select ds7i,count(feeder_repair_codes.id) as javszam ';
    sSQL := sSQL + 'from repair,feeder_repair_codes where ';
    sSQL := sSQL + '(repair.r_date >= "' + sTol + '" and repair.r_date <= "' + sIg + '") and repair.r_del = 0';
    sSQL := sSQL + ' and r_type = '+ IntToStr(iFeederType) +' and feeder_repair_codes.r_id = repair.id ';
    sSQL := sSQL + ' and feeder_repair_codes.r_code_id = ' + IntToStr(iRepairId);
    sSQL := sSQL + ' group by ds7i order by javszam desc;';

    Sqlite3Dataset1.FileName := dbPath;
    Sqlite3Dataset1.TableName := 'repair';
		Sqlite3Dataset1.SQL := sSQL;
    Sqlite3Dataset1.Active := true;
    if (Sqlite3Dataset1.RecordCount = 0) then
    begin
      RemoveStatusWindow(status);
    	ShowMessage(cmbAdagoloHibak.Text + ' nem volt az adott id??szakban.');
			Sqlite3Dataset1.Active := false;
      exit;
    end ;

    Memo1.Clear;
	  //Copy Fieldnames First
    Memo1.Lines.Add('Jav??t??sok : ' + cmbAdagoloHibak.Text + Delim + Delim + 'Id??szak : ' + sTol + ' --> ' + sIg);
    Memo1.Lines.Add('Feeder t??pus: ' + cmbFeederType.Text);
	  Memo1.Lines.Add('DS7i' + Delim + 'Jav??t??sok sz??ma');
    Sqlite3Dataset1.First;
    iOsszJavitas:=0;
	  repeat
		  with Sqlite3Dataset1 do
			  begin
      	  S := '';
          S := FieldByName('ds7i').AsString +	Delim + FieldByName('javszam').AsString;
          iOsszJavitas:=iOsszJavitas+FieldByName('javszam').AsInteger;
				  Memo1.Lines.Add(S);
        end;
      Sqlite3Dataset1.Next;
    until Sqlite3Dataset1.EOF;
    Memo1.Lines.Add(' ');
    Memo1.Lines.Add('Jav??t??sok ??sszes??t??se : ' + Delim + IntToStr(iOsszJavitas) + Delim + ' darab');

    Sqlite3Dataset1.Active := false;

    Memo1.SelectAll;
	  Memo1.CopyToClipboard;
	  RemoveStatusWindow(status);

    ReportPasteToExcel();

end;

procedure TfrmReports.btnJavitokMunkaiClick(Sender: TObject) ;
var
		sSQL,sTol,sIg,S:	string;
    iUserId:		integer;
    status: TStatusWindowHandle;

begin
    //A bel??pett felhaszn??l?? ??ltal jav??tott feederek az adott id??szakban :
    iUserId := Integer(cmbFeederJavitok.Items.Objects[cmbFeederJavitok.ItemIndex]);
		sTol := trim(edtJavitokMunkaiTol.Text);
    sIg := trim(edtJavitokMunkaiIg.Text);
    if (sTol = '') or (sIg = '') then
    begin
    	ShowMessage('A mez??k kit??lt??se k??telez??!' + chr(13) + 'D??tumforma : ????????-HH-NN (pl.: 2005-04-21)');
        exit;
    end ;
    status := CreateStatusWindow(StatusWindowText);

    if (chkNapiOsszesitett.Checked) then
    	begin
      	//Naponta h??ny darabot jav??tottak meg az adott id??szakban...
      	sSQL := 'select r_date,u_name,count(r_date) as darab from repair,users ';
        sSQL := sSQL + 'where r_del = 0 and r_end = 1 and ';
        sSQL := sSQL + 'users.id = u_id and u_id = '+ IntToStr(iUserId) +' and ';
        sSQL := sSQL + '(r_date >= "' + sTol + '" and r_date <= "' + sIg + '") ';
        //sSQL := sSQL + ' and r_type = '+ IntToStr(iFeederType);
        sSQL := sSQL + ' group by r_date order by r_date;';

        Sqlite3Dataset1.FileName := dbPath;
        Sqlite3Dataset1.TableName := 'repair';
		    Sqlite3Dataset1.SQL := sSQL;
        Sqlite3Dataset1.Active := true;
        if (Sqlite3Dataset1.RecordCount = 0) then
        begin
    		    ShowMessage('Az adott id??szakban nem volt javitott adagol??.');
				    Sqlite3Dataset1.Active := false;
            exit;
        end ;

				Memo1.Clear;
	      //Copy Fieldnames First
        Memo1.Lines.Add(cmbFeederJavitok.Text + ' feederjav??t?? munk??i');
	      S := 'D??tum' + Delim + 'Darabsz??m';
        Memo1.Lines.Add(S);
	      repeat
		      with Sqlite3Dataset1 do
			      begin
      	      S := '';
              S := FieldByName('r_date').AsString + Delim + FieldByName('darab').AsString;
				      Memo1.Lines.Add(S);
            end;
          Sqlite3Dataset1.Next;
        until Sqlite3Dataset1.EOF;
        Sqlite3Dataset1.Active := false;

        Memo1.SelectAll;
	      Memo1.CopyToClipboard;

    	end
		else
    	begin
        sSQL := 'SELECT r_date,ds7i,r_comment,u_name, feeder_types.ft_type as T??pus FROM repair,users,feeder_types ';
        sSQL := sSQL + 'WHERE r_del = 0 AND r_end = 1 AND ';
        sSQL := sSQL + 'users.id = u_id and u_id = '+ IntToStr(iUserId) +' AND feeder_types.id = r_type AND ';
        sSQL := sSQL + '(r_date >= "' + sTol + '" and r_date <= "' + sIg + '") ';
        //sSQL := sSQL + ' and r_type = '+ IntToStr(iFeederType);
        sSQL := sSQL + ' ORDER BY r_date;';
        try
		        Sqlite3Dataset1.FileName := dbPath;
            Sqlite3Dataset1.TableName := 'repair';
		        Sqlite3Dataset1.SQL := sSQL;
            Sqlite3Dataset1.Active := true;
            if (Sqlite3Dataset1.RecordCount = 0) then
            begin
                RemoveStatusWindow(status);
    		        ShowMessage('Az adott id??szakban nem volt javitott adagol??.');
				        Sqlite3Dataset1.Active := false;
                exit;
            end ;

				    Memo1.Clear;
	          //Copy Fieldnames First
            Memo1.Lines.Add(cmbFeederJavitok.Text + ' feederjav??t?? munk??i');
	          S := 'D??tum' + Delim + 'DS7i' + Delim + 'Megjegyz??s' + Delim + 'T??pus';
            Memo1.Lines.Add(S);
	          repeat
		          with Sqlite3Dataset1 do
			          begin
      	          S := '';
                  S := FieldByName('r_date').AsString + Delim + FieldByName('ds7i').AsString +
          	        Delim + FieldByName('r_comment').AsString + Delim + FieldByName('T??pus').AsString;
				          Memo1.Lines.Add(S);
                end;
              Sqlite3Dataset1.Next;
            until Sqlite3Dataset1.EOF;

            Memo1.SelectAll;
	          Memo1.CopyToClipboard;

            Sqlite3Dataset1.Active := false;

        except
            RemoveStatusWindow(status);
    		    ShowMessage('Hiba t??rt??nt a riport k??sz??t??se k??zben!' + chr(13) + 'K??rem ellen??rizze a d??tum megad??sokat!' +
            chr(13) + chr(13) + 'A helyes d??tumform??tum : ????????-HH-NN (pl.: 2005-04-21)');
            exit;
        end ;
      end;
      RemoveStatusWindow(status);

      ReportPasteToExcel();
end;

procedure TfrmReports.btnKimennyitJavitottClick(Sender: TObject) ;
var
		sSQL,sTol,sIg,S:	string;
    iUserId:		integer;
    status: TStatusWindowHandle;

begin
    //Mennyi nap alatt, mennyi adagolot javitottak :
		sTol := trim(edtKiMennyitTol.Text);
    sIg := trim(edtKiMennyitIg.Text);
    if (sTol = '') or (sIg = '') then
    begin
    		ShowMessage('A mez??k kit??lt??se k??telez??!' + chr(13) + 'D??tumforma : ????????-HH-NN (pl.: 2005-04-21)');
        exit;
    end ;

    sSQL := 'SELECT users.u_name as N??v,count(repair.id) as Darab,count(distinct repair.r_date) as Napok_sz??ma ';
    sSQL := sSQL + 'FROM repair,users ';
    sSQL := sSQL + 'WHERE repair.u_id = users.id and ';
    sSQL := sSQL + '(repair.r_date >= "' + sTol + '" and repair.r_date <= "' + sIg + '") ';
    sSQL := sSQL + ' GROUP BY users.u_name order by users.u_name;';

    status := CreateStatusWindow(StatusWindowText);
    myDataset := dbConnect('repair', sSQL, 'id');
    RemoveStatusWindow(status);

    if (myDataset.RecordCount > 0) then
        ReportToExcel('Ki mennyi feedert jav??tott', myDataset)
    else
        ShowMessage(RiportNoData);

    dbClose(myDataset);
end;

procedure TfrmReports.btnFeedercserekSoronkentClick(Sender : TObject);
var
    MyWorkbook: TsWorkbook;
  	MyWorksheet: TsWorksheet;
    MyDir: string;


begin
		//feedercser??k soronk??nt riport k??sz??t??se :
		iChartType := 1;
    sGlobalTol := trim(edtChartTol.Text);
    sGlobalIg := trim(edtChartIg.Text);
    if (sGlobalTol = '') or (sGlobalIg = '') then
    begin
    		ShowMessage('A mez??k kit??lt??se k??telez??!' + chr(13) + 'D??tumforma : ????????-HH-NN (pl.: 2005-04-21)');
        exit;
    end ;
    frmReports.Hide;
    frmChart1.Show;
    {
      //??sszes??tett riport k??sz??t??se ??s ki??r??sa excelbe...
	    MyDir := ExtractFilePath(ParamStr(0));

      // Create the spreadsheet
      MyWorkbook := TsWorkbook.Create;
      MyWorksheet := MyWorkbook.AddWorksheet('2012_szep');

      // Write some number cells
      MyWorksheet.WriteUTF8Text(0,0,'Melyik soron ??s mikor lett kirakva');
      MyWorksheet.WriteUTF8Text(1,0,'Operator');
      MyWorksheet.WriteUTF8Text(1,1,'sor');
      MyWorksheet.WriteUTF8Text(1,2,'ds7i');
      MyWorksheet.WriteUTF8Text(1,3,'datum');


      // Save the spreadsheet to a file
      MyWorkbook.WriteToFile(MyDir + '2012_jun_jul_aug' + STR_EXCEL_EXTENSION, sfExcel8, true);
      MyWorkbook.Free;
    }
end;

procedure TfrmReports.btnMagazinFullRiportClick(Sender: TObject);
type
    rFAdatok = record
      sDS7i							:string;		//Feeder DS7i sz??ma
      sDate							:string;		//Jav??t??s d??tuma
      sUname		        :string;		//Jav??t?? neve
      sWorks		        :string;		//Elv??gzett munk??k
      sRepairs					:string;		//Elv??gzett jav??t??sok
      sParts		        :string;		//Felhaszn??lt alkatr??szek
      sComment					:string;		//Megjegyz??sek.....
      sCost							:string;		//Jav??t??si kltsg-ek
    end ;

var
       sTol,sIg,sSQL	      :string;
       sDS7i,sData         :string;
       aFeederAdatok				:array of rFAdatok;
       i,j,iRows,iActualRow,iTworkID,iPartsNum,iWorksNum,iFad,iErrNum		:integer;
       myDataset2,worksDataset,partsDataset,repairDataset        :TSqlite3Dataset;
       rPartsCost,rtCost		:double;
       iArraySize					:integer;
       x: Integer;
   		 sRiportTartalom: AnsiString;
   		 sRiportFejlec,sWDNum: String;
       status: TStatusWindowHandle;

begin
  //Magazin full riport...

    sTol := trim(edtMagazinTol.Text);
    sIg := trim(edtMagazinIg.Text);
    if (sTol = '') or (sIg = '') then
      begin
      		ShowMessage('A mez??k kit??lt??se k??telez??!' + chr(13) + 'D??tumforma : ????????-HH-NN (pl.: 2005-04-21)');
          exit;
      end ;

    status := CreateStatusWindow(StatusWindowText);

    myDataset := dbConnect('magazin_works','SELECT * FROM magazin_works;','id');
    worksDataset := dbConnect('magazin_repair_works','select * from magazin_repair_works','id');
    partsDataset := dbConnect('used_magazin_parts','select * from used_magazin_parts','id');

    //??sszes jav??t??s az adott id??szakban - feederjav??t?? nevekkel :
    sSQL := 'select magazin_repair.id as rep_id,magazin_repair.m_ds7i,magazin_repair.m_date,magazin_repair.m_comment,';
		sSQL := sSQL + 'users.id,users.u_name from magazin_repair, users ';
    sSQL := sSQL + 'where m_end = 1 and m_del = 0 ';
    sSQL := sSQL + 'and (magazin_repair.m_date >= "' + sTol + '" and magazin_repair.m_date <= "' + sIg + '") ';
		sSQL := sSQL + 'and users.id = magazin_repair.u_id ';
    sSQL := sSQL + 'order by magazin_repair.id;';

    repairDataset := dbConnect('magazin_repair',sSQL,'id');

    if (repairDataset.RecordCount < 1) then
      begin
        dbClose(partsDataset);
        dbClose(worksDataset);
        dbClose(myDataset);
        dbClose(repairDataset);
        RemoveStatusWindow(status);
      	ShowMessage('Az adott id??szakban nem t??rt??nt magazin jav??t??s!');
        exit;
      end;

    //t??mb m??ret??nek be??ll??t??sa :
    SetLength(aFeederAdatok,repairDataset.RecordCount);
    iActualRow := 0;
    repeat
      	//A listaban levo ds7i-azonositokon v??gig kell menni...
      	DS7i := repairDataset.FieldByName('m_ds7i').AsString;


        //Feeder adatok oszegyujtese :

        //Aktu??lis munkalap db-id -je :
        iTworkID := repairDataset.FieldByName('rep_id').AsInteger;
        //DS7i,jav??t??,d??tum,megjegyz??s kit??lt??se :
        aFeederAdatok[iActualRow].sDS7i := DS7i;
        aFeederAdatok[iActualRow].sUname := repairDataset.FieldByName('u_name').AsString;
        aFeederAdatok[iActualRow].sComment := repairDataset.FieldByName('m_comment').AsString;
        aFeederAdatok[iActualRow].sDate := repairDataset.FieldByName('m_date').AsString;

        //magazinhoz tartoz?? elv??gzett munk??k :
        dbUpdate(worksDataset,'select magazin_works.mw_desc from magazin_repair_works,magazin_works where magazin_repair_works.m_id = '
          + IntToStr(iTworkID) + ' and magazin_repair_works.m_r_code_id = magazin_works.id');
        sData := '';
        iWorksNum := worksDataset.RecordCount;
        for i := 1 to iWorksNum do
        begin
            aFeederAdatok[iActualRow].sWorks :=
              aFeederAdatok[iActualRow].sWorks + worksDataset.FieldByName('mw_desc').AsString;
            if (i < iWorksNum) then
              aFeederAdatok[iActualRow].sWorks := aFeederAdatok[iActualRow].sWorks + ',';
            worksDataset.Next;
        end;

        //feederbe ??p??tett alkatr??szek :
        rPartsCost := 0;
        dbUpdate(partsDataset,'select parts.p_name,parts.p_cost from used_magazin_parts,parts where used_magazin_parts.m_r_id = ' +
          IntToStr(iTworkID) + ' and used_magazin_parts.m_p_id = parts.id;');
        sData := '';
        rPartsCost := 0;
        iPartsNum := partsDataset.RecordCount;
        for i := 1 to iPartsNum do
          begin
               aFeederAdatok[iActualRow].sParts :=
               aFeederAdatok[iActualRow].sParts + partsDataset.FieldByName('p_name').AsString;
               try
                  rtCost := partsDataset.FieldByName('p_cost').AsFloat;
               except
                     rtCost := 0;
               end;
               rPartsCost := rPartsCost + rtCost;
               if (i < iPartsNum) then
  		        	aFeederAdatok[iActualRow].sParts := aFeederAdatok[iActualRow].sParts + ',';
               partsDataset.Next;
          end;

        if (rPartsCost <= 0) then aFeederAdatok[iActualRow].sCost := '0.0';
        if (rPartsCost > 0) then aFeederAdatok[iActualRow].sCost := FloatToStr(rPartsCost);

        iActualRow := iActualRow + 1;
        repairDataset.Next;

      Until repairDataset.Eof;

      dbClose(partsDataset);
      dbClose(worksDataset);
      dbClose(myDataset);
      dbClose(repairDataset);

      //riport a memo-ba!
      iFad := Length(aFeederAdatok);

      Memo1.Clear;
      Memo1.Lines.Add('Magazinjav??t??sok full riport');
      {Riport form??tum :
          sDS7i							:string;		//Feeder DS7i sz??ma
          sDate							:string;		//Jav??t??s d??tuma
          sUname		        :string;		//Jav??t?? neve
          sWorks		        :string;		//Elv??gzett munk??k
          sParts		        :string;		//Felhaszn??lt alkatr??szek
          sComment					:string;		//Megjegyz??sek.....
          sCost							:string;		//Jav??t??si kltsg-ek
      }
    	sRiportFejlec := 'S.Sz.' + Delim + 'DS7i' + Delim + 'Jav??t??s d??tuma' + Delim + 'Feederjav??t??' + Delim
        + 'Elv??gzett munk??k' + Delim + 'Alkatr??sz(ek)' + Delim + 'Megjegyz??sek' + Delim
        + 'K??lts??g (EUR)';

    	Memo1.Lines.Add(sRiportFejlec);

      for i := 0 to iFad-1 do
        begin
          sRiportTartalom := '';
          sRiportTartalom := IntToStr(i+1)
              + Delim + aFeederAdatok[i].sDS7i
              + Delim + aFeederAdatok[i].sDate
              + Delim + aFeederAdatok[i].sUname
              + Delim + aFeederAdatok[i].sWorks
              + Delim + aFeederAdatok[i].sParts
              + Delim + aFeederAdatok[i].sComment
              + Delim + aFeederAdatok[i].sCost;
          Memo1.Lines.Add(sRiportTartalom);
        end;

      Memo1.SelectAll;
      Memo1.CopyToClipboard;
      RemoveStatusWindow(status);
      ReportPasteToExcel();
end;

procedure TfrmReports.btnOperatorokMunkaiRiportClick(Sender: TObject);
//TPM Oper??torok munk??i az adott id??szakban...
  var
    sSQL,sTol,sIg,S:	string;
    status: TStatusWindowHandle;

  begin
    sTol := trim(edtTPMOperatorokTol.Text);
    sIg := trim(edtTPMOperatorokIg.Text);

    if (sTol = '') or (sIg = '') then
    begin
        ShowMessage('A mez??k kit??lt??se k??telez??!' + chr(13) + 'D??tumforma : ????????-HH-NN (pl.: 2005-04-21)');
        exit;
    end ;

    status := CreateStatusWindow(StatusWindowText);

    sSQL := 'SELECT feeder_tpm.tpm_date AS "Prevent??v v. Jav??t??s", feeder_tpm.tpm_outdate AS "Ellen??rz??s ideje", ';
    sSQL := sSQL + 'feeder_tpm.tpm_ds7i as "DS7i", users.u_name AS "Oper??tor", feeder_types.ft_type AS "T??pus", ';
    sSQL := sSQL + 'feeder_size.size AS "M??ret",';
    sSQL := sSQL + 'CASE feeder_tpm.tpm_hibakod WHEN -1 THEN "OK" ELSE ';
    sSQL := sSQL + '(SELECT e_desc FROM error_codes WHERE error_codes.id = feeder_tpm.tpm_hibakod) END as "Feeder ??llapota"';
    sSQL := sSQL + 'FROM feeder_tpm JOIN users ON feeder_tpm.u_id = users.id JOIN feeder_types ON feeder_tpm.tpm_type = feeder_types.id ';
    sSQL := sSQL + 'JOIN feeder_size ON feeder_tpm.tpm_size = feeder_size.id ';
    sSQL := sSQL + 'WHERE tpm_outdate >= "' + sTol + '" AND tpm_outdate <= "' + sIg + '" AND feeder_tpm.u_id <> -1;';

    try
       Sqlite3Dataset1.FileName := dbPath;
       Sqlite3Dataset1.TableName := 'feeder_tpm';
       Sqlite3Dataset1.SQL := sSQL;
       Sqlite3Dataset1.Active := true;

       if (Sqlite3Dataset1.RecordCount = 0) then
       begin
            RemoveStatusWindow(status);
            ShowMessage('Az adott id??szakr??l nincsenek adatok!');
    	  		Sqlite3Dataset1.Active := false;
            exit;
       end ;

       	Memo1.Clear;
  	    //Copy Fieldnames First
        Memo1.Lines.Add('TPM Oper??torok munk??i az adott id??szakban...');

  			S := 'Ellen??rz??s ideje' + Delim + 'DS7i' + Delim + 'Oper??tor' + Delim + 'T??pus' + Delim + 'M??ret';
  			Memo1.Lines.Add(S);
  			repeat
  		    with Sqlite3Dataset1 do
  			    begin
        	    S := '';
              S := FieldByName('Ellen??rz??s ideje').AsString +
            	  Delim + FieldByName('ds7i').AsString + Delim + FieldByName('Oper??tor').AsString +
                Delim + FieldByName('T??pus').AsString + Delim + FieldByName('M??ret').AsString;
  				    Memo1.Lines.Add(S);
            end;
          Sqlite3Dataset1.Next;
        until Sqlite3Dataset1.EOF;

        Memo1.SelectAll;
  	    Memo1.CopyToClipboard;
        Sqlite3Dataset1.Active := false;
        RemoveStatusWindow(status);
        ReportPasteToExcel();
    except
        RemoveStatusWindow(status);
        ShowMessage('Hiba t??rt??nt a riport k??sz??t??se k??zben!' + chr(13) + 'K??rem ellen??rizze a d??tum megad??sokat!' +
        chr(13) + chr(13) + 'A helyes d??tumform??tum : ????????-HH-NN (pl.: 2005-04-21)');
        Sqlite3Dataset1.Active := false;
        exit;
    end ;
end;

procedure TfrmReports.btnPreventivesekMunkaiRiportClick(Sender: TObject);
//TPM feeder prevent??vesek munk??i az adott id??szakban...
var
   sSQL,sTol,sIg,S:	string;
   status: TStatusWindowHandle;
begin

      sTol := trim(edtPreventivesekTol.Text);
      sIg := trim(edtPreventivesekIg.Text);

      if (sTol = '') or (sIg = '') then
      begin
          ShowMessage('A mez??k kit??lt??se k??telez??!' + chr(13) + 'D??tumforma : ????????-HH-NN (pl.: 2005-04-21)');
          exit;
      end ;

      status := CreateStatusWindow(StatusWindowText);

      sSQL := 'SELECT feeder_tpm.tpm_date AS "Prevent??v v. Jav??t??s", feeder_tpm.tpm_outdate AS "Prevent??v ideje", ';
      sSQL := sSQL + 'feeder_tpm.tpm_ds7i as "DS7i", users.u_name AS "Preventives", feeder_types.ft_type AS "T??pus", ';
      sSQL := sSQL + 'feeder_size.size AS "M??ret" ';
      sSQL := sSQL + 'FROM feeder_tpm ';
      sSQL := sSQL + 'JOIN users ON feeder_tpm.prev_u_id = users.id ';
      sSQL := sSQL + 'JOIN feeder_types ON feeder_tpm.tpm_type = feeder_types.id ';
      sSQL := sSQL + 'JOIN feeder_size ON feeder_tpm.tpm_size = feeder_size.id ';
      sSQL := sSQL + 'WHERE (tpm_outdate >= "' + sTol + '" AND tpm_outdate <= "' + sIg + '") ';
      sSQL := sSQL + 'AND tpm_preventive = 1 AND tpm_lezarva = 1;';

      try
         Sqlite3Dataset1.FileName := dbPath;
         Sqlite3Dataset1.TableName := 'feeder_tpm';
         Sqlite3Dataset1.SQL := sSQL;
         Sqlite3Dataset1.Active := true;

         if (Sqlite3Dataset1.RecordCount = 0) then
         begin
            RemoveStatusWindow(status);
              ShowMessage('Az adott id??szakr??l nincsenek adatok!');
    	        Sqlite3Dataset1.Active := false;
              exit;
         end ;

          Memo1.Clear;
  	      //Copy Fieldnames First
          Memo1.Lines.Add('TPM Prevent??v karbantart??k munk??i az adott id??szakban...');

  	      S := 'Prevent??v ideje' + Delim + 'DS7i' + Delim + 'Preventives' + Delim + 'T??pus' + Delim + 'M??ret';
  	      Memo1.Lines.Add(S);
  	      repeat
  		      with Sqlite3Dataset1 do
  			      begin
        	      S := '';
                S := FieldByName('Prevent??v ideje').AsString +
                  Delim + FieldByName('ds7i').AsString + Delim + FieldByName('Preventives').AsString +
                  Delim + FieldByName('T??pus').AsString + Delim + FieldByName('M??ret').AsString;
  				      Memo1.Lines.Add(S);
              end;
            Sqlite3Dataset1.Next;
          until Sqlite3Dataset1.EOF;

          Memo1.SelectAll;
  	      Memo1.CopyToClipboard;
          Sqlite3Dataset1.Active := false;
          RemoveStatusWindow(status);
          ReportPasteToExcel();

      except
          ShowMessage('Hiba t??rt??nt a riport k??sz??t??se k??zben!' + chr(13) + 'K??rem ellen??rizze a d??tum megad??sokat!' +
          chr(13) + chr(13) + 'A helyes d??tumform??tum : ????????-HH-NN (pl.: 2005-04-21)');
          Sqlite3Dataset1.Active := false;
          exit;
      end ;

end;

procedure TfrmReports.btnRiport_min_3_javitasClick(Sender : TObject);
//Azon feederek lek??rdez??se amelyek m??r min. 3x voltak jav??tva egy h??napon bel??l:
var
    S		:string;
    status: TStatusWindowHandle;

begin

    status := CreateStatusWindow(StatusWindowText);

		try
       Sqlite3Dataset1.FileName := dbPath;
       Sqlite3Dataset1.TableName := 'temp';
       Sqlite3Dataset1.SQL := 'Select * from temp where iInfo1 = 1;';
       Sqlite3Dataset1.Active := true;
       if (Sqlite3Dataset1.RecordCount = 0) then
       begin
            RemoveStatusWindow(status);
            ShowMessage('Nincs ellen??rz??sre v??r?? feeder.');
    	  		Sqlite3Dataset1.Active := false;
            exit;
       end ;

		    Memo1.Clear;
	      //Copy Fieldnames First
        Memo1.Lines.Add('Azok a feederek amelyek m??r min. 3x voltak jav??tva egy h??napon bel??l:');
        Memo1.Lines.Add(' ');
        S := 'DS7i' + Delim + 'Kirak??s d??tuma' + Delim + 'T??pus - M??ret';
		    Memo1.Lines.Add(S);
		    repeat
		      with Sqlite3Dataset1 do
			      begin
      	      S := '';
              S := FieldByName('sTemp1').AsString + Delim + FieldByName('sTemp2').AsString +
          	    Delim + FieldByName('sTemp3').AsString;
				      Memo1.Lines.Add(S);
            end;
          Sqlite3Dataset1.Next;
        until Sqlite3Dataset1.EOF;
        Memo1.SelectAll;
	      Memo1.CopyToClipboard;
	      Sqlite3Dataset1.Active := false;
        RemoveStatusWindow(status);
        ReportPasteToExcel();

		except
        RemoveStatusWindow(status);
        ShowMessage('Hiba t??rt??nt a riport k??sz??t??se k??zben!');
        exit;
    end ;

end;

procedure TfrmReports.btnSoronkentiKiesesClick(Sender: TObject) ;
//Riport a soronk??nt kiesett feederekr??l :
var
  sSQL,sTol,sIg,sRiportName,S:	string;
  iUserId,iRiportID:		integer;
  status: TStatusWindowHandle;

begin
  sTol := trim(edtSoronkentiTol.Text);
  sIg := trim(edtSoronkentiIg.Text);
  iRiportID := 0;
  if (sTol = '') or (sIg = '') then
  begin
      ShowMessage('A mez??k kit??lt??se k??telez??!' + chr(13) + 'D??tumforma : ????????-HH-NN (pl.: 2005-04-21)');
      exit;
  end ;

  if rdbOsszesitett.Checked then
  	begin
    	sSQL := 'SELECT r_date,ds7i,sorok.name AS lname FROM repair,sorok ';
  		sSQL := sSQL + 'WHERE (sorok.id = line) AND (r_date >= "' + sTol + '" AND r_date <= "' + sIg + '") ';
  		sSQL := sSQL + 'ORDER BY lname;';
      iRiportID := 1;
  	end;
  if rdbOsszesitettJavitasokkal.Checked then
    begin
      //RemoveStatusWindow(status);
      KiMikorMelyiket_Mitjavitott();
      exit;
    end;
  if rdbOsszesitettEgyszeru.Checked then
  	begin
      sSQL := 'SELECT sorok.name AS lname,count(ds7i) as darabszam FROM repair,sorok  ';
  		sSQL := sSQL + 'WHERE (sorok.id = line) AND (r_date >= "' + sTol + '" AND r_date <= "' + sIg + '") ';
  		sSQL := sSQL + 'GROUP BY sorok.name ORDER BY lname,darabszam desc;';
      //sRiportName:='soronkenti_kieses.lrf';
      iRiportID := 2;
  	end;

  status := CreateStatusWindow(StatusWindowText);

  try
     Sqlite3Dataset1.FileName := dbPath;
     Sqlite3Dataset1.TableName := 'repair';
     Sqlite3Dataset1.SQL := sSQL;
     Sqlite3Dataset1.Active := true;

     if (Sqlite3Dataset1.RecordCount = 0) then
     begin
          RemoveStatusWindow(status);
          ShowMessage('Az adott id??szakban nem volt javitott adagol??.');
  	  		Sqlite3Dataset1.Active := false;
          exit;
     end ;

     	Memo1.Clear;
	    //Copy Fieldnames First
      Memo1.Lines.Add('Soronk??nti kies??s');
      if (iRiportID = 1) then
      begin
				S := 'Sor' + Delim + 'D??tum' + Delim + 'DS7i';
				Memo1.Lines.Add(S);
				repeat
		    	with Sqlite3Dataset1 do
			      begin
      	      S := '';
              S := FieldByName('lname').AsString + Delim + FieldByName('r_date').AsString +
          	    Delim + FieldByName('ds7i').AsString;
				      Memo1.Lines.Add(S);
            end;
        	Sqlite3Dataset1.Next;
      	until Sqlite3Dataset1.EOF;
      end;

      if (iRiportID = 2) then
      begin
				S := 'Sor' + Delim + 'Kiesett darabsz??m';
				Memo1.Lines.Add(S);
				repeat
		    	with Sqlite3Dataset1 do
			      begin
      	      S := '';
              S := FieldByName('lname').AsString + Delim + FieldByName('darabszam').AsString;
				      Memo1.Lines.Add(S);
            end;
        	Sqlite3Dataset1.Next;
      	until Sqlite3Dataset1.EOF;
      end;

      Memo1.SelectAll;
	    Memo1.CopyToClipboard;

      Sqlite3Dataset1.Active := false;
      RemoveStatusWindow(status);
  except
      RemoveStatusWindow(status);
      ShowMessage('Hiba t??rt??nt a riport k??sz??t??se k??zben!' + chr(13) + 'K??rem ellen??rizze a d??tum megad??sokat!' +
      chr(13) + chr(13) + 'A helyes d??tumform??tum : ????????-HH-NN (pl.: 2005-04-21)');
      Sqlite3Dataset1.Active := false;
      exit;
  end ;

  ReportPasteToExcel();
end;

procedure TfrmReports.FormClose(Sender: TObject ; var CloseAction: TCloseAction) ;
begin
    frmReports.Hide;
    frmMainMenu.Show;
end;

procedure TfrmReports.FormShow(Sender: TObject) ;
var
	sDate,sData,sTol:	string;
begin
	//glob??lis v??ltoz??k :
    iFeederType := 0;
    bOsszesTipus := false;

    //Mez??k be??ll??t??sa :
    sDate := FormatDateTime('YYYY-MM-DD',Now); //'2010-04-25'
    sTol := FormatDateTime('YYYY-MM-',Now)+'01';
    edtIdoszakosAlkTol.Text := sTol;
    edtIdoszakosAlkIg.Text := sDate;
    edtIdoszakosHibakIg.Text := sDate;
    edtIdoszakosHibakTol.Text := sTol;
    edt24OranBelulIg.Text := sDate;
    edt24OranBelulTol.Text := sTol;
    edtJavitokMunkaiIg.Text := sDate;
    edtJavitokMunkaiTol.Text := sTol;
    edtKiMennyitIg.Text := sDate;
    edtKiMennyitTol.Text := sTol;
    edtTOPIg.Text := sDate;
    edtTOPTol.Text := sTol;
    edtAktualisSorIg.Text := sDate;
    edtAktualisSorTol.Text := sTol;
    edtSoronkentiIg.Text := sDate;
    edtSoronkentiTol.Text := sTol;
    edtDS7iIg.Text := sDate;
    edtDS7iTol.Text := sTol;
    edtDS7i.Text := '';
    edtChartIg.Text := sDate;
    edtChartTol.Text := sTol;
    edtTroliIg.Text := sDate;
    edtTroliTol.Text := sTol;
    edtEgyebMunkakIg.Text := sDate;
    edtEgyebMunkakTol.Text := sTol;
    edtMagazinIg.Text := sDate;
    edtMagazinTol.Text := sTol;
    edtTPMOperatorokIg.Text := sDate;
    edtTPMOperatorokTol.Text := sTol;
    edtPreventivesekIg.Text := sDate;
    edtPreventivesekTol.Text := sTol;
    edtDS7iOsszesitesTol.Text := sTol;
    edtDS7iOsszesitesIg.Text := sDate;
    lstDs7iAdagolok.Clear;
    cmbSorok.Clear;
    cmbAdagoloHibak.Clear;
    cmbFeederJavitok.Clear;

    //Adagol??hib??k combo felt??lt??se :
    myDataset := dbConnect('repair_codes','SELECT * FROM repair_codes;','id');
    if (myDataset.RecordCount > 0) then
    begin
        Repeat
        	sData := myDataset.FieldByName('r_desc').AsString;
            cmbAdagoloHibak.Items.AddObject(sData,TObject(myDataset.FieldByName('id').AsInteger));
            myDataset.Next;
        Until myDataset.Eof;
        myDataset.First;
        cmbAdagoloHibak.ItemIndex := 0;
		end;

		//Feederjav??t??k n??vsor??nak felt??lt??se :
    dbUpdate(myDataset,'SELECT * FROM users WHERE u_del=0 and u_perm = 0 order by u_name;');
    if (myDataset.RecordCount > 0) then
    begin
        Repeat
        	sData := myDataset.FieldByName('u_name').AsString;
            cmbFeederJavitok.Items.AddObject(sData,TObject(myDataset.FieldByName('id').AsInteger));
            myDataset.Next;
        Until myDataset.Eof;
        myDataset.First;
        cmbFeederJavitok.ItemIndex := 0;
		end;

    //Sorok kigy??jt??se :
    dbUpdate(myDataset,'SELECT * FROM sorok where torolve = 0 order by name;');
    if (myDataset.RecordCount > 0) then
    begin
        Repeat
            sData := myDataset.FieldByName('name').AsString;
            cmbSorok.Items.AddObject(sData,TObject(myDataset.FieldByName('id').AsInteger));
        	  myDataset.Next;
        Until myDataset.Eof;
        myDataset.First;
        cmbSorok.ItemIndex := 0;
		end;


    //kapcsolat megsz??ntet??se :
    dbClose(myDataset);

    sMess := 'A riport adatok m??solva lettek a v??g??lapra!' + #10 + 'Excel-be t??rt??n?? beilleszt??s ut??n lehet sz??rni tov??bb!';



end;


procedure TfrmReports.frReport1ExportFilterSetup(Sender: TfrExportFilter);
begin
    if Sender is TfrHTMExportFilter then
    begin
         TfrHTMExportFilter(Sender).UseCSS := false;
    end;
    if Sender is TfrCSVExportFilter then
    begin
         //TfrCSVExportFilter(Sender).;
         TfrCSVExportFilter(Sender).Separator := ',';
    end;

end;

procedure TfrmReports.frReport1GetValue(const ParName : String;
    var ParValue : Variant);
begin
	if (ParName = 'cNAME') then ParValue := userName;
  //Id??szakos alkatr??szfelhaszn??l??s :
    if (ParName = 'sIDOSZAKOSALKTITLE') then
    	ParValue := 'Felhaszn??lt ' + cmbFeederType.Text + ' adagol??alkatr??szek';
    if (ParName = 'sTOL') then ParValue := edtIdoszakosAlkTol.Text;
		if (ParName = 'sIG') then ParValue := edtIdoszakosAlkIg.Text;
  //TOP feederk??lts??gek :
    if (ParName = 'sTOPHIBAKTITLE') then ParValue := cmbFeederType.Text + ' adagol??jav??t??si k??lts??gek';
		if (ParName = 'sTOL_top') then ParValue := edtTOPTol.Text;
		if (ParName = 'sIG_top') then ParValue := edtTOPIg.Text;
		//if (ParName = 'sTOPDARAB') then ParValue := edtTOPFeeders.Text;
  //Id??szakos feederhib??k :
    if (ParName = 'sALTALANOSHIBAKTITLE') then
    	ParValue := '??ltal??nos ' + cmbFeederType.Text + ' adagol??hib??k';
		if (ParName = 'sALTALANOSHIBAKTOL') then ParValue := edtIdoszakosHibakTol.Text;
		if (ParName = 'sALTALANOSHIBAKIG') then ParValue := edtIdoszakosHibakIg.Text;
    if (ParName = 'sALTKIVHIBA') then ParValue := cmbAdagoloHibak.Text;
  //24 ??r??n bel??l visszavitt feederek :
    if (ParName = 'sVISSZA24TITLE') then
		ParValue := '24 ??r??n bel??l visszavitt ' + cmbFeederType.Text + ' adagol??k';
		if (ParName = 'sTOL24') then ParValue := edt24OranBelulTol.Text;
		if (ParName = 'sIG24') then ParValue := edt24OranBelulIg.Text;
  //Adott jav??t?? ??ltal jav??tott adagol??k,adott id??szakban :
    if (ParName = 'sJAVITOTTFEEDEREKTITLE') then
    	ParValue := 'Jav??tott ' + cmbFeederType.Text + ' adagol??k';
    if (ParName = 'sTOL2') then ParValue := edtJavitokMunkaiTol.Text;
		if (ParName = 'sIG2') then ParValue := edtJavitokMunkaiIg.Text;
	//Ki mennyi feedert jav??tott,adott id??szakban :
    if (ParName = 'sKIMENNYITTITLE') then
    	ParValue := 'Jav??tott adagol??k szem??lyenk??nt';
    if (ParName = 'sTOL3') then ParValue := edtKiMennyitTol.Text;
		if (ParName = 'sIG3') then ParValue := edtKiMennyitIg.Text;
  //Soronk??nti feederkies??s :
  	if (ParName = 'sTITLE_soronkent') then
    	ParValue := 'Soronk??nti adagol??kies??sek';
  	if (ParName = 'sTOL4') then ParValue := edtSoronkentiTol.Text;
		if (ParName = 'sIG4') then ParValue := edtSoronkentiIg.Text;
  //Kiv??lasztott sorr??l kiesett adagol??k :
  	if (ParName = 'sAKTUALISSORROLKIESETTTITLE') then
    	ParValue := 'Az aktu??lis sorr??l kiesett adagol??k';
    if (ParName = 'sKIVALASZTOTTSOR') then ParValue := cmbSorok.Text;
  	if (ParName = 'sKIVALASZTOTTSORTOL') then ParValue := edtAktualisSorTol.Text;
		if (ParName = 'sKIVALASZTOTTSORIG') then ParValue := edtAktualisSorIg.Text;

  //DS7i -szerinti inf??k :
		if (ParName = 'sDS7iFEEDEREKINFOTITLE') then
    	ParValue := 'R??szletes adagol?? inform??ci??k DS7i alapj??n';
		if (ParName = 'sTOL_DS7i') then ParValue := edtDS7iTol.Text;
		if (ParName = 'sIG_DS7i') then ParValue := edtDS7iIg.Text;

  //min_3_jav_egy_heten inf??k :
		if (ParName = 'sMIN_3_JAV_EGY_HETEN_TITLE') then
    	ParValue := 'Egy h??ten bel??l min. 3x jav??tott feeder(ek)';

end;

procedure TfrmReports.tshDS7iSzerintShow(Sender: TObject);
begin
  Label7.Caption:='Feeder t??pusa : ';
  gpbTipusBeallitas.Caption:='Feeder t??pus??nak be??ll??t??sa :';
end;

procedure TfrmReports.tshFeederEllenorzesShow(Sender: TObject);
begin
  Label7.Caption:='Feeder t??pusa : ';
  gpbTipusBeallitas.Caption:='Feeder t??pus??nak be??ll??t??sa :';
end;

procedure TfrmReports.tshRiport1Show(Sender: TObject);
begin
  Label7.Caption:='Feeder t??pusa : ';
  gpbTipusBeallitas.Caption:='Feeder t??pus??nak be??ll??t??sa :';
end;

procedure TfrmReports.tshTroliRiportokShow(Sender: TObject);
begin
  Label7.Caption:='Troli t??pusa : ';
  gpbTipusBeallitas.Caption:='Troli t??pus??nak be??ll??t??sa :';
end;

procedure TfrmReports.Trolijavitasok_full_riport();
  Const
    //Tab character
    Delim = CHR(9);

  type
    rFAdatok = record
      sDS7i							:string;		//Troli DS7i sz??ma
      sTroliNumber      :string;    //Troli sorsz??ma
      sDate							:string;		//Jav??t??s d??tuma
      sE_Date						:string;		//Kirak??s d??tuma (opi ekkor rakta ki)
      sUname		        :string;		//Jav??t?? neve
      sOname						:string;		//Oper??tor neve aki kirakta
      //sWorks		        :string;		//Elv??gzett munk??k (r??gi lek??rdez??sek miatt...)
      sRepairs					:string;		//Elv??gzett jav??t??sok
      sMachine					:string;		//Err??l a g??pr??l esett ki
      sPosition					:string;		//Err??l az oldalr??l esett ki
      sParts		        :string;		//Felhaszn??lt alkatr??szek
      sComment					:string;		//Megjegyz??sek.....
      sCost							:string;		//Jav??t??si kltsg
      sLine							:string;		//Err??l a sorr??l lett kirakva
      sType							:string;		//Asztal t??pusa (Troli t??pusa : 0=S,F ; 1=HS ; 2=X)
      sPreventiv				:string;		//Jav??t??s vagy prevent??v??
      wWeekNum					:word;			//Ezen a h??ten volt a jav??t??s v. prevent??v
    end ;


  var
        sTol,sIg			      :string;
        sSQL								:AnsiString;
        sDS7i,sData         :string;
        aFeederAdatok				:array of rFAdatok;
        i,j,iRows,iActualRow,iTworkID,iPartsNum,iWorksNum,iFad		:integer;
        //myDataset2,worksDataset,partsDataset,repairDataset        :TSqlite3Dataset;
				errorDataset,partsDataset,repairDataset,trolleyDataset        :TSqlite3Dataset;
        rPartsCost,rtCost		:double;
        iArraySize					:integer;
        x: Integer;
    		sRiportTartalom: String;
    		sRiportFejlec,sWDNum: String;
        iLine	:integer;			//err??l a sorr??l esett ki a feeder
        iMachine :integer;	//err??l a g??pr??l esett ki a feeder

        weekNum : word;
        status: TStatusWindowHandle;

  begin

      sTol := trim(edtTroliTol.Text);
      sIg := trim(edtTroliIg.Text);
      if (sTol = '') or (sIg = '') then
      begin
      		ShowMessage('A mez??k kit??lt??se k??telez??!' + chr(13) + 'D??tumforma : ????????-HH-NN (pl.: 2005-04-21)');
          exit;
      end ;

      status := CreateStatusWindow(StatusWindowText);

      myDataset := dbConnect('trolley_works','SELECT * FROM trolley_works;','id');
      //worksDataset := dbConnect('feeder_works','select * from feeder_works','id');
      repairDataset := dbConnect('trolley_r_c','select * from trolley_r_c','id');

      //??sszes jav??t??s az adott id??szakban - feederjav??t?? nevekkel :
      sSQL := 'select trolley_repair.id as rep_id,trolley_repair.tr_ds7i,trolley_repair.tr_number,trolley_repair.tr_date,' +
      			'trolley_repair.tr_comment,trolley_repair.tr_lineid,trolley_repair.tr_preventiv,trolley_repair.tr_type,';
			sSQL := sSQL + 'trolley_repair.tr_wd_num,trolley_repair.tr_op_name,trolley_repair.tr_machine,' +
      			'trolley_repair.tr_position,trolley_repair.tr_error_code,trolley_repair.tr_e_date';
      sSQL := sSQL + ',users.id,users.u_name from trolley_repair, users where tr_end = 1 and tr_del = 0 ';
      sSQL := sSQL + ' and (trolley_repair.tr_date >= "' + sTol + '" and trolley_repair.tr_date <= "' + sIg + '") ';
			sSQL := sSQL + ' and users.id = trolley_repair.u_id';
      sSQL := sSQL + ' order by trolley_repair.id;';
      trolleyDataset := dbConnect('trolley_repair',sSQL,'id');

      if (trolleyDataset.RecordCount < 1) then
      begin
        RemoveStatusWindow(status);
      	ShowMessage('Az adott id??szakban nem volt adagol??asztal jav??t??s!');
				dbClose(trolleyDataset);
        dbClose(repairDataset);
        exit;
      end;

      //t??mb m??ret??nek be??ll??t??sa :
      SetLength(aFeederAdatok,trolleyDataset.RecordCount);
      iActualRow := 0;
      repeat
      	//A listaban levo ds7i-azonositokon v??gig kell menni...
      	DS7i := trolleyDataset.FieldByName('tr_ds7i').AsString;

        //Troli adatok oszegyujtese :

        //Aktu??lis munkalap db-id -je :
        iTworkID := trolleyDataset.FieldByName('rep_id').AsInteger;
        //DS7i,jav??t??,d??tum,megjegyz??s kit??lt??se :
        aFeederAdatok[iActualRow].sDS7i := DS7i;
        aFeederAdatok[iActualRow].sTroliNumber := trolleyDataset.FieldByName('tr_number').AsString;
  			aFeederAdatok[iActualRow].sUname := trolleyDataset.FieldByName('u_name').AsString;
        aFeederAdatok[iActualRow].sComment := trolleyDataset.FieldByName('tr_comment').AsString;
        aFeederAdatok[iActualRow].sDate := trolleyDataset.FieldByName('tr_date').AsString;
        aFeederAdatok[iActualRow].sE_Date := trolleyDataset.FieldByName('tr_e_date').AsString;
				aFeederAdatok[iActualRow].sPosition := trolleyDataset.FieldByName('tr_position').AsString;
        //H??t be??ll??t??sa...
        aFeederAdatok[iActualRow].wWeekNum := GetWeekNumber(aFeederAdatok[iActualRow].sDate);

        if (trolleyDataset.FieldByName('tr_preventiv').AsInteger = 1) then
        	aFeederAdatok[iActualRow].sPreventiv := 'IGEN'
        else
           aFeederAdatok[iActualRow].sPreventiv := 'NEM';

        //Asztal t??pus??nak be??ll??t??sa :
        case trolleyDataset.FieldByName('tr_type').AsInteger of
        	0 : aFeederAdatok[iActualRow].sType := 'F/S';
          1 : aFeederAdatok[iActualRow].sType := 'HS';
          2 : aFeederAdatok[iActualRow].sType := 'X';
        end;

        //Oper??tor aki kirakta :
				sWDNum := trolleyDataset.FieldByName('tr_wd_num').AsString;

        //Ha nincs megadva az oper??tor neve akkor megpr??b??ljuk megkeresni a wd-alapj??n:
        if (Trim(trolleyDataset.FieldByName('tr_op_name').AsString) = '') then
          begin
            dbUpdate(myDataset,'select * from dolgozok where wd_azonosito = "' + Trim(sWDNum) + '";');
            if (myDataset.RecordCount < 1) then
        	    aFeederAdatok[iActualRow].sOname := 'N.A.'
            else
        	    aFeederAdatok[iActualRow].sOname := myDataset.FieldByName('name').AsString;
          end
        else
        	aFeederAdatok[iActualRow].sOname := trolleyDataset.FieldByName('tr_op_name').AsString;

        //err??l a sorr??l esett ki :
        iLine := trolleyDataset.FieldByName('tr_lineid').AsInteger;
				dbUpdate(myDataset,'select * from sorok where id = ' + IntToStr(iLine) + ';');
        if (myDataset.RecordCount < 1) then
        	aFeederAdatok[iActualRow].sLine := 'N.A.'
        else
        	aFeederAdatok[iActualRow].sLine := myDataset.FieldByName('name').AsString;

				//err??l a g??pr??l esett ki :
        iMachine := trolleyDataset.FieldByName('tr_machine').AsInteger;
				dbUpdate(myDataset,'select * from machines where id = ' + IntToStr(iMachine) + ';');
        if (myDataset.RecordCount < 1) then
        	aFeederAdatok[iActualRow].sMachine := 'N.A.'
        else
        	aFeederAdatok[iActualRow].sMachine := myDataset.FieldByName('m_name').AsString;

        //trolin elv??gzett jav??t??sok :
				dbUpdate(repairDataset,'select trolley_r_c.tr_r_desc from trolley_r_c,trolley_works where trolley_works.r_id = '
          + IntToStr(iTworkID) + ' and trolley_works.t_r_code_id = trolley_r_c.id');
        sData := '';
        iWorksNum := repairDataset.RecordCount;
        for i := 1 to iWorksNum do
        begin
            aFeederAdatok[iActualRow].sRepairs :=
              aFeederAdatok[iActualRow].sRepairs + repairDataset.FieldByName('tr_r_desc').AsString;
            if (i < iWorksNum) then
              aFeederAdatok[iActualRow].sRepairs := aFeederAdatok[iActualRow].sRepairs + ',';
            repairDataset.Next;
        end;

        //troliba ??p??tett alkatr??szek :
        rPartsCost := 0;
        partsDataset := dbConnect('parts','select parts.p_name,parts.p_cost from used_trolley_parts,parts ' +
        	'where used_trolley_parts.t_r_id = ' + IntToStr(iTworkID) + ' and used_trolley_parts.t_p_id = parts.id;','id');
        sData := '';
        rPartsCost := 0;
        iPartsNum := partsDataset.RecordCount;
        for i := 1 to iPartsNum do
          begin
               aFeederAdatok[iActualRow].sParts :=
               aFeederAdatok[iActualRow].sParts + partsDataset.FieldByName('p_name').AsString;
               try
                  rtCost := partsDataset.FieldByName('p_cost').AsFloat;
               except
                     rtCost := 0;
               end;
               rPartsCost := rPartsCost + rtCost;
               if (i < iPartsNum) then aFeederAdatok[iActualRow].sParts := aFeederAdatok[iActualRow].sParts + ',';
               partsDataset.Next;
          end;

        if (rPartsCost <= 0) then aFeederAdatok[iActualRow].sCost := '0.0';
        if (rPartsCost > 0) then aFeederAdatok[iActualRow].sCost := FloatToStr(rPartsCost);

  			iActualRow := iActualRow + 1;
        trolleyDataset.Next;

      Until trolleyDataset.Eof;


      dbClose(partsDataset);
      dbClose(trolleyDataset);
			repairDataset.Close;
      dbClose(myDataset);

      //riport a memo-ba!
      iFad := Length(aFeederAdatok);

      Memo1.Clear;
      Memo1.Lines.Add('Troli jav??t??sok, full riport');
      {Riport form??tum :

          sDS7i							:string;		//Feeder DS7i sz??ma
          sDate							:string;		//Jav??t??s d??tuma
          sE_Date						:string;		//Kirak??s d??tuma (opi ekko rakta ki)
          sUname		        :string;		//Jav??t?? neve
          sOname						:string;		//Oper??tor neve aki kirakta
          sWorks		        :string;		//Elv??gzett munk??k (r??gi lek??rdez??sek miatt...)
          sRepairs					:string;		//Elv??gzett jav??t??sok (Karcsi m??dos??t??sa miatt...)
          sMachine					:string;		//Err??l a g??pr??l esett ki
          sPosition					:string;		//Err??l a helyr??l (pl.: 3/19/2)
          sParts		        :string;		//Felhaszn??lt alkatr??szek
          sComment					:string;		//Megjegyz??sek.....
          sCost							:string;		//Jav??t??si kltsg-ek
          sLine							:string;		//Err??l a sorr??l lett kirakva
      }
    	sRiportFejlec := 'S.Sz.' + Delim + 'DS7i' + Delim + 'Sorsz??m' + Delim + 'T??pus' + Delim + 'Jav??t??s d??tuma' + Delim
      	+ 'Kirak??s d??tuma' + Delim + 'Feederjav??t??' + Delim + 'Oper??tor neve' + Delim + 'Elv??gzett jav??t??sok' + Delim
        + 'Alkatr??sz(ek)' + Delim + 'Megjegyz??sek (feederjav??t??kt??l)' + Delim
        + 'K??lts??g (EUR)' + Delim + 'Sor' + Delim + 'G??p' + Delim + 'Oldal' + Delim + 'Prevent??v?' + Delim + 'H??t';

    	Memo1.Lines.Add(sRiportFejlec);

      for i := 0 to iFad-1 do
        begin
          sRiportTartalom := '';
          sRiportTartalom := IntToStr(i+1)
              + Delim + aFeederAdatok[i].sDS7i
              + Delim + aFeederAdatok[i].sTroliNumber
              + Delim + aFeederAdatok[i].sType
              + Delim + aFeederAdatok[i].sDate
              + Delim + aFeederAdatok[i].sE_Date
              + Delim + aFeederAdatok[i].sUname
              + Delim + aFeederAdatok[i].sOname
              //+ Delim + aFeederAdatok[i].sWorks
              + Delim + aFeederAdatok[i].sRepairs
              + Delim + aFeederAdatok[i].sParts
              + Delim + aFeederAdatok[i].sComment
              + Delim + aFeederAdatok[i].sCost
              + Delim + aFeederAdatok[i].sLine
              + Delim + aFeederAdatok[i].sMachine
              + Delim + aFeederAdatok[i].sPosition
          		+ Delim + aFeederAdatok[i].sPreventiv
              + Delim + IntToStr(aFeederAdatok[i].wWeekNum);
          Memo1.Lines.Add(sRiportTartalom);
        end;

      Memo1.SelectAll;
      Memo1.CopyToClipboard;
      RemoveStatusWindow(status);
      ReportPasteToExcel();

end;

procedure TfrmReports.KiMikorMelyiket_Mitjavitott();

  type
    rFAdatok = record
      sDS7i							:string;		//Feeder DS7i sz??ma
      sType             :string;    //Feeder t??pusa (S,F stb.)
      sSize             :string;    //Feeder m??rete (2x8, 3x8 stb.)
      sDate							:string;		//Jav??t??s d??tuma
      sE_Date						:string;		//Kirak??s d??tuma (opi ekko rakta ki)
      sUname		        :string;		//Jav??t?? neve
      sOname						:string;		//Oper??tor neve aki kirakta
      sWorks		        :string;		//Elv??gzett munk??k (r??gi lek??rdez??sek miatt...)
      sRepairs					:string;		//Elv??gzett jav??t??sok (Karcsi m??dos??t??sa miatt...)
      sMachine					:string;		//Err??l a g??pr??l esett ki
      sError						:string;		//Ezzel a hib??val rakta ki az oper??tor
      sPosition					:string;		//Err??l a helyr??l (pl.: 3/19/2)
      sParts		        :string;		//Felhaszn??lt alkatr??szek
      sComment					:string;		//Megjegyz??sek.....
      sCost							:string;		//Jav??t??si kltsg-ek
      sLine							:string;		//Err??l a sorr??l lett kirakva
    end ;


  var
        sTol,sIg,sSQL	      :string;
        sDS7i,sData         :string;
        aFeederAdatok				:array of rFAdatok;
        i,j,iRows,iActualRow,iTworkID,iPartsNum,iWorksNum,iFad,iErrNum		:integer;
        myDataset2,worksDataset,partsDataset,repairDataset        :TSqlite3Dataset;
        rPartsCost,rtCost		:double;
        iArraySize					:integer;
        x: Integer;
    		sRiportTartalom: String;
    		sRiportFejlec,sWDNum: String;
        iLine	:integer;			//err??l a sorr??l esett ki a feeder
        iMachine :integer;	//err??l a g??pr??l esett ki a feeder
        XLApp,munkalap       :OLEVariant;
        aName                :Variant;
        status: TStatusWindowHandle;



  begin
      sTol := trim(edtSoronkentiTol.Text);
      sIg := trim(edtSoronkentiIg.Text);
      if (sTol = '') or (sIg = '') then
      begin
      		ShowMessage('A mez??k kit??lt??se k??telez??!' + chr(13) + 'D??tumforma : ????????-HH-NN (pl.: 2005-04-21)');
          exit;
      end ;

      status := CreateStatusWindow(StatusWindowText);

      myDataset := dbConnect('works','SELECT * FROM works WHERE w_del=0;','id');
      worksDataset := dbConnect('feeder_works','select * from feeder_works','id');
      partsDataset := dbConnect('feeder_errors','select * from feeder_errors','id');
      //??sszes jav??t??s az adott id??szakban - feederjav??t?? nevekkel :
      sSQL := 'select repair.id as rep_id,repair.ds7i,repair.r_date,repair.r_comment,repair.line,';
			sSQL := sSQL + 'repair.wd_num,repair.op_name,repair.machine,repair.position,repair.error_code,repair.e_date';
      sSQL := sSQL + ',feeder_size.size as feeder_size ,feeder_types.ft_type as feeder_type';
      sSQL := sSQL + ',users.id,users.u_name from repair, users, feeder_size, feeder_types ';
      sSQL := sSQL + 'where r_end = 1 and r_del = 0 ';
      sSQL := sSQL + ' and (repair.r_date >= "' + sTol + '" and repair.r_date <= "' + sIg + '") ';
			sSQL := sSQL + ' and r_type = ' + IntToStr(iFeederType) + ' and users.id = repair.u_id';
      sSQL := sSQL + ' and feeder_size.id = repair.size and feeder_types.id = repair.r_type';
      sSQL := sSQL + ' order by repair.id;';

      //ShowMessage(sSQL);
      repairDataset := dbConnect('repair',sSQL,'id');

      if (repairDataset.RecordCount < 1) then
      begin
        RemoveStatusWindow(status);
      	ShowMessage('Az adott id??szakban nem volt kirakott adagol??!');
				dbClose(partsDataset);
      	dbClose(worksDataset);
      	dbClose(myDataset);
      	dbClose(repairDataset);
        exit;
      end;

      Memo1.Clear;
      Memo1.Lines.Add('??sszes jav??t??s az adott id??szakban (' + sTol + ' - ' + sIg + ')');

      //t??mb m??ret??nek be??ll??t??sa :
      SetLength(aFeederAdatok,repairDataset.RecordCount);
      iActualRow := 0;
      repeat
      	//A listaban levo ds7i-azonositokon v??gig kell menni...
      	DS7i := repairDataset.FieldByName('ds7i').AsString;


        //Feeder adatok oszegyujtese :

        //Aktu??lis munkalap db-id -je :
        iTworkID := repairDataset.FieldByName('rep_id').AsInteger;
        //DS7i,jav??t??,d??tum,megjegyz??s kit??lt??se :
        aFeederAdatok[iActualRow].sDS7i := DS7i;
        aFeederAdatok[iActualRow].sType := repairDataset.FieldByName('feeder_type').AsString;
        aFeederAdatok[iActualRow].sSize := repairDataset.FieldByName('feeder_size').AsString;
  			aFeederAdatok[iActualRow].sUname := repairDataset.FieldByName('u_name').AsString;
        aFeederAdatok[iActualRow].sComment := repairDataset.FieldByName('r_comment').AsString;
        aFeederAdatok[iActualRow].sDate := repairDataset.FieldByName('r_date').AsString;
        aFeederAdatok[iActualRow].sE_Date := repairDataset.FieldByName('e_date').AsString;
				aFeederAdatok[iActualRow].sPosition := repairDataset.FieldByName('position').AsString;

        //Oper??tor aki kirakta :
				sWDNum := repairDataset.FieldByName('wd_num').AsString;
        dbUpdate(myDataset,'select * from dolgozok where wd_azonosito = "' +
        	sWDNum + '";');
        if (myDataset.RecordCount < 1) then
        	aFeederAdatok[iActualRow].sOname := 'N.A.'
        else
        	aFeederAdatok[iActualRow].sOname := myDataset.FieldByName('name').AsString;

        //err??l a sorr??l esett ki :
        iLine := repairDataset.FieldByName('line').AsInteger;
				dbUpdate(myDataset,'select * from sorok where id = ' + IntToStr(iLine) + ';');
        if (myDataset.RecordCount < 1) then
        	aFeederAdatok[iActualRow].sLine := 'N.A.'
        else
        	aFeederAdatok[iActualRow].sLine := myDataset.FieldByName('name').AsString;

        //ezzel a hib??val lett kirakva :
        iErrNum := repairDataset.FieldByName('error_code').AsInteger;
				dbUpdate(myDataset,'select * from error_codes where id = ' + IntToStr(iErrNum) + ';');
        if (myDataset.RecordCount < 1) then
        	aFeederAdatok[iActualRow].sError := 'N.A.'
        else
        	aFeederAdatok[iActualRow].sError := myDataset.FieldByName('e_desc').AsString;

				//err??l a g??pr??l esett ki :
        iMachine := repairDataset.FieldByName('machine').AsInteger;
				dbUpdate(myDataset,'select * from machines where id = ' + IntToStr(iMachine) + ';');
        if (myDataset.RecordCount < 1) then
        	aFeederAdatok[iActualRow].sMachine := 'N.A.'
        else
        	aFeederAdatok[iActualRow].sMachine := myDataset.FieldByName('m_name').AsString;

        //feederhez tartoz?? elv??gzett munk??k :
        dbUpdate(worksDataset,'select works.w_desc from feeder_works,works where feeder_works.r_id = '
          + IntToStr(iTworkID) + ' and feeder_works.w_id = works.id');
        sData := '';
        iWorksNum := worksDataset.RecordCount;
        for i := 1 to iWorksNum do
        begin
            aFeederAdatok[iActualRow].sWorks :=
              aFeederAdatok[iActualRow].sWorks + worksDataset.FieldByName('w_desc').AsString;
            if (i < iWorksNum) then
              aFeederAdatok[iActualRow].sWorks := aFeederAdatok[iActualRow].sWorks + ',';
            worksDataset.Next;
        end;

        //feederen elv??gzett jav??t??sok (Karcsi f??le m??dos??t??s....)
				dbUpdate(worksDataset,'select repair_codes.r_desc from repair_codes,feeder_repair_codes where feeder_repair_codes.r_id = '
          + IntToStr(iTworkID) + ' and feeder_repair_codes.r_code_id = repair_codes.id');
        sData := '';
        iWorksNum := worksDataset.RecordCount;
        for i := 1 to iWorksNum do
        begin
            aFeederAdatok[iActualRow].sRepairs :=
              aFeederAdatok[iActualRow].sRepairs + worksDataset.FieldByName('r_desc').AsString;
            if (i < iWorksNum) then
              aFeederAdatok[iActualRow].sRepairs := aFeederAdatok[iActualRow].sRepairs + ',';
            worksDataset.Next;
        end;

        //feederbe ??p??tett alkatr??szek :
        rPartsCost := 0;
        dbUpdate(partsDataset,'select parts.p_name,parts.p_cost from usedparts,parts where usedparts.r_id = ' +
          IntToStr(iTworkID) + ' and usedparts.p_id = parts.id;');
        sData := '';
        rPartsCost := 0;
        iPartsNum := partsDataset.RecordCount;
        for i := 1 to iPartsNum do
          begin
               aFeederAdatok[iActualRow].sParts :=
               aFeederAdatok[iActualRow].sParts + partsDataset.FieldByName('p_name').AsString;
               try
                  rtCost := partsDataset.FieldByName('p_cost').AsFloat;
               except
                     rtCost := 0;
               end;
               rPartsCost := rPartsCost + rtCost;
               if (i < iPartsNum) then
  		        	aFeederAdatok[iActualRow].sParts := aFeederAdatok[iActualRow].sParts + ',';
               partsDataset.Next;
          end;

        if (rPartsCost <= 0) then aFeederAdatok[iActualRow].sCost := '0.0';
        if (rPartsCost > 0) then aFeederAdatok[iActualRow].sCost := FloatToStr(rPartsCost);

  			iActualRow := iActualRow + 1;
        //ShowMessage(IntToStr(iActualRow));
        repairDataset.Next;

      Until repairDataset.Eof;


      dbClose(partsDataset);
      dbClose(worksDataset);
      dbClose(myDataset);
      dbClose(repairDataset);

      //riport a memo-ba!
      iFad := Length(aFeederAdatok);

      {Riport form??tum :
          sDS7i							:string;		//Feeder DS7i sz??ma
          sDate							:string;		//Jav??t??s d??tuma
          sE_Date						:string;		//Kirak??s d??tuma (opi ekko rakta ki)
          sUname		        :string;		//Jav??t?? neve
          sOname						:string;		//Oper??tor neve aki kirakta
          sWorks		        :string;		//Elv??gzett munk??k (r??gi lek??rdez??sek miatt...)
          sRepairs					:string;		//Elv??gzett jav??t??sok (Karcsi m??dos??t??sa miatt...)
          sMachine					:string;		//Err??l a g??pr??l esett ki
          sError						:string;		//Ezzel a hib??val rakta ki az oper??tor
          sPosition					:string;		//Err??l a helyr??l (pl.: 3/19/2)
          sParts		        :string;		//Felhaszn??lt alkatr??szek
          sComment					:string;		//Megjegyz??sek.....
          sCost							:string;		//Jav??t??si kltsg-ek
          sLine							:string;		//Err??l a sorr??l lett kirakva
      }
    	sRiportFejlec := 'S.Sz.' + Delim + 'DS7i' + Delim + 'Jav??t??s d??tuma' + Delim + 'Kirak??s d??tuma' + Delim
      	+ 'Feederjav??t??' + Delim + 'Oper??tor neve' + Delim + 'Elv??gzett munk??k (r??gi)' + Delim
        + 'Elv??gzett jav??t??sok (??j)' + Delim
        + 'Alkatr??sz(ek)' + Delim + 'Megjegyz??sek (feederjav??t??kt??l)' + Delim
        + 'K??lts??g (EUR)' + Delim + 'Feeder csere oka' + Delim + 'Sor' + Delim
        + 'G??p' + Delim + 'Poz??ci??' + Delim + 'M??ret' + Delim + 'T??pus';

    	Memo1.Lines.Add(sRiportFejlec);

      for i := 0 to iFad-1 do
        begin
          sRiportTartalom := '';
          sRiportTartalom := IntToStr(i+1)
              + Delim + aFeederAdatok[i].sDS7i
              + Delim + aFeederAdatok[i].sDate
              + Delim + aFeederAdatok[i].sE_Date
              + Delim + aFeederAdatok[i].sUname
              + Delim + aFeederAdatok[i].sOname
              + Delim + aFeederAdatok[i].sWorks
              + Delim + aFeederAdatok[i].sRepairs
              + Delim + aFeederAdatok[i].sParts
              + Delim + aFeederAdatok[i].sComment
              + Delim + aFeederAdatok[i].sCost
              + Delim + aFeederAdatok[i].sError
              + Delim + aFeederAdatok[i].sLine
              + Delim + aFeederAdatok[i].sMachine
              + Delim + aFeederAdatok[i].sPosition
              + Delim + aFeederAdatok[i].sSize
              + Delim + aFeederAdatok[i].sType;
          Memo1.Lines.Add(sRiportTartalom);
          //ShowMessage(sRiportTartalom);
        end;

      Memo1.SelectAll;
      Memo1.CopyToClipboard;
      RemoveStatusWindow(status);

      XLApp := CreateOleObject('Excel.Application');
      try
       XLApp.Visible := true;
       XLApp.DisplayAlerts := true;

       XLApp.Workbooks.Add;
       munkalap := XLApp.Workbooks[1].WorkSheets[1];
       aName := 'Riport';
       munkalap.Name := aName;

       munkalap.Paste;

       //oszlopok sz??less??g??nek be??ll??t??sa:
       munkalap.Range['A1:Z1'].EntireColumn.AutoFit;

     finally
       //XLApp.Quit;
       //XLAPP := Unassigned;
	    end;


end;

procedure TfrmReports.ReportToExcel(ExcelLapCim: string; dsRiport: TSqlite3Dataset);
//??tvett dataset ki??r??sa excel-be:
var
   XLApp,munkalap       :OLEVariant;
   aData,aName          :Variant;
   i,x,y                :integer;

begin
     XLApp := CreateOleObject('Excel.Application');
  try
       XLApp.Visible := true;
       XLApp.DisplayAlerts := true;

       XLApp.Workbooks.Add;
       munkalap := XLApp.Workbooks[1].WorkSheets[1];
       aName := ExcelLapCim;
       munkalap.Name := aName;
       //sleep(1500);

       //fejl??c ki??r??sa:
       for i := 0 to dsRiport.FieldCount - 1 do
       begin
            aData := dsRiport.Fields[i].FieldName;
            munkalap.Cells[1,i+1].Value := aData;
       end;
       //adatok...
       y := 0;
       repeat
         for x := 0 to dsRiport.FieldCount - 1 do
         begin
              aData := dsRiport.Fields[x].AsString;
              munkalap.Cells[y+2, x+1].Value := aData;
         end;
         y += 1;
         dsRiport.Next;
       until dsRiport.EOF;
       //oszlopok sz??less??g??nek be??ll??t??sa:
       munkalap.Range['A1:Z1'].EntireColumn.AutoFit;

     finally
       //XLApp.Quit;
       //XLAPP := Unassigned;
	    end;
end;

procedure TfrmReports.ReportPasteToExcel();
//V??g??lapon l??v?? adatok (riport a Memo1-b??l) beilleszt??se az excelbe....
var
    XLApp,munkalap       :OLEVariant;
    aName                 :Variant;
begin
  XLApp := CreateOleObject('Excel.Application');
      try
       XLApp.Visible := true;
       XLApp.DisplayAlerts := true;

       XLApp.Workbooks.Add;
       munkalap := XLApp.Workbooks[1].WorkSheets[1];
       aName := 'Riport';
       munkalap.Name := aName;

       munkalap.Paste;

       //oszlopok sz??less??g??nek be??ll??t??sa:
       munkalap.Range['A1:Z1'].EntireColumn.AutoFit;

     finally
       //XLApp.Quit;
       //XLAPP := Unassigned;
	    end;
end;

initialization
  {$I reports.lrs}

end.

