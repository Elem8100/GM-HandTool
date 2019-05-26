unit MainUnit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, Grids, AdvObj,
  BaseGrid, AdvGrid, StdCtrls, WZIMGFile, WZArchive, WZDirectory, AdvSmoothLabel, AdvOfficePager,
  ToolWin, ComCtrls, ExtCtrls, ToolPanels, AdvEdit, AdvOfficePagerStylers, AdvEdBtn, AdvPanel, Menus,
  StrUtils, FolderDialog, Buttons, KeyHandler, WZReader, PNGMapleCanvas, AdvToolBtn, ButtonGroup,
  Generics.Collections, pngimage, Tools, Math, RegularExpressions, RegularExpressionsCore,
  AeroButtons, bass, BassHandler, AdvUtil, Global;

type
  TDataMode = (dmBIN, dmWZ);

  TViewMode = (vmSmall, vmStretch, vmFull);

  TLinkInfo = record
    ID: string;
    Row: Integer;
  end;

  TMapNameInfo = record
    MapName, StreetName: string;
  end;


  TForm1 = class(TForm)
    AdvOfficePager1: TAdvOfficePager;
    Cash: TAdvOfficePage;
    Consume1: TAdvOfficePage;
    Weapon: TAdvOfficePage;
    Grid: TAdvStringGrid;
    AdvOfficePagerOfficeStyler1: TAdvOfficePagerOfficeStyler;
    Cap: TAdvOfficePage;
    Coat: TAdvOfficePage;
    Longcoat: TAdvOfficePage;
    Pants: TAdvOfficePage;
    Shoes: TAdvOfficePage;
    Glove: TAdvOfficePage;
    Ring: TAdvOfficePage;
    AdvPanel1: TAdvPanel;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Edit1: TEdit;
    Cape: TAdvOfficePage;
    Accessory: TAdvOfficePage;
    Shield: TAdvOfficePage;
    TamingMob: TAdvOfficePage;
    Hair: TAdvOfficePage;
    Face: TAdvOfficePage;
    Map1: TAdvOfficePage;
    Mob1: TAdvOfficePage;
    Skill1: TAdvOfficePage;
    NPC: TAdvOfficePage;
    Pet: TAdvOfficePage;
    Install: TAdvOfficePage;
    Etc: TAdvOfficePage;
    Edit2: TEdit;
    LoadButton: TButton;
    PopupMenu1: TPopupMenu;
    Label2: TLabel;
    FolderDialog1: TFolderDialog;
    Map2: TAdvOfficePage;
    Mob2: TAdvOfficePage;
    ComboKey: TComboBox;
    lblCredits: TLabel;
    Consume2: TAdvOfficePage;
    Android: TAdvOfficePage;
    Mechanic: TAdvOfficePage;
    PetEquip: TAdvOfficePage;
    Bits: TAdvOfficePage;
    AeroSpeedButton1: TAeroSpeedButton;
    AeroSpeedButton2: TAeroSpeedButton;
    AeroSpeedButton3: TAeroSpeedButton;
    AeroSpeedButton4: TAeroSpeedButton;
    AeroSpeedButton5: TAeroSpeedButton;
    Mob3: TAdvOfficePage;
    Music: TAdvOfficePage;
    MonsterBattle: TAdvOfficePage;
    Totem: TAdvOfficePage;
    Mopher: TAdvOfficePage;
    Familiar: TAdvOfficePage;
    Map3: TAdvOfficePage;
    DamageSkin: TAdvOfficePage;
    Consume3: TAdvOfficePage;
    Skill2: TAdvOfficePage;
    Reactor: TAdvOfficePage;
    procedure FormCreate(Sender: TObject);
    procedure AdvOfficePager1Change(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure LoadButtonClick(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure GridClick(Sender: TObject);
    procedure ComboKeyChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AeroSpeedButton1Click(Sender: TObject);
    procedure AeroSpeedButton3Click(Sender: TObject);
    procedure AeroSpeedButton2Click(Sender: TObject);
    procedure AeroSpeedButton4Click(Sender: TObject);
    procedure GridClickCell(Sender: TObject; ARow, ACol: Integer);
  private
    DataMode: TDataMode;
    ViewMode: TViewMode;
    PageIndex: Integer;
    Category: string;
    BINName: string;
    ActiveBass: TBassHandler;
    ColList2: TStringList;
    RowList2: TDictionary<Integer, string>;
    Row1, Row2: Integer;
    HasSound2WZ: Boolean;
    procedure DumpData2(Entry: TWZIMGEntry);
    procedure Dump2(Entry: TWZIMGEntry);
    procedure PutGridData2(Col: Integer);
    function CommonMatch(const Match: TMatch): string;
    function PCommonMatch(const Match: TMatch): string;
    procedure LoadCharacter;
    procedure LoadItem(Part: Integer);
    procedure LoadSkill(Part: Integer);
    procedure LoadMob(Part: Integer);
    procedure LoadMap(Part: Integer);
    procedure LoadNpc;
    procedure LoadMorph;
    procedure LoadFamiliar;
    procedure LoadDamageSkin;
    procedure LoadReactor;
    procedure LoadMusic;
    procedure SetView;
    procedure LoadBIN;
    procedure LoadWZ;
    procedure ReSetWZ;
    function IDToInt(ID: string): string;
    { Private declarations }
  public
    function GetEntry(Path: string; UseGet2: Boolean = False): TWZIMGEntry;
    function GetEntryMob2(Path: string): TWZIMGEntry;
    { Public declarations }
  end;

var
  Form1: TForm1;
  Common, PCommon: TWZIMGEntry;
  MaxLev, PMaxLev: Integer;
  IsKMS: Boolean;

implementation

{$R *.dfm}

function TForm1.GetEntry(Path: string; UseGet2: Boolean = False): TWZIMGEntry;
var
  S: TStringArray;
  ImgName: string;
  WZ: TWZArchive;
  Len: Integer;
begin

  case Path[2] of
    'a':
      WZ := MapWz;
    // 'o': WZ := MobWZ;
    'o':
      if Path[1] = 'S' then
        WZ := SoundWZ
      else if Path[3] = 'r' then
        WZ := MorphWz
      else if Path[4] = '2' then
        WZ := Mob2WZ
      else
        WZ := MobWZ;

    'p':
      WZ := NPCWZ;
    'h':
      WZ := CharacterWZ;
    // 'e': WZ := ReactorWZ;
    'k':
      WZ := SkillWZ;
    't':
      if Path[1] = 'I' then
        WZ := ItemWZ
      else
        WZ := StringWZ;
    'e':
      WZ := ReactorWZ;
  end;
  S := Explode('.img/', Path);
  Len := Pos('/', S[0]) + 1;
  ImgName := MidStr(S[0], Len, 100) + '.img';

  if UseGet2 then
    Result := WZ.GetImgFile(ImgName).Root.Get2(S[1])
  else
    Result := WZ.GetImgFile(ImgName).Root.Get(S[1]);

end;

function TForm1.GetEntryMob2(Path: string): TWZIMGEntry;
var
  S: TStringArray;
  ImgName: string;
  Len: Integer;
begin

  S := Explode('.img/', Path);
  Len := Pos('/', S[0]) + 1;
  ImgName := MidStr(S[0], Len, 100) + '.img';
  Result := Mob2WZ.GetImgFile(ImgName).Root.Get(S[1]);
end;

procedure TForm1.AeroSpeedButton1Click(Sender: TObject);
begin
  Grid.SaveToBinFile(ExtractFilePath(ParamStr(0)) + BINName + '.BIN');
  MessageDlg('Save  ' + BINName + '.BIN' + '  Completed', mtInformation, [mbOK], 0);
end;

procedure TForm1.AeroSpeedButton2Click(Sender: TObject);
begin
  Grid.SaveToHTML(ExtractFilePath(ParamStr(0)) + BINName + '.html');
  MessageDlg('Save' + BINName + '.html' + 'Completed', mtInformation, [mbOK], 0);
end;

procedure TForm1.AeroSpeedButton3Click(Sender: TObject);
begin
  Grid.SaveToASCII(ExtractFilePath(ParamStr(0)) + BINName + '.txt');
  MessageDlg('Save' + BINName + '.txt' + 'Completed', mtInformation, [mbOK], 0);
end;

procedure TForm1.AeroSpeedButton4Click(Sender: TObject);
begin
  case TAeroSpeedButton(Sender).Tag of
    0:
      ViewMode := vmSmall;
    1:
      ViewMode := vmStretch;
    2:
      ViewMode := vmFull;
  end;
  case PageIndex of
    16, 17, 18, 19:
      SetView;
  end;
end;

function GetPath1(Entry: TWZIMGEntry): string;
var
  Path: string;
  E: TWZEntry;
begin
  Path := Entry.Name;
  E := Entry.Parent;
  while E <> nil do
  begin
    Path := E.Name + '.' + Path;
    E := E.Parent;
  end;
  Result := Path;
end;

procedure TForm1.Dump2(Entry: TWZIMGEntry);
var
  E: TWZIMGEntry;
  Data: string;
begin

  case Entry.DataType of
    mdtInt, mdtVector, mdtShort, mdtString, mdtFloat, mdtDouble, mdtInt64:
      begin
        if Entry.DataType = mdtVector then
          Data := 'x:' + IntToStr(Entry.Vector.X) + '  ' + 'y:' + IntToStr(Entry.Vector.Y)
        else
          Data := Entry.Data;

        ColList2.Add(GetPath1(Entry) + '=' + Data + ',  ');
      end;
  end;

  for E in Entry.Children do
    if Entry.DataType <> mdtCanvas then
      Dump2(E);

end;

procedure TForm1.DumpData2(Entry: TWZIMGEntry);
var
  i: Integer;
  S, FinalStr: string;
begin

  ColList2.BeginUpdate;
  Inc(Row2);
  Dump2(Entry);

  S := GetPath1(Entry) + '.';
  for i := 0 to ColList2.Count - 1 do
  begin
    ColList2[i] := StringReplace(ColList2[i], S, '', [rfReplaceAll]);
    FinalStr := FinalStr + ColList2[i];
  end;
  ColList2.EndUpdate;
  Delete(FinalStr, Length(FinalStr) - 2, 1);
  RowList2.Add(Row2, FinalStr);
  ColList2.Clear;
end;


procedure TForm1.PutGridData2(Col: Integer);
var
  i: Integer;
begin

  for i in RowList2.Keys do
    Grid.Cells[Col, i] := RowList2[i];
  RowList2.Clear;
end;

procedure TForm1.ComboBox1Change(Sender: TObject);
begin
  Grid.ClearAll;
  case ComboBox1.ItemIndex of
    0:
      begin
        DataMode := dmBIN;
        Label1.Visible := False;
        Edit1.Visible := False;
        LoadButton.Visible := False;
        ComboKey.Visible := False;
        LoadBIN;
      end;
    1:
      begin
        DataMode := dmWZ;
        Label1.Visible := True;
        Edit1.Visible := True;
        LoadButton.Visible := True;
        ComboKey.Visible := True;
      end;
  end;
end;

procedure TForm1.ComboKeyChange(Sender: TObject);
begin
  case ComboKey.ItemIndex of
    0:
      TWZReader.EncryptionIV := 0;

    1:
      TWZReader.EncryptionIV := GMS_IV;
    2:
      TWZReader.EncryptionIV := GENERAL_IV;
  end;
end;

procedure TForm1.ReSetWZ;
begin
  // if not FileExists(Edit1.Text + '\String.wz') then
  // Exit;
  if StringWZ <> nil then
    FreeAndNil(StringWZ);
  if ItemWZ <> nil then
    FreeAndNil(ItemWZ);
  if CharacterWZ <> nil then
    FreeAndNil(CharacterWZ);
  if SkillWZ <> nil then
    FreeAndNil(SkillWZ);
  if Skill001Wz <> nil then
    FreeAndNil(Skill001Wz);

  if MobWZ <> nil then
    FreeAndNil(MobWZ);
  if Mob2WZ <> nil then
    FreeAndNil(Mob2WZ);
  if MapWz <> nil then
    FreeAndNil(MapWz);
  if NPCWZ <> nil then
    FreeAndNil(NPCWZ);

  if SoundWZ <> nil then
    FreeAndNil(SoundWZ);
  if Sound2Wz <> nil then
    FreeAndNil(Sound2Wz);

  if MorphWz <> nil then
    FreeAndNil(MorphWz);
  if ReactorWZ <> nil then
    FreeAndNil(ReactorWZ);

  StringWZ := TWZArchive.Create(Edit1.Text + '\String.wz');
  if StringWZ.GetImgFile('Mob.img').Root.Get('100000/name', '') = '달팽이' then
    IsKMS := True;
  ItemWZ := TWZArchive.Create(Edit1.Text + '\Item.wz');
  CharacterWZ := TWZArchive.Create(Edit1.Text + '\Character.wz');
  SkillWZ := TWZArchive.Create(Edit1.Text + '\Skill.wz');
  if FileExists(Edit1.Text + '\Skill001.wz') then
    Skill001Wz := TWZArchive.Create(Edit1.Text + '\Skill001.wz');
  MobWZ := TWZArchive.Create(Edit1.Text + '\Mob.wz');
  if FileExists(Edit1.Text + '\Mob2.wz') then
    Mob2WZ := TWZArchive.Create(Edit1.Text + '\Mob2.wz');
  MapWz := TWZArchive.Create(Edit1.Text + '\Map.wz');
  NPCWZ := TWZArchive.Create(Edit1.Text + '\Npc.wz');
  MorphWz := TWZArchive.Create(Edit1.Text + '\Morph.wz');
  ReactorWZ := TWZArchive.Create(Edit1.Text + '\Reactor.wz');
  SoundWZ := TWZArchive.Create(Edit1.Text + '\Sound.wz');
  if FileExists(Edit1.Text + '\Sound2.wz') then
  begin
    HasSound2WZ := True;
    Sound2Wz := TWZArchive.Create(Edit1.Text + '\Sound2.wz');
  end;
end;

procedure TForm1.LoadButtonClick(Sender: TObject);
begin

  if FileExists(Edit1.Text + '\String.wz') then
  begin
    with Grid.Canvas do
    begin
      // ComboKey.Enabled := False;
      Font.Size := 25;
      Brush.Color := clGrayText;
      TextOut(150, 150, 'Loading...');
    end;
    ReSetWZ;
    LoadWZ;
  end
  else
    ShowMessage('wrong folder');
end;

function TForm1.IDToInt(ID: string): string;
var
  S: Integer;
begin
  S := Trim(ID).toInteger;
  Result := S.ToString;
end;

procedure TForm1.LoadItem(Part: Integer);
type
  TRec = record
    Desc, Name: string;
  end;
var
  Rec: TRec;
  Dict: TDictionary<string, TRec>;
  Row, Col, I2, i, j: Integer;
  Name, Desc, Path, ItemDir, InfoData, Data1, Data2, Data3, Data4: string;
  Iter, Iter2, Iter3, Child, Source: TWZIMGEntry;
  Dir: TWZDirectory;
  img: TWZFile;
  Bmp: TBitmap;
begin

  Grid.ClearAll;
  case AdvOfficePager1.ActivePageIndex of
    1, 2, 3:
      ItemDir := 'Consume';
  else
    ItemDir := Category;
  end;

  Dir := TWZDirectory(ItemWZ.Root.Entry[ItemDir]);
  Row := -1;
  Row2 := -1;
  Grid.ColCount := 10;
  I2 := -1;

  Dict := TDictionary<string, TRec>.Create;
  if ItemDir <> 'Pet' then
  begin
    if (ItemDir = 'Etc') then
      Child := StringWZ.GetImgFile('Etc.img').Root.Child['Etc']
    else if (ItemDir = 'Install') then
      Child := StringWZ.GetImgFile('Ins.img').Root
    else
      Child := StringWZ.GetImgFile(ItemDir + '.img').Root;

    for Iter in Child.Children do
    begin
      Rec.Desc := Iter.Get('desc', '');
      Rec.Name := Iter.Get('name', '');
      Dict.Add(Iter.Name, Rec);
    end;
  end;

  var ID: string;
  for img in Dir.Files do
  begin

    case Part of
      1:
        begin
          if (ItemDir = 'Consume') and (not CharInSet(img.Name[3], ['0'..'3'])) then
            Continue;
          // if (ItemDir = 'Etc') and (CharInSet(img.Name[3], ['0'])) then
          // Continue;
        end;
      2:
        if (ItemDir = 'Consume') and (not CharInSet(img.Name[3], ['4'..'6'])) then
          Continue;
      3:
        if (ItemDir = 'Consume') and (not CharInSet(img.Name[3], ['7'..'9'])) then
          Continue;
    end;

    if ItemDir = 'Pet' then
    begin
      DumpData2(ItemWZ.GetImgFile(ItemDir + '/' + img.Name).Root);
      Inc(I2);
      Grid.RowCount := I2 + 1;
      Desc := StringWZ.GetImgFile('Pet.img').Root.Get(LeftStr(img.Name, 7) + '/' + 'desc', '');
      Name := StringWZ.GetImgFile('Pet.img').Root.Get(LeftStr(img.Name, 7) + '/' + 'name', '');
      Grid.Cells[1, I2] := (LeftStr(img.Name, 7));
      Grid.Cells[3, I2] := (Name);
      Grid.Cells[4, I2] := (Desc);
    end;

    for Iter in ItemWZ.GetImgFile(ItemDir + '/' + img.Name).Root.Children do
    begin

      if ItemDir <> 'Pet' then
      begin
        DumpData2(Iter);
        Inc(Row);
        Grid.RowCount := Row + 1;
        Grid.Cells[1, Row] := Iter.Name;
        ID := IDToInt(Iter.Name);
        if Dict.ContainsKey(ID) then
        begin
          Grid.Cells[3, Row] := Dict[ID].Name;
          Grid.Cells[4, Row] := Dict[ID].Desc;
        end;
        if { Install 0306.img } (Iter.Get('info/icon') <> nil) and
        { Consume 02591488 } (LeftStr(Iter.Get('info/icon').Data, 9) <> '../../../') then
        begin
          Bmp := Iter.Get2('info/icon').Canvas.DumpBmp;
          Grid.CreateBitmap(2, Row, False, haCenter, vaCenter).Assign(Bmp);
          Bmp.Free;
        end;
      end;

      if Iter.Child['iconD'] <> nil then
      begin
        Bmp := Iter.Get2('iconD').Canvas.DumpBmp;
        Grid.CreateBitmap(2, I2, False, haCenter, vaCenter).Assign(Bmp);
        Bmp.Free;
      end;

    end;

  end;

  PutGridData2(5);

  Grid.InsertRows(0, 1);
  Grid.DefaultRowHeight := 45;
  Grid.FixedRowHeight := 25;
  Grid.RowHeights[0] := 22;
  Grid.RowHeights[1] := 33;

  Grid.ColWidths[1] := 93;
  Grid.ColWidths[2] := 60;
  Grid.ColWidths[3] := 122;
  Grid.ColWidths[4] := 600;
  Grid.ColWidths[5] := 800;

  Grid.ColumnHeaders.Clear;
  Grid.ColumnHeaders.Add('');
  Grid.ColumnHeaders.Add('ID');
  Grid.ColumnHeaders.Add('Icon');
  Grid.ColumnHeaders.Add('Name');
  Grid.ColumnHeaders.Add('Description');
  Grid.ColumnHeaders.Add('info');
  // Grid.RemoveDuplicates(1, False);
  Grid.SortByColumn(1);
  // for Col := 0 to 15 do
  // Grid.MergeCols(5, 6);
  if Grid.Cells[1, 1] = '' then
    Grid.RemoveRows(1, 1);
  for i := 0 to Grid.ColCount - 1 do
    Grid.CellProperties[i, 0].Alignment := taCenter;

  Dict.Free;

end;

function Add7(Name: string): string;
begin
  case Length(Name) of
    0:
      Result := '';
    6:
      Result := '0' + Name;
  else
    Result := Name;
  end;
end;

procedure TForm1.LoadFamiliar;
var
  img: TWZFile;
  Row, i: Integer;
  CardID, MobID, SkillID: string;
  MobEntry, Entry, CardEntry: TWZIMGEntry;
  Bmp: TBitmap;
begin
  Row := -1;
  Grid.ClearAll;
  Grid.ColCount := 20;
  for img in TWZDirectory(CharacterWZ.Root.Entry['Familiar']).Files do
  begin
    Inc(Row);
    Grid.RowCount := Row + 1;
    Grid.Cells[1, Row] := LeftStr(img.name, 7);
    Entry := CharacterWZ.GetImgFile('Familiar/' + img.name).Root;
    MobID := Add7(Entry.Get2('info/MobID').Data);
    DumpData2(Entry.Get2('info'));

    if GetEntry('Character.wz/Familiar/' + img.name + '/jump/0') <> nil then
    begin
      Bmp := GetEntry('Character.wz/Familiar/' + img.name + '/jump/0', True).Canvas.DumpBmp;
      Grid.CreateBitmap(2, Row, False, haCenter, vaCenter).Assign(Bmp);
      Bmp.Free;
    end;

    // for TMS
    {
      if MobWZ.GetImgFile(MobID + '.img') <> nil then
      begin
      MobEntry := MobWZ.GetImgFile(MobID + '.img').Root;
      if MobEntry.Child['stand'] <> nil then
      Bmp := MobEntry.Get2('stand/0').Canvas.DumpBmp
      else
      Bmp := MobEntry.Get2('fly/0').Canvas.DumpBmp;
      Grid.CreateBitmap(2, Row, False, haCenter, vaCenter).Assign(Bmp);
      Bmp.Free;

      end;

      if Mob2WZ.GetImgFile(MobID + '.img') <> nil then
      begin
      MobEntry := Mob2WZ.GetImgFile(MobID + '.img').Root;
      if MobEntry.Child['stand'] <> nil then
      Bmp := MobEntry.GetMob2('stand/0').Canvas.DumpBmp
      else
      Bmp := MobEntry.GetMob2('fly/0').Canvas.DumpBmp;
      Grid.CreateBitmap(2, Row, False, haCenter, vaCenter).Assign(Bmp);
      Bmp.Free;
      end;
    }
    SkillID := Entry.Get2('info/skill/id').Data;

    // GMS =Familiar.img,  TMS=FamiliarSkill.img
    Grid.Cells[4, Row] := GetEntry('String/Familiar.img/skill/' + SkillID + '/name', True).Data;
    Grid.Cells[5, Row] := GetEntry('String/Familiar.img/skill/' + SkillID + '/desc', True).Data;

    // for TMS
    {
      CardID := Entry.Get2('info/monsterCardID').Data;
      Grid.Cells[6, Row] := CardID;
      CardEntry := ItemWZ.GetImgFile('Consume/0287.img').Root.Child['0' + CardID];
      if CardEntry <> nil then
      begin
      Bmp := CardEntry.Get2('info/icon').Canvas.DumpBmp;
      Grid.CreateBitmap(7, Row, False, haCenter, vaCenter).Assign(Bmp);
      Bmp.Free;
      end;

      Grid.Cells[8, Row] := StringWZ.GetImgFile('Consume.img').Root.Get(CardID + '/name', '');
    }
  end;
  PutGridData2(3);
  Grid.InsertRows(0, 1);
  Grid.DefaultRowHeight := 35;
  Grid.FixedRowHeight := 25;
  Grid.RowHeights[0] := 22;
  Grid.RowHeights[1] := 33;

  Grid.ColWidths[1] := 100;
  Grid.ColWidths[2] := 180;
  Grid.ColWidths[3] := 160;
  Grid.ColWidths[4] := 80;
  Grid.ColWidths[5] := 360;
  Grid.ColWidths[6] := 60;
  Grid.ColWidths[7] := 50;
  Grid.ColWidths[8] := 100;
  Grid.ColumnHeaders.Clear;
  Grid.ColumnHeaders.Add('');
  Grid.ColumnHeaders.Add('Familiar ID');
  Grid.ColumnHeaders.Add('Familiar');
  Grid.ColumnHeaders.Add('Info');
  Grid.ColumnHeaders.Add('Skill Name');
  Grid.ColumnHeaders.Add('Skill Desc');
  // Grid.ColumnHeaders.Add('Card ID');
  // Grid.ColumnHeaders.Add('Card');
  // Grid.ColumnHeaders.Add('Card Name');
  Grid.SortByColumn(1);

  for i := 0 to Grid.ColCount - 1 do
    Grid.CellProperties[i, 0].Alignment := taCenter;

  for i := 0 to Grid.RowCount - 1 do
    if Grid.CellTypes[2, i] = ctBitmap then
      Grid.RowHeights[i] := Grid.GetBitmap(2, i).Height + 2;

end;

procedure TForm1.LoadReactor;
var
  Links: TList<TLinkInfo>;
  Link: TLinkInfo;
begin

  var Row: Integer := -1;
  var Entry, Entry2: TWZIMGEntry;
  var BMP: TBitmap;
  Links := TList<TLinkInfo>.Create;
  for var img in ReactorWZ.Root.Files do
  begin

    DumpData2(ReactorWZ.GetImgFile(img.Name).Root.Child['info']);
    var ID := LeftStr(img.Name, 7);
    Inc(Row);

    Grid.RowCount := Row + 2;
    Grid.Cells[1, Row] := ID;

    Entry := ReactorWZ.GetImgFile(img.Name).Root.Child['0'];

    if Entry <> nil then
    begin
      if (Entry.Child['0'] <> nil) then
      begin
        BMP := Entry.Get2('0').Canvas.DumpBmp;
        Grid.CreateBitmap(2, Row, False, haCenter, vaCenter).Assign(BMP);
        BMP.Free;
      end;
    end;

    Entry := ReactorWZ.GetImgFile(img.Name).Root.Get('info/link');
    if Entry <> nil then
    begin
      Link.ID := Entry.Data;
      Link.Row := Row;
      Links.Add(Link);
    end;

  end;

  for var i := 0 to Links.Count - 1 do
  begin
    Entry := ReactorWZ.GetImgFile(Links[i].ID + '.img').Root.Child['0'];
    if Entry <> nil then
    begin
      if (Entry.Child['0'] <> nil) then
      begin
        BMP := Entry.Get2('0').Canvas.DumpBmp;
        Grid.CreateBitmap(2, Links[i].Row, False, haCenter, vaCenter).Assign(BMP);
        BMP.Free;
      end;
    end;
  end;

  PutGridData2(3);
  Grid.InsertRows(0, 1);
  Grid.ColumnHeaders.Add('');
  Grid.ColumnHeaders.Add('ID');
  Grid.ColumnHeaders.Add('Reactor');
  Grid.ColumnHeaders.Add('Info');

  Grid.ColWidths[0] := 10;
  Grid.RowHeights[0] := 22;
  Grid.ColWidths[1] := 80;
  Grid.ColWidths[2] := 250;
  Grid.ColWidths[3] := 350;
  Grid.ColWidths[4] := 570;
  Grid.ColWidths[5] := 500;
  Grid.SortByColumn(1);
  for var i := 0 to Grid.RowCount - 1 do
  begin
    if Grid.CellTypes[2, i] = ctBitmap then
    begin
      Grid.RowHeights[i] := Grid.GetBitmap(2, i).Height + 2;
      if Grid.RowHeights[i] > 200 then
        Grid.RowHeights[i] := 200;
      if Grid.RowHeights[i] < 30 then
        Grid.RowHeights[i] := 30;
    end;
  end;
  if Grid.Cells[1, 1] = '' then
    Grid.RemoveRows(1, 1);
  for var i := 0 to Grid.ColCount - 1 do
    Grid.CellProperties[i, 0].Alignment := taCenter;

  Links.Free;

end;

function Add4(Name: string): string;
begin
  case Length(Name) of
    0:
      Result := '';
    1:
      Result := '000' + Name;
    2:
      Result := '00' + Name;
    3:
      Result := '0' + Name;
    4:
      Result := Name;
  end;
end;

procedure TForm1.LoadMorph;
type
  TRec = record
    Desc, Name: string;
  end;
var
  Rec: TRec;
  Dict: TDictionary<string, TRec>;
  imgs: TList<string>;
  Name, Desc, Path, ItemDir, InfoData, MorphID: string;
  Iter, Iter2, Iter3, Child, Source: TWZIMGEntry;
  Row, i: Integer;
  Bmp: TBitmap;
  img: TWZFile;
begin
  Grid.ClearAll;
  Grid.ColCount := 10;
  Row := -1;
  Dict := TDictionary<string, TRec>.Create;
  imgs := TList<string>.Create;

  for Iter in StringWZ.GetImgFile('Consume.img').Root.Children do
  begin
    Rec.Desc := Iter.Get('desc', '');
    Rec.Name := Iter.Get('name', '');
    Dict.Add(Iter.Name, Rec);
  end;

  for img in MorphWz.Root.Files do
    imgs.Add(LeftStr(img.Name, 4));

  for Iter in ItemWZ.GetImgFile('Consume/0221.img').Root.Children do
  begin
    Inc(Row);
    Grid.RowCount := Row + 1;
    Grid.Cells[1, Row] := (Iter.Name);
    if Dict.ContainsKey(IDToInt(Iter.Name)) then
    begin
      Grid.Cells[5, Row] := Dict[IDToInt(Iter.Name)].Name;
      Grid.Cells[6, Row] := Dict[IDToInt(Iter.Name)].Desc;
    end;

    Bmp := Iter.Get2('info/icon').Canvas.DumpBmp;

    Grid.CreateBitmap(2, Row, False, haCenter, vaCenter).Assign(Bmp);
    Bmp.Free;

    MorphID := Add4(Iter.Get('spec/morph', ''));

    if imgs.contains(MorphID) then
    begin
      Grid.Cells[3, Row] := MorphID;
      Bmp := MorphWz.GetImgFile(MorphID + '.img').Root.Get2('walk/0').Canvas.DumpBmp;
      Grid.CreateBitmap(4, Row, False, haCenter, vaCenter).Assign(Bmp);
      Bmp.Free;
    end;

  end;

  Grid.InsertRows(0, 1);
  Grid.DefaultRowHeight := 35;
  Grid.FixedRowHeight := 25;
  Grid.RowHeights[0] := 22;
  Grid.RowHeights[1] := 33;

  Grid.ColWidths[1] := 93;
  Grid.ColWidths[2] := 60;
  Grid.ColWidths[3] := 80;
  Grid.ColWidths[4] := 200;
  Grid.ColWidths[5] := 120;
  Grid.ColWidths[6] := 400;
  Grid.ColumnHeaders.Clear;
  Grid.ColumnHeaders.Add('');
  Grid.ColumnHeaders.Add('ID');
  Grid.ColumnHeaders.Add('Icon');
  Grid.ColumnHeaders.Add('Morph ID');
  Grid.ColumnHeaders.Add('Morph');
  Grid.ColumnHeaders.Add('Name');
  Grid.ColumnHeaders.Add('Description');

  Grid.SortByColumn(1);

  for i := 0 to Grid.ColCount - 1 do
    Grid.CellProperties[i, 0].Alignment := taCenter;

  for i := 0 to Grid.RowCount - 1 do
    if Grid.CellTypes[4, i] = ctBitmap then
      Grid.RowHeights[i] := Grid.GetBitmap(4, i).Height + 2;

  Dict.Free;
  imgs.Free;
end;

procedure TForm1.LoadDamageSkin;
var
  Name, Desc, Path, ItemDir, InfoData, MorphID: string;
  Iter, Pic: TWZIMGEntry;
  Row, i: Integer;
  Bmp: TBitmap;
  img: TWZFile;
begin
  Grid.ClearAll;
  Grid.ColCount := 10;
  Row := -1;
  for Iter in StringWZ.GetImgFile('Consume.img').Root.Children do
  begin

    Name := Iter.Get('name', '');
    if (ContainsText(Name, '字型')) or (ContainsText(Name, 'ジスキン')) or (ContainsText(Name, '스킨')) or (ContainsText
      (Name, 'Damage Skin')) or (ContainsText(Name, '字型')) or (ContainsText(Name, '伤害皮肤')) then
    begin
      Inc(Row);
      Grid.RowCount := Row + 1;
      Grid.Cells[1, Row] := '0' + Iter.Name;

      Pic := GetEntry('Item/Consume/0243.img/0' + Iter.Name + '/info/icon', True);
      if Pic.Name <> 'arm' then
      begin
        Bmp := Pic.Canvas.DumpBmp;
        Grid.CreateBitmap(2, Row, False, haCenter, vaCenter).Assign(Bmp);
        Bmp.Free;
      end;

      Grid.Cells[3, Row] := Name;

      Pic := GetEntry('Item/Consume/0243.img/0' + Iter.Name + '/info/sample', True);
      if Pic.Name <> 'arm' then
      begin
        Bmp := Pic.Canvas.DumpBmp;
        Grid.CreateBitmap(4, Row, False, haCenter, vaCenter).Assign(Bmp);
        Bmp.Free;
      end;
      Grid.Cells[5, Row] := Iter.Get('desc', '');

    end;

  end;
  Grid.InsertRows(0, 1);
  Grid.DefaultRowHeight := 55;
  Grid.FixedRowHeight := 25;
  Grid.RowHeights[0] := 22;
  Grid.RowHeights[1] := 33;

  Grid.ColWidths[1] := 93;
  Grid.ColWidths[2] := 69;
  Grid.ColWidths[3] := 102;
  Grid.ColWidths[4] := 300;
  Grid.ColWidths[5] := 600;

  Grid.ColumnHeaders.Clear;
  Grid.ColumnHeaders.Add('');
  Grid.ColumnHeaders.Add('ID');
  Grid.ColumnHeaders.Add('Icon');
  Grid.ColumnHeaders.Add('name');
  Grid.ColumnHeaders.Add('Sample');
  Grid.ColumnHeaders.Add('Description');
  // Grid.RemoveDuplicates(1, False);
  Grid.SortByColumn(1);
  // for Col := 0 to 15 do
  // Grid.MergeCols(5, 6);
  if Grid.Cells[1, 1] = '' then
    Grid.RemoveRows(1, 1);
  for i := 0 to Grid.ColCount - 1 do
    Grid.CellProperties[i, 0].Alignment := taCenter;
  // Grid.CellProperties[5, 0].Alignment := taLeftJustify;
end;

function ToBlank(Name: string): Boolean;
begin
  if (Name = 'or') or (Name = 'or2') then
    Result := True
  else
    Result := False;
end;




function StrJoin(const StringArray: array of string; const Separator: string): string;
var
  i: Integer;
begin
  Result := '';
  for i := Low(StringArray) to High(StringArray) do
    Result := Result + StringArray[i] + Separator;

  Delete(Result, Length(Result), 1);
end;

function GetJobID(ID: string): string;
begin
  Result := IntToStr(StrToInt(ID) div 10000);
end;

function NoIMG(const Name: string): Integer; inline;
begin
  Result := ChangeFileExt(Name, '').toInteger;
end;

procedure TForm1.LoadCharacter;
var
  Row, i, j: Integer;
  Ids, Jobs, Skills: string;
  joins: array of string;
  Name, Desc, Data, ID, CharacterDir, D, SkillID, h, h1, h1_, s1, s2, lv: string;
  Iter, Iter2, Iter3, Child, Source, Entry4, Entry6: TWZIMGEntry;
  Dir: TWZDirectory;
  img: TWZFile;
  Bmp: TBitmap;
  IName: string;

const
  Icons: array[0..2] of string = ('icon', 'face', 'hairOverHead');
begin

  CharacterDir := Category;

  Grid.ColCount := 10;
  Dir := TWZDirectory(CharacterWZ.Root.Entry[CharacterDir]);
  Grid.RowCount := Dir.Files.Count + 2;
  Row := -1;

  for img in Dir.Files do
  begin
    if not CharInSet(img.Name[8], ['0'..'9']) then
      Continue;

    DumpData2(CharacterWZ.GetImgFile(CharacterDir + '/' + img.Name).Root.Child['info']);

    Inc(Row);
    ID := LeftStr(img.Name, 8);
    Grid.Cells[1, Row] := ID;
    ID := IDToInt(ID);

    if CharacterDir = 'Totem' then
    begin
      Name := StringWZ.GetImgFile('Eqp.img').Root.Get('Eqp/Accessory/' + ID + '/name', '');
      Desc := StringWZ.GetImgFile('Eqp.img').Root.Get('Eqp/Accessory/' + ID + '/desc', '');
      h1 := StringWZ.GetImgFile('Eqp.img').Root.Get('Eqp/Accessory/' + ID + '/h1', '');
    end
    else if CharacterDir <> 'TamingMob' then
    begin
      Name := StringWZ.GetImgFile('Eqp.img').Root.Get('Eqp/' + CharacterDir + '/' + ID + '/name', '');
      Desc := StringWZ.GetImgFile('Eqp.img').Root.Get('Eqp/' + CharacterDir + '/' + ID + '/desc', '');
      h1 := StringWZ.GetImgFile('Eqp.img').Root.Get('Eqp/' + CharacterDir + '/' + ID + '/h1', '');
    end
    else
    begin
      Name := StringWZ.GetImgFile('Eqp.img').Root.Get('Eqp/Taming/' + ID + '/name', '');
      Desc := StringWZ.GetImgFile('Eqp.img').Root.Get('Eqp/Taming/' + ID + '/desc', '');
      h1 := StringWZ.GetImgFile('Eqp.img').Root.Get('Eqp/Taming/' + ID + '/h1', '');
    end;

    Grid.Cells[3, Row] := Name;

    for Iter in CharacterWZ.GetImgFile(CharacterDir + '/' + img.Name).Root.Children do
    begin

      for j := 0 to 2 do
      begin
        if Iter.Child[Icons[j]] <> nil then
        begin
          Bmp := Iter.Get2(Icons[j]).Canvas.DumpBmp;
          Grid.CreateBitmap(2, Row, False, haCenter, vaCenter).Assign(Bmp);
          Bmp.Free;
        end;
      end;



    end;



    Entry4 := GetEntry('Character/' + CharacterDir + '/' + img.Name + '/info/level/case/1/4');
    if Entry4 <> nil then
    begin
      SetLength(joins, Entry4.Get('Skill').Children.Count);
      for i := 0 to High(joins) do
      begin
        Ids := Entry4.Get('Skill/' + IntToStr(i) + '/id', '');
        Jobs := StringWZ.GetImgFile('Skill.img').Root.Get(GetJobID(Ids) + '/bookName', '');
        Skills := StringWZ.GetImgFile('Skill.img').Root.Get(Ids + '/name', '');
        lv := Entry4.Get('Skill/' + IntToStr(i) + '/level', '');
        joins[i] := Jobs + ' - ' + Skills + '+' + lv;
      end;

    end;

    Entry6 := GetEntry('Character/' + CharacterDir + '/' + img.Name + '/info/level/case/1/6');
    if Entry6 <> nil then
    begin
      SetLength(joins, Entry6.Get('Skill').Children.Count);
      for i := 0 to High(joins) do
      begin
        Ids := Entry6.Get('Skill/' + IntToStr(i) + '/id', '');
        Jobs := StringWZ.GetImgFile('Skill.img').Root.Get(GetJobID(Ids) + '/bookName', '');
        Skills := StringWZ.GetImgFile('Skill.img').Root.Get(Ids + '/name', '');
        lv := Entry6.Get('Skill/' + IntToStr(i) + '/level', '');
        joins[i] := Jobs + ' - ' + Skills + '+' + lv;
      end;

    end;

    if PageIndex = 11 then
    begin
    {
      SkillID := CharacterWZ.GetImgFile('Ring/' + img.Name).Root.Get('info/level/case/0/1/EquipmentSkill/0/id', '');
      if SkillID <> '' then
      begin
        if MidStr(SkillID, 4, 1) = '0' then
          Common := SkillWZ.GetImgFile(LeftStr(SkillID, 6) + '.img').Root.Get('skill/' + SkillID + '/common')
        else
          Common := SkillWZ.GetImgFile(LeftStr(SkillID, 4) + '.img').Root.Get('skill/' + SkillID + '/common');
        h := StringWZ.GetImgFile('Skill.img').Root.Get(SkillID + '/' + 'h', '');
        s1 := StringReplace(h, 'mpConMP', 'mpCon MP', [rfReplaceAll]);
        s2 := StringReplace(s1, ',', ' ,', [rfReplaceAll]);
        if Common <> nil then
        begin
          MaxLev := Common.Get('maxLevel', '1');
          if h <> '' then
            ColList1.Add('   Lv.' + IntToStr(MaxLev) + '技能效果: ' + TRegEx.Replace(s2, '\#[a-z,A-Z,\.]+', CommonMatch));
        end;

      end;
      }
    end;

  end;


  PutGridData2(4);
  Grid.InsertRows(0, 1);
  Grid.ColumnHeaders.Add('');
  Grid.ColumnHeaders.Add('ID');
  Grid.ColumnHeaders.Add('Icon');
  Grid.ColumnHeaders.Add('Name');
  Grid.ColumnHeaders.Add('Info');
  Grid.DefaultRowHeight := 45;
  Grid.ColWidths[0] := 10;
  Grid.RowHeights[0] := 22;
  Grid.RowHeights[1] := 35;
  Grid.ColWidths[1] := 93;
  Grid.ColWidths[2] := 69;
  Grid.ColWidths[3] := 202;
  Grid.ColWidths[4] := 900;
  Grid.ColWidths[5] := 880;
  Grid.SortByColumn(1);
  Grid.RemoveDuplicates(1, False);

  if Grid.Cells[1, 1] = '' then
    Grid.RemoveRows(1, 1);

  for i := 0 to Grid.ColCount - 1 do
    Grid.CellProperties[i, 0].Alignment := taCenter;

  for i := 0 to Grid.RowCount - 1 do
    if Length(Grid.Cells[4, i]) > 173 then
      Grid.RowHeights[i] := 45;

end;

function AddBlank(S: string): string;
begin
  case Length(S) of
    3:
      Result := '  ' + S;
    4, 7:
      Result := ' ' + S;
  end;
end;

procedure Eval(Formula: string; var Value: Real; var ErrPos: Integer);
const
  Digit: set of Char = ['0'..'9'];
var
  Posn: Integer;
  CurrChar: Char;

  procedure ParseNext;
  begin
    repeat
      Posn := Posn + 1;
      if Posn <= Length(Formula) then
        CurrChar := Formula[Posn]
      else
        CurrChar := ^M;
    until CurrChar <> '   ';
  end { ParseNext };

  function add_subt: Real;
  var
    E: Real;
    Opr: Char;

    function mult_DIV: Real;
    var
      S: Real;
      Opr: Char;

      function Power: Real;
      var
        t: Real;

        function SignedOp: Real;

          function UnsignedOp: Real;
          type
            StdFunc = (u, D, fabs, fsqrt, fsqr, fsin, fcos, farctan, fln, flog, fexp, ffact);

            StdFuncList = array[StdFunc] of string[6];
          const
            StdFuncName: StdFuncList = ('U', 'D', 'ABS', 'SQRT', 'SQR', 'SIN', 'COS', 'ARCTAN', 'LN',
              'LOG', 'EXP', 'FACT');
          var
            E, L, Start: Integer;
            Funnet: Boolean;
            F: Real;
            Sf: StdFunc;

            function Fact(i: Integer): Real;
            begin
              if i > 0 then
              begin
                Fact := i * Fact(i - 1);
              end
              else
                Fact := 1;
            end { Fact };

          begin
            if CurrChar in Digit then
            begin
              Start := Posn;
              repeat
                ParseNext
              until not (CurrChar in Digit);
              if CurrChar = '.' then
                repeat
                  ParseNext
                until not (CurrChar in Digit);
              if CurrChar = 'E' then
              begin
                ParseNext;
                repeat
                  ParseNext
                until not (CurrChar in Digit);
              end;
              Val(Copy(Formula, Start, Posn - Start), F, ErrPos);
            end
            else if CurrChar = '(' then
            begin
              ParseNext;
              F := add_subt;
              if CurrChar = ')' then
                ParseNext
              else
                ErrPos := Posn;
            end
            else
            begin
              Funnet := False;
              for Sf := u to ffact do
                if not Funnet then
                begin
                  L := Length(StdFuncName[Sf]);
                  if Copy(Formula, Posn, L) = StdFuncName[Sf] then
                  begin
                    Posn := Posn + L - 1;
                    ParseNext;
                    F := UnsignedOp;
                    case Sf of
                      u:
                        F := Ceil(F);
                      D:
                        F := Floor(F);
                      fabs:
                        F := Abs(F);
                      fsqrt:
                        F := Sqrt(F);
                      fsqr:
                        F := Sqr(F);
                      fsin:
                        F := Sin(F);
                      fcos:
                        F := Cos(F);
                      farctan:
                        F := ArcTan(F);
                      fln:
                        F := Ln(F);
                      flog:
                        F := Ln(F) / Ln(10);
                      fexp:
                        F := Exp(F);
                      ffact:
                        F := Fact(Trunc(F));
                    end;
                    Funnet := True;
                  end;
                end;
              if not Funnet then
              begin
                ErrPos := Posn;
                F := 0;
              end;
            end;
            UnsignedOp := F;
          end { UnsignedOp };

        begin { SignedOp }
          if CurrChar = '-' then
          begin
            ParseNext;
            SignedOp := -UnsignedOp;
          end
          else
            SignedOp := UnsignedOp;
        end { SignedOp };

      begin { Power }
        t := SignedOp;
        while CurrChar = '^' do
        begin
          ParseNext;
          if t <> 0 then
            t := Exp(Ln(Abs(t)) * SignedOp)
          else
            t := 0;
        end;
        Power := t;
      end { Power };

    begin
      S := Power;
      while CurrChar in ['*', '/'] do
      begin
        Opr := CurrChar;
        ParseNext;
        case Opr of
          '*':
            S := S * Power;
          '/':
            S := S / Power;
        end;
      end;
      mult_DIV := S;
    end;

  begin
    E := mult_DIV;
    while CurrChar in ['+', '-'] do
    begin
      Opr := CurrChar;
      ParseNext;
      case Opr of
        '+':
          E := E + mult_DIV;
        '-':
          E := E - mult_DIV;
      end;
    end;
    add_subt := E;
  end;

begin
  if Formula[1] = '.' then
    Formula := '0' + Formula;
  if Formula[1] = '+' then
    Delete(Formula, 1, 1);
  for Posn := 1 to Length(Formula) do
    Formula[Posn] := UpCase(Formula[Posn]);
  Posn := 0;
  ParseNext;
  Value := add_subt;
  if CurrChar = ^M then
    ErrPos := 0
  else
    ErrPos := Posn;
end;

function GetFValue(FormStr: string; Level: Integer): Real;
var
  E: Integer;
  A: Real;
  Str: string;
begin
  Str := StringReplace(FormStr, 'x', IntToStr(Level), [rfReplaceAll]);
  Eval(Str, A, E);
  Result := A;
end;

function TForm1.CommonMatch(const Match: TMatch): string;
var
  MatchName: string;
  Iter: TWZIMGEntry;
begin
  MatchName := MidStr(Match.Value, 2, 100);

  for Iter in Common.Children do
    if Iter.Name = MatchName then
      Result := Variant(GetFValue(Iter.Data, MaxLev));
end;

function TForm1.PCommonMatch(const Match: TMatch): string;
var
  MatchName: string;
  Iter: TWZIMGEntry;
begin
  MatchName := MidStr(Match.Value, 2, 100);

  for Iter in PCommon.Children do
    if Iter.Name = MatchName then
      Result := Variant(GetFValue(Iter.Data, PMaxLev));
end;


procedure TForm1.LoadSkill(Part: Integer);
var
  i, Len, Row, Col, Sum: Integer;
  Iter, Iter2, Iter3, Child, h1, iterreq, Source, Child1, IChar, Action: TWZIMGEntry;
  SkillID, Desc, PDesc, Ph, Name, BookID, BookName, InfoData, s1, s2, h, hStr, hString: string;
  img: TWZFile;
  D: Variant;
  Bmp, Bmp2: TBitmap;

  WZ: TWZArchive;
begin

  Grid.ColCount := 12;

  Row := -1;
  case Part of
    1:
      WZ := SkillWZ;
    2:
      WZ := Skill001Wz;
  end;
  for img in WZ.Root.Files do
  begin
    Len := Length(img.Name);
    if CharInSet(img.Name[1], ['0'..'9']) then
    begin
      Inc(Row);
      Grid.RowCount := Row + 1;

      DumpData2(WZ.GetImgFile(img.Name).Root.Get2('info'));
      BookID := LeftStr(img.Name, Len - 4);
      BookName := StringWZ.GetImgFile('Skill.img').Root.Get(BookID + '/' + 'bookName', '');

      Grid.Cells[1, Row] := AddBlank(BookID);
      Grid.Cells[3, Row] := BookName;
      Grid.Cells[4, Row] := '';

      for Iter in WZ.GetImgFile(img.Name).Root.Children do
      begin
        if Iter.Child['icon'] <> nil then
        begin
          Bmp := Iter.Get2('icon').Canvas.DumpBmp;
          Grid.CreateBitmap(2, Row, False, haCenter, vaCenter).Assign(Bmp);
          Bmp.Free;
        end;

        for Iter2 in Iter.Children do
        begin

          if Iter.Name = 'skill' then
          begin
            Inc(Row);
            Grid.RowCount := Row + 1;
            DumpData2(Iter2);
            SkillID := Iter2.Name;
            Grid.Cells[1, Row] := SkillID;
            Name := StringWZ.GetImgFile('Skill.img').Root.Get(SkillID + '/' + 'name', '');
            if (Iter2.Child['icon'] <> nil) and (Iter2.Child['icon'].DataType = mdtCanvas) then
            begin
              Bmp2 := Iter2.Get2('icon').Canvas.DumpBmp;
              Grid.CreateBitmap(2, Row, False, haCenter, vaCenter).Assign(Bmp2);
              Bmp2.Free;
            end;

            Grid.Cells[3, Row] := Name;
            Desc := StringWZ.GetImgFile('Skill.img').Root.Get(SkillID + '/' + 'desc', '');
            Grid.Cells[4, Row] := Desc;
            Common := Iter2.Child['common'];
            h := StringWZ.GetImgFile('Skill.img').Root.Get(SkillID + '/' + 'h', '');
            s1 := StringReplace(h, 'mpConMP', 'mpCon MP', [rfReplaceAll]);
            s2 := StringReplace(s1, ',', ' ,', [rfReplaceAll]);
            if Common <> nil then
            begin
              MaxLev := Common.Get('maxLevel', '1');
              if h <> '' then
                Grid.Cells[5, Row] := 'Lv.' + IntToStr(MaxLev) + '= ' + TRegEx.Replace(s2,
                  '\#[0-9,_,a-z,A-Z,\.]+', CommonMatch);
            end;
            h1 := GetEntry('String.wz/Skill.img/' + SkillID + '/h1');
            if h1 <> nil then
              Grid.Cells[6, Row] := h1.Data;
            {
              PDesc := StringWZ.GetImgFile('Skill.img').Root.Get(SkillID + '/' + 'pdesc', '');
              Grid.Cells[21, Row] := PDesc;
              PCommon := Iter2.Child['PVPcommon'];
              Ph := StringWZ.GetImgFile('Skill.img').Root.Get(SkillID + '/' + 'ph', '');
              if PCommon <> nil then
              begin
              PMaxLev := PCommon.Get('maxLevel', '1');
              if Ph <> '' then
              begin
              Grid.Cells[22, Row] := 'Lv.' + IntToStr(PMaxLev) + '效果: ' + TRegEx.Replace(Ph, '\#[a-z,A-Z,\.]+', PCommonMatch);
              // Grid.MarkInCell(False, 19, Row, 'Lv.' + IntToStr(MaxLev) + '效果');
              end;
              end;
            }



          end;

          Col := -1;

          // max level

        end;
      end;
    end;

  end;


  PutGridData2(6);
  Grid.InsertRows(0, 1);
  Grid.DefaultRowHeight := 45;
  Grid.FixedRowHeight := 25;
  Grid.RowHeights[1] := 33;
  Grid.ColWidths[1] := 90;
  Grid.ColWidths[2] := 45;
  Grid.ColWidths[3] := 132;
  Grid.ColWidths[4] := 400;
  Grid.ColWidths[5] := 400;
  Grid.ColWidths[6] := 750;
  Grid.ColumnHeaders.Clear;
  Grid.ColumnHeaders.Add('');
  Grid.ColumnHeaders.Add('ID');
  Grid.ColumnHeaders.Add('Icon');
  Grid.ColumnHeaders.Add('Name');
  Grid.ColumnHeaders.Add('Description');
  Grid.ColumnHeaders.Add('Level');
  Grid.ColumnHeaders.Add('Info');

  Grid.SortByColumn(1);
  // Grid.RemoveDuplicates(1, False);

  // Grid.ColumnHeaders.Add('PvP戰鬥效果');
  if Grid.Cells[1, 1] = '' then
    Grid.RemoveRows(1, 1);

  for i := 0 to Grid.ColCount - 1 do
    Grid.CellProperties[i, 0].Alignment := taCenter;

end;

procedure TForm1.LoadMob(Part: Integer);
var
  MobImg: TWZFile;
  i, j, Row: Integer;
  ID, Name, AttrName, Data, Data2, Data3, Data4, D: string;
  Iter, Iter2, Iter3, Iter4, Source, Child, MobEntry: TWZIMGEntry;
  Mob1Entry, Mob2Entry: TWZEntry;
  Link: TLinkInfo;
  Links: TList<TLinkInfo>;
  Bmp: TBitmap;

  WZ: TWZArchive;
begin
  if (not FileExists(Edit1.Text + '\Mob2.wz')) and (Part = 3) then
  begin
    ShowMessage('No Mob2.wz');
    Exit;
  end;



  Links := TList<TLinkInfo>.Create;
  Row := -1;

  case Part of
    1, 2:
      WZ := MobWZ;
    3:
      WZ := Mob2WZ;
  end;
  Grid.ColCount := 8;

  for MobImg in WZ.Root.Files do
  begin
    if (MobImg.Name = '9400090.img') or (MobImg.Name = '9402153.img') or (MobImg.Name = '9402152.img') then
      Continue;

    if Part <> 3 then
      case Part of
        1:
          if CharInSet(MobImg.Name[1], ['9']) then
            Continue;
        2:
          if CharInSet(MobImg.Name[1], ['0'..'8']) then
            Continue;
      end;

    ID := LeftStr(MobImg.Name, 7);
    Inc(Row);

    DumpData2(WZ.GetImgFile(MobImg.Name).Root);

    Grid.RowCount := Row + 2;
    Grid.Cells[1, Row] := ID;
    Name := StringWZ.GetImgFile('Mob.img').Root.Get(IDToInt(ID) + '/' + 'name', '');
    Grid.Cells[3, Row] := Name;

    if Part <> 3 then
    begin
      MobEntry := WZ.GetImgFile(MobImg.Name).Root;
      if MobEntry.Child['stand'] <> nil then
        Bmp := MobEntry.Get2('stand/0').Canvas.DumpBmp
      else
        Bmp := MobEntry.Get2('fly/0').Canvas.DumpBmp; // else
    end
    else
    begin
      MobEntry := Mob2WZ.GetImgFile(MobImg.Name).Root;
      if MobEntry.Child['stand'] <> nil then
        Bmp := MobEntry.Get2('stand/0').Canvas.DumpBmp
      else
        Bmp := MobEntry.Get2('fly/0').Canvas.DumpBmp; // else
    end;

    Grid.CreateBitmap(2, Row, False, haCenter, vaCenter).Assign(Bmp);
    Bmp.Free;

    for Iter in WZ.GetImgFile(MobImg.Name).Root.Children do
    begin

      if (Iter.DataType = mdtCanvas) and (RightStr(Iter.Name, 4) = '.png') then
      begin

        if Part <> 3 then
        begin
          Bmp := GetEntry('Mob/' + MobImg.Name + '/' + Iter.Name, True).Canvas.DumpBmp;
          Grid.CreateBitmap(2, Row, False, haCenter, vaCenter).Assign(Bmp);
          Bmp.Free;
        end
        else
        begin
          Bmp := GetEntryMob2('Mob2/' + MobImg.Name + '/' + Iter.Name).Canvas.DumpBmp;
          Grid.CreateBitmap(2, Row, False, haCenter, vaCenter).Assign(Bmp);
          Bmp.Free;
        end;
      end;

      for Iter2 in Iter.Children do
      begin
        if Iter2.Name = 'link' then
        begin
          Link.ID := Iter2.Data;
          Link.Row := Row;
          Links.Add(Link);
        end;


      end;

    end;

  end;

  for i := 0 to Links.Count - 1 do
  begin
    Mob1Entry := MobWZ.Root.Entry[Links[i].ID + '.img'];

    if Mob1Entry <> nil then
    begin
      MobEntry := MobWZ.GetImgFile(Links[i].ID + '.img').Root;
      if MobEntry.Child['stand'] <> nil then
        Bmp := MobEntry.Get2('stand/0').Canvas.DumpBmp
      else
        Bmp := MobEntry.Get2('fly/0').Canvas.DumpBmp;

      Grid.CreateBitmap(2, Links[i].Row, False, haCenter, vaCenter).Assign(Bmp);
      Bmp.Free;
    end;

    if FileExists(Edit1.Text + '\Mob2.wz') then
      Mob2Entry := Mob2WZ.Root.Entry[Links[i].ID + '.img'];

    if Mob2Entry <> nil then
    begin
      MobEntry := Mob2WZ.GetImgFile(Links[i].ID + '.img').Root;
      if MobEntry.Child['stand'] <> nil then
        Bmp := MobEntry.Get2('stand/0').Canvas.DumpBmp
      else
        Bmp := MobEntry.Get2('fly/0').Canvas.DumpBmp;

      Grid.CreateBitmap(2, Links[i].Row, False, haCenter, vaCenter).Assign(Bmp);
      Bmp.Free;
    end;

  end;


  PutGridData2(4);

  Grid.InsertRows(0, 1);
  Grid.ColumnHeaders.Add('');
  Grid.ColumnHeaders.Add('ID');
  Grid.ColumnHeaders.Add('Mob');
  Grid.ColumnHeaders.Add('Name');
  Grid.ColumnHeaders.Add('Info');
  Grid.ColWidths[0] := 10;
  Grid.RowHeights[0] := 22;
  Grid.ColWidths[1] := 80;
  Grid.ColWidths[2] := 200;
  Grid.ColWidths[3] := 150;
  Grid.ColWidths[4] := 800;
  Grid.ColWidths[5] := 580;
  Grid.RemoveDuplicates(1, False);
  Grid.SortByColumn(1);

  for i := 0 to Grid.RowCount - 1 do
  begin
    if Grid.CellTypes[2, i] = ctBitmap then
    begin
      Grid.RowHeights[i] := Grid.GetBitmap(2, i).Height + 2;
      if Grid.RowHeights[i] > 200 then
        Grid.RowHeights[i] := 200;
      if Grid.RowHeights[i] < 30 then
        Grid.RowHeights[i] := 30;
    end;
  end;
  if Grid.Cells[1, 1] = '' then
    Grid.RemoveRows(1, 1);
  for i := 0 to Grid.ColCount - 1 do
    Grid.CellProperties[i, 0].Alignment := taCenter;

  Links.Free;

end;

function Add9(Name: string): string;
begin
  case Length(Name) of
    1:
      Result := '00000000' + Name;
    5:
      Result := '0000' + Name;
    7:
      Result := '00' + Name;
    9:
      Result := Name;
  end;
end;

procedure TForm1.LoadMap(Part: Integer);
var
  i, Row, Col: Integer;
  Name, Desc, InfoData, ID: string;
  Iter, Iter2, Child, Entry: TWZIMGEntry;
  LEntry: TWZEntry;
  Dir: TWZDirectory;
  img: TWZFile;
  MapNameInfo: TMapNameInfo;
  MapNames: TDictionary<string, TMapNameInfo>;
  Png: TPngImage;
  Bmp: TBitmap;
  Link: TLinkInfo;
  Links: TList<TLinkInfo>;
begin
  Links := TList<TLinkInfo>.Create;
  Row := -1;
  MapNames := TDictionary<string, TMapNameInfo>.Create;
  for Iter in StringWZ.GetImgFile('Map.img').Root.Children do
    for Iter2 in Iter.Children do
    begin
      ID := Add9(Iter2.Name);
      MapNameInfo.MapName := Iter2.Get('mapName', '');
      MapNameInfo.StreetName := Iter2.Get('streetName', '');
      MapNames.Addorsetvalue(ID, MapNameInfo);
    end;
  Grid.ColCount := 10;
  for Dir in TWZDirectory(MapWz.Root.Entry['Map']).SubDirs do
  begin

    for img in Dir.Files do
    begin
      Col := -1;

      case Part of
        1:
          if CharInSet(img.Name[1], ['3'..'9']) then
            Continue;
        2:
          if CharInSet(img.Name[1], ['0'..'4', '9']) then
            Continue;
        3:
          if CharInSet(img.Name[1], ['0'..'8']) then
            Continue;
      end;

      ID := LeftStr(img.Name, 9);
      if MapNames.ContainsKey(ID) then
      begin
        Entry := MapWz.GetImgFile('Map/' + Dir.Name + '/' + img.Name).Root;
        Inc(Row);
        DumpData2(Entry.Get2('info'));
        Grid.RowCount := Row + 2;
        Grid.Cells[1, Row] := ID;

        Child := Entry.Get('miniMap/canvas');
        if (Child <> nil) and (Child.DataType = mdtCanvas) then
        begin
          Bmp := Child.Canvas.DumpBmp;
          Grid.CreateBitmap(2, Row, False, haCenter, vaCenter).Assign(Bmp);
          Bmp.Free;
        end;
        Grid.Cells[4, Row] := MapNames[ID].MapName;
        Grid.Cells[3, Row] := MapNames[ID].StreetName;
        Child := Entry.Get('info');

        Child := Entry.Get('info/link');
        if Child <> nil then
        begin
          Link.ID := 'Map/Map' + LeftStr(Child.Data, 1) + '/' + Child.Data + '.img';
          Link.Row := Row;
          Links.Add(Link);
        end;

      end;
    end;
  end;

  for i := 0 to Links.Count - 1 do
  begin
    Child := MapWz.GetImgFile(Links[i].ID).Root.Get('miniMap/canvas');

    if Child <> nil then
    begin
      Bmp := Child.Canvas.DumpBmp;
      Grid.CreateBitmap(2, Links[i].Row, False, haCenter, vaCenter).Assign(Bmp);
      Bmp.Free;
    end;

  end;

  PutGridData2(5);
  Grid.InsertRows(0, 1);
  Grid.ColumnHeaders.Add('');
  Grid.ColumnHeaders.Add('ID');
  Grid.ColumnHeaders.Add('Icon');
  Grid.ColumnHeaders.Add('Street Name');
  Grid.ColumnHeaders.Add('Map name');
  Grid.ColumnHeaders.Add('Info');
  Grid.ColWidths[0] := 10;
  Grid.RowHeights[0] := 22;
  Grid.ColWidths[1] := 100;
  Grid.ColWidths[2] := 300;
  Grid.ColWidths[3] := 100;
  Grid.ColWidths[4] := 170;
  Grid.ColWidths[5] := 550;
  Grid.RemoveDuplicates(1, False);
  Grid.SortByColumn(1);

  for i := 0 to Grid.RowCount - 1 do
  begin
    if Grid.CellTypes[2, i] = ctBitmap then
    begin
      Grid.RowHeights[i] := Grid.GetBitmap(2, i).Height + 2;
      if Grid.RowHeights[i] > 200 then
        Grid.RowHeights[i] := 200;
      if Grid.RowHeights[i] < 35 then
        Grid.RowHeights[i] := 35;

    end;
  end;

  if Grid.Cells[1, 1] = '' then
    Grid.RemoveRows(1, 1);
  for i := 0 to Grid.ColCount - 1 do
    Grid.CellProperties[i, 0].Alignment := taCenter;
  MapNames.Free;
  Links.Free;
end;

procedure TForm1.LoadNpc;
var
  Link: TLinkInfo;
  Links: TList<TLinkInfo>;
  NpcImg: TWZFile;
  Row, i, c: Integer;
  Name, Data, ID: string;
  Iter, Iter2, Entry, Source: TWZIMGEntry;
  Bmp: TBitmap;
begin
  Links := TList<TLinkInfo>.Create;
  Row := -1;
  Grid.ColCount := 10;
  Grid.RowCount := NPCWZ.Root.Files.Count;

  for NpcImg in NPCWZ.Root.Files do
  begin

    DumpData2(NPCWZ.GetImgFile(NpcImg.Name).Root.Child['info']);
    Inc(Row);
    Grid.Cells[1, Row] := LeftStr(NpcImg.Name, 7);
    ID := IDToInt(LeftStr(NpcImg.Name, 7));
    Name := StringWZ.GetImgFile('Npc.img').Root.Get(ID + '/name', '');

    Grid.Cells[3, Row] := Name;
    c := -1;
    Entry := StringWZ.GetImgFile('Npc.img').Root.Get(ID);

    {
      Entry := GetEntry('Npc/' + NpcImg.Name + '/stand');
      if Entry.Child['0'] <> nil then
      begin
      Bmp := Entry.Get2('0').Canvas.DumpBmp;
      Grid.CreateBitmap(2, Row, False, haCenter, vaCenter).Assign(Bmp);
      Bmp.Free;
      end
      else if Entry.Child['default'] <> nil then
      begin
      Bmp := Entry.Get2('default').Canvas.DumpBmp;
      Grid.CreateBitmap(2, Row, False, haCenter, vaCenter).Assign(Bmp);
      Bmp.Free;
      end;
    }

    Entry := NPCWZ.GetImgFile(NpcImg.Name).Root;

    if Entry.Child['stand'] <> nil then
    begin
      Bmp := Entry.Get2('stand/0').Canvas.DumpBmp;
      Grid.CreateBitmap(2, Row, False, haCenter, vaCenter).Assign(Bmp);
      Bmp.Free;
    end;

    if Entry.Child['default'] <> nil then
    begin
      Bmp := Entry.Get2('default/0').Canvas.DumpBmp;
      Grid.CreateBitmap(2, Row, False, haCenter, vaCenter).Assign(Bmp);
      Bmp.Free;
    end;

    for Iter in NPCWZ.GetImgFile(NpcImg.Name).Root.Children do
    begin

      for Iter2 in Iter.Children do
      begin

        if Iter2.Name = 'link' then
        begin
          Link.ID := Iter2.Data;
          Link.Row := Row;
          Links.Add(Link);
        end;

      end;
    end;
  end;

  for i := 0 to Links.Count - 1 do
  begin
    Entry := GetEntry('Npc/' + Links[i].ID + '.img/stand');
    if Entry.Child['0'] <> nil then
    begin
      Bmp := Entry.Get2('0').Canvas.DumpBmp;
      Grid.CreateBitmap(2, Links[i].Row, False, haCenter, vaCenter).Assign(Bmp);
      Bmp.Free;
    end;
  end;

  PutGridData2(4);
  Grid.InsertRows(0, 1);
  Grid.ColumnHeaders.Add('');
  Grid.ColumnHeaders.Add('ID');
  Grid.ColumnHeaders.Add('Icon');
  Grid.ColumnHeaders.Add('Name');
  Grid.ColumnHeaders.Add('Info');
  Grid.ColWidths[0] := 10;
  Grid.RowHeights[0] := 22;
  Grid.ColWidths[1] := 80;
  Grid.ColWidths[2] := 200;
  Grid.ColWidths[3] := 100;
  Grid.ColWidths[4] := 570;
  Grid.ColWidths[5] := 500;
  Grid.SortByColumn(1);

  for i := 0 to Grid.RowCount - 1 do
  begin
    if Grid.CellTypes[2, i] = ctBitmap then
    begin
      Grid.RowHeights[i] := Grid.GetBitmap(2, i).Height + 2;
      if Grid.RowHeights[i] > 200 then
        Grid.RowHeights[i] := 200;
      if Grid.RowHeights[i] < 30 then
        Grid.RowHeights[i] := 30;
    end;
  end;

  for i := 0 to Grid.ColCount - 1 do
    Grid.CellProperties[i, 0].Alignment := taCenter;

  Links.Free;
end;

procedure TForm1.LoadMusic;
var
  Iter: TWZIMGEntry;
  img: TWZFile;
  i, Row: Integer;
begin
  Row := -1;
  Grid.ColCount := 10;

  for img in SoundWZ.Root.Files do
  begin
    if LeftStr(img.Name, 3) = 'Bgm' then
      for Iter in SoundWZ.GetImgFile(img.Name).Root.Children do
      begin
        Inc(Row);
        Grid.RowCount := Row + 2;
        Grid.Cells[1, Row] := ('    ' + img.Name + '/' + Iter.Name);
      end;
  end;

  if HasSound2WZ then
    for img in Sound2Wz.Root.Files do
    begin
      if LeftStr(img.Name, 3) = 'Bgm' then
        for Iter in Sound2Wz.GetImgFile(img.Name).Root.Children do
        begin
          Inc(Row);
          Grid.RowCount := Row + 2;
          Grid.Cells[1, Row] := ('    ' + img.Name + '/' + Iter.Name);
        end;
    end;

  Grid.InsertRows(0, 1);
  Grid.RemoveDuplicates(1, False);
  Grid.SortByColumn(1);
  Grid.DefaultRowHeight := 27;
  Grid.ColWidths[1] := 350;
  if Grid.Cells[1, 1] = '' then
    Grid.RemoveRows(1, 1);

  Grid.ColumnHeaders.Add('');
  Grid.ColumnHeaders.Add('     點擊播放音樂');
end;

procedure TForm1.SetView;
var
  i: Integer;
begin
  case ViewMode of
    vmSmall:
      begin
        Grid.DefaultRowHeight := 32;
      end;

    vmFull:
      begin
        for i := 0 to Grid.RowCount - 1 do
          if Grid.CellTypes[2, i] = ctBitmap then
            Grid.RowHeights[i] := Grid.GetBitmap(2, i).Height + 2;
        Grid.ColWidths[2] := 200;
      end;
  end;
  Grid.RowHeights[0] := 22;
end;

procedure TForm1.LoadBIN;
begin
  if FileExists(BINName + '.BIN') then
  begin
    with Grid.Canvas do
    begin
      Font.Size := 25;
      Brush.Color := clGrayText;
      TextOut(150, 150, '載入中...');
    end;
  end;
  Grid.LoadFromBinFile(BINName + '.BIN');
  for var i := 0 to Grid.ColCount - 1 do
    Grid.CellProperties[i, 0].FontSize := 19;
end;

procedure TForm1.LoadWZ;
var
  i: Int64;
begin
  i := GetTickCount;
  Grid.BeginUpdate;
  Grid.ColCount := 8;
  Grid.RowCount := 100;
  Grid.ClearAll;
  Grid.ColumnHeaders.Clear;
  Row1 := -1;
  Row2 := -1;

  RowList2.Clear;
  case PageIndex of
    0, 1, 27, 28, 38:
      LoadItem(1);
    2:
      LoadItem(2);
    3:
      LoadItem(3);
    4..17, 29..34:
      LoadCharacter;
    18:
      LoadMap(1);
    19:
      LoadMap(2);

    20:
      LoadMap(3);
    21:
      LoadMob(1);
    22:
      LoadMob(2);
    23:
      LoadMob(3);
    24:
      LoadSkill(1);
    25:
      LoadSkill(2);
    26:
      LoadNpc;
    35:
      LoadMorph;

    36:
      LoadFamiliar;
    37:
      LoadDamageSkin;
    39:
      LoadReactor;
    40:
      LoadMusic;
  end;
  Grid.RowHeights[0] := 22;
  Grid.ScrollInView(0, 0);
  Grid.EndUpdate;
  // caption := variant(gettickcount - i);
end;

procedure TForm1.Edit1Click(Sender: TObject);
begin
  Edit1.Clear;
  if FolderDialog1.Execute then
  begin
    Edit1.Text := FolderDialog1.Directory;

  end;
end;

procedure TForm1.Edit2Change(Sender: TObject);
begin
  Grid.NarrowDown(Edit2.Text);
end;

procedure TForm1.AdvOfficePager1Change(Sender: TObject);
var
  Name: string;
  Len: Integer;
begin
  Edit2.Clear;
  Grid.ClearAll;

  PageIndex := AdvOfficePager1.ActivePageIndex;
  Grid.Parent := AdvOfficePager1.ActivePage;
  Grid.ScrollInView(0, 0);

  Name := AdvOfficePager1.ActivePage.Name;
  Len := Length(Name);
  if CharInSet(Name[Len], ['0'..'9']) then
    Category := LeftStr(Name, Len - 1)
  else
    Category := Name;
  BINName := Name;

  case PageIndex of
    0..16, 24..30:
      begin
        AeroSpeedButton4.Visible := False;
        AeroSpeedButton5.Visible := False;
      end;
    18, 19, 20, 21, 22, 23:
      begin
        AeroSpeedButton4.Visible := True;
        AeroSpeedButton5.Visible := True;
      end;
  end;
  Grid.ScrollInView(0, 0);
  if DataMode = dmBIN then
    LoadBIN;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TWZReader.EncryptionIV := 0;

  Label1.Visible := False;
  Edit1.Visible := False;
  LoadButton.Visible := False;
  Category := 'Cash';
  PageIndex := 0;
  BINName := 'Cash';
  DataMode := dmWZ;
  Label1.Visible := True;
  Edit1.Visible := True;
  LoadButton.Visible := True;
  // LoadBIN;
  ViewMode := vmFull;


  RowList2 := TDictionary<Integer, string>.Create;
  ColList2 := TStringList.Create;
  BassInit;
  Edit2.Clear;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  if StringWZ <> nil then
    FreeAndNil(StringWZ);
  if ItemWZ <> nil then
    FreeAndNil(ItemWZ);
  if CharacterWZ <> nil then
    FreeAndNil(CharacterWZ);
  if SkillWZ <> nil then
    FreeAndNil(SkillWZ);
  if Skill001Wz <> nil then
    FreeAndNil(Skill001Wz);

  if MobWZ <> nil then
    FreeAndNil(MobWZ);
  if Mob2WZ <> nil then
    FreeAndNil(Mob2WZ);
  if MapWz <> nil then
    FreeAndNil(MapWz);
  if NPCWZ <> nil then
    FreeAndNil(NPCWZ);
  if SoundWZ <> nil then
    FreeAndNil(SoundWZ);
  if Sound2Wz <> nil then
    FreeAndNil(Sound2Wz);
  if MorphWz <> nil then
    FreeAndNil(MorphWz);
  if ReactorWZ <> nil then
    FreeAndNil(ReactorWZ);
  BassFree;
  if ActiveBass <> nil then
    ActiveBass.Free;

  RowList2.Free;
  ColList2.Free;

  // ReportMemoryLeaksOnShutdown := True;
end;

procedure TForm1.GridClick(Sender: TObject);
begin
  //Grid.CopySelectionToClipboard;
end;

procedure TForm1.GridClickCell(Sender: TObject; ARow, ACol: Integer);
var
  Path: string;
  Entry: TWZIMGEntry;
begin
  if PageIndex <> 40 then
    Exit;

  Path := Trim(Grid.Rows[ARow].Text);
  if LeftStr(Path, 3) <> 'Bgm' then
    Exit;

  var WZ: TWZArchive;
  var S: TArray<string> := Path.Split(['.img/']);
  if SoundWZ.GetImgFile(S[0] + '.img') <> nil then
  begin
    Entry := SoundWZ.GetImgFile(S[0] + '.img').Root.Child[S[1]];
    WZ := SoundWZ;
  end
  else if Sound2Wz.GetImgFile(S[0] + '.img') <> nil then
  begin
    Entry := Sound2Wz.GetImgFile(S[0] + '.img').Root.Child[S[1]];
    WZ := Sound2Wz;
  end
  else
    Exit;

  if Entry <> nil then
    if Entry.DataType = mdtSound then
    begin
      if Assigned(ActiveBass) then
        FreeAndNil(ActiveBass);
      ActiveBass := TBassHandler.Create(WZ.Reader.Stream, Entry.Sound.Offset, Entry.Sound.DataLength);
      ActiveBass.Play;
    end;

end;

end.

