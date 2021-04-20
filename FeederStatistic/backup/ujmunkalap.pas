unit ujmunkalap;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  StdCtrls, global, sqlite3ds, ActnList, database, ExtCtrls,
  DbCtrls, ComCtrls, SynHighlighterHTML, IpHtml, crt;


type



  { TfrmUjMunkalap }

  TfrmUjMunkalap = class(TForm)

    btnAdagolohibaFelvetel: TButton ;
    btnJavitasiKodHozzaadasa : TButton;
    btnJavitasiKodTorlesAListabol1 : TButton;
    btnKilepLezarasNelkul: TButton ;
    btnWorksFelvetel: TButton ;
    btnAdagolohibaTorlesAListabol: TButton ;
    btnWorksTorlesAListabol: TButton ;
    btnAlkatreszFelvetel: TButton ;
    btnAlkatreszTorlesAListabol: TButton ;
    btnMunkalapLezarasa: TButton ;
    cmbJavitasiKodok : TComboBox;
    cmbAlkatreszek: TComboBox ;
    cmbWorks: TComboBox ;
    cmbAdagoloHibak: TComboBox ;
    edtDS7i: TEdit ;
    edtFeederType: TEdit ;
    edtFeederSize: TEdit ;
    edtKarbantarto: TEdit ;
    edtLepeszam1: TEdit;
    edtLepeszam2: TEdit;
    edtLepeszam3: TEdit;
    edtLepeszam4: TEdit;
    edtLepeszam5: TEdit;
    edtLepeszam6: TEdit;
    GroupBox1: TGroupBox ;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    IpHtmlPanel1: TIpHtmlPanel;
    Label1: TLabel ;
    Label2: TLabel ;
    Label3: TLabel ;
    Label4: TLabel ;
    lblLepes1: TLabel;
    lblLepes2: TLabel;
    lblLepes3: TLabel;
    lblLepes4: TLabel;
    lblLepes5: TLabel;
    lblLepes6: TLabel;
    lstAdagolohibak: TListBox ;
    lstJavitasiKodok : TListBox;
    lstWorks: TListBox ;
    lstFelvettAlkatreszek: TListBox ;
    memMegjegyzesek: TMemo ;
    Shape3: TShape ;
    Shape4: TShape ;
    tabMainSheet: TPageControl ;
    Shape1: TShape ;
    Shape2: TShape ;
    tabRepairCodes : TTabSheet;
    tabLepesSzam: TTabSheet;
    tabWorks: TTabSheet ;
    tabErrors: TTabSheet ;
    tabUsedParts: TTabSheet ;
    tabComment: TTabSheet ;
    procedure btnJavitasiKodHozzaadasaClick(Sender : TObject);
    procedure btnAdagolohibaFelvetelClick(Sender: TObject) ;
    procedure btnAdagolohibaTorlesAListabolClick(Sender: TObject) ;
    procedure btnAlkatreszFelvetelClick(Sender: TObject);
    procedure btnAlkatreszTorlesAListabolClick(Sender: TObject);
    procedure btnJavitasiKodTorlesAListabol1Click(Sender : TObject);
    procedure btnKilepLezarasNelkulClick(Sender: TObject) ;
    procedure btnMunkalapLezarasaClick(Sender: TObject);
    procedure btnWorksFelvetelClick(Sender: TObject) ;
    procedure btnWorksTorlesAListabolClick(Sender: TObject) ;
    procedure cmbAdagoloHibakKeyPress(Sender: TObject ; var Key: char) ;
    procedure cmbAlkatreszekKeyPress(Sender: TObject ; var Key: char) ;
    procedure cmbWorksKeyPress(Sender: TObject ; var Key: char) ;
    procedure FormCloseQuery(Sender: TObject ; var CanClose: boolean) ;
    procedure FormShow(Sender: TObject) ;

  private
    { private declarations }

    //feeder_tortenet array of array of tFeeders;
    myDataset:             	TSqlite3Dataset;

  public
    { public declarations }
  end;

var
  frmUjMunkalap: TfrmUjMunkalap;

implementation

{ TfrmUjMunkalap }
uses fomenu;


procedure TfrmUjMunkalap.FormCloseQuery(Sender: TObject ; var CanClose: boolean
  ) ;
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

procedure TfrmUjMunkalap.btnMunkalapLezarasaClick(Sender: TObject);
var
	sDate,sInfo:	string;
    iRepairID:		Integer;	//munkalap adatbázis ID !
    i:						Integer;	//ciklusokhoz
    iTempID,iRet:	Integer;
    iLepes1,iLepes2,iLepes3,iOldLepes1,iOldLepes2,iOldLepes3: Integer; //feeder lépészámok

