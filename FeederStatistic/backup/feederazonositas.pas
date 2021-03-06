unit feederazonositas ;

{$mode objfpc}

interface

uses
  Classes , SysUtils , FileUtil , LResources , Forms , Controls , Graphics , 
      Dialogs , StdCtrls, ExtCtrls, MaskEdit , global , database , Sqlite3DS;

type

  { TfrmFeederAzonositas }

  TfrmFeederAzonositas = class(TForm)
      btnMegsem: TButton ;
      btnOK: TButton ;
      cmbLines: TComboBox ;
      cmbErrorCodes : TComboBox;
      cmbMachines : TComboBox;
      cmbTipus: TComboBox ;
      cmbMeret: TComboBox ;
      edtAdagolo : TEdit;
      edtAdagoloOldal : TEdit;
      edtDS7i: TEdit ;
      edtKirakas_EV : TEdit;
      edtKirakas_HO : TEdit;
      edtKirakas_NAP : TEdit;
      edtOldal : TEdit;
      edtOperatorWD: TEdit;
      edtOperatorName: TEdit;
      Label1: TLabel ;
      Label10 : TLabel;
      Label11 : TLabel;
      Label12 : TLabel;
      Label13 : TLabel;
      Label14 : TLabel;
      Label2: TLabel ;
      Label3: TLabel ;
      Label4: TLabel ;
      Label5: TLabel;
      Label6: TLabel;
      Label7 : TLabel;
      Label8 : TLabel;
      Label9 : TLabel;
      procedure btnMegsemClick(Sender: TObject) ;
      procedure btnOKClick(Sender: TObject) ;
      procedure cmbLinesChange(Sender : TObject);
      procedure cmbTipusChange(Sender: TObject) ;
      procedure FormCloseQuery(Sender: TObject ; var CanClose: boolean) ;
      procedure FormShow(Sender: TObject) ;
  private
    { private declarations }
			myDataset					:TSqlite3Dataset;
      procedure SetFeederSize(iFType: integer);

  public
    { public declarations }
	end ;

var
  frmFeederAzonositas: TfrmFeederAzonositas ;

implementation
	uses fomenu, ujmunkalap;

{ TfrmFeederAzonositas }

procedure TfrmFeederAzonositas.btnMegsemClick(Sender: TObject) ;
begin
    frmFeederAzonositas.Hide;
    frmMainMenu.Show;
end;

procedure TfrmFeederAzonositas.btnOKClick(Sender: TObject) ;
var
  	iE_code:	integer;

