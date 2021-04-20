unit chart1;

{$mode objfpc}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, LResources, Forms, Controls, Graphics,
  Dialogs, global, database, sqlite3ds, db, TASeries, windows;

type

  { TfrmChart1 }

  TfrmChart1 = class(TForm)
    Chart1 : TChart;
    procedure FormClose(Sender : TObject; var CloseAction : TCloseAction);
    procedure FormShow(Sender : TObject);
  private
    { private declarations }
    myDataset					:TSqlite3Dataset;
    sSQL							: WideString;

  public
    { public declarations }
  end;

var
  frmChart1 : TfrmChart1;

implementation

uses reports;

{ TfrmChart1 }

procedure TfrmChart1.FormClose(Sender : TObject; var CloseAction : TCloseAction);
begin
  frmChart1.Hide;
  frmReports.Show;
end;

procedure TfrmChart1.FormShow(Sender : TObject);
var
  FBar : TBarSeries;

begin
  //grafikon létrehozása a típus alapján :
  sSQL := '';

	if (iChartType = 1) then
  begin
    //Feedercserék soronként egy adott időszakban
		sSQL := 'SELECT dolgozok.name as operator,sorok.name as sor,count(repair.wd_num) as darabszam ';
    sSQL := sSQL + 'FROM repair,sorok,dolgozok ';
    sSQL := sSQL + 'WHERE (sorok.id = line) and (dolgozok.wd_azonosito = repair.wd_num) AND ';
    sSQL := sSQL + '(repair.r_date >= "' + sGlobalTol + '" and repair.r_date <= "' + sGlobalIg + '") ';
    sSQL := sSQL + ' and repair.r_type = '+ IntToStr(iFeederType);
    sSQL := sSQL + ' GROUP BY operator,sor ORDER BY darabszam desc limit 20;';

    //ShowMessage(sSQL);

		myDataset := dbConnect('repair',sSQL,'id');
    if (myDataset.RecordCount = 0) then
    begin
      myDataset.Close;
      ShowMessage('Nincsenek adatok a grafikon elkészítéséhez!');
      frmChart1.Hide;
      frmReports.Show;
      exit;
    end;
		FBar := TBarSeries.Create(Chart1);
  	FBar.Title := 'bars';
  	FBar.SeriesColor := clGreen;
    FBar.AddXY(2,10,'',clBlue);
  	Chart1.AddSeries(FBar);

    myDataset.Close;
  end;
end;

initialization
  {$I chart1.lrs}

end.

