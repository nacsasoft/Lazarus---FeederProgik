unit fomenu;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls,
  Graphics, Dialogs, StdCtrls, Buttons, global, ExtCtrls, sqlite3ds, database,
  dateutils;

type

  { TfrmMainMenu }

  TfrmMainMenu = class(TForm)
    btnADMIN_FeederAlkatreszek: TButton;
    btnADMIN_FelhasznalokSzerkesztese: TButton;
    btnErrorLogClear: TButton;
    btnRiportok: TButton ;
    btnMagazinJavitas: TButton;
    btnUjMunkalap: TButton;
    btnRiportokNoAdmin: TButton;
    btnUjMunkalap1 : TButton;
    btnTroliJavitas : TButton;
    btnPreventiv: TButton;
    edtKarbantartoName: TEdit ;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    grpAdminFunkciok: TGroupBox;
    Label2: TLabel ;
    lstPreventivreVar: TListBox;
    Shape2: TShape ;
    procedure btnADMIN_FeederAlkatreszekClick(Sender: TObject);
    procedure btnADMIN_FelhasznalokSzerkeszteseClick(Sender: TObject);
    procedure btnMagazinJavitasClick(Sender: TObject);
    procedure btnMunkalapSzerkesztesClick(Sender: TObject);
    procedure btnErrorLogClearClick(Sender: TObject);
    procedure btnPreventivClick(Sender: TObject);
    procedure btnRiportokClick(Sender: TObject) ;
    procedure btnRiportokNoAdminClick(Sender: TObject) ;
    procedure btnTroliJavitasClick(Sender : TObject);
    procedure btnUjMunkalap1Click(Sender : TObject);
    procedure btnUjMunkalapClick(Sender: TObject) ;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    myDataset:             TSqlite3Dataset;

  public
    { public declarations }
  end; 

var
  frmMainMenu: TfrmMainMenu;

implementation

{ TfrmMainMenu }
uses
  login, felhasznalok, feederpartsedit, ujmunkalap, reports, reportsnoadmin, feederpreventiv,
  feederazonositas, sorbeallitasa, egyebmunkak, trolijavitas, magazinjavitas, prevfeederazon;

procedure TfrmMainMenu.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
     frmMainMenu.Hide;
     frmLogin.Show;
end;

procedure TfrmMainMenu.btnADMIN_FelhasznalokSzerkeszteseClick(Sender: TObject);
begin
     //Felhaszn??l??i adatok szerk.
     frmMainMenu.Hide;
     frmFelhasznalok.Show;
end;

procedure TfrmMainMenu.btnMagazinJavitasClick(Sender: TObject);
begin
  //Magazin jav??t??s.
    frmMainMenu.Hide;
    frmMagazinJavitas.Show;
end;


procedure TfrmMainMenu.btnMunkalapSzerkesztesClick(Sender: TObject);
begin
     //L??tez?? munkalap szerkeszt??se.

end;

procedure TfrmMainMenu.btnErrorLogClearClick(Sender: TObject);
var
  iRet:	Integer;
begin
    //log fajl tiszt??tasa (??r??tese...)
    iRet:=MessageDlg('Log t??rl??se...','Biztos hogy t??r??ljem a log-f??jl tartalm??t?',mtConfirmation,mbYesNo,0);
    if (iRet <> mrYes) then exit; ;
    clearLogFile();
    ShowMessage('Log f??jl tartalma t??r??lve!');

end;

procedure TfrmMainMenu.btnPreventivClick(Sender: TObject);
//TPM feeder prevent??ve ind??t??sa....
var
		ifType,iRecCount:											integer;
    bRet:																				boolean;

