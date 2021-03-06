unit trolimunkalap;

{$mode objfpc}

interface

uses
  Classes, SysUtils, FileUtil, IpHtml, LResources, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, global, database, sqlite3ds, dateutils;

type

  { TfrmTroliMunkalap }

  TfrmTroliMunkalap = class(TForm)
    btnAlkatreszFelvetel : TButton;
    btnAlkatreszTorlesAListabol : TButton;
    btnKilepLezarasNelkul : TButton;
    btnMunkalapLezarasa : TButton;
    btnWorksFelvetel : TButton;
    btnWorksTorlesAListabol : TButton;
    chkTroliPreventiv : TCheckBox;
    cmbAlkatreszek : TComboBox;
    cmbWorks : TComboBox;
    edtDS7i : TEdit;
    edtTroliTipus : TEdit;
    edtKarbantarto : TEdit;
    GroupBox1 : TGroupBox;
    IpHtmlPanel1 : TIpHtmlPanel;
    Label1 : TLabel;
    Label2 : TLabel;
    Label3 : TLabel;
    lstFelvettAlkatreszek : TListBox;
    lstWorks : TListBox;
    memMegjegyzesek : TMemo;
    Shape1 : TShape;
    Shape2 : TShape;
    Shape3 : TShape;
    Shape4 : TShape;
    tabComment : TTabSheet;
    tabMainSheet : TPageControl;
    tabUsedParts : TTabSheet;
    tabWorks : TTabSheet;
    procedure btnAlkatreszFelvetelClick(Sender : TObject);
    procedure btnAlkatreszTorlesAListabolClick(Sender : TObject);
    procedure btnKilepLezarasNelkulClick(Sender : TObject);
    procedure btnMunkalapLezarasaClick(Sender : TObject);
    procedure btnWorksFelvetelClick(Sender : TObject);
    procedure btnWorksTorlesAListabolClick(Sender : TObject);
    procedure FormCloseQuery(Sender : TObject; var CanClose : boolean);
    procedure FormShow(Sender : TObject);
  private
    { private declarations }
    troliJavitasokDataset,troliAlkatreszekDataset,myDataset:             TSqlite3Dataset;
    bTroliPreventive:   boolean;  //ha az adott heten kell prevozni a trolit akkor = 1
    wWeekNum           :word;

  public
    { public declarations }
  end;

var
  frmTroliMunkalap : TfrmTroliMunkalap;

implementation

uses trolijavitas,fomenu;

{ TfrmTroliMunkalap }

procedure TfrmTroliMunkalap.FormCloseQuery(Sender : TObject; var CanClose : boolean);
var
   iRet:  integer;
   sInfo: string;
begin
    writeLogMessage('Troli munkalap - kil??p??s ment??s n??lk??l start : '+userName);
    sInfo := 'Figyelem !' + chr(13) + chr(13) +
    		'Ha most kil??p, a munkalap t??rl??sre ker??l !' + chr(13) +
           	'Biztos hogy ki akar l??pni ?';
    iRet := MessageDlg('Kil??p??s lez??r??s n??lk??l...',sInfo,mtWarning,mbYesNo,0);
    if (iRet <> mrYes) then
    begin
        CanClose := false;
        exit;
    end ;
    CanClose := true;

    //writeLogMessage('Trolimunkalap bez??r??s ment??s n??lk??l - Adatb??zisok bez??r??sa START, felhaszn??l?? : ' + userName);

    //dbClose(troliAlkatreszekDataset);
    //dbClose(troliJavitasokDataset);

    //writeLogMessage('Trolimunkalap bez??r??s ment??s n??lk??l - Adatb??zisok bez??r??sa OK, felhaszn??l?? : ' + userName);

    frmTroliMunkalap.Hide;
		frmMainMenu.Show;
end;

procedure TfrmTroliMunkalap.btnWorksFelvetelClick(Sender : TObject);
var
	iWorkID,i,iTempID:	integer;