begin
	//Feedertípus szerinti adatellenörzés :
  if (iFeederType < 3) or (iFeederType = 5) then
    begin
  		//Siemens - Fuji feederek....
        //Javítási kód ellenörzése:
	      if (lstJavitasiKodok.Count = 0) then
          begin
    	      ShowMessage('Az javítási kódok közül legalább egyet fel kell venni a listába !');
            exit;
          end;
    end
	else
    begin
			//rli,seq,vcd adagolók....
        //Felvitt munka ellenörzése :
	      if (lstWorks.Count = 0) then
          begin
    	      ShowMessage('Az elvégzett munkák közül legalább egyet fel kell venni a listába !');
            exit;
          end;
        //Adagolóhibák ellenörzése....
        if (lstAdagolohibak.Count = 0) then
          begin
            ShowMessage('Az adagolóhibák közül legalább egyet fel kell venni a listába !');
            exit;
          end;
    end;

  iLepes1 := 0;
  iLepes2 := 0;
  iLepes3 := 0;
  if(trim(edtLepeszam4.Text) <> '') then iOldLepes1 := StrToInt(edtLepeszam4.Text) else iOldLepes1 := 0;
  if(trim(edtLepeszam5.Text) <> '') then iOldLepes2 := StrToInt(edtLepeszam5.Text) else iOldLepes2 := 0;
  if(trim(edtLepeszam6.Text) <> '') then iOldLepes3 := StrToInt(edtLepeszam6.Text) else iOldLepes3 := 0;

  case iFeederSize Of
    1,9 : begin
          //2x8mm (S,X tipusok)
          {
          if(trim(edtLepeszam1.Text) = '') or (trim(edtLepeszam2.Text) = '') then
            begin
              ShowMessage('Lépészám mezők kitöltése kötelező!');
              exit;
            end;
          }
          if(trim(edtLepeszam1.Text) <> '') then iLepes1 := StrToInt(trim(edtLepeszam1.Text));
          if(trim(edtLepeszam2.Text) <> '') then iLepes2 := StrToInt(trim(edtLepeszam2.Text));
          {
          if (iOldLepes1 > iLepes1) or (iOldLepes2 > iLepes2) then
            begin
              ShowMessage('Az előző lépészám nem lehet több mint a jelenlegi lépészám!');
              exit;
            end;
          }
        end;
    2 : begin
          //3x8mm
          {
          if(trim(edtLepeszam1.Text) = '') or (trim(edtLepeszam2.Text) = '') or (trim(edtLepeszam3.Text) = '') then
            begin
              ShowMessage('Lépészám mezők kitöltése kötelező!');
              exit;
            end;
          }
          if(trim(edtLepeszam1.Text) <> '') then iLepes1 := StrToInt(trim(edtLepeszam1.Text));
          if(trim(edtLepeszam2.Text) <> '') then iLepes2 := StrToInt(trim(edtLepeszam2.Text));
          if(trim(edtLepeszam3.Text) <> '') then iLepes3 := StrToInt(trim(edtLepeszam3.Text));
          {
          if (iOldLepes1 > iLepes1) or (iOldLepes2 > iLepes2) or (iOldLepes3 > iLepes3) then
            begin
              ShowMessage('Az előző lépészám nem lehet több mint a jelenlegi lépészám!');
              exit;
            end;
          }
        end;
    3..7,10,12..21 : begin
          {
          if(trim(edtLepeszam1.Text) = '') then
            begin
              ShowMessage('Lépészám mező kitöltése kötelező!');
              exit;
            end;
          }
          if(trim(edtLepeszam1.Text) <> '') then iLepes1 := StrToInt(trim(edtLepeszam1.Text));
          {
          if (iOldLepes1 > iLepes1) then
            begin
              ShowMessage('Az előző lépészám nem lehet több mint a jelenlegi lépészám!');
              exit;
            end;
          }
        end;
  end; {end of case}

	//Biztos hogy az adatok rendben vannak ?
    sInfo := 'Figyelem !' + chr(13) + chr(13) +
    		'A munkalap lezárása után már nincs lehetőség a munkalap adatainak módosítására !' + chr(13) +
           	'Biztos hogy lezárja a munkalapot ?';
    iRet := MessageDlg('Munkalap lezárás megerősítés...',sInfo,mtInformation,mbYesNo,0);
    if (iRet <> mrYes) then exit;

    sDate := FormatDateTime('YYYY-MM-DD',Now); //'2010-04-25';

    //Ha volt nyitott munkalap a feeder_tpm táblában akkor azt is le kell zárni:
    myDataset := dbConnect('feeder_tpm','SELECT * FROM feeder_tpm WHERE tpm_ds7i="' + DS7i + '" and tpm_javitasra = 1 and tpm_lezarva = 0','id');
    if (myDataset.RecordCount > 0) then
      begin
         myDataset.Edit;
         myDataset.FieldByName('tpm_date').AsString := sDate;
         myDataset.FieldByName('tpm_lezarva').AsInteger := 1;
         myDataset.Post;
         myDataset.ApplyUpdates;
         //dbUpdate(myDataset,'Select * from feeder_tpm Order By id;');
      end;
    dbClose(myDataset);

    //Munkalap létrehozása,lezárása,adatok rögzítése :
    myDataset := dbConnect('repair','SELECT * FROM repair','id');
    //if (iFeederType < 3) then iTempID := Integer(lstJavitasiKodok.Items.Objects[0]);
    with myDataset do
        begin
            Insert;
            FieldByName('u_id').AsInteger := userDB_ID;
            FieldByName('r_date').AsString := sDate;
            FieldByName('r_comment').AsString := memMegjegyzesek.Text;
            FieldByName('r_end').AsInteger := 1;
            FieldByName('r_del').AsInteger := 0;
            FieldByName('r_type').AsInteger := iFeederType;
            FieldByName('ds7i').AsString := DS7i;
            FieldByName('size').AsInteger := iFeederSize;
            FieldByName('line').AsInteger := iLineID;
            FieldByName('wd_num').AsString := sOperatorWDNum;
            FieldByName('op_name').AsString := sOperatorName;
            FieldByName('machine').AsInteger := iMachineID;
            FieldByName('position').AsString := sFeederPosition;
            FieldByName('error_code').AsInteger := iErrorCode;
            //FieldByName('repair_code').AsInteger := ;	//így nem ok, mert több javítási kódot is fel lehet vinni egy feederhez...
            FieldByName('e_date').AsString := sKirakasDatuma;
            FieldByName('lepesszam1').AsInteger := iLepes1;
            FieldByName('lepesszam2').AsInteger := iLepes2;
            FieldByName('lepesszam3').AsInteger := iLepes3;
            Post;
            ApplyUpdates;
            dbClose(myDataset);
        end;
    //Kell az új munkalap azonosítója :
    myDataset := dbConnect('repair','SELECT * FROM repair WHERE ds7i = "' + DS7i + '" AND u_id = ' + IntToStr(userDB_ID),'id;');
		myDataset.Last;
    iRepairID := myDataset.FieldByName('id').AsInteger;
		dbClose(myDataset);

    //Javítási kódok felvitele ha siemens-fuji-HD adagolókról van szó :
    if (iFeederType < 3) or (iFeederType = 5) then
      begin
        myDataset := dbConnect('feeder_repair_codes','SELECT * FROM feeder_repair_codes ORDER BY id;','id');
        for i := 0 to lstJavitasiKodok.Items.Count - 1 do
        begin
            iTempID := Integer(lstJavitasiKodok.Items.Objects[i]);
            with myDataset do
            begin
                Insert;
                FieldByName('r_code_id').AsInteger := iTempID;
                FieldByName('r_id').AsInteger := iRepairID;
                Post;
                ApplyUpdates;
            end;
        end;
		    dbClose(myDataset);
      end;


    //Feederhibák bejegyzése :
    myDataset := dbConnect('feeder_errors','SELECT * FROM feeder_errors ORDER BY id;','id');
    for i := 0 to lstAdagolohibak.Items.Count - 1 do
    begin
        iTempID := Integer(lstAdagolohibak.Items.Objects[i]);
        with myDataset do
        begin
            Insert;
            FieldByName('e_id').AsInteger := iTempID;
            FieldByName('r_id').AsInteger := iRepairID;
            Post;
            ApplyUpdates;
        end;
    end;
		dbClose(myDataset);

    //Felhasznált alkatrészek bejegyzése :
    myDataset := dbConnect('usedparts','SELECT * FROM usedparts ORDER BY id;','id');
    for i := 0 to lstFelvettAlkatreszek.Items.Count - 1 do
    begin
        iTempID := Integer(lstFelvettAlkatreszek.Items.Objects[i]);
        with myDataset do
        begin
            Insert;
            FieldByName('p_id').AsInteger := iTempID;
            FieldByName('r_id').AsInteger := iRepairID;
            Post;
            ApplyUpdates;
            //ShowMessage(inttostr(iTempID));
        end;
    end;
    dbClose(myDataset);

    //Elvégzett javítások bejegyzése :
    myDataset := dbConnect('feeder_works','SELECT * FROM feeder_works ORDER BY id;','id');
    for i := 0 to lstWorks.Items.Count - 1 do
    begin
        iTempID := Integer(lstWorks.Items.Objects[i]);
        with myDataset do
        begin
            Insert;
            FieldByName('w_id').AsInteger := iTempID;
            FieldByName('r_id').AsInteger := iRepairID;
            Post;
            ApplyUpdates;
        end;
    end;

    //feeder_tpm -táblában ha van nyitott javításra indított munkalap akkor azt is le kell zárni!!
    dbUpdate(myDataset,'select * from feeder_tpm where tpm_ds7i = "' + DS7i + '" and tpm_javitasra = 1 and tpm_lezarva = 0;');
    if (myDataset.RecordCount > 0) then
      begin
        myDataset.Edit;
        myDataset.FieldByName('tpm_date').AsString := sDate;
        myDataset.FieldByName('tpm_lezarva').AsInteger := 1;
        myDataset.Post;
        myDataset.ApplyUpdates;
        dbUpdate(myDataset,'Select * from feeder_tpm Order By id;');
      end;

    myDataset.Close;
    //myDataset.Free;
    //Az újonan nyitott munkalap lezárva :
    ShowMessage('A munkalap sikeresen lezárásra került !');
    frmUjMunkalap.Hide;
    frmMainMenu.Show;
