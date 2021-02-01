Unit MainUnit;

interface

uses System, System.Drawing, System.Windows.Forms,WzUtils, System.IO, DataGrid;

type
  MainForm = class(Form)
    procedure MainForm_Load(sender: Object; e: EventArgs);
    procedure comboBox1_SelectedIndexChanged(sender: Object; e: EventArgs);
    procedure tabControl1_Selected(sender: Object; e: TabControlEventArgs);
    procedure LoadButton_Click(sender: Object; e: EventArgs);
    procedure SaveButton_Click(sender: Object; e: EventArgs);
    procedure SearchBox_TextChanged(sender: Object; e: EventArgs);
    procedure SelectFolderBox_TextChanged(sender: Object; e: EventArgs);
    procedure SelectFolderBox_Click(sender: Object; e: EventArgs);
   private
    TabIndex: Integer;
    MaxLev: Integer;
    Common: WzNode;
    DataGrid: array[0..38] of DataViewer; 
    TempGrid: array[0..38] of DataViewer; 
    Grid: DataViewer;
    SearchGrid: DataViewer;
    function CommonMatch(const Match1: system.Text.RegularExpressions.Match): string;
    procedure LoadItem;
    procedure LoadCharacter;
    procedure LoadMap(Part: Integer);
    procedure LoadMob(Part: Integer);
    procedure LoadSkill(Part: Integer);
    procedure LoadNpc;
    procedure LoadFamiliar;
    procedure LoadDamageSkin;
    procedure LoadMorph;
    procedure LoadReactor;
    procedure LoadBIN;
  {$region FormDesigner}
  internal
    {$resource MainUnit.MainForm.resources}
    panel1: Panel;
    label2: &Label;
    label1: &Label;
    SearchBox: TextBox;
    SaveButton: Button;
    LoadButton: Button;
    SelectFolderBox: TextBox;
    comboBox1: ComboBox;
    tabControl1: TabControl;
    Cash: TabPage;
    Consume: TabPage;
    Weapon: TabPage;
    Cap: TabPage;
    Coat: TabPage;
    Longcoat: TabPage;
    Pants: TabPage;
    Shoes: TabPage;
    Glove: TabPage;
    Ring: TabPage;
    Cape: TabPage;
    Accessory: TabPage;
    Shield: TabPage;
    TamingMob: TabPage;
    Hair: TabPage;
    Face: TabPage;
    Map1: TabPage;
    Map2: TabPage;
    Map3: TabPage;
    Mob: TabPage;
    Mob001: TabPage;
    Mob2: TabPage;
    Skill: TabPage;
    Skill001: TabPage;
    Skill002: TabPage;
    Npc: TabPage;
    Pet: TabPage;
    Install: TabPage;
    Android: TabPage;
    Mechanic: TabPage;
    PetEquip: TabPage;
    Bits: TabPage;
    MonsterBattle: TabPage;
    Totem: TabPage;
    Morph: TabPage;
    Familiar: TabPage;
    DamageSkin: TabPage;
    Etc: TabPage;
    Reactor: TabPage;
    imageList1: ImageList;
    components: System.ComponentModel.IContainer;
    folderBrowserDialog1: FolderBrowserDialog;
    {$include MainUnit.MainForm.inc}
  {$endregion FormDesigner}
  public
    constructor;
    begin
      InitializeComponent;
    end;
  end;

implementation

var
  ColList, RowList: List<string>;

procedure Dump2(Entry: WzNode);
begin
  if Entry <> nil then
  begin
    if Entry.Value is WzVector then
    begin
      var P := WzVector(Entry.GetValue&<WzVector>);
      ColList.Add(Entry.GetPathD + '=' + P.X.ToString + ',' + P.Y.ToString + ',  ');
    end
    else if (Entry.GetValue('Null') <> 'Null') then 
      ColList.Add(Entry.GetPathD + '=' + Entry.GetValueEx&<string>('-') + ',  ');
    foreach var E in Entry.Nodes do
      if not (E.Value is WzPng) then
        Dump2(E);
  end;
end;

procedure DumpData2(Entry: wznode);
begin
  Dump2(Entry);
  var FinalStr: string;
  var S := Entry.GetPathD + '.';
  for var i := 0 to ColList.Count - 1 do
  begin
    ColList[i] := ColList[i].Replace(S, '');
    FinalStr := FinalStr + ColList[i];
  end;
  Delete(FinalStr, Length(FinalStr) - 2, 1);
  RowList.Add(FinalStr);
  ColList.Clear;
end;

procedure MainForm.LoadItem;
var
  ItemDir: string;
  Child: WzNode;
