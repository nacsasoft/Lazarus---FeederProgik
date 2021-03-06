unit sorbeallitasa ;

{$mode objfpc}

interface

uses
  Classes , SysUtils , FileUtil , LResources , Forms , Controls , Graphics , 
      Dialogs , StdCtrls, MaskEdit , global , database , Sqlite3DS;

type

  { TfrmSorBeallitasa }

  TfrmSorBeallitasa = class(TForm)
      btnOK: TButton ;
      cmbErrorCodes : TComboBox;
      cmbLines: TComboBox ;
      cmbMachines : TComboBox;
      edtAdagolo : TEdit;
      edtKirakas_HO : TEdit;
      edtAdagoloOldal : TEdit;
      edtKirakas_NAP : TEdit;
      edtKirakas_EV : TEdit;
      edtOperatorName: TEdit;
      edtOperatorWD: TEdit;
      edtOldal : TEdit;
      Label10 : TLabel;
      Label11 : TLabel;
      Label12 : TLabel;
      Label13 : TLabel;
      Label14 : TLabel;
      Label4: TLabel ;
      Label5: TLabel;
      Label6: TLabel;
      Label7 : TLabel;
      Label8 : TLabel;
      Label9 : TLabel;
      procedure btnOKClick(Sender: TObject) ;
      procedure cmbLinesChange(Sender : TObject);
      procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
      procedure FormShow(Sender: TObject) ;
  private
    { private declarations }
      myDataset					:TSqlite3Dataset;

  public
    { public declarations }
  end ; 

var
  frmSorBeallitasa: TfrmSorBeallitasa ;

implementation

uses fomenu,ujmunkalap;

{ TfrmSorBeallitasa }

{ TfrmSorBeallitasa }

procedure TfrmSorBeallitasa.btnOKClick(Sender: TObject) ;
begin
    //ShowMessage(IntToStr(cmbLines.ItemIndex));
    iLineID := integer(cmbLines.Items.Objects[cmbLines.ItemIndex]);

    //Siemens és Fuji feedereknél kötelező megadni a sor,gép,sáv, kirakás dátuma,hibakód adatokat:
    if (iFeederType < 3) and (iLineID <> 14) then
      begin
			  if (Trim(cmbLines.Text) = '') or (trim(cmbMachines.Text) = '') or
      	  (trim(edtOldal.Text) = '') or (trim(edtAdagolo.Text) = '') or
          (trim(edtAdagoloOldal.Text) = '') or (trim(edtKirakas_EV.Text) = '') or
          (trim(edtKirakas_HO.Text) = '') or (trim(edtKirakas_NAP.Text) = '') then
          begin
            ShowMessage('A sor,gép,sáv,kirakás dátuma,hibakód mezők kitöltése kötelező!');
            exit;
          end;
        if (Trim(edtOperatorWD.Text) = '') and (Trim(edtOperatorName.Text) = '') then
          begin
              ShowMessage('WorkDay azonosító, vagy az Operátor Neve mezők közül az egyik kitöltése kötelező !');
              exit;
          end;
        if (Length(edtOperatorWD.Text) > 1) and (IsStrANumber(edtOperatorWD.Text) = false) then
          begin
    	      ShowMessage('A Workday azonosító csak szám lehet!');
            exit;
          end;
        //adagoló pozíció csak szám lehet (pl.: 3/25/2)
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
        sLine := cmbLines.Text;

        iMachineID := integer(cmbMachines.Items.Objects[cmbMachines.ItemIndex]);
        sFeederPosition := edtOldal.Text + '/' + edtAdagolo.Text + '/' + edtAdagoloOldal.Text;
        if (Length(Trim(edtKirakas_HO.Text)) = 1) then edtKirakas_HO.Text := '0' + edtKirakas_HO.Text;
				if (Length(Trim(edtKirakas_NAP.Text)) = 1) then edtKirakas_NAP.Text := '0' + edtKirakas_NAP.Text;
        sKirakasDatuma := edtKirakas_EV.Text + '-' + edtKirakas_HO.Text + '-' + edtKirakas_NAP.Text;
        iErrorCode := integer(cmbErrorCodes.Items.Objects[cmbErrorCodes.ItemIndex]);
        //ShowMessage(sKirakasDatuma);
      end
    else
      begin
        if (iLineID = 14) then
            begin
              //setup-ból jött....
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
              //ShowMessage('VCD');
        		end;
      end;

		{ ShowMessage('Sor   : ' + IntToStr(iLineID) + #10 +
                'Gép   : ' + IntToStr(iMachineID) + #10 +
                'Sáv   : ' + sFeederPosition + #10 +
                'Hibakód : ' + IntToStr(iErrorCode)); }

    if (trim(edtOperatorWD.Text) = '') then
        sOperatorWDNum := '0'
    else
      sOperatorWDNum := edtOperatorWD.Text;

    frmSorBeallitasa.Hide;
    frmUjMunkalap.Show;
