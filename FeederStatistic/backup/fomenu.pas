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
     //Felhasználói adatok szerk.
     frmMainMenu.Hide;
     frmFelhasznalok.Show;
end;

procedure TfrmMainMenu.btnMagazinJavitasClick(Sender: TObject);
begin
  //Magazin javítás.
    frmMainMenu.Hide;
    frmMagazinJavitas.Show;
end;


procedure TfrmMainMenu.btnMunkalapSzerkesztesClick(Sender: TObject);
begin
     //Létező munkalap szerkesztése.

end;

procedure TfrmMainMenu.btnErrorLogClearClick(Sender: TObject);
var
  iRet:	Integer;
begin
    //log fajl tisztítasa (ürítese...)
    iRet:=MessageDlg('Log törlése...','Biztos hogy töröljem a log-fájl tartalmát?',mtConfirmation,mbYesNo,0);
    if (iRet <> mrYes) then exit; ;
    clearLogFile();
    ShowMessage('Log fájl tartalma törölve!');

end;

procedure TfrmMainMenu.btnPreventivClick(Sender: TObject);
//TPM feeder preventíve indítása....
var
		ifType,iRecCount:											integer;
    bRet, bDs7iOK:																	boolean;

begin
    //DS7i azonosító bekérése :
    DS7i := '';
    bRet := InputQuery('DS7i azonosító...','Kérem az adagoló DS7i azonosítóját :',DS7i);
    if (not bRet) then exit;

    //ha a bárkód olvasó a nulla helyett ö-t írna be akkor ki kell javítani 0-ra!
    DS7i := StringReplace(DS7i,'ö','0',[rfReplaceAll]);

    DS7i := trim(DS7i);
    if (IsStrANumber(DS7i) = false) then
       begin
			    DS7i := '';
          ShowMessage('A DS7i azonosító csak számot tartalmazhat !');
          exit;
       end ;
    if (DS7i = '') then
       begin
            DS7i := '';
            ShowMessage('Az azonosító megadása kötelező !');
            exit;
       end;

    // Van ehez a feederhez nyitott munkalap javításra??:
    // Javításra megjelölést nem nézünk mert a setupcenterben nem használják (2025.09.17.)
    { myDataset := dbConnect('feeder_tpm','SELECT * FROM feeder_tpm WHERE tpm_ds7i="' + DS7i + '" and tpm_lezarva = 0 and tpm_javitasra = 1;','id');
    iRecCount := myDataset.RecordCount;
    if (iRecCount > 0) then
        begin
          //Igen van!!
          dbClose(myDataset);
          ShowMessage('Figyelem!' + #10 + #10 + 'A feeder már meg lett jelölve javításra,' + #10 + 'Kérem helyezze a megfelelő polcra!' );
          exit;
        end;
        }
    //Ha nincs nyitott munkalap akkor meg kell nézni hogy szerepel-e az adatbázisban:
    bDs7iOK := false;
    myDataset := dbConnect('feeder_tpm', 'SELECT * FROM feeder_tpm WHERE tpm_ds7i="' + DS7i + '" LIMIT 1;');
    // dbUpdate(myDataset,'SELECT * FROM feeder_tpm WHERE tpm_ds7i="' + DS7i + '" LIMIT 1;');
    iRecCount := myDataset.RecordCount;
    if (iRecCount = 0) then
       begin
          // TPM táblában még nincs, megnézzük a javítás (repair) táblában is.
          // Rákeresünk a javítási táblában is (repair) mert ott már van egy rakat adagoló...
          dbUpdate(myDataset,'SELECT * FROM repair WHERE ds7i="' + DS7i + '" LIMIT 1;');
          iRecCount := myDataset.RecordCount;
          if (iRecCount > 0) then
             begin
                bDs7iOK := true;
                //Igen szerepel!!
                //globális változók beállítása:
                iFeederType := myDataset.FieldByName('r_type').AsInteger;
                iFeederSize := myDataset.FieldByName('size').AsInteger;
             end;
       end
    else
      begin
          bDs7iOK := true;
          //Igen szerepel!!
          //globális változók beállítása:
          iFeederType := myDataset.FieldByName('tpm_type').AsInteger;
          iFeederSize := myDataset.FieldByName('tpm_size').AsInteger;
      end;

    if (bDs7iOK = true) then
        begin
          //Megvan az adagoló vmelyik táblában, lekérjük a méretet is!!
          //globális változók beállítása:
          dbUpdate(myDataset,'SELECT * FROM feeder_size WHERE id = ' + IntToStr(iFeederSize));
          sFeederSize := myDataset.FieldByName('size').AsString;
        end;

    dbClose(myDataset);
    frmMainMenu.Hide;

    // Ha nincs sehol még a feeder akkor be kell azonosítani
    if (bDs7iOK = false) then
        begin
          //Még nincs bennt a rendszerben (sem a repair sem a feeder_tpm táblában):
          ShowMessage('Az adagoló még nem szerepel az adatbázisban!' + #10 + 'A megjelenő ablakban tudja rögzíteni!');
          frmPreventiveFeederazonositas.Show;
          exit;
        end;

      frmFeederPreventiv.Show;
end;

procedure TfrmMainMenu.btnRiportokClick(Sender: TObject) ;
begin
     //Admin riportok készítése.
     frmMainMenu.Hide;
     frmReports.Show;
end;

procedure TfrmMainMenu.btnRiportokNoAdminClick(Sender: TObject) ;
begin
     //Riportok készítése.
     frmMainMenu.Hide;
     //frmReportsNoAdmin.Show;
     frmReports.Show;
end;

procedure TfrmMainMenu.btnTroliJavitasClick(Sender : TObject);
begin
     //Troli javítás indítása....
     frmMainMenu.Hide;
     frmTroliJavitas.Show;
end;

procedure TfrmMainMenu.btnUjMunkalap1Click(Sender : TObject);
begin
  	//Egyéb, nem adagolójavítással kapcsolatos munkák......Tofi kérésére....  :)
		frmMainMenu.Hide;
    frmEgyebMunkak.Show;
end;

procedure TfrmMainMenu.btnUjMunkalapClick(Sender: TObject) ;
var
		ifType,iJavitasokSzama, iMID:																			integer;
    bRet:																												boolean;
    sLine,sSQL,sTol,sIg,sInfo,sFeederType:											string;

    dbSorozatszam : TSqlite3Dataset;
    bRosszSorozatszam : boolean;
    sSorozatszam : string;

begin
     //Új munkalap indítása,ha a DS7i-t megadta.
     //DS7i azonosító bekérése :
     DS7i := '';
     bRet := InputQuery('DS7i azonosító...','Kérem az adagoló DS7i azonosítóját :',DS7i);
     if (not bRet) then exit;

     //ha a bárkód olvasó a nulla helyett ö-t írna be akkor ki kell javítani 0-ra!
     DS7i := StringReplace(DS7i,'ö','0',[rfReplaceAll]);

     DS7i := trim(DS7i);
     if (IsStrANumber(DS7i) = false) then
         begin
				    DS7i := '';
            ShowMessage('A DS7i azonosító csak számot tartalmazhat !');
            exit;
         end ;
     if (DS7i = '') then
         begin
              DS7i := '';
              ShowMessage('Az azonosító megadása kötelező !');
              exit;
         end;

     {
     //Ha a feeder már volt az adott hónapban 3-szor javítva akkor félre kell tenni és experttel
     //együtt átvizsgálni!!
     sTol := FormatDateTime('yyyy-mm-dd',IncMonth(Today,-1));
     sIg := FormatDateTime('yyyy-mm-dd',Today);

		 //teszt adatok.....adott időszakban 4-szer volt javítva ez a feeder.....
     //DS7i := '291507';
     //sTol := '2013-01-01';
     //sIg := '2013-12-31';

		 //Hányszor volt a feeder javítva az időszakban:
     sSQL := 'select repair.ds7i as ds7i,count(ds7i) as javitasok_szama from repair ';
     sSQL := sSQL + 'where (repair.ds7i = "' + DS7i + '") and (r_date >= "' + sTol + '" AND r_date <= "' + sIg + '");';

     myDataset := dbConnect('repair',sSQL,'id');
     iJavitasokSzama := myDataset.FieldByName('javitasok_szama').AsInteger;
     if (iJavitasokSzama >= 3) then
         begin
              //4x jött vissza javításra a feeder 1 héten belül, ezért fel kell vinni a db-be (temp tábla)
              //iInfo = adatazonosítás
              //sTemp1 = visszahozott feeder DS7i azonosítója
              //sTemp2 = kirakás dátuma
              //sTemp3 = feeder típusa (pl. 2x8mm S-feeder)

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

              //update nem ok mert nem ír a db-be!! le kell zárni és ujra megnyitni!!
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

							//Feederjavító figyelmét fel kell hívni! Feeder nem kerülhet vissza a termelésbe
              //tüzetes átvizsgálás nélkül!!!
              sInfo := 'Ez a feeder a(z) ' + sTol + ' és ' + sIg + #13;
              sInfo := sInfo + 'időszakban már háromszor volt javítás alatt!' + #13 + #13;
							sInfo := sInfo + 'Javítás után a feedert félre kell rakni további átvizsgálás céljából!' + #13 + #13;
							ShowMessage(sInfo);

         end;
     }

     //Ha a feeder a SETUP-ban meg lett jelölve javításra akkor a feeder_tpm -táblából
     //kell lekérni az adatokat!
     sSQL := 'SELECT * FROM feeder_tpm WHERE tpm_ds7i="' + DS7i + '" and tpm_javitasra = 1 and tpm_lezarva = 0';
     myDataset := dbConnect('repair',sSQL,'id');

     if (myDataset.RecordCount > 0) then
         begin
              //setup-ból jött és meg lett jelölve javításra....
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

     //Ha a feeder először került javítás alá, akkor be kell azonosítani :
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
          //ha nincs a feederhez beállítva még sorozatszám akkor be kell kérni:
          myDataset.Last;
          if (Length(Trim(myDataset.FieldByName('sorozatszam').AsString)) < 5) then
            begin
              bRosszSorozatszam := false;
              iMID := myDataset.FieldByName('id').AsInteger;
              repeat
                sSorozatszam := '';
                if Not InputQuery('Feeder sorozatszám beállítása...','Kérem a feeder sorozatszámát (pl.: KL-C8-0580) : ',sSorozatszam) then
                  begin
                    bRosszSorozatszam := false;
                  end
                else
                  begin
                     if (Length(Trim(sSorozatszam)) < 5) then
                       begin
                          //túl rövid a megadott sorozatszám!
                          showmessage('Túl rövid a sorozatszám (min.: 5 karakter)!');
                          bRosszSorozatszam := false;
                       end
                     else
                        begin
                            //sorozatszám oké, le kell frissíteni a feederhez:
                            bRosszSorozatszam := true;
                            sSQL := 'SELECT * FROM repair WHERE id=' + inttostr(iMID) + ';';
                            dbSorozatszam := dbConnect('repair',sSQL,'id');
                            dbSorozatszam.Edit;
                            dbSorozatszam.FieldByName('sorozatszam').AsString := UpperCase(trim(sSorozatszam));
                            dbSorozatszam.Post;
                            dbSorozatszam.ApplyUpdates;
                            dbUpdate(dbSorozatszam,sSQL);
                            dbClose(dbSorozatszam);
                            gsSorozatszam := UpperCase(trim(sSorozatszam));
                        end;
                  end;
              //addíg kell bekérni a sorozatszámot amíg meg nem adja rendesen!!
              until bRosszSorozatszam;
            end;

     	    myDataset.First;
          //Van sor azonosítás ?
          iLineID := 1; //myDataset.FieldByName('line').AsInteger;
          iErrorCode := 1;
          iFeederType := myDataset.FieldByName('r_type').AsInteger;
          iFeederSize := myDataset.FieldByName('size').AsInteger;
          //ShowMessage(IntToStr(iFeederSize));
          dbUpdate(myDataset,'select * from feeder_size where id = ' + IntToStr(iFeederSize));
          sFeederSize := myDataset.FieldByName('size').AsString;
          //ShowMessage(sFeederSize);
          dbClose(myDataset);
		      //Meg kell adni a sort és az operátor azonosítót :
          frmMainMenu.Hide;
          frmSorBeallitasa.Show;
         end;
end;

procedure TfrmMainMenu.btnADMIN_FeederAlkatreszekClick(Sender: TObject);
begin
     //Feeder alkatrészek adatainak szerkesztése(felvitel,törlés,szerk.).
     frmMainMenu.Hide;
     frmFeederPartsEdit.Show;
end;

procedure TfrmMainMenu.FormShow(Sender: TObject);
var
    sSQL,sDate,sData      :string;
    wWeekNum              :word;

begin
     writeLogMessage('Főmenü start...Felhasználó : '+userName);
     //A helyes tizedes számításokhoz be kell állítani az EN. decimális elválasztót .-ra !
  	 DecimalSeparator := '.';

     btnUjMunkalap.Enabled := false;
     btnTroliJavitas.Enabled := false;
     btnMagazinJavitas.Enabled := false;
     btnUjMunkalap1.Enabled := false;
     btnRiportokNoAdmin.Enabled := false;
     // btnPreventiv.Enabled := false;
     btnADMIN_FeederAlkatreszek.Enabled := false;
     btnADMIN_FelhasznalokSzerkesztese.Enabled := False;
     btnRiportok.Enabled := false;
     btnErrorLogClear.Enabled := false;


     //Felhasználónév beírása :
     edtKarbantartoName.Text := userName;

     //Alap felhasználó :
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

     //Riport készítésre jogosult :
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

     //Riport, felhasználó, alkatrészek szerkesztésre jogosult :
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
     // 2025.07.14.: Csak az X-es trolik kellenek!!!
     wWeekNum:=WeekOfTheYear(Now);
     { sSQL := 'select * from trolley_preventive where tr_p_week = ' + IntToStr(wWeekNum) +
              ' and tr_p_ok = 0;'; }
     sSQL := 'SELECT * FROM trolley_preventive, trolley_list ' +
            'WHERE tr_p_week = ' + IntToStr(wWeekNum) +
            ' AND tr_tipus = "X" AND tr_p_ds7i = tr_sorszam AND tr_p_ok = 0;';

     myDataset := dbConnect('trolley_preventive',sSQL,'id');
     lstPreventivreVar.Clear;
     GroupBox3.Caption:='Preventívre váró trolik a(z) ' + IntToStr(wWeekNum) + '. héten:';
     if (myDataset.RecordCount > 0) then
     begin
        myDataset.First;
        Repeat
        	sData := 'Troli azonosító : ' + myDataset.FieldByName('tr_p_ds7i').AsString;
          lstPreventivreVar.Items.Add(sData);
          myDataset.Next;
      Until myDataset.Eof;
     end
     else
     begin
        lstPreventivreVar.Items.Add('Nincs preventívre váró troli!');
     end;
     dbClose(myDataset);

     frmMainMenu.Position := poScreenCenter;
     frmMainMenu.Update;
end;

initialization
  {$I fomenu.lrs}

end.