begin
  ItemDir := tabControl1.TabPages[TabIndex].Name;
  
  case ItemDir of
    'Etc': Child := StringWZ.GetNode('Etc.img/Etc');
    'Install': Child := StringWZ.GetNode('Ins.img');
  else
    Child := StringWZ.GetNode(ItemDir + '.img');
  end;
  
  var ID: string;
  var Icon: Bitmap;
  foreach var img in ItemWz.GetNodeA(ItemDir).Nodes do
  begin
    if ItemDir = 'Pet' then
    begin
      ID := Img.ImgID;
      if ItemWz.GetNode('Pet/' + img.Text + '/info/iconD') <> nil then
        Icon := ItemWz.GetNode('Pet/' + img.Text + '/info/iconD').ExtractPng2;
      var Name := Child.GetValue2(ID + '/name', '  ');
      var Desc := Child.GetValue2(ID + '/desc', '  ');
      DumpData2(ItemWz.GetNode('Pet/' + img.Text + '/info'));
      Grid.Rows.Add(ID, Icon, Name, Desc, '');
    end
    else
    begin
      foreach var Iter in ItemWz.GetNodeA(ItemDir + '/' + img.Text).Nodes do
      begin
        DumpData2(Iter);
        ID := Iter.Text.IDString;
        if Iter.GetNodeA('info/icon') <> nil then
          Icon := Iter.GetNode('info/icon').ExtractPng2;
        Grid.Rows.Add(Iter.Text, Icon, Child.GetValue2(ID + '/name', '  '), Child.GetValue2(ID + '/desc', '  '), '');
      end;
    end;
  end;
  for var i := 0 to RowList.Count - 1 do
    Grid.Item[4, i].Value := RowList[i];
  Grid.Sort(Grid.Columns[0], System.ComponentModel.ListSortDirection.Ascending);
end;

procedure MainForm.LoadCharacter;
begin
  
  var Dir: string := tabControl1.TabPages[TabIndex].Name;
  if CharacterWz.GetNode(Dir) = nil then
  begin
    MessageBox.Show(Dir + '  not found');   
    Exit;  
  end;
  var Child: WzNode;
  case Dir of
    'Totem': Child := StringWZ.GetNode('Eqp.img/Eqp/Accessory');
    'TamingMob': Child := StringWZ.GetNode('Eqp.img/Eqp/Taming');
  else
    Child := StringWZ.GetNode('Eqp.img/Eqp/' + Dir);
  end;
  var Row: Integer := -1; 
  var ID, Desc, h1: string;
  var Icon: Bitmap;
  foreach var img in CharacterWz.GetNodeA(Dir).Nodes do
  begin
    if LeftStr(img.Text, 1) <> '0' then
      Continue;
    // if LeftStr(img.Text, 4) = '0191' then
     // Continue;
    //if LeftStr(img.Text, 4) = '0198' then
    //  Continue;
    Row += 1;
    DumpData2(img.GetNode('info'));
    case Dir of 
      'Hair':
        begin
          if img.GetNodeA('default/hairOverHead') <> nil then
            Icon := img.GetNode('default/hairOverHead').ExtractPng2;
        end;
      'Face':
        begin
          if img.GetNodeA('default/face') <> nil then
            Icon := img.GetNode('default/face').ExtractPng2;
        end;
    else
      begin
        if img.GetNodeA('info/icon') <> nil then
          Icon := img.GetNode('info/icon').ExtractPng2;
      end;
    end;
    ID := img.ImgID.IDString;
    Desc := Child.GetValue2(ID + '/desc', '');
    h1 := Child.GetValue2(ID + '/h1', '');
    RowList[Row] += ', ' + Desc + h1;
    Grid.Rows.Add(img.ImgID, Icon, Child.GetValue2(ID + '/name', ''), RowList[Row]);
  end;
  
  if (Dir = 'TamingMob') and (Skill001Wz <> nil) then
  begin
    var Dict := new Dictionary<string, string>;
    for var i := 11 to 28 do
      if Skill001Wz.GetNode('8000' + i.ToString + '.img') <> nil then
      begin
        foreach var Iter in Skill001Wz.GetNode('8000' + i.ToString + '.img/skill').Nodes do
          if (Iter.GetNode('vehicleID') <> nil) and (not Dict.ContainsKey('0' + Iter.GetNode('vehicleID').Value.ToString)) then
            Dict.Add('0' + Iter.GetNode('vehicleID').Value.ToString, Iter.Text);
      end;
    for var i := 0 to 9 do
      if Skill001Wz.GetNode('80011' + i.ToString + '.img') <> nil then
      begin
        foreach var Iter in Skill001Wz.GetNode('80011' + i.ToString + '.img/skill').Nodes do
          if (Iter.GetNode('vehicleID') <> nil) and (not Dict.ContainsKey('0' + Iter.GetNode('vehicleID').Value.ToString)) then
            Dict.Add('0' + Iter.GetNode('vehicleID').Value.ToString, Iter.Text);
      end;
    for var i := 0 to Grid.RowCount - 1 do
    begin
      if Grid.Item[0, i].Value is string then
      begin
        var TamingID := Grid.Item[0, i].Value.ToString;
        if (Grid.Item[2, i].Value = '') and (Dict.ContainsKey(TamingID)) then
          Grid.Item[2, i].Value := StringWZ.GetNode('Skill.img/' + Dict[TamingID]).GetValue2('name', '');
      end;
    end;
  end;
  // for var i := 0 to RowList.Count - 1 do
   // Grid.Item[3, i].Value := RowList[i];
  Grid.Sort(Grid.Columns[0], System.ComponentModel.ListSortDirection.Ascending);
end;

