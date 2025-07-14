unit global;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, dateutils, Dialogs, windows, Forms;

type
  TStatusWindowHandle = type HWND;

var
    sLogFile:           string;

  	sStoreFileName:			string;
    sKirakasDatuma:			string;		//Ekkor rakta ki az opi a feedert vagy trolit
    iMachineID:					integer;	//Erről a gépről került le a feeder (siemens)
    sFeederPosition:		string;		//A siemens feedert erről a helyről vették le (pl.: 3/25/2)
    iErrorCode:					integer;	//Hibakód, amit az operátor ír a feederre...(error_codes tábla id-je)
   	iAdmin:           	integer; 	//0 = alap felh.
    															//1 = admin
                                  //2 = setup center
                                  //5 = TPM Setup (setuposok használják ha találnak hibás adagolót!)

   	userName:         	string;  	//Felhasználó teljes neve
   	userDB_ID:        	integer; 	//Felhasználó adatbázis id-je
   	DS7i:             	string;  	//Adagoló,troli DS7i azonosítója
    gsSorozatszam:      string;   //Feeder sorozatszáma....
    iTroliTipus:				integer;	//Troli típusa (0=S,F ; 1=HS ; 2=X)
    sTroliTipus:				string;		//Troli típusa...
   	iFeederType:				integer;	//Feeder típusa :
    	{ 0=SIEMENS S,F,HS ; 1=SIEMENS X ; 2=FUJI ; 3=RLI ; 4=VCD & SEQ ;
      	5=Siemens S,F trolley ; 6=HS trolley ; 7=X trolley) }
    iFeederSize:				integer;	//Feeder mérete (lsd.:adatbázis - feeder_size tábla) :
    	{ Feeder mérete
				-Siemens S-típusok :
        		1 = 2x8 mm
          	2 = 3x8 mm
            3 = 12x16 mm
            4 = 24x32 mm
        		5 = 44 mm
            6 = 56 mm
            7 = 72 mm
            8 = 88 mm
            9 = Rezgő adagoló

				-Siemens X-típusok :
        		10 = 8 mm
            11 = 2x8 mm
            12 = 12 mm
            13 = 16 mm
            14 = 24 mm
            15 = 32 mm
            16 = 44 mm
            17 = 56 mm
            18 = 72 mm
            19 = 88 mm

        -Fuji :
        		20 = 8 mm
            21 = 12 mm

        -VCD_RLI_SEQ : no

			}
    sFeederSize:			string;		//Feeder méret szöveggel pl.:"2x8 mm"
    sLine:						string;		//Erről a sorról esett ki a a feeder
    iLineID:					integer;	//Sor azonosító....
    sOperatorWDNum:   string;   //Operátor azonosító (Csak szám!!)
    sOperatorName:		string;		//Operátor neve...(vagy ahonnét ki lett rakva a feeder)
    iTroliPosition:		Integer;	//A erről az oldaláról vették le a trolit.
    iTroliNumber:     Integer;  //Troli ID !! (a preventív miatt szükséges!)
    sTroliNumber:     string;   //Troli sorszáma (nem ds7i!)

    iChartType:				integer;	//Grafikon típusa a riportkészítésnél :
    	{
      	1 = Feedercserék soronként egy adott időszakban
        2 = Soronkénti feederkiesések egy adott időszakban
        3 = Legtöbbet javított feeder az adott időszakban
      }

    sGlobalTol,sGlobalIg:	string;	//grafikonkészítéshez át kell adni az infókat...

    //TStatusWindowHandle:  hwnd;

    sTPMSetupWDNum: String; //setupos wd-száma


const
	  dbPath = 'database/feeders.db';
    sReportsPath = 'reports/';

    Codes64 = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+/';
    secstring = 'SPH9Q8WAeONhdm5z';

    //Tab character
  	Delim = CHR(9);
    //Műszakok :
    sMuszak1_Start = '05-41';
    sMuszak1_End = '13-50';
    sMuszak2_Start = '13-41';
    sMuszak2_End = '21-50';
    sMuszak3_Start = '21-41';
    sMuszak3_End = '05-50';

    aMonth : array[0..11] of string = ('Január', 'Február', 'Március', 'Április',
                                      'Május', 'Június', 'Július', 'Augusztus',
                                      'Szeptember', 'Október', 'November', 'December');



//Globális függvények :
function IsStrANumber(const S: string): Boolean;
function MakeRNDString(Chars: string; Count: Integer): string;
function EncodePWDEx(Data: string; MinV: Integer = 0; MaxV: Integer = 5): string;
function DecodePWDEx(Data: string): string;
function GetWeekNumber(sDate: string): word;
function CreateStatusWindow(const Text: AnsiString): TStatusWindowHandle;

procedure writeLogMessage(sLogMessage: string);
procedure clearLogFile();
procedure RemoveStatusWindow(StatusWindow: TStatusWindowHandle);

implementation


//a string szám ?
function IsStrANumber(const S: string): Boolean;
var
  P: PChar;
begin
  P      := PChar(S);
  Result := False;
  while P^ <> #0 do
  begin
    if not (P^ in ['0'..'9']) then Exit;
    Inc(P);
  end;
  Result := True;
end;

function MakeRNDString(Chars: string; Count: Integer): string;
var
  i, x: integer;
begin
  Result := '';
  for i := 0 to Count - 1 do
  begin
    x := Length(chars) - Random(Length(chars));
    Result := Result + chars[x];
    chars := Copy(chars, 1,x - 1) + Copy(chars, x + 1,Length(chars));
  end;
end;

function EncodePWDEx(Data: string; MinV: Integer = 0;
  MaxV: Integer = 5): string;