end;

procedure TfrmUjMunkalap.btnWorksTorlesAListabolClick(Sender: TObject) ;
begin
	//Kiválasztott munka törlése a listából :
    if (lstWorks.ItemIndex < 0) then exit;
    lstWorks.Items.Delete(lstWorks.ItemIndex);
    lstWorks.Refresh;
end;

procedure TfrmUjMunkalap.cmbAdagoloHibakKeyPress(Sender: TObject ; var Key: char
    ) ;
begin
	if (Key = chr(13)) then btnAdagolohibaFelvetelClick(Sender);
end;

procedure TfrmUjMunkalap.cmbAlkatreszekKeyPress(Sender: TObject ; var Key: char
    ) ;
begin
	if (Key = chr(13)) then btnAlkatreszFelvetelClick(Sender);
end;

procedure TfrmUjMunkalap.cmbWorksKeyPress(Sender: TObject ; var Key: char) ;
begin
	if (Key = chr(13)) then btnWorksFelvetelClick(Sender);
end;

procedure TfrmUjMunkalap.btnWorksFelvetelClick(Sender: TObject) ;
var
	iWorkID,i,iTempID:	integer;
begin
	//Elvégzett munka felvétele a listába (lstWorks)
    //Az elvégzett munkából csak egyet szabad felvinni !
		iWorkID:=integer(cmbWorks.Items.Objects[cmbWorks.ItemIndex]);
		for i := 0 to lstWorks.Items.Count -1 do
    begin
        iTempID := integer(lstWorks.Items.Objects[i]);
        if (iWorkID = iTempID) then
          begin
            ShowMessage('A következő munka már szerepel a listában :' + #10 + #10 +
            	cmbWorks.Text);
            exit;
          end;
    end;
    lstWorks.Items.AddObject(cmbWorks.Text,TObject(iWorkID));
    lstWorks.Refresh;