function LeftPad(Self: string; Length: Integer := 8): string; extensionmethod;
begin
  Result := RightStr(StringOfChar('0', Length) + Self, Length);
end;

procedure MainForm.LoadMap(Part: Integer);
begin
  var Links := new List<(String, Integer)>;
  var MapNames := new Dictionary<string, (string, string)>;
  var StreetName, MapName: string;
  foreach var Iter in StringWZ.GetNode('Map.img').Nodes do
  begin
    foreach var Iter2 in Iter.Nodes do
    begin
      var ID := Iter2.Text.LeftPad(9);
      StreetName := Iter2.GetValue2('streetName', '');
      MapName := Iter2.GetValue2('mapName', '');
      if not MapNames.ContainsKey(ID) then
        MapNames.Add(ID, (StreetName, MapName));
    end;
  end;
  
  var MapDir: WzNode;
  if MapWz.GetNode('Map') <> nil then
    MapDir := MapWz.GetNode('Map')
  else
    MapDir := Map002Wz.GetNode('Map');
  var Icon: Bitmap;
  var Row := -1;
  foreach var Dir in MapDir.Nodes do
  begin
    if LeftStr(Dir.Text, 3) <> 'Map' then
      continue;
    case Part of
      1:
        if(Dir.Text <> 'Map0') and (Dir.Text <> 'Map1') and (Dir.Text <> 'Map2') and (Dir.Text <> 'Map3') then
          continue;
      2:
        if(Dir.Text <> 'Map4') and (Dir.Text <> 'Map5') and (Dir.Text <> 'Map6') and (Dir.Text <> 'Map7') and (Dir.Text <> 'Map8') then
          continue;
      3:
        if (Dir.Text <> 'Map9') then
          continue; 
    end; 
    
    foreach var img in Dir.Nodes do
    begin
      Row += 1;
      DumpData2(Img.GetNodeA('info'));
      if MapNames.ContainsKey(img.ImgID) then
      begin
        StreetName := MapNames[img.ImgID].Item1;
        MapName := MapNames[img.ImgID].Item2;
      end  
      else
      begin
        StreetName := '';
        MapName := '';
      end;
      if img.GetNode('miniMap/canvas') <> nil then
        Icon := img.GetNode('miniMap/canvas').ExtractPng2
      else
        Icon := nil;
      Grid.Rows.Add(img.ImgID, Icon, StreetName, MapName, '');
      var Link := img.GetNode('info/link');
      if Link <> nil then
      begin
        Links.Add(('Map' + LeftStr(Link.Value.ToString, 1) + '/' + Link.Value.ToString + '.img', Row));
      end;
    end;
  end;
  for var i := 0 to Links.Count - 1 do
  begin
    var Child := MapDir.GetNode(Links[i].Item1 + '/miniMap/canvas');
    if Child <> nil then
      Grid.Item[1, Links[i].Item2].Value := Child.ExtractPng2;
  end;
  for var i := 0 to RowList.Count - 1 do
    Grid.Item[4, i].Value := RowList[i];
  Grid.Sort(Grid.Columns[0], System.ComponentModel.ListSortDirection.Ascending);
  
end;

procedure MainForm.LoadMob(Part: Integer);
begin
  var Links := new List<(String, Integer)>;
  var Child: WzNode; 
  var WZArchive: WzStructure;
  case Part of
    1: WZArchive := MobWz;
    2: WzArchive := Mob001Wz;
    3: WzArchive := Mob2Wz;
  end;
  var Row := -1;
  foreach var Iter in WzArchive.Nodes do
  begin
    if RightStr(Iter.Text, 4) <> '.img' then
      continue;
    Row += 1;
    if WzArchive.GetNode(Iter.Text + '/stand/0') <> nil then
      Child := WzArchive.GetNode(Iter.Text + '/stand/0')
    else if WzArchive.GetNode(Iter.Text + '/fly/0') <> nil then
      Child := WzArchive.GetNode(Iter.Text + '/fly/0');
    DumpData2(WzArchive.GetNode(Iter.Text));
    Grid.Rows.Add(Iter.ImgID, Child.ExtractPng2, StringWZ.GetNode('Mob.img/' + Iter.ImgID.IDString).GetValue2('name', ''), '');
    var Link := Iter.GetNode('info/link');
    if Link <> nil then
      Links.Add((Link.Value.ToString + '.img', Row));
  end;
  for var i := 0 to Links.Count - 1 do
  begin
    if WzArchive.GetNode(Links[i].Item1 + '/stand/0') <> nil then
      Child := WzArchive.GetNode(Links[i].Item1 + '/stand/0')
    else if WzArchive.GetNode(Links[i].Item1 + '/fly/0') <> nil then
      Child := WzArchive.GetNode(Links[i].Item1 + '/fly/0');
    Grid.Item[1, Links[i].Item2].Value := Child.ExtractPng2;
  end;
  for var i := 0 to RowList.Count - 1 do
    Grid.Item[3, i].Value := RowList[i];
  Grid.Sort(Grid.Columns[0], System.ComponentModel.ListSortDirection.Ascending);
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
        CurrChar := chr(13);
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
        
        begin{ SignedOp }
          if CurrChar = '-' then
          begin
            ParseNext;
            SignedOp := -UnsignedOp;
          end
          else
            SignedOp := UnsignedOp;
        end { SignedOp };
      
      begin{ Power }
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
  if CurrChar = chr(13) then
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
  Str := FormStr.Replace('x', Level.ToString);
  Eval(Str, A, E);
  Result := A;
