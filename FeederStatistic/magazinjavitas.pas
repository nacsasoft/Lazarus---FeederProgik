unit magazinjavitas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LResources, Forms, Controls, Graphics, Dialogs,
  ComCtrls, StdCtrls, ExtCtrls, global, database, sqlite3ds;

type

  { TfrmMagazinJavitas }

  TfrmMagazinJavitas = class(TForm)
    btnAlkatreszFelvetel: TButton;
    btnAlkatreszTorlesAListabol: TButton;
    btnKilepLezarasNelkul: TButton;
    btnMunkalapLezarasa: TButton;
    btnWorksFelvetel: TButton;
    btnWorksTorlesAListabol: TButton;
    cmbAlkatreszek: TComboBox;
    cmbWorks: TComboBox;
    edtMagazinAzonosito: TEdit;
    Label1: TLabel;
    lstFelvettAlkatreszek: TListBox;
    lstWorks: TListBox;
    memMegjegyzesek: TMemo;
    Shape1: TShape;
    Shape3: TShape;
    Shape4: TShape;
    tabComment: TTabSheet;
    tabMainSheet: TPageControl;
    tabUsedParts: TTabSheet;
    tabWorks: TTabSheet;
    procedure btnAlkatreszFelvetelClick(Sender: TObject);
    procedure btnAlkatreszTorlesAListabolClick(Sender: TObject);
    procedure btnKilepLezarasNelkulClick(Sender: TObject);
    procedure btnMunkalapLezarasaClick(Sender: TObject);
    procedure btnWorksFelvetelClick(Sender: TObject);
    procedure btnWorksTorlesAListabolClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    myDataset:             TSqlite3Dataset;

  public
    { public declarations }
  end;

var
  frmMagazinJavitas: TfrmMagazinJavitas;

implementation
uses
  fomenu;

{ TfrmMagazinJavitas }

procedure TfrmMagazinJavitas.FormCloseQuery(Sender: TObject; var CanClose : boolean);
  var
   iRet:  integer;
   sInfo: string;
begin
    //writeLogMessage('Magazin munkalap - kilépés mentés nélkül start : '+userName);
    sInfo := 'Figyelem !' + chr(13) + chr(13) +
    		'Ha most kilép, a munkalap törlésre kerül !' + chr(13) +
           	'Biztos hogy ki akar lépni ?';
    iRet := MessageDlg('Kilépés lezárás nélkül...',sInfo,mtWarning,mbYesNo,0);
    if (iRet <> mrYes) then
    begin
        CanClose := false;
        exit;
    end ;
    CanClose := true;

    frmMagazinJavitas.Hide;
		frmMainMenu.Show;
end;

procedure TfrmMagazinJavitas.FormShow(Sender: TObject);
var
  sSQL: AnsiString;
  sData: string;
  it: integer;
  worksDataset, magazinAlkatreszekDataset:             TSqlite3Dataset;

begin
  edtMagazinAzonosito.Text := '';
  cmbWorks.Clear;
  lstWorks.Clear;
  lstWorks.Sorted := false;
	cmbAlkatreszek.Clear;
  lstFelvettAlkatreszek.Clear;
  lstFelvettAlkatreszek.Sorted := false;
  memMegjegyzesek.Text := '';
  tabWorks.Show;

  worksDataset := dbConnect('magazin_works','select * from magazin_works','id');
  sSQL := 'select * from parts where p_type = 8 and p_del = 0;';
	magazinAlkatreszekDataset := dbConnect('parts',sSQL,'id');

  //Elvégzendő munkák feltöltése :
    Repeat
				sData := worksDataset.FieldByName('mw_desc').AsString;
				it := worksDataset.FieldByName('id').AsInteger;
        cmbWorks.Items.AddObject(sData,TObject(it));
				worksDataset.Next;
    Until worksDataset.Eof;
    cmbWorks.ItemIndex := 0;
    dbClose(worksDataset);

    //Magazin alkatrészek feltöltése :
    if (magazinAlkatreszekDataset.RecordCount > 0) then
     begin
        Repeat
          	sData := magazinAlkatreszekDataset.FieldByName('p_ordernum').AsString + ' - '
            + magazinAlkatreszekDataset.FieldByName('p_name').AsString;
              cmbAlkatreszek.Items.AddObject(sData,TObject(magazinAlkatreszekDataset.FieldByName('id').AsInteger));
              magazinAlkatreszekDataset.Next;
        Until magazinAlkatreszekDataset.Eof;
        magazinAlkatreszekDataset.First;
        cmbAlkatreszek.ItemIndex := 0;
     end;
    dbClose(magazinAlkatreszekDataset);