begin
    //Minden mező kitöltése kötelező :
    if (Trim(edtDS7i.Text) = '') then
    begin
        ShowMessage('A DS7i mező kitöltése kötelező !');
        exit;
    end;

    iFeederType := cmbTipus.ItemIndex;
    iLineID := integer(cmbLines.Items.Objects[cmbLines.ItemIndex]);

    //Siemens és Fuji feedereknél kötelező megadni a sor,gép,sáv,hibakód adatokat:
    if ((iFeederType < 3) or (iFeederType = 5)) and (iLineID <> 14) then
      begin
      	//Siemens - Fuji feederek....
			  if (Trim(cmbLines.Text) = '') or (trim(cmbMachines.Text) = '') or
      	  (trim(edtOldal.Text) = '') or (trim(edtAdagolo.Text) = '') or
          (trim(edtAdagoloOldal.Text) = '')  or (trim(edtKirakas_EV.Text) = '') or
          (trim(edtKirakas_HO.Text) = '') or (trim(edtKirakas_NAP.Text) = '') then
          begin
            ShowMessage('A sor,gép,sáv,kirakás dátuma,hibakód mezők kitöltése kötelező!');
            exit;
          end;
        if (Length(edtOperatorWD.Text) > 1) and (IsStrANumber(edtOperatorWD.Text) = false) then
          begin
    	      ShowMessage('A Workday azonosító csak szám lehet!');
            exit;
          end;
        if (Trim(edtOperatorWD.Text) = '') and (Trim(edtOperatorName.Text) = '') then
          begin
              ShowMessage('WorkDay azonosító, és az Operátor Neve mezők közül az egyik kitöltése kötelező !');
              exit;
          end;
        //adagoló pozíció csak szám lehe (pl.: 3/25/2)
        if (IsStrANumber(edtOldal.Text) = false) or (IsStrANumber(edtAdagolo.Text) = false) or
          (IsStrANumber(edtAdagoloOldal.Text) = false) then
            begin
              ShowMessage('A sáv mezők csak számokat tartalmazhatnak!');
              edtOldal.SetFocus;
              exit;
            end;
        if (IsStrANumber(edtKirakas_EV.Text) = false) or (IsStrANumber(edtKirakas_HO.Text) = false) or
          (IsStrANumber(edtKirakas_NAP.Text) = false) then
            begin
              ShowMessage('A kirakás dátuma mezők csak számokat tartalmazhatnak!');
              edtKirakas_EV.SetFocus;
              exit;
            end;
        sFeederSize := cmbMeret.Text;
        iFeederSize := integer(cmbMeret.Items.Objects[cmbMeret.ItemIndex]);
        sLine := cmbLines.Text;
        iMachineID := integer(cmbMachines.Items.Objects[cmbMachines.ItemIndex]);
        sFeederPosition := edtOldal.Text + '/' + edtAdagolo.Text + '/' + edtAdagoloOldal.Text;
        if (Length(Trim(edtKirakas_HO.Text)) = 1) then edtKirakas_HO.Text := '0' + edtKirakas_HO.Text;
				if (Length(Trim(edtKirakas_NAP.Text)) = 1) then edtKirakas_NAP.Text := '0' + edtKirakas_NAP.Text;
        sKirakasDatuma := edtKirakas_EV.Text + '-' + edtKirakas_HO.Text + '-' + edtKirakas_NAP.Text;
        iErrorCode := integer(cmbErrorCodes.Items.Objects[cmbErrorCodes.ItemIndex]);

        //ShowMessage(IntToStr(iFeederSize));
      end
    else
      begin
        if (iSorId = 14) then
            begin
              //setup-ból jött....
				      sFeederSize := cmbMeret.Text;
        			iFeederSize := integer(cmbMeret.Items.Objects[cmbMeret.ItemIndex]);
              sLine := cmbLines.Text;
        			iLineID := integer(cmbLines.Items.Objects[cmbLines.ItemIndex]);
              iMachineID := -1;
              sFeederPosition := '';
              sKirakasDatuma := edtKirakas_EV.Text + '-' + edtKirakas_HO.Text + '-' + edtKirakas_NAP.Text;
        			iErrorCode := integer(cmbErrorCodes.Items.Objects[cmbErrorCodes.ItemIndex]);
              //ShowMessage('SETUP');
            end
        else
        		begin
              //rli,seq,vcd adagolók....
				      sFeederSize := '';
              iFeederSize := -1;
              sLine := '';
              iLineID := -1;
              iMachineID := -1;
              sFeederPosition := '';
              sKirakasDatuma := edtKirakas_EV.Text + '-' + edtKirakas_HO.Text + '-' + edtKirakas_NAP.Text;
        			iErrorCode := integer(cmbErrorCodes.Items.Objects[cmbErrorCodes.ItemIndex]);
              //ShowMessage('OK');
        		end;
      end;

    if (trim(edtOperatorWD.Text) = '') then
        sOperatorWDNum := '0'
    else
      sOperatorWDNum := edtOperatorWD.Text;

    //sOperatorWDNum := edtOperatorWD.Text;
    sOperatorName:=edtOperatorName.Text;

    {ShowMessage('Típus : ' + IntToStr(iFeederType) + #10 +
    						'Méret : ' + IntToStr(iFeederSize) + #10 +
                'Sor   : ' + IntToStr(iLineID) + #10 +
                'Gép   : ' + IntToStr(iMachineID) + #10 +
                'Sáv   : ' + sFeederPosition + #10 +
                'Hibakód : ' + IntToStr(iErrorCode));}

    frmFeederAzonositas.Hide;
    frmUjMunkalap.Show;
end;

procedure TfrmFeederAzonositas.cmbLinesChange(Sender : TObject);
var
    iSorId  :integer;

begin
	//Ha a SETUP-van kiválasztva akkor nem kell felvinni gépet,sávot.
  iSorId := integer(cmbLines.Items.Objects[cmbLines.ItemIndex]);

  if (iSorId = 14) then
      begin
        cmbMachines.Enabled := false;
        edtOldal.Enabled := false;
        edtAdagolo.Enabled := false;
        edtAdagoloOldal.Enabled := false;
        edtKirakas_EV.Enabled := false;
        edtKirakas_HO.Enabled := false;
        edtKirakas_NAP.Enabled := false;
        //cmbErrorCodes.Enabled := false;
      end
  else
  		begin
				cmbMachines.Enabled := true;
        edtOldal.Enabled := true;
        edtAdagolo.Enabled := true;
        edtAdagoloOldal.Enabled := true;
        edtKirakas_EV.Enabled := true;
        edtKirakas_HO.Enabled := true;
        edtKirakas_NAP.Enabled := true;
        cmbErrorCodes.Enabled := true;
  		end;
end;

procedure TfrmFeederAzonositas.cmbTipusChange(Sender: TObject) ;
begin
    //Típushoz tartozó méretek beállítása (ahol szükséges)...
    SetFeederSize(cmbTipus.ItemIndex);
end;

procedure TfrmFeederAzonositas.FormCloseQuery(Sender: TObject ;
    var CanClose: boolean) ;

begin
    //ShowMessage('kilépés');
    CanClose := true;
		frmMainMenu.Show;
end;

procedure TfrmFeederAzonositas.FormShow(Sender: TObject) ;
var
	sData							:string;