end;

function MainForm.CommonMatch(const Match1: System.Text.RegularExpressions.Match): String;
begin
  var MatchName: String := Copy(Match1.Value, 2, 100);
  foreach var Iter in Common.Nodes do
    if Iter.Text = MatchName then
      Result := GetFValue(Iter.Value.ToString, MaxLev).ToString;
end;

procedure MainForm.LoadSkill(Part: Integer);
begin
  var WZArchive: WzStructure;
  case Part of
    1: WZArchive := SkillWz;
    2: WzArchive := Skill001Wz;
    3: WzArchive := Skill002Wz;
  end; 
  var Icon: Bitmap;
  foreach var img in WzArchive.Nodes do
  begin
    if Char.IsNumber(img.Text.Chars[1]) then
    begin
      DumpData2(WZArchive.GetNode(img.Text + '/info'));
      var BookID := img.ImgID;
      var BookName := StringWZ.Getnode('Skill.img/' + BookID).GetValue2('bookName', '');
      if WzArchive.GetNode(img.Text + '/info/icon') <> nil then
        Icon := wzarchive.GetNode(img.Text + '/info/icon').ExtractPng2
      else
        Icon := nil;
      Grid.Rows.Add(BookID, Icon, BookName, '', ''); 
      
      foreach var Iter in WZArchive.GetNode(img.Text).Nodes do
      begin
        foreach var Iter2 in Iter.Nodes do
        begin
          if Iter.Text = 'skill' then
          begin
            DumpData2(Iter2);
            var SkillID := Iter2.Text;
            if (Iter2.GetNode('icon') <> nil) then
              Icon := Iter2.GetNode('icon').ExtractPng2;
            var SkillName := StringWZ.GetNode('Skill.img/' + SkillID).GetValue2('name', '');
            var Desc := StringWZ.GetNode('Skill.img/' + SkillID).GetValue2('desc', '');
            var hDesc: String;
            var Child := StringWZ.GetNode('Skill.img/' + SkillID);
            if (Child.GetNode('h') <> nil) then
            begin
              if Child.GetNode('h').Value is string then
                hDesc := Child.GetNode('h').Value.ToString;
              hDesc := hDesc.Replace('mpConMP', 'mpCon MP');
              hdesc := hDesc.Replace(',', ' ,');
              Common := Iter2.GetNode('common');
              if Common <> nil then
              begin
                MaxLev := Common.GetValue2('maxLevel', 1);
                if hDesc <> '' then
                  hDesc := 'Lv.' + IntToStr(MaxLev) + '= ' + RegEx.Replace(hDesc, '\#[0-9,_,a-z,A-Z,\.]+', CommonMatch);
              end;
            end  
            else
            begin
              for var i := 1 to 30 do
                if Child.GetNode('h' + i.ToString) <> nil then
                  hDesc := 'Lv.' + i.ToString + '= ' + Child.GetNode('h' + i.ToString).Value.ToString
            end;
            
            Grid.Rows.Add(SkillID, Icon, SkillName, Desc, hDesc, '');
            
          end;
        end;
        
      end;  
    end;
  end;
  for var i := 0 to RowList.Count - 1 do
    Grid.Item[5, i].Value := RowList[i];
  
  Grid.Sort(Grid.Columns[0], System.ComponentModel.ListSortDirection.Ascending);
end;

procedure MainForm.LoadNpc;
begin
  var Row := -1;
  var Links := new List<(String, Integer)>;
  var Icon: Bitmap;
  foreach var Img in NpcWz.Nodes do
  begin
    Row += 1;
    var ID := Img.ImgID;
    var Entry := NpcWz.GetNode(Img.Text);
    if Entry.GetNode('stand/0') <> nil then
      Icon := Entry.GetNode('stand/0').ExtractPng2;
    if Entry.GetNode('default/0') <> nil then
      Icon := Entry.GetNode('default/0').ExtractPng2; 
    var Name := StringWz.GetNode('Npc.img/' + ID.IDString).GetValue2('name', '');
    DumpData2(StringWz.GetNode('Npc.img/' + ID.IDString));
    Grid.Rows.Add(ID, Icon, Name, '');
    var Link := Npcwz.GetNode(Img.Text + '/info/link');
    if Link <> nil then
      Links.Add((Link.Value.ToString + '.img', Row));
  end;
  var Child: WzNode;
  for var i := 0 to Links.Count - 1 do
  begin
    if NpcWz.GetNode(Links[i].Item1 + '/stand/0') <> nil then
      Child := NpcWz.GetNode(Links[i].Item1 + '/stand/0')
    else if NpcWz.GetNode(Links[i].Item1 + '/default/0') <> nil then
      Child := NpcWz.GetNode(Links[i].Item1 + '/default/0');
    Grid.Item[1, Links[i].Item2].Value := Child.ExtractPng2;
  end;
  for var i := 0 to RowList.Count - 1 do
    Grid.Item[3, i].Value := RowList[i]; 
  ColList.Clear;
  RowList.Clear;
  foreach var Img in NpcWz.Nodes do
    DumpData2(NpcWz.GetNode(Img.Text + '/info'));
  for var i := 0 to RowList.Count - 1 do
    Grid.Item[4, i].Value := RowList[i]; 
  Grid.Sort(Grid.Columns[0], System.ComponentModel.ListSortDirection.Ascending);