end;

procedure TfrmUjMunkalap.btnAlkatreszFelvetelClick(Sender: TObject);
var
	iPartID:	integer;
begin
	//Alkatrész felvétele a listába (lstFelvettAlkatreszek)
    //Ha egy alk.-ből többet is felhasznált,akkor azt többször kell felvinni a listába !
    iPartID:=integer(cmbAlkatreszek.Items.Objects[cmbAlkatreszek.ItemIndex]);
    lstFelvettAlkatreszek.Items.AddObject(cmbAlkatreszek.Text,TObject(iPartID));
    lstFelvettAlkatreszek.Refresh;
    //ShowMessage(inttostr(iPartID));
end;

procedure TfrmUjMunkalap.btnAdagolohibaFelvetelClick(Sender: TObject) ;
var
	iPartID:	integer;
begin
	//Adagolóhiba felvétele a listába (lstAdagolohibak)
    //Ha egy hibából több is előfordult,akkor azt többször kell felvinni a listába !
    iPartID:=integer(cmbAdagoloHibak.Items.Objects[cmbAdagoloHibak.ItemIndex]);
    lstAdagolohibak.Items.AddObject(cmbAdagoloHibak.Text,TObject(iPartID));
    lstAdagolohibak.Refresh;
end;

procedure TfrmUjMunkalap.btnJavitasiKodHozzaadasaClick(Sender : TObject);
var
  iRepairCode,i,iTempID:	integer;
begin
  //Javítási kód felvétele a listába (lstJavitasiKodok)
  //Egy kódot csak egyszer szabad felvinni!
    iRepairCode:=integer(cmbJavitasiKodok.Items.Objects[cmbJavitasiKodok.ItemIndex]);
    for i := 0 to lstJavitasiKodok.Items.Count -1 do
    begin
        iTempID := integer(lstJavitasiKodok.Items.Objects[i]);
        if (iRepairCode = iTempID) then
          begin
            ShowMessage('A következő javítási kód már szerepel a listában :' + #10 + #10 +
            	cmbJavitasiKodok.Text);
            exit;
          end;
    end;
    lstJavitasiKodok.Items.AddObject(cmbJavitasiKodok.Text,TObject(iRepairCode));
    lstJavitasiKodok.Refresh;
