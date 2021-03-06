unit tabsetup ;

{$mode objfpc}{$H+}

interface

uses
  Classes , SysUtils , sqlite3ds , db , FileUtil , LResources , Forms ,
  Controls , Graphics , Dialogs , DbCtrls , DBGrids , StdCtrls , global , database ;

type

  { TfrmSetupCenter }

  TfrmSetupCenter = class(TForm)
      btnKilepes: TButton ;
      btnUjFeeder: TButton ;
      Datasource1: TDatasource ;
      dbgFeederAdatok: TDBGrid ;
      DBNavigator1: TDBNavigator ;
      Label1: TLabel ;
      lblDS7i: TLabel ;
      Sqlite3Dataset1: TSqlite3Dataset ;
      procedure btnKilepesClick(Sender: TObject) ;
      procedure btnUjFeederClick(Sender: TObject) ;
      procedure FormClose(Sender: TObject ; var CloseAction: TCloseAction) ;
      procedure FormShow(Sender: TObject) ;
  private
    { private declarations }
	procedure FeederAdatokUpdate();

  public
    { public declarations }
  end ; 

var
  frmSetupCenter: TfrmSetupCenter ;

implementation

uses login;

{ TfrmSetupCenter }

procedure TfrmSetupCenter.FormShow(Sender: TObject) ;
begin
    lblDS7i.Caption := DS7i;
    FeederAdatokUpdate();

end;

procedure TfrmSetupCenter.FormClose(Sender: TObject ;
    var CloseAction: TCloseAction) ;
begin
    frmSetupCenter.Hide;
    frmLogin.Show;
end;

procedure TfrmSetupCenter.btnKilepesClick(Sender: TObject) ;
begin
    frmSetupCenter.Hide;
    frmLogin.Show;
end;

procedure TfrmSetupCenter.btnUjFeederClick(Sender: TObject) ;
var
	bRet:		boolean;
begin
    //Új feeder azonosító bekérése, majd a lista frissítése :
	//DS7i azonosító bekérése :
    DS7i := '';
    bRet := InputQuery('DS7i azonosító...','Kérem az adagoló DS7i azonosítóját :',DS7i);
    if (not bRet) then exit;

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
    FeederAdatokUpdate();
end;

procedure TfrmSetupCenter.FeederAdatokUpdate();
//Feeder adatok frissítése a listában...
var
	ssql:	string;
begin
	//vezérlők beállítása...
	ssql := 'select r_date as [Kalibrálás dátuma], r_comment as [Megjegyzés],u_name as [Javító] ';
    ssql := ssql + 'from repair,users,feeder_works where ds7i = "';
    ssql := ssql + DS7i;
    ssql := ssql + '" and u_id = users.id ';
    ssql := ssql + 'and feeder_works.r_id = repair.id and feeder_works.w_id = 1 order by r_date;';
    Sqlite3Dataset1.Active := false;
    with Sqlite3Dataset1 do
    begin
        FileName:=dbPath;
        AutoIncrementKey:=true;
        PrimaryKey:='id';
        SaveOnClose:=true;
        SaveOnRefetch:=true;
        TableName:='repair';;
        SQL:=ssql;
        Active:=true;
        Open;
        First;
    end; //end of with
    Sqlite3Dataset1.Refresh;
    dbgFeederAdatok.Refresh;
    lblDS7i.Caption := DS7i;
end ;

initialization
  {$I tabsetup.lrs}

end.