var
  i, x: integer;
  s1, s2, ss: string;
begin
  if minV > MaxV then
  begin
    i := minv;
    minv := maxv;
    maxv := i;
  end;
  if MinV < 0 then MinV := 0;
  if MaxV > 100 then MaxV := 100;
  Result := '';
  if (length(secstring) < 16) then exit;
  for i := 1 to Length(secstring) do
  begin
    s1 := Copy(secstring, i + 1,Length(secstring));
    if Pos(secstring[i], s1) > 0 then Exit;
    if Pos(secstring[i], Codes64) <= 0 then Exit;
  end;
  s1 := Codes64;
  s2 := '';
  for i := 1 to Length(secstring) do
  begin
    x := Pos(secstring[i], s1);
    if x > 0 then s1 := Copy(s1, 1,x - 1) + Copy(s1, x + 1,Length(s1));
  end;
  ss := secstring;
  for i := 1 to Length(Data) do
  begin
    s2 := s2 + ss[Ord(Data[i]) mod 16 + 1];
    ss := Copy(ss, Length(ss), 1) + Copy(ss, 1,Length(ss) - 1);
    s2 := s2 + ss[Ord(Data[i]) div 16 + 1];
    ss := Copy(ss, Length(ss), 1) + Copy(ss, 1,Length(ss) - 1);
  end;
  Result := MakeRNDString(s1, Random(MaxV - MinV) + minV + 1);
  for i := 1 to Length(s2) do Result := Result + s2[i] + MakeRNDString(s1,
      Random(MaxV - MinV) + minV);
end;

function DecodePWDEx(Data: string): string;
var
  i, x, x2: integer;
  s1, s2, ss: string;
begin
  Result := #1;
  if (length(secstring) < 16) then exit;
  for i := 1 to Length(secstring) do
  begin
    s1 := Copy(secstring, i + 1,Length(secstring));
    if Pos(secstring[i], s1) > 0 then Exit;
    if Pos(secstring[i], Codes64) <= 0 then Exit;
  end;
  s1 := Codes64;
  s2 := '';
  ss := secstring;
  for i := 1 to Length(Data) do if Pos(Data[i], ss) > 0 then s2 := s2 + Data[i];
  Data := s2;
  s2   := '';
  if Length(Data) mod 2 <> 0 then Exit;
  for i := 0 to Length(Data) div 2 - 1 do
  begin
    x := Pos(Data[i * 2 + 1], ss) - 1;
    if x < 0 then Exit;
    ss := Copy(ss, Length(ss), 1) + Copy(ss, 1,Length(ss) - 1);
    x2 := Pos(Data[i * 2 + 2], ss) - 1;
    if x2 < 0 then Exit;
    x  := x + x2 * 16;
    s2 := s2 + chr(x);
    ss := Copy(ss, Length(ss), 1) + Copy(ss, 1,Length(ss) - 1);
  end;
  Result := s2;
end;

function GetWeekNumber(sDate: string): word;
var
  day,month,year : word;
  FirstOfYear, Datum : TDateTime;

begin
  Datum := StrToDate(sDate,'yyyy-mm-dd','-');
	//ShowMessage(DateTimeToStr(Datum));
	//DecodeDate(Datum, year, month, day);
  //FirstOfYear := EncodeDate(year, 1, 1);
  //Result := Trunc(Datum - FirstOfYear) div 7 + 1;
  //ShowMessage(inttostr(WeekOfTheYear(Datum)));
  Result := WeekOfTheYear(Datum);
end;

procedure writeLogMessage(sLogMessage: AnsiString);
//Írás a log-fájlba (ha nem létezik a fájl, akkor létre is hozzuk):
var
  logFile :TextFile;
  sInfos  :string;  //általános információk...

begin

  //már nem kell logolni....csúnya megoldás de ez van....
  exit;

  sInfos := '********> Bejegyzés létrehozva : ' + FormatDateTime('YYYY-MM-DD / hh:mm:ss',Now) + ' <********';
  if (FileExists(sLogFile)) then
    begin
      AssignFile (logFile, sLogFile);
      Append (logFile);
    end
  else
    begin
      AssignFile (logFile, sLogFile);
      Rewrite (logFile);
    end;
  WriteLn(logFile,sInfos);
  WriteLn(logFile,sLogMessage);
  WriteLn(logFile,'********> Bejegyzés vége! <********');
  WriteLn(logFile,' ');
  CloseFile(logFile);
end;

procedure clearLogFile();
//Log fájl tartalmaának törlése:
var
  logFile :TextFile;

begin
  AssignFile (logFile, sLogFile);
  Rewrite (logFile);
  CloseFile(logFile);
end;

function CreateStatusWindow(const Text: AnsiString): TStatusWindowHandle;
var
  FormWidth,  FormHeight: integer;
begin
  FormWidth := 400;
  FormHeight := 164;
  result := CreateWindow('STATIC',
                         PChar(AnsiToUtf8(Text)),
                         WS_OVERLAPPED or WS_POPUPWINDOW or WS_THICKFRAME or SS_CENTER or SS_CENTERIMAGE or DS_MODALFRAME,
                         (Screen.Width - FormWidth) div 2,
                         (Screen.Height - FormHeight) div 2,
                         FormWidth,
                         FormHeight,
                         Application.MainForm.Handle,
                         0,
                         HInstance,
                         nil);
  ShowWindow(result, SW_SHOWNORMAL);
  UpdateWindow(result);
end;

procedure RemoveStatusWindow(StatusWindow: TStatusWindowHandle);
begin
  DestroyWindow(StatusWindow);
end;


end.