end;

procedure MainForm.LoadMorph;
begin
  
  var Dict := new Dictionary<String, (String, String)>;
  var imgs := new List<string>;
  var Desc, Name: string;
  foreach var Iter in StringWZ.GetNode('Consume.img').Nodes do
  begin
    Desc := Iter.GetValue2('desc', '');
    Name := Iter.GetValue2('name', '');
    Dict.Add(Iter.Text, (Name, Desc));
  end;
  foreach var img in MorphWz.Nodes do
    imgs.Add(img.ImgID);
  var Icon: Bitmap;
  var MorphPic: Bitmap;
  foreach var Iter in ItemWZ.GetNode('Consume/0221.img').Nodes do
  begin
    DumpData2(Iter);
    var ID := Iter.Text;
    if Dict.ContainsKey(Iter.Text.IDString) then
    begin
      Name := Dict[Iter.Text.IDString].Item1;
      Desc := Dict[Iter.Text.IDString].Item2;
    end;
    if Iter.GetNode('info/icon') <> nil then
      Icon := Iter.GetNode('info/icon').ExtractPng2;
    
    var MorphID := Iter.GetValue2('spec/morph', '').LeftPad(4);
    if imgs.contains(MorphID) then
    begin
      if MorphWz.GetNode(MorphID + '.img/walk/0') <> nil then
        MorphPic := MorphWz.GetNode(MorphID + '.img/walk/0').ExtractPng2;
    end;
    Grid.Rows.Add(ID, Icon, MorphID, MorphPic, Name, Desc, '');
  end;
  for var i := 0 to RowList.Count - 1 do
    Grid.Item[6, i].Value := RowList[i]; 
end;

procedure MainForm.LoadFamiliar;
begin
  if CharacterWz.GetNode('Familiar') = nil then
  begin
    MessageBox.Show('Familiar  not found');   
    Exit;  
  end;
  var  CardEntry: WzNode;
  var MobPic, Icon: Bitmap;
  var CardID, MobID: String; 
  foreach var img in CharacterWZ.GetNode('Familiar').Nodes do
  begin
    var ID: String := img.ImgID;
    var Entry := CharacterWZ.GetNode('Familiar/' + img.Text);
    if Entry.GetNode('info/MobID') <> nil then
      MobID := Entry.GetNode('info/MobID').Value.ToString.LeftPad(7)
    else if EtcWz.GetNode('FamiliarInfo.img') <> nil then
      MobID := EtcWz.GetNode('FamiliarInfo.img/' + ID).GetValue2('mob', '100100').LeftPad(7);                 
    
    DumpData2(Entry.GetNode('info'));
    
    if MobWZ.GetNode(MobID + '.img') <> nil then
    begin
      if MobWz.GetNode(MobID + '.img/stand/0') <> nil then
        MobPic := Mobwz.GetNode(MobID + '.img/stand/0').ExtractPng2
      else if MobWz.GetNode(MobID + '.img/fly/0') <> nil then 
        MobPic := MobWz.GetNode(MobID + '.img/fly/0').ExtractPng2;
    end
    else if (Mob001wz <> nil) and (Mob001WZ.GetNode(MobID + '.img') <> nil) then
    begin
      if Mob001Wz.GetNode(MobID + '.img/stand/0') <> nil then
        MobPic := Mob001wz.GetNode(MobID + '.img/stand/0').ExtractPng2
      else if Mob001Wz.GetNode(MobID + '.img/fly/0') <> nil then 
        MobPic := Mob001Wz.GetNode(MobID + '.img/fly/0').ExtractPng2;
    end
    else if Mob2WZ.GetNode(MobID + '.img') <> nil then
    begin
      if Mob2Wz.GetNode(MobID + '.img/stand/0') <> nil then
        MobPic := Mob2wz.GetNode(MobID + '.img/stand/0').ExtractPng2
      else if Mob2Wz.GetNode(MobID + '.img/fly/0') <> nil then 
        MobPic := Mob2Wz.GetNode(MobID + '.img/fly/0').ExtractPng2;
    end;
    
    var SkillID := Entry.GetNode('info/skill').GetValue2('id', '');
    var SkillName, Skilldesc: String;
    if StringWz.GetNode('FamiliarSkill.img') <> nil then
    begin
      SkillName := SkillID + ':' + StringWz.GetNode('FamiliarSkill.img/skill/' + SkillID).GetValue2('name', '');
      SkillDesc := StringWz.GetNode('FamiliarSkill.img/skill/' + SkillID).GetValue2('desc', '');
    end
    else if StringWz.GetNode('Familiar.img') <> nil then
    begin
      SkillName := SkillID + ':' + StringWz.GetNode('Familiar.img/skill/' + SkillID).GetValue2('name', '');
      Skilldesc := StringWz.GetNode('Familiar.img/skill/' + SkillID).GetValue2('desc', '');
    end;
    if EtcWz.GetNode('FamiliarInfo.img') <> nil then
    begin
      if EtcWz.GetNode('FamiliarInfo.img/' + ID) <> nil then
        CardID := EtcWz.GetNode('FamiliarInfo.img/' + ID).GetValue2('consume', '');
    end
    else
    begin
      if Entry.GetNode('info/monsterCardID') <> nil then
        CardID := Entry.GetNode('info/monsterCardID').Value.ToString
      else
        CardId := '';
    end;
    if ItemWZ.GetNode('Consume/0287.img/0' + CardID) <> nil then
    begin
      CardEntry := ItemWZ.GetNode('Consume/0287.img/0' + CardID);
      if CardEntry.GetNode('info/icon') <> nil then
        Icon := CardEntry.GetNode('info/icon').ExtractPng2;
    end
    else if ItemWZ.GetNode('Consume/0238.img/0' + CardID) <> nil then
    begin
      CardEntry := ItemWZ.GetNode('Consume/0238.img/0' + CardID);
      if CardEntry.GetNode('info/iconRaw') <> nil then
        Icon := CardEntry.GetNode('info/iconRaw').ExtractPng2;
    end
    else
      icon := nil;
    
    var CardName := StringWZ.GetNode('Consume.img/' + CardID).GetValue2('name', '');
    Grid.Rows.Add(ID, MobPic, '', SkillName, SkillDesc, CardID, Icon, CardName);
  end; 
  for var i := 0 to RowList.Count - 1 do
    Grid.Item[2, i].Value := RowList[i]; 
  Grid.Sort(Grid.Columns[0], System.ComponentModel.ListSortDirection.Ascending);