end;

procedure TfrmUjMunkalap.btnAdagolohibaTorlesAListabolClick(Sender: TObject) ;
begin
	//Kiválasztott adagolóhiba törlése a listából :
    if (lstAdagolohibak.ItemIndex < 0) then exit;
    lstAdagolohibak.Items.Delete(lstAdagolohibak.ItemIndex);
    lstAdagolohibak.Refresh;
end;

procedure TfrmUjMunkalap.btnAlkatreszTorlesAListabolClick(Sender: TObject);
begin
	//Kiválasztott alkatrész törlése a listából :
    if (lstFelvettAlkatreszek.ItemIndex < 0) then exit;
    lstFelvettAlkatreszek.Items.Delete(lstFelvettAlkatreszek.ItemIndex);
    lstFelvettAlkatreszek.Refresh;
end;

procedure TfrmUjMunkalap.btnJavitasiKodTorlesAListabol1Click(Sender : TObject);
begin
  //Kiválasztott javítási kód törlése a listából :
    if (lstJavitasiKodok.ItemIndex < 0) then exit;
    lstJavitasiKodok.Items.Delete(lstJavitasiKodok.ItemIndex);
    lstJavitasiKodok.Refresh;
end;

procedure TfrmUjMunkalap.btnKilepLezarasNelkulClick(Sender: TObject) ;
begin
    //Kilépés munkalap lezárása nélkül :
    frmUjMunkalap.Close;
end;

procedure TfrmUjMunkalap.FormShow(Sender: TObject) ;
type
  rFAdatok = record
    sDS7i			:string;
    sUname		:string;
    sWorks		:array of string;
    sParts		:array of string;
    sCost			:string;
    sComment	:string;
    sDate     :string;
  end ;

var
		sSQL,sDate,sData,sMelok:															string;
    worksDataset,partsDataset,userDataset,RepairCodesDataset:			TSqlite3Dataset;
    iRows,i,j,k,iActualRow,iMaxHeight,it,iTworkID, iLepes1,iLepes2,iLepes3:	integer;
    rPartsCost,rtCost:																	double;

    aFeederAdatok 							:array of rFAdatok;
    iFad,iPartsNum,iWorksNum		:integer;
    sFeederInfos								:string;

     sl : TStringList;
		ms : TMemoryStream;
		html: TIpHtml;