begin
    //DS7i azonos??t?? bek??r??se :
    DS7i := '';
    bRet := InputQuery('DS7i azonos??t??...','K??rem az adagol?? DS7i azonos??t??j??t :',DS7i);
    if (not bRet) then exit;

    //ha a b??rk??d olvas?? a nulla helyett ??-t ??rna be akkor ki kell jav??tani 0-ra!
    DS7i := StringReplace(DS7i,'??','0',[rfReplaceAll]);

    DS7i := trim(DS7i);
    if (IsStrANumber(DS7i) = false) then
       begin
			    DS7i := '';
          ShowMessage('A DS7i azonos??t?? csak sz??mot tartalmazhat !');
          exit;
       end ;
    if (DS7i = '') then
       begin
            DS7i := '';
            ShowMessage('Az azonos??t?? megad??sa k??telez?? !');
            exit;
       end;

    //Van ehez a feederhez nyitott munkalap jav??t??sra??:
    myDataset := dbConnect('feeder_tpm','SELECT * FROM feeder_tpm WHERE tpm_ds7i="' + DS7i + '" and tpm_lezarva = 0 and tpm_javitasra = 1;','id');
    iRecCount := myDataset.RecordCount;
    if (iRecCount > 0) then
        begin
          //Igen van!!
          dbClose(myDataset);
          ShowMessage('Figyelem!' + #10 + #10 + 'A feeder m??r meg lett jel??lve jav??t??sra,' + #10 + 'K??rem helyezze a megfelel?? polcra!' );
          exit;
        end;
    //Ha nincs nyitott munkalap akkor meg kell n??zni hogy szerepel-e az adatb??zisban:
    dbUpdate(myDataset,'SELECT * FROM feeder_tpm WHERE tpm_ds7i="' + DS7i + '";');
    iRecCount := myDataset.RecordCount;
    if (iRecCount > 0) then
        begin
          //Igen szerepel!!
          //glob??lis v??ltoz??k be??ll??t??sa:
          iFeederType := myDataset.FieldByName('tpm_type').AsInteger;
          iFeederSize := myDataset.FieldByName('tpm_size').AsInteger;
          dbUpdate(myDataset,'SELECT * FROM feeder_size WHERE id = ' + IntToStr(iFeederSize));
          sFeederSize := myDataset.FieldByName('size').AsString;
        end;

    dbClose(myDataset);
    frmMainMenu.Hide;

    if (iRecCount = 0) then
        begin
          //M??g nincs bennt a rendszerben:
          ShowMessage('Az adagol?? m??g nem szerepel az adatb??zisban!' + #10 + 'A megjelen?? ablakban tudja r??gz??teni!');
          frmPreventiveFeederazonositas.Show;
          exit;
        end;

      frmFeederPreventiv.Show;
end;

procedure TfrmMainMenu.btnRiportokClick(Sender: TObject) ;
begin
     //Admin riportok k??sz??t??se.
     frmMainMenu.Hide;
     frmReports.Show;
end;

procedure TfrmMainMenu.btnRiportokNoAdminClick(Sender: TObject) ;
begin
     //Riportok k??sz??t??se.
     frmMainMenu.Hide;
     //frmReportsNoAdmin.Show;
     frmReports.Show;
end;

procedure TfrmMainMenu.btnTroliJavitasClick(Sender : TObject);
begin
     //Troli jav??t??s ind??t??sa....
     frmMainMenu.Hide;
     frmTroliJavitas.Show;
end;

procedure TfrmMainMenu.btnUjMunkalap1Click(Sender : TObject);
begin
  	//Egy??b, nem adagol??jav??t??ssal kapcsolatos munk??k......Tofi k??r??s??re....  :)
		frmMainMenu.Hide;
    frmEgyebMunkak.Show;
end;

procedure TfrmMainMenu.btnUjMunkalapClick(Sender: TObject) ;
var
		ifType,iJavitasokSzama:																			integer;
    bRet:																												boolean;
    sLine,sSQL,sTol,sIg,sInfo,sFeederType:											string;

begin
     //??j munkalap ind??t??sa,ha a DS7i-t megadta.
     //DS7i azonos??t?? bek??r??se :
     DS7i := '';
     bRet := InputQuery('DS7i azonos??t??...','K??rem az adagol?? DS7i azonos??t??j??t :',DS7i);
     if (not bRet) then exit;

     //ha a b??rk??d olvas?? a nulla helyett ??-t ??rna be akkor ki kell jav??tani 0-ra!
     DS7i := StringReplace(DS7i,'??','0',[rfReplaceAll]);

     DS7i := trim(DS7i);
     if (IsStrANumber(DS7i) = false) then
         begin
				    DS7i := '';
            ShowMessage('A DS7i azonos??t?? csak sz??mot tartalmazhat !');
            exit;
         end ;
     if (DS7i = '') then
         begin
              DS7i := '';
              ShowMessage('Az azonos??t?? megad??sa k??telez?? !');
              exit;
         end;

     {
     //Ha a feeder m??r volt az adott h??napban 3-szor jav??tva akkor f??lre kell tenni ??s experttel
     //egy??tt ??tvizsg??lni!!
     sTol := FormatDateTime('yyyy-mm-dd',IncMonth(Today,-1));
     sIg := FormatDateTime('yyyy-mm-dd',Today);

		 //teszt adatok.....adott id??szakban 4-szer volt jav??tva ez a feeder.....
     //DS7i := '291507';
     //sTol := '2013-01-01';
     //sIg := '2013-12-31';

		 //H??nyszor volt a feeder jav??tva az id??szakban:
     sSQL := 'select repair.ds7i as ds7i,count(ds7i) as javitasok_szama from repair ';
     sSQL := sSQL + 'where (repair.ds7i = "' + DS7i + '") and (r_date >= "' + sTol + '" AND r_date <= "' + sIg + '");';

     myDataset := dbConnect('repair',sSQL,'id');
     iJavitasokSzama := myDataset.FieldByName('javitasok_szama').AsInteger;
     if (iJavitasokSzama >= 3) then
         begin
              //4x j??tt vissza jav??t??sra a feeder 1 h??ten bel??l, ez??rt fel kell vinni a db-be (temp t??bla)
              //iInfo = adatazonos??t??s
              //sTemp1 = visszahozott feeder DS7i azonos??t??ja
              //sTemp2 = kirak??s d??tuma
              //sTemp3 = feeder t??pusa (pl. 2x8mm S-feeder)

              dbUpdate(myDataset,'SELECT * FROM repair WHERE ds7i="' + DS7i + '" order by id');
              iFeederType := myDataset.FieldByName('r_type').AsInteger;
          		iFeederSize := myDataset.FieldByName('size').AsInteger;
              dbUpdate(myDataset,'select * from feeder_size where id = ' + IntToStr(iFeederSize));
          		sFeederSize := myDataset.FieldByName('size').AsString;
              if (iFeederType = 0) then sFeederType := 'SIEMENS S,F,HS';
							if (iFeederType = 1) then sFeederType := 'SIEMENS X';
							if (iFeederType = 2) then sFeederType := 'FUJI';
    					if (iFeederType = 3) then sFeederType := 'RLI';
    					if (iFeederType = 4) then sFeederType := 'VCD-SEQ';
              if (iFeederType = 5) then sFeederType := 'Hover Davis';

              dbClose(myDataset);
              myDataset := dbConnect('temp','SELECT * FROM temp ORDER BY id;','id');

              //update nem ok mert nem ??r a db-be!! le kell z??rni ??s ujra megnyitni!!
              //dbUpdate(myDataset,'SELECT * FROM temp ORDER BY id;');
              with myDataset do
                begin
                    Insert;
                    FieldByName('iInfo1').AsInteger := 1;
                    FieldByName('sTemp1').AsString := DS7i;
                    FieldByName('sTemp2').AsString := sIg;
                    FieldByName('sTemp3').AsString := sFeederType + ' - ' + sFeederSize;
                    Post;
                    ApplyUpdates;
                end;

							//Feederjav??t?? figyelm??t fel kell h??vni! Feeder nem ker??lhet vissza a termel??sbe
              //t??zetes ??tvizsg??l??s n??lk??l!!!
              sInfo := 'Ez a feeder a(z) ' + sTol + ' ??s ' + sIg + #13;
              sInfo := sInfo + 'id??szakban m??r h??romszor volt jav??t??s alatt!' + #13 + #13;
							sInfo := sInfo + 'Jav??t??s ut??n a feedert f??lre kell rakni tov??bbi ??tvizsg??l??s c??lj??b??l!' + #13 + #13;
							ShowMessage(sInfo);

         end;
     }

     //Ha a feeder a SETUP-ban meg lett jel??lve jav??t??sra akkor a feeder_tpm -t??bl??b??l
     //kell lek??rni az adatokat!
     sSQL := 'SELECT * FROM feeder_tpm WHERE tpm_ds7i="' + DS7i + '" and tpm_javitasra = 1 and tpm_lezarva = 0';
     myDataset := dbConnect('repair',sSQL,'id');

     if (myDataset.RecordCount > 0) then
         begin
              //setup-b??l j??tt ??s meg lett jel??lve jav??t??sra....
              sLine := 'SETUP';
              iMachineID := -1;
              sFeederPosition := '';
              iFeederSize := myDataset.FieldByName('tpm_size').AsInteger;
              iFeederType := myDataset.FieldByName('tpm_type').AsInteger;
              sKirakasDatuma := myDataset.FieldByName('tpm_outdate').AsString;
              iErrorCode := myDataset.FieldByName('tpm_hibakod').AsInteger;
              iLineID := 14;  //SETUP
              dbUpdate(myDataset,'select * from feeder_size where id = ' + IntToStr(iFeederSize));
              sFeederSize := myDataset.FieldByName('size').AsString;
              dbClose(myDataset);
              //ShowMessage('SETUP');
              frmMainMenu.Hide;
              //frmUjMunkalap.Show;
              frmSorBeallitasa.Show;
              exit;
         end;

     //Ha a feeder el??sz??r ker??lt jav??t??s al??, akkor be kell azonos??tani :
     dbUpdate(myDataset,'SELECT * FROM repair WHERE ds7i="' + DS7i + '" order by id');
		 if (myDataset.RecordCount = 0) then
         begin
		      dbClose(myDataset);
			  	frmMainMenu.Hide;
          frmFeederAzonositas.Show;
          exit;
         end;
     if (myDataset.RecordCount > 0) then
         begin
     	    myDataset.First;
          //Van sor azonos??t??s ?
          iLineID := 1; //myDataset.FieldByName('line').AsInteger;
          iErrorCode := 1;
          iFeederType := myDataset.FieldByName('r_type').AsInteger;
          iFeederSize := myDataset.FieldByName('size').AsInteger;
          ShowMessage(IntToStr(iFeederSize));
          dbUpdate(myDataset,'select * from feeder_size where id = ' + IntToStr(iFeederSize));
          sFeederSize := myDataset.FieldByName('size').AsString;
          //ShowMessage(sFeederSize);
          dbClose(myDataset);
		      //Meg kell adni a sort ??s az oper??tor azonos??t??t :
          frmMainMenu.Hide;
          frmSorBeallitasa.Show;
         end;
end;

procedure TfrmMainMenu.btnADMIN_FeederAlkatreszekClick(Sender: TObject);
begin
     //Feeder alkatr??szek adatainak szerkeszt??se(felvitel,t??rl??s,szerk.).
     frmMainMenu.Hide;
     frmFeederPartsEdit.Show;
end;

procedure TfrmMainMenu.FormShow(Sender: TObject);
var
    sSQL,sDate,sData      :string;
    wWeekNum              :word;

begin
     writeLogMessage('F??men?? start...Felhaszn??l?? : '+userName);
     //A helyes tizedes sz??m??t??sokhoz be kell ??ll??tani az EN. decim??lis elv??laszt??t .-ra !
  	 DecimalSeparator := '.';

     btnUjMunkalap.Enabled := false;
     btnTroliJavitas.Enabled := false;
     btnMagazinJavitas.Enabled := false;
     btnUjMunkalap1.Enabled := false;
     btnRiportokNoAdmin.Enabled := false;
     btnPreventiv.Enabled := false;
     btnADMIN_FeederAlkatreszek.Enabled := false;
     btnADMIN_FelhasznalokSzerkesztese.Enabled := False;
     btnRiportok.Enabled := false;
     btnErrorLogClear.Enabled := false;


     //Felhaszn??l??n??v be??r??sa :
     edtKarbantartoName.Text := userName;

     //Alap felhaszn??l?? :
     if (iAdmin = 0) then
         begin
              frmMainMenu.Height:=255; //220;  255=kicsit magasabb kell a preventiv miatt...
              frmMainMenu.Width := 590;
              btnUjMunkalap.Enabled := true;
              btnTroliJavitas.Enabled := true;
              btnMagazinJavitas.Enabled := true;
              btnUjMunkalap1.Enabled := true;
              //grpAdminFunkciok.Hide;
              //GroupBox2.Hide;
         end;

     //Riport k??sz??t??sre jogosult :
     if (iAdmin = 1) then
        begin
             frmMainMenu.Height := 390;
             frmMainMenu.Width := 590;
             //btnADMIN_FeederAlkatreszek.Enabled := false;
						 //btnADMIN_FelhasznalokSzerkesztese.Enabled := false;
             //btnErrorLogClear.Enabled := false;
             btnPreventiv.Enabled := true;
             btnUjMunkalap.Enabled := true;
             btnTroliJavitas.Enabled := true;
             btnMagazinJavitas.Enabled := true;
             btnUjMunkalap1.Enabled := true;
             btnRiportokNoAdmin.Enabled := true;
             //GroupBox2.Show;
             //grpAdminFunkciok.Show;
        end;

     //Riport, felhaszn??l??, alkatr??szek szerkeszt??sre jogosult :
     if (iAdmin = 3) then
        begin
             frmMainMenu.Height := 553;
             frmMainMenu.Width := 590;
             btnADMIN_FeederAlkatreszek.Enabled := true;
						 btnADMIN_FelhasznalokSzerkesztese.Enabled := true;
             btnErrorLogClear.Enabled := true;
             btnRiportok.Enabled := true;
             btnPreventiv.Enabled := true;
             btnUjMunkalap.Enabled := true;
             btnTroliJavitas.Enabled := true;
             btnMagazinJavitas.Enabled := true;
             btnUjMunkalap1.Enabled := true;
             btnRiportokNoAdmin.Enabled := true;
             //grpAdminFunkciok.Show;
        end;

     //TPM Preventivesek:
     if (iAdmin = 5) then
        begin
             frmMainMenu.Height := 264;
             frmMainMenu.Width := 300;
             btnPreventiv.Enabled := true;
             exit;
        end;




     //Preventivre varo trolik feltoltese:
     wWeekNum:=WeekOfTheYear(Now);
     sSQL := 'select * from trolley_preventive where tr_p_week = ' + IntToStr(wWeekNum) +
              ' and tr_p_ok = 0;';
     myDataset := dbConnect('trolley_preventive',sSQL,'id');
     lstPreventivreVar.Clear;
     GroupBox3.Caption:='Prevent??vre v??r?? trolik a(z) ' + IntToStr(wWeekNum) + '. h??ten:';
     if (myDataset.RecordCount > 0) then
     begin
        myDataset.First;
        Repeat
        	sData := 'Troli azonos??t?? : ' + myDataset.FieldByName('tr_p_ds7i').AsString;
          lstPreventivreVar.Items.Add(sData);
          myDataset.Next;
      Until myDataset.Eof;
     end
     else
     begin
        lstPreventivreVar.Items.Add('Nincs prevent??vre v??r?? troli!');
     end;
     dbClose(myDataset);

     frmMainMenu.Position := poScreenCenter;
     frmMainMenu.Update;
end;

initialization
  {$I fomenu.lrs}

end.