end;

procedure MainForm.LoadDamageSkin;
begin
  var Icon, Sample: Bitmap;
  foreach var Iter in StringWZ.GetNode('Consume.img').Nodes do
  begin
    var Name := Iter.GetValue2('name', '');
    if (Name.Contains('字型')) or (Name.Contains('ジスキン')) or (Name.Contains('스킨')) or (Name.Contains
      ('Damage Skin')) or (Name.Contains('字型')) or (Name.Contains('伤害皮肤')) then
    begin
      var ID := '0' + Iter.Text;
      var Entry := ItemWz.Getnode('Consume/0243.img/0' + Iter.Text + '/info/icon');
      if Entry <> nil then
        Icon := Entry.ExtractPng2;
      Entry := ItemWz.GetNode('Consume/0243.img/0' + Iter.Text + '/info/sample');
      if Entry <> nil then
        Sample := Entry.ExtractPng2;      
      var Desc := Iter.GetValue2('desc', '');
      Grid.Rows.Add(ID, Icon, Name, Sample, Desc);  
    end;
  end;
  Grid.Sort(Grid.Columns[0], System.ComponentModel.ListSortDirection.Ascending);
end;

procedure MainForm.LoadReactor;
begin
  var Row := -1;
  var Links := new List<(String, Integer)>;
  var Icon: Bitmap;
 
  foreach var img in ReactorWZ.Nodes do
  begin
    Row+=1;
    DumpData2(ReactorWZ.GetNode(img.Text+'/info'));
    var ID := img.ImgID;
    var Entry := ReactorWZ.GetNode(img.Text+'/0/0');
    if Entry <> nil then
      Icon:=Entry.ExtractPng2;
    Entry := ReactorWZ.GetNode(img.Text+'/info/link');
    if Entry <> nil then
       Links.Add((Entry.Value.ToString,Row));
    Grid.Rows.Add(ID, Icon,'');  
  end;
  
   var Child: WzNode;
  for var i := 0 to Links.Count - 1 do
  begin
    if ReactorWz.GetNode(Links[i].Item1 + '.img/0/0') <> nil then
      Child := ReactorWz.GetNode(Links[i].Item1 + '.img/0/0');
    Grid.Item[1, Links[i].Item2].Value := Child.ExtractPng2;
  end;
  for var i := 0 to RowList.Count - 1 do
    Grid.Item[2, i].Value := RowList[i]; 
  Grid.Sort(Grid.Columns[0], System.ComponentModel.ListSortDirection.Ascending);
end;

procedure MainForm.LoadBIN;
begin
  var BinFile: String := System.Environment.CurrentDirectory + '\' + Grid.Parent.Name + '.BIN';
  if System.IO.File.Exists(BinFile) then
  begin
    for var i := 0 to 38 do
    begin
      DataGrid[i].Rows.Clear;
      DataGrid[i].Refresh;
      var Graphic := DataGrid[i].CreateGraphics;
      var Font := new System.Drawing.Font(FontFamily.GenericSansSerif, 20, FontStyle.Bold);
      Graphic.DrawString('Loading...', Font, Brushes.Black, 300, 200);  
    end;
    Grid.LoadBin(BinFile);
  end  
  else
    MessageBox.Show(Grid.Parent.Name + '.BIN' + ' not found');
end;