begin
	//Elv??gzett munka felv??tele a list??ba (lstWorks)
    //Az elv??gzett munk??b??l csak egyet szabad felvinni !
		iWorkID:=integer(cmbWorks.Items.Objects[cmbWorks.ItemIndex]);
		for i := 0 to lstWorks.Items.Count -1 do
    begin
        iTempID := integer(lstWorks.Items.Objects[i]);
        if (iWorkID = iTempID) then
          begin
            ShowMessage('A k??vetkez?? jav??t??s m??r szerepel a list??ban :' + #10 + #10 +
            	cmbWorks.Text);
            exit;
          end;
    end;
    writeLogMessage('Troli munka hozz??ad??sa : ' + cmbWorks.Text + ' ...Felhaszn??l?? : '+userName);
    lstWorks.Items.AddObject(cmbWorks.Text,TObject(iWorkID));
    lstWorks.Refresh;
end;

procedure TfrmTroliMunkalap.btnWorksTorlesAListabolClick(Sender : TObject);
begin
	//Kiv??lasztott munka t??rl??se a list??b??l :
    if (lstWorks.ItemIndex < 0) then exit;
    lstWorks.Items.Delete(lstWorks.ItemIndex);
    lstWorks.Refresh;
end;

procedure TfrmTroliMunkalap.btnAlkatreszFelvetelClick(Sender : TObject);
var
	iPartID:	integer;
begin
	//Alkatr??sz felv??tele a list??ba (lstFelvettAlkatreszek)
    //Ha egy alk.-b??l t??bbet is felhaszn??lt,akkor azt t??bbsz??r kell felvinni a list??ba !
    iPartID:=integer(cmbAlkatreszek.Items.Objects[cmbAlkatreszek.ItemIndex]);
    lstFelvettAlkatreszek.Items.AddObject(cmbAlkatreszek.Text,TObject(iPartID));
    lstFelvettAlkatreszek.Refresh;
    writeLogMessage('Troli alkatr??sz hozz??ad??sa : ' + cmbAlkatreszek.Text + ' ...Felhaszn??l?? : '+userName);
    //ShowMessage(inttostr(iPartID));
end;

procedure TfrmTroliMunkalap.btnAlkatreszTorlesAListabolClick(Sender : TObject);
begin
	//Kiv??lasztott alkatr??sz t??rl??se a list??b??l :
    if (lstFelvettAlkatreszek.ItemIndex < 0) then exit;
    lstFelvettAlkatreszek.Items.Delete(lstFelvettAlkatreszek.ItemIndex);
    lstFelvettAlkatreszek.Refresh;
end;

procedure TfrmTroliMunkalap.btnKilepLezarasNelkulClick(Sender : TObject);
begin
  frmTroliMunkalap.Close;
end;

procedure TfrmTroliMunkalap.btnMunkalapLezarasaClick(Sender : TObject);
var
	  sDate:      	string;
    sInfo:        AnsiString;
    iRepairID:		Integer;	//munkalap adatb??zis ID!
    i:						Integer;	//ciklusokhoz
    iTempID,iRet:	Integer;