end;

procedure TfrmMagazinJavitas.btnWorksFelvetelClick(Sender: TObject);
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
              ShowMessage('A következő javítás már szerepel a listában :' + #10 + #10 +
              	cmbWorks.Text);
              exit;
            end;
      end;
      //writeLogMessage('Troli munka hozzáadása : ' + cmbWorks.Text + ' ...Felhasználó : '+userName);
      lstWorks.Items.AddObject(cmbWorks.Text,TObject(iWorkID));
      lstWorks.Refresh;
  end;

procedure TfrmMagazinJavitas.btnAlkatreszFelvetelClick(Sender: TObject);
  var
  	iPartID:	integer;
  begin
  	//Alkatrész felvétele a listába (lstFelvettAlkatreszek)
      //Ha egy alk.-ből többet is felhasznált,akkor azt többször kell felvinni a listába !
      iPartID:=integer(cmbAlkatreszek.Items.Objects[cmbAlkatreszek.ItemIndex]);
      lstFelvettAlkatreszek.Items.AddObject(cmbAlkatreszek.Text,TObject(iPartID));
      lstFelvettAlkatreszek.Refresh;
      //writeLogMessage('Troli alkatrész hozzáadása : ' + cmbAlkatreszek.Text + ' ...Felhasználó : '+userName);
      //ShowMessage(inttostr(iPartID));
  end;

procedure TfrmMagazinJavitas.btnAlkatreszTorlesAListabolClick(Sender: TObject);
  begin
  	//Kiválasztott alkatrész törlése a listából :
      if (lstFelvettAlkatreszek.ItemIndex < 0) then exit;
      lstFelvettAlkatreszek.Items.Delete(lstFelvettAlkatreszek.ItemIndex);
      lstFelvettAlkatreszek.Refresh;
  end;

procedure TfrmMagazinJavitas.btnKilepLezarasNelkulClick(Sender: TObject);
begin
  frmMagazinJavitas.Close;
end;