begin
    {
    	Ha siemens adagolókat kell javítani akkor el kell rejteni az "Elvégzett munkák" és az
      "Adagolóhibák" füleket, és meg kell jeleníteni a "Javítási kódok" fület.
    }
    if (iFeederType = 0) or (iFeederType = 1) or (iFeederType = 5) then
      begin
        tabWorks.TabVisible := false;
        tabErrors.TabVisible := false;
        tabRepairCodes.TabVisible := true;
        tabMainSheet.ActivePage := tabLepesSzam;
      end
    else
			begin
        tabWorks.TabVisible := true;
        tabErrors.TabVisible := true;
        tabRepairCodes.TabVisible := false;
        tabLepesSzam.TabVisible := false;
        tabMainSheet.ActivePage := tabWorks;
      end;
    tabMainSheet.Refresh;

	//adatok a db-ből :
    //myDataset := dbConnect('repair','SELECT * FROM repair where ds7i = "' + DS7i + '" and r_del = 0 order by id;','id');
    //workID := myDataset.FieldByName('id').AsInteger;
    myDataset := dbConnect('works','SELECT * FROM works WHERE w_del=0;','id');
    worksDataset := dbConnect('feeder_works','select * from feeder_works','id');
    partsDataset := dbConnect('feeder_errors','select * from feeder_errors','id');
    RepairCodesDataset := dbConnect('repair_codes','select * from repair_codes order by id','id');

   	//Közös mezők beállítása :
		frmUjMunkalap.Caption := 'FeederStatistic - Új munkalap létrehozása';
    edtDS7i.Text := DS7i;
    edtKarbantarto.Text := userName;
    edtFeederSize.Text := sFeederSize;
    lstWorks.Clear;
    lstWorks.Sorted := false;	//Azért kell letiltani mert ha több egyformát kiválaszt,akkor bekattan...
    lstFelvettAlkatreszek.Clear;
    lstFelvettAlkatreszek.Sorted := false;
    lstAdagolohibak.Clear;
    lstAdagolohibak.Sorted := false;
    lstJavitasiKodok.Clear;
    lstJavitasiKodok.Sorted := false;
    edtLepeszam1.Text := '';
    edtLepeszam2.Text := '';
    edtLepeszam3.Text := '';
    edtLepeszam4.Text := '';
    edtLepeszam5.Text := '';
    edtLepeszam6.Text := '';
    edtLepeszam1.Enabled := false;
    edtLepeszam2.Enabled := false;
    edtLepeszam3.Enabled := false;
    edtLepeszam4.Enabled := false;
    edtLepeszam5.Enabled := false;
    edtLepeszam6.Enabled := false;

    iPartsNum := 0;
    iWorksNum := 0;

		//Ha a típus S vagy X akkor a mérettől függően be kell állítani
    //a lépészám mezők hozzáférését :
		if (iFeederType = 0) or (iFeederType = 1) then
    begin
      case iFeederSize of
        3..8,10,12-21 :
          //egyoldalas feederek :
          begin
            edtLepeszam1.Enabled := true;
            edtLepeszam4.Enabled := true;
          end;
        1,11 :
          //2x8mm :
          begin
             edtLepeszam1.Enabled := true;
             edtLepeszam2.Enabled := true;
             edtLepeszam4.Enabled := true;
             edtLepeszam5.Enabled := true;
          end;
        2 :
          //3x8mm :
          begin
             edtLepeszam1.Enabled := true;
             edtLepeszam2.Enabled := true;
             edtLepeszam3.Enabled := true;
             edtLepeszam4.Enabled := true;
             edtLepeszam5.Enabled := true;
             edtLepeszam6.Enabled := true;
          end;
      end;  //end of case
    end;  //end of if

    if (iFeederType = 0) then edtFeederType.Text := 'SIEMENS S,F,HS';
    if (iFeederType = 1) then edtFeederType.Text := 'SIEMENS X';
		if (iFeederType = 2) then edtFeederType.Text := 'FUJI';
    if (iFeederType = 3) then edtFeederType.Text := 'RLI';
    if (iFeederType = 4) then edtFeederType.Text := 'VCD-SEQ';
    if (iFeederType = 5) then edtFeederType.Text := 'Hover Davis';

		memMegjegyzesek.Text := '';

    //Javítási kódok feltöltése :
    cmbJavitasiKodok.Clear;
		Repeat
				sData := RepairCodesDataset.FieldByName('r_code').AsString + ' - ' + RepairCodesDataset.FieldByName('r_desc').AsString;
				it := RepairCodesDataset.FieldByName('id').AsInteger;
        cmbJavitasiKodok.Items.AddObject(sData,TObject(it));
				RepairCodesDataset.Next;
    Until RepairCodesDataset.Eof;
    dbClose(RepairCodesDataset);
    cmbJavitasiKodok.ItemIndex := 0;

    //Elvégzendő munkák feltöltése :
    cmbWorks.Clear;
    Repeat
				sData := myDataset.FieldByName('w_desc').AsString;
				it := myDataset.FieldByName('id').AsInteger;
        cmbWorks.Items.AddObject(sData,TObject(it));
				myDataset.Next;
    Until myDataset.Eof;
    if (iFeederType >= 3) then cmbWorks.Items.Delete(1);	//RLI_VCD_SEQ nincs kalibrálás !
    cmbWorks.ItemIndex := 0;

    //Feederalkatrészek feltöltése a feeder típusától függően :
    cmbAlkatreszek.Clear;
    dbUpdate(myDataset,'SELECT * FROM parts WHERE p_del=0 AND p_type=' + IntToStr(iFeederType));
    if (myDataset.RecordCount > 0) then
     begin
          Repeat
          		sData := myDataset.FieldByName('p_ordernum').AsString + ' - ' + myDataset.FieldByName('p_name').AsString;
                cmbAlkatreszek.Items.AddObject(sData,TObject(myDataset.FieldByName('id').AsInteger));
                myDataset.Next;
          Until myDataset.Eof;
          myDataset.First;
          cmbAlkatreszek.ItemIndex := 0;
     end;

	//Adagolóhibák feltöltése a feeder típusától függően :
    cmbAdagoloHibak.Clear;
    dbUpdate(myDataset,'SELECT * FROM errors WHERE e_del=0 AND e_type='+IntToStr(iFeederType));
    if (myDataset.RecordCount > 0) then
     begin
          Repeat
          		sData := myDataset.FieldByName('e_desc').AsString;
                cmbAdagoloHibak.Items.AddObject(sData,TObject(myDataset.FieldByName('id').AsInteger));
                myDataset.Next;
          Until myDataset.Eof;
          myDataset.First;
          cmbAdagoloHibak.ItemIndex := 0;
     end;

	//A feederhez tartozó adatok összegyüjtése :

    	//DS7i-hez tartozó lezárt munkalapok :
      sSQL := 'select repair.id as rep_id,repair.ds7i,repair.r_date,repair.r_comment,repair.lepesszam1,';
      sSQL := sSQL + 'repair.lepesszam2,repair.lepesszam3,users.id,users.u_name ';
      sSQL := sSQL + 'from repair,users ';
      sSQL := sSQL + 'where ds7i="' + DS7i + '" and r_end = 1 and r_type = ' + IntToStr(iFeederType);
      sSQL := sSQL + ' and users.id = repair.u_id order by repair.id;';

      dbUpdate(myDataset,	sSQL);
      iRows := myDataset.RecordCount;

      //ShowMessage(inttostr(iRows));

      if (iRows = 0) then
       begin
          sFeederInfos := '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body>';
          sFeederInfos := sFeederInfos + '<table align="center" width="98%" border="1" CELLPADDING=4 CELLSPACING=0 >';
          sFeederInfos := sFeederInfos + '<tr align="center" height="40px">' +
          		'<td><b>DS7i</b></td><td><b>Karbantartó</b></td><td><b>Dátum</b></td><td><b>Javítási kódok</b></td><td><b>Felhasznált alkatrészek</b></td>' +
              '<td><b>Költség (EUR)</b></td><td><b>Megjegyzések...</b></td></tr>';
          sFeederInfos := sFeederInfos + '</table></body></html>';

          IpHtmlPanel1.SetHtmlFromStr(sFeederInfos);
          IpHtmlPanel1.Refresh;
       end;

      if (iRows > 0) then
       begin
          myDataset.Last;
          //előző lépésszámok kitöltése:
          edtLepeszam4.Text := IntToStr(myDataset.FieldByName('lepesszam1').AsInteger);
          edtLepeszam5.Text := IntToStr(myDataset.FieldByName('lepesszam2').AsInteger);
          edtLepeszam6.Text := IntToStr(myDataset.FieldByName('lepesszam3').AsInteger);
          myDataset.First;
       end;

      //végig kell menni a feederhez tartozó munkalapokon:
      SetLength(aFeederAdatok,0);

			if (iRows > 0) then
        begin
					iActualRow := 1;
        	SetLength(aFeederAdatok,iRows+1);
          Repeat
            	//Aktuális munkalap db-id -je :
            		iTworkID := myDataset.FieldByName('rep_id').AsInteger;
            	//DS7i,javító,dátum,megjegyzés kitöltése :
                aFeederAdatok[iActualRow].sDS7i := DS7i;
								aFeederAdatok[iActualRow].sUname := myDataset.FieldByName('u_name').AsString;
                aFeederAdatok[iActualRow].sComment := myDataset.FieldByName('r_comment').AsString;
                aFeederAdatok[iActualRow].sDate := myDataset.FieldByName('r_date').AsString;

                //feederhez tartozó elvégzett munkák :
                if (iFeederType > 2) then
                  begin
                    //rli,seq,vcd állomások munkái :
                    dbUpdate(worksDataset,'select works.w_desc from feeder_works,works where feeder_works.r_id = '
                	  + IntToStr(iTworkID) + ' and feeder_works.w_id = works.id');
                	  sData := '';
                	  iWorksNum := worksDataset.RecordCount;
                	  SetLength(aFeederAdatok[iActualRow].sWorks,iWorksNum+1);
                    for i := 1 to iWorksNum do
                    begin
                        aFeederAdatok[iActualRow].sWorks[i] := worksDataset.FieldByName('w_desc').AsString;
                        worksDataset.Next;
                    end;
                  end
                else
                  begin
                  	//siemens állomások munkái :
                    dbUpdate(worksDataset,'select repair_codes.r_desc from feeder_repair_codes,repair_codes where feeder_repair_codes.r_id = '
                	  + IntToStr(iTworkID) + ' and feeder_repair_codes.r_code_id = repair_codes.id');
                	  sData := '';
                	  iWorksNum := worksDataset.RecordCount;
                	  SetLength(aFeederAdatok[iActualRow].sWorks,iWorksNum+1);
                    for i := 1 to iWorksNum do
                    begin
                        aFeederAdatok[iActualRow].sWorks[i] := worksDataset.FieldByName('r_desc').AsString;
                        worksDataset.Next;
                    end;
                  end;


                //feederbe épített alkatrészek :
                rPartsCost := 0;
                dbUpdate(partsDataset,'select parts.p_name,parts.p_cost from usedparts,parts where usedparts.r_id = ' +
                	IntToStr(iTworkID) + ' and usedparts.p_id = parts.id;');
                sData := '';
                rPartsCost := 0;
                iPartsNum := partsDataset.RecordCount;
                SetLength(aFeederAdatok[iActualRow].sParts,iPartsNum+1);
                for i := 1 to iPartsNum do
                begin
                		aFeederAdatok[iActualRow].sParts[i] := partsDataset.FieldByName('p_name').AsString;
                    try
                      rtCost := partsDataset.FieldByName('p_cost').AsFloat;
                    except
                      rtCost := 0;
                    end;
                    rPartsCost := rPartsCost + rtCost;
                    partsDataset.Next;
                end;

                if (rPartsCost <= 0) then aFeederAdatok[iActualRow].sCost := '0.0';
                if (rPartsCost > 0) then aFeederAdatok[iActualRow].sCost := FloatToStr(rPartsCost);


								iActualRow := iActualRow + 1;
                myDataset.Next;

          	Until myDataset.Eof;

            dbClose(partsDataset);
            dbClose(worksDataset);

        end ;
        dbClose(myDataset);

        //Adatok megjelenítése HTML táblázatban :
				iFad := Length(aFeederAdatok);
        //ShowMessage(IntToStr(iFad));
        sFeederInfos := '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body>';
        sFeederInfos := sFeederInfos + '<table align="center" width="98%" border="1" CELLPADDING=4 CELLSPACING=0 >';
        sFeederInfos := sFeederInfos + '<tr align="center" height="40px">' +
          		'<td><b>DS7i</b></td><td><b>Karbantartó</b></td><td><b>Dátum</b></td><td><b>Javítási kódok</b></td><td><b>Felhasznált alkatrészek</b></td>' +
              '<td><b>Költség (EUR)</b></td><td><b>Megjegyzések...</b></td></tr>';
        sFeederInfos := sFeederInfos + '</table></body></html>';

        //ShowMessage(sFeederInfos);

        if (iFad > 0) then
        begin
          //van már ehez a feederhez adat felvíve...
          //ShowMessage('Van már adat a feederhez!');
          sFeederInfos := '';
          sFeederInfos := sFeederInfos +
        	'<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body>';
          if (iFeederType > 2) then
          	sMelok := 'Elvégzett munkák'
          else
          	sMelok := 'Javítási kódok';
          sFeederInfos := sFeederInfos + '<table align="center" width="98%" border="1" CELLPADDING=4 CELLSPACING=0 >';
					sFeederInfos := sFeederInfos + '<tr align="center" height="40px">' +
          		'<td><b>DS7i</b></td><td><b>Karbantartó</b></td><td><b>Dátum</b></td><td><b>' + sMelok + '</b></td><td><b>Felhasznált alkatrészek</b></td>' +
              '<td><b>Költség (EUR)</b></td><td><b>Megjegyzések...</b></td></tr>';
          for i := 1 to iFad-1 do
          begin
							iPartsNum := Length(aFeederAdatok[i].sParts);
              iWorksNum := Length(aFeederAdatok[i].sWorks);

              sFeederInfos := sFeederInfos + '<tr>' +
              	'<td><font size="1">' + aFeederAdatok[i].sDS7i + '</font></td>' +
                '<td><font size="1">' + aFeederAdatok[i].sUname + '</font></td>' +
                '<td><font size="1">' + aFeederAdatok[i].sDate + '</font></td>' +
                '<td align="left"><font size="1">';

              for j := 1 to iWorksNum-1 do
              begin
                  sFeederInfos := sFeederInfos + aFeederAdatok[i].sWorks[j];
                  if (iWorksNum > j) then sFeederInfos := sFeederInfos + '<br>';
              end;
              sFeederInfos := sFeederInfos + '</font></td><td align="left"><font size="1">';
              for j := 1 to iPartsNum-1 do
              begin
                  sFeederInfos := sFeederInfos + aFeederAdatok[i].sParts[j];
                  if (iPartsNum > j) then sFeederInfos := sFeederInfos + '<br>';
              end;
              sFeederInfos := sFeederInfos + '</font></td><td><font size="1">' + aFeederAdatok[i].sCost +
                    '</font></td><td align="left"><font size="1">' + aFeederAdatok[i].sComment + '</font></td>';
              sFeederInfos := sFeederInfos + '</tr>';
          end;
          sFeederInfos := sFeederInfos + '</table></body></html>';
        end;

        IpHtmlPanel1.SetHtmlFromStr(sFeederInfos);
        IpHtmlPanel1.Refresh;

{
				try
           ms:=TMemoryStream.Create;
           sl:=TStringList.Create;
           try
              sl.Add(sFeederInfos);	// .LoadFromFile('my.html');
              sl.SaveToStream(ms);
              html:=TIpHtml.Create;
              ms.seek(0,0);
              html.LoadFromStream(ms);
              IpHtmlPanel1.SetHtml(html);
              finally
              ms.free;
           end;
           finally
           sl.free;
        end;
}

end;

initialization
  {$I ujmunkalap.lrs}

end.