begin

  //Lett felv??ve munka?
	if (lstWorks.Count = 0) then
    begin
      ShowMessage('Az elv??gzett munk??k k??z??l legal??bb egyet fel kell venni a list??ba !');
      cmbWorks.SetFocus;
      exit;
    end;
  //Ha az adott troli ki van irva a hetre prevora es nem lett bepipalva akkor feldobjuk a lehetoseget:
  if (bTroliPreventive = true and chkTroliPreventiv.Checked = false) then
    begin
      sInfo := 'Figyelem !' + chr(13) + chr(13) +
          'A troli (sorsz??m: ' + IntToStr(iTroliNumber) + ') erre a h??tre ki van ??rva prevent??v karbantart??sra!' + chr(13) +
          'Megt??rt??nt a prevent??v?';
      iRet := MessageDlg('Troli prevent??v meger??s??t??s...',sInfo,mtInformation,mbYesNo,0);
      if (iRet = mrYes) then chkTroliPreventiv.Checked := true;
    end;
	//Biztos hogy az adatok rendben vannak?
  sInfo := 'Figyelem !' + chr(13) + chr(13) +
    'A munkalap lez??r??sa ut??n m??r nincs lehet??s??g a munkalap adatainak m??dos??t??s??ra !' + chr(13) +
          'Biztos hogy lez??rja a munkalapot ?';
  iRet := MessageDlg('Munkalap lez??r??s meger??s??t??s...',sInfo,mtInformation,mbYesNo,0);
  if (iRet <> mrYes) then exit;

  try
    try
      //writeLogMessage('Troli munkalap hozz??ad??sa...');
      sDate := FormatDateTime('YYYY-MM-DD',Now); //'2010-04-25';
      myDataset := dbConnect('trolley_repair','SELECT * FROM trolley_repair ORDER BY id;','id');
      with myDataset do
          begin
              Insert;
              FieldByName('u_id').AsInteger := userDB_ID;
              FieldByName('tr_date').AsString := sDate;
              FieldByName('tr_comment').AsString := memMegjegyzesek.Text;
              FieldByName('tr_end').AsInteger := 1;
              FieldByName('tr_del').AsInteger := 0;
              FieldByName('tr_type').AsInteger := iTroliTipus;
              FieldByName('tr_ds7i').AsString := DS7i;
              FieldByName('tr_lineid').AsInteger := iLineID;
              FieldByName('tr_machine').AsInteger := iMachineID;
              FieldByName('tr_wd_num').AsString := sOperatorWDNum;
              FieldByName('tr_op_name').AsString := sOperatorName;
              FieldByName('tr_position').AsInteger := iTroliPosition;
              FieldByName('tr_number').AsInteger := iTroliNumber;
              FieldByName('tr_e_date').AsString := sKirakasDatuma;
              if (chkTroliPreventiv.Checked) then
                FieldByName('tr_preventiv').AsInteger := 1
              else
                FieldByName('tr_preventiv').AsInteger := 0;
              Post;
              ApplyUpdates;
          end;
    except
         on E: Exception do
         begin
             sInfo := 'TfrmTroliMunkalap.btnMunkalapLezarasaClick - '+e.Message +  chr(13) +
              'userDB_ID : ' + IntToStr(userDB_ID) + chr(13) +
              'sDate : ' + sDate + chr(13) +
              'memMegjegyzesek : ' + memMegjegyzesek.Text + chr(13) +
              'iTroliTipus : ' + IntToStr(iTroliTipus) + chr(13) +
              'DS7i : ' + DS7i + chr(13) +
              'iLineID : ' + IntToStr(iLineID) + chr(13) +
              'iMachineID : ' + inttostr(iMachineID) + chr(13) +
              'sOperatorWDNum : ' + sOperatorWDNum + chr(13) +
              'sOperatorName : ' + sOperatorName + chr(13) +
              'iTroliPosition : ' + IntToStr(iTroliPosition);
             //writeLogMessage(sInfo);
         end;
    end;
  finally
        dbClose(myDataset)
  end;

  Sleep(500);
  //Kell az ??j munkalap azonos??t??ja :
  try
    try
        writeLogMessage('Troli munkalap azonos??t?? lek??rdez??se...');
        myDataset := dbConnect('trolley_repair','SELECT * FROM trolley_repair WHERE tr_ds7i = "' + DS7i + '" AND u_id = '
          + IntToStr(userDB_ID) + ' ORDER BY id;','id');
	      myDataset.Last;
        iRepairID := myDataset.FieldByName('id').AsInteger;
	  except
         on E: Exception do
         begin
             sInfo := 'Kell az ??j munkalap azonos??t??ja :' + chr(13) +
              'TfrmTroliMunkalap.btnMunkalapLezarasaClick - '+e.Message +  chr(13) +
              'userDB_ID : ' + IntToStr(userDB_ID) + chr(13) +
              'SQL : ' + 'SELECT * FROM trolley_repair WHERE tr_ds7i = "' + DS7i +
              '" AND u_id = ' + IntToStr(userDB_ID) + ' ORDER BY id;';
             writeLogMessage(sInfo);
         end;
    end;
  finally
        dbClose(myDataset)
  end;

  //Felhaszn??lt alkatr??szek bejegyz??se :
  try
    try
        writeLogMessage('Troli felhaszn??lt alkatr??szek bejegyz??se...');
        myDataset := dbConnect('used_trolley_parts','SELECT * FROM used_trolley_parts ORDER BY id;','id');
        for i := 0 to lstFelvettAlkatreszek.Items.Count - 1 do
        begin
            iTempID := Integer(lstFelvettAlkatreszek.Items.Objects[i]);
            with myDataset do
            begin
                Insert;
                FieldByName('t_p_id').AsInteger := iTempID;
                FieldByName('t_r_id').AsInteger := iRepairID;
                Post;
                ApplyUpdates;
            end;
        end;
    except
         on E: Exception do
         begin
             sInfo := 'Felhaszn??lt alkatr??szek bejegyz??se :' + chr(13) +
              'TfrmTroliMunkalap.btnMunkalapLezarasaClick - '+e.Message +  chr(13) +
              't_p_id : ' + IntToStr(iTempID) + chr(13) +
              't_r_id : ' + IntToStr(iRepairID) + chr(13) +
              'lstFelvettAlkatreszek.Items.Count : ' + IntToStr(lstFelvettAlkatreszek.Items.Count) + chr(13) +
              'SQL : ' + 'SELECT * FROM used_trolley_parts ORDER BY id;';
             writeLogMessage(sInfo);
         end;
    end;
  finally
        dbClose(myDataset)
  end;

  Sleep(500);
  //Elv??gzett jav??t??sok bejegyz??se :
  try
    try
        writeLogMessage('Troli elv??gzett jav??t??sok hozz??ad??sa...');
        myDataset := dbConnect('trolley_works','SELECT * FROM trolley_works ORDER BY id;','id');
        for i := 0 to lstWorks.Items.Count - 1 do
        begin
            iTempID := Integer(lstWorks.Items.Objects[i]);
            with myDataset do
            begin
                Insert;
                FieldByName('t_r_code_id').AsInteger := iTempID;
                FieldByName('r_id').AsInteger := iRepairID;
                Post;
                ApplyUpdates;
            end;
        end;
    except
         on E: Exception do
         begin
             sInfo := 'Elv??gzett jav??t??sok bejegyz??se :' + chr(13) +
              'TfrmTroliMunkalap.btnMunkalapLezarasaClick - '+e.Message +  chr(13) +
              't_r_code_id : ' + IntToStr(iTempID) + chr(13) +
              'r_id : ' + IntToStr(iRepairID) + chr(13) +
              'lstWorks.Items.Count : ' + IntToStr(lstWorks.Items.Count) + chr(13) +
              'SQL : ' + 'SELECT * FROM trolley_works ORDER BY id;';
             writeLogMessage(sInfo);
         end;
    end;
  finally
          dbClose(myDataset)
  end;

  Sleep(500);

  //Ha preventiv volt a trolin akkor frissiteni kell a trolley_preventive -tablat is az aktualis heten!!
     try
        //writeLogMessage('Troli prevent??v bejegyz??se...');
        if (chkTroliPreventiv.Checked) then
          begin
            myDataset := dbConnect('trolley_preventive','update trolley_preventive set tr_p_ok = 1 ' +
              'where tr_p_ds7i = "' + IntToStr(iTroliNumber) + '" and tr_p_week = ' + IntToStr(wWeekNum) + ';','id');
            dbClose(myDataset);
          end;
    except
         on e: Exception do
         begin
             dbClose(myDataset);
             sInfo := 'Troli prevent??v bejegyz??se :' + chr(13) +
              'TfrmTroliMunkalap.btnMunkalapLezarasaClick - '+e.Message +  chr(13) +
              'chkTroliPreventiv.Checked : ';
             if (chkTroliPreventiv.Checked) then
               sInfo:=sInfo+'true'
             else
                sInfo:=sInfo+'false';
             //writeLogMessage(sInfo);
         end;
    end;



  //Az ??jonan nyitott munkalap lez??rva :
  writeLogMessage('Troli munkalap lez??r??sra ker??lt....Felhaszn??l?? : ' + userName);
  ShowMessage('A munkalap sikeresen lez??r??sra ker??lt !');
  frmTroliMunkalap.Hide;
  frmMainMenu.Show;