procedure TfrmMagazinJavitas.btnMunkalapLezarasaClick(Sender: TObject);
  var
  	  sDate:      	string;
      sInfo:        AnsiString;
      iRepairID:		Integer;	//munkalap adatbázis ID!
      i:						Integer;	//ciklusokhoz
      iTempID,iRet:	Integer;

  begin

    //Lett felvíve munka?
  	if (lstWorks.Count = 0) then
      begin
        ShowMessage('Az elvégzett munkák közül legalább egyet fel kell venni a listába !');
        cmbWorks.SetFocus;
        exit;
      end;
    if (trim(edtMagazinAzonosito.Text) = '') then
      begin
        ShowMessage('A magazin azonosító mező kitöltése kötelező!');
        edtMagazinAzonosito.SetFocus;
        exit;
      end;
  	//Biztos hogy az adatok rendben vannak?
    sInfo := 'Figyelem !' + chr(13) + chr(13) +
      	'A munkalap lezárása után már nincs lehetőség a munkalap adatainak módosítására !' + chr(13) +
            'Biztos hogy lezárja a munkalapot ?';
    iRet := MessageDlg('Munkalap lezárás megerősítés...',sInfo,mtInformation,mbYesNo,0);
    if (iRet <> mrYes) then exit;

    DS7i := edtMagazinAzonosito.Text;

    try
      try
        //writeLogMessage('Troli munkalap hozzáadása...');
        sDate := FormatDateTime('YYYY-MM-DD',Now); //'2010-04-25';
        myDataset := dbConnect('magazin_repair','SELECT * FROM magazin_repair ORDER BY id;','id');
        with myDataset do
            begin
                Insert;
                FieldByName('u_id').AsInteger := userDB_ID;
                FieldByName('m_date').AsString := sDate;
                FieldByName('m_comment').AsString := memMegjegyzesek.Text;
                FieldByName('m_end').AsInteger := 1;
                FieldByName('m_del').AsInteger := 0;
                FieldByName('m_ds7i').AsString := DS7i;
                Post;
                ApplyUpdates;
            end;
      except
           on E: Exception do
           begin
               sInfo := 'TfrmMagazinJavitas.btnMunkalapLezarasaClick - '+e.Message +  chr(13) +
                'userDB_ID : ' + IntToStr(userDB_ID) + chr(13) +
                'sDate : ' + sDate + chr(13) +
                'memMegjegyzesek : ' + memMegjegyzesek.Text + chr(13) +
                'DS7i : ' + DS7i + chr(13);
               writeLogMessage(sInfo);
           end;
      end;
    finally
          dbClose(myDataset)
    end;

    Sleep(500);
    //Kell az új munkalap azonosítója :
    try
      try
          //writeLogMessage('Troli munkalap azonosító lekérdezése...');
          myDataset := dbConnect('magazin_repair','SELECT * FROM magazin_repair WHERE m_ds7i = "' + DS7i + '" AND u_id = '
            + IntToStr(userDB_ID) + ' ORDER BY id;','id');
  	      myDataset.Last;
          iRepairID := myDataset.FieldByName('id').AsInteger;
  	  except
           on E: Exception do
           begin
               sInfo := 'Kell az új munkalap azonosítója :' + chr(13) +
                'magazinjavitas.btnMunkalapLezarasaClick - '+e.Message +  chr(13) +
                'userDB_ID : ' + IntToStr(userDB_ID) + chr(13) +
                'SQL : ' + 'SELECT * FROM magazin_repair WHERE m_ds7i = "' + DS7i +
                '" AND u_id = ' + IntToStr(userDB_ID) + ' ORDER BY id;';
               writeLogMessage(sInfo);
           end;
      end;
    finally
          dbClose(myDataset)
    end;

    //Felhasznált alkatrészek bejegyzése :
    try
      try
          //writeLogMessage('Magazin felhasznált alkatrészek bejegyzése...');
          myDataset := dbConnect('used_magazin_parts','SELECT * FROM used_magazin_parts ORDER BY id;','id');
          for i := 0 to lstFelvettAlkatreszek.Items.Count - 1 do
          begin
              iTempID := Integer(lstFelvettAlkatreszek.Items.Objects[i]);
              with myDataset do
              begin
                  Insert;
                  FieldByName('m_p_id').AsInteger := iTempID;
                  FieldByName('m_r_id').AsInteger := iRepairID;
                  Post;
                  ApplyUpdates;
              end;
          end;
      except
           on E: Exception do
           begin
               sInfo := 'Felhasznált alkatrészek bejegyzése :' + chr(13) +
                'magazinjavitas.btnMunkalapLezarasaClick - '+e.Message +  chr(13) +
                'm_p_id : ' + IntToStr(iTempID) + chr(13) +
                'm_r_id : ' + IntToStr(iRepairID) + chr(13) +
                'lstFelvettAlkatreszek.Items.Count : ' + IntToStr(lstFelvettAlkatreszek.Items.Count) + chr(13) +
                'SQL : ' + 'SELECT * FROM used_magazin_parts ORDER BY id;';
               writeLogMessage(sInfo);
           end;
      end;
    finally
          dbClose(myDataset)
    end;

    Sleep(500);
    //Elvégzett javítások bejegyzése :
    try
      try
          //writeLogMessage('Magazinon elvégzett javítások hozzáadása...');
          myDataset := dbConnect('magazin_repair_works','SELECT * FROM magazin_repair_works ORDER BY id;','id');
          for i := 0 to lstWorks.Items.Count - 1 do
          begin
              iTempID := Integer(lstWorks.Items.Objects[i]);
              with myDataset do
              begin
                  Insert;
                  FieldByName('m_r_code_id').AsInteger := iTempID;
                  FieldByName('m_id').AsInteger := iRepairID;
                  Post;
                  ApplyUpdates;
              end;
          end;
      except
           on E: Exception do
           begin
               sInfo := 'Elvégzett javítások bejegyzése :' + chr(13) +
                'magazinjavitas.btnMunkalapLezarasaClick - '+e.Message +  chr(13) +
                'm_r_code_id : ' + IntToStr(iTempID) + chr(13) +
                'm_id : ' + IntToStr(iRepairID) + chr(13) +
                'lstWorks.Items.Count : ' + IntToStr(lstWorks.Items.Count) + chr(13) +
                'SQL : ' + 'SELECT * FROM magazin_repair_works ORDER BY id;';
               writeLogMessage(sInfo);
           end;
      end;
    finally
            dbClose(myDataset)
    end;

    //Sleep(500);

    //Az újonan nyitott munkalap lezárva :
    //writeLogMessage('Troli munkalap lezárásra került....Felhasználó : ' + userName);
    ShowMessage('A munkalap sikeresen lezárásra került !');
    frmMagazinJavitas.Hide;
    frmMainMenu.Show;
  end;


procedure TfrmMagazinJavitas.btnWorksTorlesAListabolClick(Sender: TObject);
  begin
  	//Kiválasztott munka törlése a listából :
      if (lstWorks.ItemIndex < 0) then exit;
      lstWorks.Items.Delete(lstWorks.ItemIndex);
      lstWorks.Refresh;
  end;

initialization
  {$I magazinjavitas.lrs}

end.