begin
    cmbLines.Clear;
    edtOperatorWD.Text:='';
    //sorok lista feltöltése :
    myDataset := dbConnect('line','SELECT * FROM sorok where torolve = 0;','name');
    if (myDataset.RecordCount > 0) then
    begin
        Repeat
              sData := myDataset.FieldByName('name').AsString;
              cmbLines.Items.AddObject(sData,TObject(myDataset.FieldByName('id').AsInteger));
              myDataset.Next;
        Until myDataset.Eof;
        cmbLines.ItemIndex := 0;
		end;

    //Hibakód lista feltöltése :
    cmbErrorCodes.Clear;
    dbUpdate(myDataset,'select * from error_codes order by id;');
		Repeat
        sData := myDataset.FieldByName('e_code').AsString + ' - ' + myDataset.FieldByName('e_desc').AsString;
        cmbErrorCodes.Items.AddObject(sData,TObject(myDataset.FieldByName('id').AsInteger));
        myDataset.Next;
    Until myDataset.Eof;
    cmbErrorCodes.ItemIndex := 0;

    //géptípusok lista feltöltése :
		cmbMachines.Clear;
    dbUpdate(myDataset,'select * from machines where torolve = 0 order by m_name;');
		Repeat
        sData := myDataset.FieldByName('m_name').AsString;
        cmbMachines.Items.AddObject(sData,TObject(myDataset.FieldByName('id').AsInteger));
        myDataset.Next;
    Until myDataset.Eof;
    cmbMachines.ItemIndex := 0;

    cmbMachines.Enabled := true;
    edtOldal.Enabled := true;
    edtAdagolo.Enabled := true;
    edtAdagoloOldal.Enabled := true;
    edtKirakas_EV.Enabled := true;
		edtKirakas_HO.Enabled := true;
		edtKirakas_NAP.Enabled := true;
    cmbErrorCodes.Enabled := true;

		myDataset.Close;
    edtDS7i.Text := DS7i;
    edtOperatorName.Text:='';
    edtOperatorWD.Text:='';
    edtOldal.Text := '';
    edtAdagolo.Text := '';
    edtAdagoloOldal.Text := '';
    edtKirakas_EV.Text := FormatDateTime('YYYY',Now);
    edtKirakas_HO.Text := FormatDateTime('MM',Now);
    edtKirakas_NAP.Text := FormatDateTime('DD',Now);
    //SetFeederSize(0);
    //Típushoz tartozó méretek beállítása (ahol szükséges)...
    cmbTipus.ItemIndex := 0;
    SetFeederSize(cmbTipus.ItemIndex);
    edtOperatorWD.SetFocus;
end;

procedure TfrmFeederAzonositas.SetFeederSize(iFType: integer);
var
  	feeder_size_dataset	:TSqlite3Dataset;
    sData								:string;
    it									:integer;

begin
    cmbMeret.Items.Clear;
    feeder_size_dataset := dbConnect('feeder_size','select * from feeder_size where type = ' + inttostr(iFType) + ';','id');
    cmbMeret.Enabled 					:= true;
    cmbLines.Enabled 					:= true;
    cmbMachines.Enabled 			:= true;
    edtOldal.Enabled 					:= true;
    edtAdagolo.Enabled 				:= true;
    edtAdagoloOldal.Enabled 	:= true;
    cmbErrorCodes.Enabled 		:= true;
    edtKirakas_EV.Enabled 		:= true;
		edtKirakas_HO.Enabled 		:= true;
		edtKirakas_NAP.Enabled 		:= true;

    //Adagolóméret legördülő beállítása a típusnak megfelelően...
    if (iFType < 3) or (iFType = 5) then
        begin
            Repeat
				        sData := feeder_size_dataset.FieldByName('size').AsString;
				        it := feeder_size_dataset.FieldByName('id').AsInteger;
                cmbMeret.Items.AddObject(sData,TObject(it));
				        feeder_size_dataset.Next;
            Until feeder_size_dataset.Eof;
        end
		else
    	begin
				cmbMeret.Enabled 				:= false;
        cmbLines.Enabled 				:= false;
        cmbMachines.Enabled 		:= false;
    		edtOldal.Enabled 				:= false;
    		edtAdagolo.Enabled 			:= false;
    		edtAdagoloOldal.Enabled := false;
        edtKirakas_EV.Enabled 	:= false;
        edtKirakas_HO.Enabled 	:= false;
        edtKirakas_NAP.Enabled 	:= false;
        cmbErrorCodes.Enabled 	:= false;
    	end ;

    if (cmbLines.ItemIndex = 13) then
      begin
				cmbMachines.Enabled := false;
        edtOldal.Enabled := false;
        edtAdagolo.Enabled := false;
        edtAdagoloOldal.Enabled := false;
      end;


    cmbMeret.Update;
    cmbMeret.ItemIndex := 0;
    dbClose(feeder_size_dataset);
end ;

initialization
  {$I feederazonositas.lrs}

end.