end;

procedure TfrmTroliMunkalap.FormShow(Sender : TObject);
type
  rFAdatok = record
    sDS7i					:string;
    sUname				:string;
    sWorks				:array of string;
    sParts				:array of string;
    sCost					:string;
    sComment			:string;
    sDate					:string;	//Jav??t??s d??tuma
    bPreventiv 		:Boolean;	//Ha prevent?? volt akkor = true
  end ;
var
   i,j,it,iRows,iActualRow										    :integer;
   sData,sSQL,sMelok,sTroliPreventiv					    :String;
   aTroliAdatok 															    :array of rFAdatok;
   iTad,iPartsNum,iWorksNum,iTworkID					    :integer;
   worksDataset,partsDataset,preventiveDataset		:TSqlite3Dataset;
   rPartsCost,rtCost													    :double;
   sTroliInfos																    :AnsiString;

begin

    writeLogMessage('Troli munkalap megjelen??t??se....Felhaszn??l?? : ' + userName);

  	//Mez??k be??ll??t??sa:
    edtKarbantarto.Text := userName;
    edtDS7i.Text := IntToStr(iTroliNumber); //DS7i;
    edtTroliTipus.Text := sTroliTipus;
		cmbWorks.Clear;
    lstWorks.Clear;
    lstWorks.Sorted := false;
		cmbAlkatreszek.Clear;
    lstFelvettAlkatreszek.Clear;
    lstFelvettAlkatreszek.Sorted := false;
    memMegjegyzesek.Text := '';
    chkTroliPreventiv.Checked := false;
    chkTroliPreventiv.Enabled := false;
    tabWorks.Show;
    wWeekNum:=WeekOfTheYear(Now); //aktualis het...

    troliJavitasokDataset := dbConnect('trolley_r_c','SELECT * FROM trolley_r_c;','id');
    sSQL := 'select * from parts where p_type = ' + IntToStr(iTroliTipus + 5) + ' and p_del = 0;';
		troliAlkatreszekDataset := dbConnect('parts',sSQL,'id');
    myDataset := dbConnect('trolley_repair','SELECT * FROM trolley_repair WHERE tr_del=0;','id');
    worksDataset := dbConnect('trolley_works','select * from trolley_works','id');
    partsDataset := dbConnect('used_trolley_parts','select * from used_trolley_parts','id');

    //Ha van az adott hetre preventive ehez a trolihoz akkor mehet a pipa...
    bTroliPreventive := false;
    preventiveDataset := dbConnect('trolley_preventive','select * from trolley_preventive where tr_p_week = ' +
      IntToStr(wWeekNum) + ' and tr_p_ds7i = "' + IntToStr(iTroliNumber) + '" and tr_p_ok = 0;','id');
    if (preventiveDataset.RecordCount > 0) then
    begin
      chkTroliPreventiv.Checked := true;
      chkTroliPreventiv.Enabled := true;
      bTroliPreventive := true;
    end;

    //Elv??gzend?? jav??t??sok felt??lt??se :
    Repeat
				sData := troliJavitasokDataset.FieldByName('tr_r_desc').AsString;
				it := troliJavitasokDataset.FieldByName('id').AsInteger;
        cmbWorks.Items.AddObject(sData,TObject(it));
				troliJavitasokDataset.Next;
    Until troliJavitasokDataset.Eof;
    cmbWorks.ItemIndex := 0;
    dbClose(troliJavitasokDataset);

    //Feederalkatr??szek felt??lt??se a feeder t??pus??t??l f??gg??en :
    if (troliAlkatreszekDataset.RecordCount > 0) then
     begin
        Repeat
          	sData := troliAlkatreszekDataset.FieldByName('p_ordernum').AsString + ' - '
            + troliAlkatreszekDataset.FieldByName('p_name').AsString;
              cmbAlkatreszek.Items.AddObject(sData,TObject(troliAlkatreszekDataset.FieldByName('id').AsInteger));
              troliAlkatreszekDataset.Next;
        Until troliAlkatreszekDataset.Eof;
        troliAlkatreszekDataset.First;
        cmbAlkatreszek.ItemIndex := 0;
     end;
    dbClose(troliAlkatreszekDataset);

    //A trolihoz tartoz?? adatok ??sszegy??jt??se :

    		//DS7i-hez tartoz?? lez??rt munkalapok :
        dbUpdate(myDataset,'select trolley_repair.id as rep_id,trolley_repair.tr_ds7i,trolley_repair.tr_date,' +
        	'trolley_repair.tr_comment,trolley_repair.tr_preventiv,users.id,users.u_name from trolley_repair,users where tr_ds7i="' +
        		DS7i + '" and tr_end = 1 and users.id = trolley_repair.u_id order by trolley_repair.id;');
        myDataset.First;
        iRows := myDataset.RecordCount;

        //v??gig kell menni a trolihoz tartoz?? munkalapokon:
				if (iRows > 0) then
        begin
					iActualRow := 1;
        	SetLength(aTroliAdatok,iRows+1);

          Repeat
            	//Aktu??lis munkalap db-id -je :
            		iTworkID := myDataset.FieldByName('rep_id').AsInteger;
            	//DS7i,jav??t??,d??tum,megjegyz??s kit??lt??se :
                aTroliAdatok[iActualRow].sDS7i := DS7i;
								aTroliAdatok[iActualRow].sUname := myDataset.FieldByName('u_name').AsString;
                aTroliAdatok[iActualRow].sComment := myDataset.FieldByName('tr_comment').AsString;
                aTroliAdatok[iActualRow].sDate:= myDataset.FieldByName('tr_date').AsString;
                if (myDataset.FieldByName('tr_preventiv').AsInteger = 0) then
                	aTroliAdatok[iActualRow].bPreventiv := false
                else
									aTroliAdatok[iActualRow].bPreventiv := true;

                //trolihoz tartoz?? elv??gzett munk??k :
                dbUpdate(worksDataset,'select trolley_r_c.tr_r_desc from trolley_r_c,trolley_works where trolley_works.r_id = '
                + IntToStr(iTworkID) + ' and trolley_works.t_r_code_id = trolley_r_c.id');
                sData := '';
                iWorksNum := worksDataset.RecordCount;
                SetLength(aTroliAdatok[iActualRow].sWorks,iWorksNum+1);
                //ShowMessage('iWorksNum : '+inttostr(iWorksNum));
                for i := 1 to iWorksNum do
                begin
                    aTroliAdatok[iActualRow].sWorks[i] := worksDataset.FieldByName('tr_r_desc').AsString;
                    worksDataset.Next;
                    //ShowMessage('Munka : '+aTroliAdatok[iActualRow].sWorks[i]);
                end;

                //troliba ??p??tett alkatr??szek :
                rPartsCost := 0;
                dbUpdate(partsDataset,'select parts.p_name,parts.p_cost from used_trolley_parts,parts where ' +
                	'used_trolley_parts.t_r_id = ' +	IntToStr(iTworkID) + ' and used_trolley_parts.t_p_id = parts.id;');
                sData := '';
                rPartsCost := 0;
                iPartsNum := partsDataset.RecordCount;
                SetLength(aTroliAdatok[iActualRow].sParts,iPartsNum+1);
                //ShowMessage('iPartsNum : '+inttostr(iPartsNum));
                for i := 1 to iPartsNum do
                begin
                		aTroliAdatok[iActualRow].sParts[i] := partsDataset.FieldByName('p_name').AsString;
                    try
                      rtCost := partsDataset.FieldByName('p_cost').AsFloat;
                    except
                      rtCost := 0;
                    end;
                    rPartsCost := rPartsCost + rtCost;
                    partsDataset.Next;
                    //ShowMessage('Alkatr??sz : '+aTroliAdatok[iActualRow].sParts[i]);
                end;

                if (rPartsCost <= 0) then aTroliAdatok[iActualRow].sCost := '0.0';
                if (rPartsCost > 0) then aTroliAdatok[iActualRow].sCost := FloatToStr(rPartsCost);

								iActualRow := iActualRow + 1;
                myDataset.Next;

          	Until myDataset.Eof;
        end ;
        dbClose(partsDataset);
        dbClose(worksDataset);

        //Adatok megjelen??t??se HTML t??bl??zatban :
				iTad := Length(aTroliAdatok);
        //ShowMessage('Troli adatok sz??ma : '+IntToStr(iTad));


        if (iTad > 0) then
        begin
          //van m??r ehez a trolihoz adat felv??ve...
          sTroliInfos := '';
          sTroliInfos := '<html><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head><body>';
          sTroliInfos := sTroliInfos +
          	'<table align="center" width="98%" border="1" CELLPADDING=4 CELLSPACING=0 >' +
						'<tr align="center" height="40px"><td><b>Azonos??t??</b></td><td><b>Jav. d??tum</b></td><td><b>Karbantart??</b></td>' +
            '<td><b>Elv??gzett munk??k</b></td><td><b>Felhaszn??lt alkatr??szek</b></td>' +
            '<td><b>K??lts??g (EUR)</b></td><td><b>Megjegyz??sek...</b></td><td><b>Prevent??v</b></td></tr>';

          for i := 1 to iTad-1 do
          begin
							iPartsNum := Length(aTroliAdatok[i].sParts);
              iWorksNum := Length(aTroliAdatok[i].sWorks);

              sTroliInfos := sTroliInfos + '<tr>' +
              	'<td><font size="1">' + aTroliAdatok[i].sDS7i + '</font></td>' +
                '<td><font size="1">' + aTroliAdatok[i].sDate + '</font></td>' +
                '<td><font size="1">' + aTroliAdatok[i].sUname + '</font></td>' +
                '<td align="left"><font size="1">';

              if (iWorksNum >= 1) then
                for j := 1 to iWorksNum-1 do
                begin
                    sTroliInfos := sTroliInfos + aTroliAdatok[i].sWorks[j];
                    if (iWorksNum > j) then sTroliInfos := sTroliInfos + '<br>';
                end
              else
              	sTroliInfos := sTroliInfos + '<br>';

              sTroliInfos := sTroliInfos + '</font></td><td align="left"><font size="1">';
              if (iPartsNum >= 1) then
                for j := 1 to iPartsNum-1 do
                begin
                    sTroliInfos := sTroliInfos + aTroliAdatok[i].sParts[j];
                    if (iPartsNum > j) then sTroliInfos := sTroliInfos + '<br>';
                end
              else
               	sTroliInfos := sTroliInfos + '<br>';

              if (aTroliAdatok[i].bPreventiv) then
              	sTroliPreventiv := 'IGEN'
              else
              	sTroliPreventiv := 'NEM';
              sTroliInfos := sTroliInfos + '</font></td><td><font size="1">' + aTroliAdatok[i].sCost +
                    '</font></td><td align="left"><font size="1">' + aTroliAdatok[i].sComment + '</font></td>' +
                    '<td><font size="1">' + sTroliPreventiv + '</font></td>';
              sTroliInfos := sTroliInfos + '</tr>';
          end;

          sTroliInfos := sTroliInfos + '</table></body></html>';
          IpHtmlPanel1.SetHtmlFromStr(sTroliInfos);

        end;

//ShowMessage(sTroliInfos);

        IpHtmlPanel1.Refresh;

        dbClose(myDataset);

end;

initialization
  {$I trolimunkalap.lrs}

end.