procedure MainForm.MainForm_Load(sender: Object; e: EventArgs);
begin
   ColList := new List<string>;
  RowList := new List<string>;
  
  
  for var i := 0 to 38 do
  begin
    case i of
      0, 1, 26, 27,37:
        begin
          DataGrid[i] := new DataViewer(gtItem);
          DataGrid[i].Parent := tabControl1.TabPages[i];
          TempGrid[i] := new DataViewer(gtItem);
          TempGrid[i].Parent := tabControl1.TabPages[i];
        end;
      2..15, 28..33:
        begin
          DataGrid[i] := new DataViewer(gtNormal);
          DataGrid[i].Parent := tabControl1.TabPages[i];
          TempGrid[i] := new DataViewer(gtNormal);
          TempGrid[i].Parent := tabControl1.TabPages[i];
        end;
      16..18:
        begin
          DataGrid[i] := new DataViewer(gtMap);
          DataGrid[i].Parent := tabControl1.TabPages[i];
          TempGrid[i] := new DataViewer(gtMap);
          TempGrid[i].Parent := tabControl1.TabPages[i];
        end;
      19..21:
        begin
          DataGrid[i] := new DataViewer(gtMob);
          DataGrid[i].Parent := tabControl1.TabPages[i];
          TempGrid[i] := new DataViewer(gtMob);
          TempGrid[i].Parent := tabControl1.TabPages[i];
        end;
      22..24:
        begin
          DataGrid[i] := new DataViewer(gtSkill);
          DataGrid[i].Parent := tabControl1.TabPages[i];
          TempGrid[i] := new DataViewer(gtSkill);
          TempGrid[i].Parent := tabControl1.TabPages[i];
        end; 
      25:
        begin
          DataGrid[i] := new DataViewer(gtNpc);
          DataGrid[i].Parent := tabControl1.TabPages[i];
          TempGrid[i] := new DataViewer(gtNpc);
          TempGrid[i].Parent := tabControl1.TabPages[i];
        end; 
      
      34:
        begin
          DataGrid[i] := new DataViewer(gtMorph);
          DataGrid[i].Parent := tabControl1.TabPages[i];
          TempGrid[i] := new DataViewer(gtMorph);
          TempGrid[i].Parent := tabControl1.TabPages[i];
        end; 
      
      35:
        begin
          DataGrid[i] := new DataViewer(gtFamiliar);
          DataGrid[i].Parent := tabControl1.TabPages[i];
          TempGrid[i] := new DataViewer(gtFamiliar);
          TempGrid[i].Parent := tabControl1.TabPages[i];
        end; 
      36:
        begin
          DataGrid[i] := new DataViewer(gtDamageSkin);
          DataGrid[i].Parent := tabControl1.TabPages[i];
          TempGrid[i] := new DataViewer(gtDamageSkin);
          TempGrid[i].Parent := tabControl1.TabPages[i];
        end; 
       38:
        begin
          DataGrid[i] := new DataViewer(gtReactor);
          DataGrid[i].Parent := tabControl1.TabPages[i];
          TempGrid[i] := new DataViewer(gtReactor);
          TempGrid[i].Parent := tabControl1.TabPages[i];
        end; 
    end;
    
  end;
  Grid := DataGrid[0];
  SearchGrid := TempGrid[0];
end;

procedure MainForm.comboBox1_SelectedIndexChanged(sender: Object; e: EventArgs);
begin
  if ComboBox1.Text = 'Load From BIN' then
  begin  
    Label1.Visible:=False;
    SelectFolderBox.Visible := False;
    LoadButton.Visible := False;
    LoadBin;
  end  
  else
  begin
    Label1.Visible:=True;
    SelectFolderBox.Visible := True;
    LoadButton.Visible := True;
    Grid.Rows.Clear;
    Grid.Refresh;
  end;  
end;

procedure MainForm.tabControl1_Selected(sender: Object; e: TabControlEventArgs);
begin
   // RowList.Clear;
  // ColList.Clear;
  TabIndex := tabControl1.SelectedIndex;
  Grid := DataGrid[TabIndex];
  SearchGrid := TempGrid[TabIndex];
  Grid.Visible := True;
  SearchGrid.Visible := False;
  SearchBox.Clear;
  if ComboBox1.Text = 'Load From BIN' then
  begin
    LoadBin;
  end;   
end;

procedure MainForm.LoadButton_Click(sender: Object; e: EventArgs);
 function GetWzFileName: String;
  begin
    case TabIndex of
      0, 1, 26, 27,36,37: Result := 'Item.wz';
      2..15, 28..33, 35: Result := 'Character.wz';
      16..18: Result := 'Map.wz';
      19: Result := 'Mob.wz';
      20: Result := 'Mob001.wz';
      21: Result := 'Mob2.wz';
      22: Result := 'Skill.wz';
      23: Result := 'Skill001.wz';
      24: Result := 'Skill002.wz';
      25: Result := 'Npc.wz';
      34: Result := 'Morph.wz';
      38: Result := 'Reactor.wz';
    end;
  end;