end;

procedure TfrmSorBeallitasa.cmbLinesChange(Sender : TObject);
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

procedure TfrmSorBeallitasa.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  frmSorBeallitasa.Hide;
  frmMainMenu.Show;
end;

procedure TfrmSorBeallitasa.FormShow(Sender: TObject) ;
var
  sData: string;
begin
  	//sorok feltöltése :
    cmbLines.Clear;
    myDataset := dbConnect('line','SELECT * FROM sorok where torolve = 0;','name');
    if (myDataset.RecordCount > 0) then
    begin
        Repeat
        		sData := myDataset.FieldByName('name').AsString;
            cmbLines.Items.AddObject(sData,TObject(myDataset.FieldByName('id').AsInteger));
            myDataset.Next;
        Until myDataset.Eof;
        myDataset.First;
        cmbLines.ItemIndex := iLineID - 1;  // 0;
		end;

    //géptípusok feltöltése :
		cmbMachines.Clear;
    dbUpdate(myDataset,'SELECT * FROM machines where torolve = 0 order by m_name;');
    if (myDataset.RecordCount > 0) then
    begin
        Repeat
        		sData := myDataset.FieldByName('m_name').AsString;
            cmbMachines.Items.AddObject(sData,TObject(myDataset.FieldByName('id').AsInteger));
            myDataset.Next;
        Until myDataset.Eof;
        myDataset.First;
        cmbMachines.ItemIndex := 0;
		end;

    //Hibakód lista feltöltése :
    cmbErrorCodes.Clear;
    dbUpdate(myDataset,'select * from error_codes order by id;');
		Repeat
        sData := myDataset.FieldByName('e_code').AsString + ' - ' + myDataset.FieldByName('e_desc').AsString;
        cmbErrorCodes.Items.AddObject(sData,TObject(myDataset.FieldByName('id').AsInteger));
        myDataset.Next;
    Until myDataset.Eof;
    cmbErrorCodes.ItemIndex := iErrorCode - 1;  // 0;
    if (iFeederType > 2) and (iFeederType < 5) then
      begin
    	  cmbErrorCodes.Enabled := false;
			  cmbLines.Enabled := false;
        cmbMachines.Enabled := false;
        edtOldal.Enabled := false;
        edtAdagolo.Enabled := false;
        edtAdagoloOldal.Enabled := false;
      	edtKirakas_EV.Enabled := false;
        edtKirakas_HO.Enabled := false;
        edtKirakas_NAP.Enabled := false;
      end
    else
      begin
			  cmbErrorCodes.Enabled := true;
        cmbLines.Enabled := true;
        cmbMachines.Enabled := true;
        edtOldal.Enabled := true;
        edtAdagolo.Enabled := true;
        edtAdagoloOldal.Enabled := true;
        edtKirakas_EV.Enabled := true;
        edtKirakas_HO.Enabled := true;
        edtKirakas_NAP.Enabled := true;
      end;


		if (cmbLines.Enabled) then
    	cmbLines.SetFocus
    else
			edtOperatorWD.SetFocus;

    myDataset.Close;
    edtOperatorName.Text:='';
    edtOperatorWD.Text:='';
    edtOldal.Text := '';
    edtAdagolo.Text := '';
    edtAdagoloOldal.Text := '';
    edtKirakas_EV.Text := FormatDateTime('YYYY',Now);
    edtKirakas_HO.Text := FormatDateTime('MM',Now);
    edtKirakas_NAP.Text := FormatDateTime('DD',Now);

    cmbMachines.Enabled := true;
    edtOldal.Enabled := true;
    edtAdagolo.Enabled := true;
    edtAdagoloOldal.Enabled := true;
		edtKirakas_EV.Enabled := true;
		edtKirakas_HO.Enabled := true;
		edtKirakas_NAP.Enabled := true;
    cmbErrorCodes.Enabled := true;
    if (cmbLines.ItemIndex = 13) then
      begin
        cmbMachines.Enabled := false;
        edtOldal.Enabled := false;
        edtAdagolo.Enabled := false;
        edtAdagoloOldal.Enabled := false;
				edtKirakas_EV.Enabled := false;
        edtKirakas_HO.Enabled := false;
        edtKirakas_NAP.Enabled := false;
        //cmbErrorCodes.Enabled := false;
      end;

end;

initialization
  {$I sorbeallitasa.lrs}

end.

