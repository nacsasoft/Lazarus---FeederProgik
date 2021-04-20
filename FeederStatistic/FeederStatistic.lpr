program FeederStatistic;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { you can add units after this }, fomenu, LResources, laz_fpspreadsheet,
  turbopoweripro, lazmouseandkeyinput, tachartlazaruspkg, multiloglaz, login,
  database, global, jelszomod, felhasznalok, feederpartsedit, ujmunkalap,
  reports, reportsnoadmin, tabsetup, feederazonositas, sorbeallitasa,
  egyebmunkak, chart1, trolijavitas, trolimunkalap, magazinjavitas, 
prevfeederazon, feederpreventiv, tpmsetupmain, tpmds7iazonositas;

  //sqlite3laz,lazparadox, SQLDBLaz,

{$IFDEF WINDOWS}{$R FeederStatistic.rc}{$ENDIF}

begin
  {$I FeederStatistic.lrs}
  Application.Initialize;
  Application.CreateForm(TfrmLogin, frmLogin);
  Application.CreateForm(TfrmMainMenu, frmMainMenu);
  Application.CreateForm(TfrmJelszomod, frmJelszomod);
  Application.CreateForm(TfrmFelhasznalok, frmFelhasznalok) ;
  Application.CreateForm(TfrmFeederPartsEdit, frmFeederPartsEdit);
  Application.CreateForm(TfrmUjMunkalap, frmUjMunkalap);
  Application.CreateForm(TfrmReports , frmReports) ;
  Application.CreateForm(TfrmReportsNoAdmin , frmReportsNoAdmin) ;
  Application.CreateForm(TfrmSetupCenter , frmSetupCenter) ;
  Application.CreateForm(TfrmFeederAzonositas , frmFeederAzonositas) ;
  Application.CreateForm(TfrmSorBeallitasa , frmSorBeallitasa) ;
  Application.CreateForm(TfrmEgyebMunkak, frmEgyebMunkak);
  Application.CreateForm(TfrmChart1, frmChart1);
  Application.CreateForm(TfrmTroliJavitas, frmTroliJavitas);
  Application.CreateForm(TfrmTroliMunkalap, frmTroliMunkalap);
  Application.CreateForm(TfrmMagazinJavitas, frmMagazinJavitas);
  Application.CreateForm(TfrmPreventiveFeederazonositas, 
    frmPreventiveFeederazonositas);
  Application.CreateForm(TfrmFeederPreventiv, frmFeederPreventiv);
  Application.CreateForm(TfrmTPMSetupMain, frmTPMSetupMain);
  Application.CreateForm(TfrmTPMDS7i_Azonositas, frmTPMDS7i_Azonositas);
  Application.Run;
end.