begin
  if not FileExists(SelectFolderBox.Text + '/' + GetWzFileName) then
  begin
    MessageBox.Show('Wrong MapleStory folder,  ' + GetWzFileName + '  couble not be found');
    Exit;
  end;
  Grid.Rows.Clear;
  Grid.Refresh;
  RowList.Clear;
  ColList.Clear;
  var Graphic := Grid.CreateGraphics;
  var Font := new System.Drawing.Font(FontFamily.GenericSansSerif, 20, FontStyle.Bold);
  Graphic.DrawString('Loading...', Font, Brushes.Black, 300, 200);
  
  case TabIndex of
    0, 1, 26, 27,37: LoadItem;
    2..15, 28..33: LoadCharacter; 
    16: LoadMap(1);
    17: LoadMap(2);
    18: LoadMap(3);
    19: LoadMob(1);
    20: LoadMob(2);
    21: LoadMob(3);
    22: LoadSkill(1);
    23: LoadSkill(2);
    24: LoadSkill(3);
    25: LoadNpc;
    34: LoadMorph;
    35: LoadFamiliar;
    36: LoadDamageSkin;
    38: LoadReactor;
  end;
  
end;

procedure MainForm.SaveButton_Click(sender: Object; e: EventArgs);
begin
  Grid.SaveBin(System.Environment.CurrentDirectory + '\' + Grid.Parent.Name + '.BIN');
  MessageBox.Show('Save '+Grid.Parent.Name + '.BIN Completed');
end;

procedure MainForm.SearchBox_TextChanged(sender: Object; e: EventArgs);
begin
   var SearchStr: string := Trim(SearchBox.Text); 
  if SearchStr = '' then
  begin
    Grid.Visible := True;
    SearchGrid.Visible := False;
  end
  else
  begin
    SearchGrid.Rows.Clear;
    var Row: DataGridViewRow := new DataGridViewRow();
    for var i := 0 to Grid.RowCount - 1 do
    begin
      for var j := 0 to Grid.Columns.Count - 1 do
      begin
        if Grid.Rows[i].Cells[j].Value is string then
        begin
          if Grid.Rows[i].Cells[j].Value.ToString.ToLower.Contains(SearchStr) then
          begin
            Row := DataGridViewRow(Grid.Rows[i].Clone);
            for var j2 := 0 to Grid.Columns.Count - 1 do
              Row.Cells[j2].Value := Grid.Rows[i].Cells[j2].Value;
            SearchGrid.Rows.Add(Row);
          end;
        end;
      end;
    end;
    Grid.Visible := False;
    SearchGrid.Visible := True;
    SearchGrid.Refresh;
  end;
end;

procedure MainForm.SelectFolderBox_TextChanged(sender: Object; e: EventArgs);
begin
  
end;

procedure MainForm.SelectFolderBox_Click(sender: Object; e: EventArgs);
begin
   if FolderBrowserDialog1.ShowDialog.ToString = 'OK' then
  begin
    SelectFolderBox.Text := FolderBrowserDialog1.SelectedPath;
    var FolderPath: string := SelectFolderBox.Text;
    if FileExists(FolderPath + '\string.wz') then
    begin
      Mobwz := new WzStructure;
      MapWz := new WzStructure;
      Skillwz := new WzStructure;
      ItemWz := new WzStructure;
      CharacterWz := new WzStructure;
      NpcWz := new WzStructure;
      MorphWz := new WzStructure;
      StringWz := new WzStructure;
      EtcWz := new WzStructure;
      ReactorWz := new WzStructure;
      
      MobWz.Load(FolderPath + '\Mob.wz');
      if FileExists(FolderPath + '\Mob001.wz') then
      begin
        Mob001wz := new WzStructure;
        Mob001wz.Load(FolderPath + '\Mob001.wz');
      end;  
      
      if FileExists(FolderPath + '\Mob2.wz') then
      begin
        Mob2wz := new WzStructure;
        Mob2wz.Load(FolderPath + '\Mob2.wz');
      end;  
      
      MapWz.Load(FolderPath + '\Map.wz');
      if FileExists(FolderPath + '\Map001.wz') then
      begin
        Map001Wz := new WzStructure;
        Map001wz.Load(FolderPath + '\Map001.wz');
      end;
      if FileExists(FolderPath + '\Map002.wz') then
      begin
        Map002Wz := new WzStructure;
        Map002wz.Load(FolderPath + '\Map002.wz');
      end;  
      
      SkillWz.Load(FolderPath + '\Skill.wz');
      if FileExists(FolderPath + '\Skill001.wz') then
      begin
        Skill001Wz := new WzStructure;
        Skill001wz.Load(FolderPath + '\Skill001.wz');
      end;
      if FileExists(FolderPath + '\Skill002.wz') then
      begin
        Skill002Wz := new WzStructure;
        Skill002wz.Load(FolderPath + '\Skill002.wz');
      end;
      ItemWz.Load(FolderPath + '\Item.wz');
      CharacterWz.Load(FolderPath + '\Character.wz');
      NpcWz.Load(FolderPath + '\Npc.wz');
      MorphWz.Load(FolderPath + '\Morph.wz');
      StringWz.Load(FolderPath + '\String.wz');
      EtcWz.Load(FolderPath + '\Etc.wz');
      ReactorWz.Load(FolderPath + '\Reactor.wz');
    end;
  end;  
end;

end.
