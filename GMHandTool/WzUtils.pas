unit WzUtils;

interface

uses System, System.Drawing, System.Windows.Forms;

type
  WzPng = WzComparerR2.WzLib.Wz_Png;
  WzStructure = WzComparerR2.WzLib.Wz_Structure;
  WzUOL = WzComparerR2.WzLib.Wz_Uol;
  WzNode = WzComparerR2.WzLib.Wz_Node;
  WzVector = WzComparerR2.WzLib.Wz_Vector;
  WzImage = WzComparerR2.WzLib.Wz_Image;
  WzSound = WzComparerR2.WzLib.Wz_Sound;
  WzFile = WzComparerR2.WzLib.Wz_File;
  TWzType = (wtValue, wtPng, wtUol, wtSound, wtVector, WtStructure, wtImage, wtFile, WtCrypto, wtHeader);

var
  MobWz, Mob001WZ, Mob2Wz, MapWz, Map2Wz, Map001Wz, Map002Wz, SkillWz, Skill001Wz, Skill002Wz,
  CharacterWz, Itemwz,NpcWz,MorphWz, StringWz,EtcWz,ReactorWz: WzStructure;

{$reference WZComparerR2.Wzlib.dll}

implementation

function IDString(Self: string): string; extensionmethod;
begin
  Result := Self.ToInteger.ToString;
end;

function GetPathD(Self: WzNode): string; extensionmethod;
begin
  var Path: Stack<String> := new Stack<String>;
  var Node: WzNode := Self;
  while Node <> nil do
  begin
    Path.Push(Node.Text);
    Node := Node.ParentNode;
  end;
  Result := string.Join('.', Path.ToArray);
end;

function GetPath(Self: WzNode): string; extensionmethod;
begin
  var Path: Stack<String> := new Stack<String>;
  var Node: WzNode := Self;
  while Node <> nil do
  begin
    Path.Push(Node.Text);
    Node := Node.ParentNode;
  end;
  Result := string.Join('/', Path.ToArray);
end;

function WzType(Self: WzNode): TWZType; extensionmethod;
begin
  case Self.Value.GetType.Name of
    'Wz_Uol': Result := wtUol;
    'Wz_Png': Result := wtPng;
    'Wz_Vector': Result := wtVector;
    'Wz_Sound': Result := wtSound;
    'Wz_Image': Result := wtImage;
    'WZ_Structure': Result := WtStructure
  else
    Result := wtValue;
  end;
end;

function ImgName(Self: WzNode): string; extensionmethod;
begin
  Result := Self.GetNodeWzImage.Name;
end;

function ImgID(Self: WzNode): string; extensionmethod;
begin
  Result := Self.GetNodeWzImage.Name.Replace('.img', '');
end;

function WzName(Self: WzNode): string; extensionmethod;
begin
  Result := Self.GetNodeWzFile.Type.ToString;
end;

function FindNodeByPathA(Self: WzNode; ExtractImage: Boolean; params fullPath: array of string): WzNode; extensionmethod;
begin
  Result := self.FindNodeByPath(extractImage, false, fullPath);
end;

function FindNodeByPathA(Self: WzNode; FullPath: string; ExtractImage: Boolean): WzNode; extensionmethod;
begin
  var Patten: array of string := FullPath.Split('/');
  if Self <> nil then
    Result := Self.FindNodeByPath(ExtractImage, Patten);
end;

function GetNodeA(Self: WzNode; Path: string): WzNode; extensionmethod;
begin
  Result := Self.FindNodeByPathA(Path, True);
end;

function GetNode(Self: WzNode; Path: string): WzNode; extensionmethod;
begin
  if Self.FindNodeByPathA(Path, True) <> nil then
  begin
    if Self.FindNodeByPathA(Path, True).Value is WzUol then
      Result := Self.FindNodeByPathA(Path, True).ResolveUol
    else
      Result := Self.FindNodeByPathA(Path, True);
  end
  else
  begin
    var Split: array of string := Path.Split('/');
    var Count: Integer;
    var Str, Path1, Path2: string;
    var HasUol: Boolean;
    for var i := 0 to Split.Length - 1 do
    begin
      if i = 0 then
        Str := Str + Split[i]
      else
        Str := Str + '/' + Split[i];
      if (Self.FindNodeByPathA(Str, True) <> nil) and (Self.FindNodeByPathA(Str, True).Value is WzUol) then
      begin
        HasUol := True;
        Count := i;
        Path1 := Str;
        break;
      end;  
    end;
    if HasUol then
    begin
      Str := '';
      for var i := Count + 1 to Split.Length - 1 do
      begin
        if i = Count + 1 then
          Str := Str + Split[i]
        else
          Str := Str + '/' + Split[i];
        Path2 := Str;
      end;
      Result := Self.FindNodeByPathA(Path1, True).ResolveUol.FindNodeByPathA(Path2, True);
    end;
  end;  
end;

{
function GetNodeNil(Self: WzNode; Path: string): WzNode; extensionmethod;
begin
  if self.FindNodeByPathA(Path, True) <> nil then
    Result := Self.FindNodeByPathA(Path, True)
  else
    Result := NilNode;
end;
}
function GetNode(Self: WzStructure; Path: string): WzNode; extensionmethod;
begin
  Result := Self.WzNode.GetNode(Path);
end;

function GetNodeA(Self: WzStructure; Path: string): WzNode; extensionmethod;
begin
  Result := Self.WzNode.GetNodeA(Path);
end;
{
function GetNodeNil(Self: WzStructure; Path: string): WzNode; extensionmethod;
begin
  Result := Self.WzNode.GetNodeNil(Path);
end;
}
function Value(Self: WzStructure; Path: string): Object; extensionmethod;
begin
  Result := Self.WzNode.GetNode(Path).Value;
end;

function GetNodeValue<T>(Self: WzNode; Path: string; DefaultValue: T): T; extensionmethod;
begin
  Result := Self.FindNodeByPathA(Path, True).GetValueEx(DefaultValue);
end;

function GetNodeValue<T>(Self: WzStructure; Path: string; DefaultValue: T): T; extensionmethod;
begin
  Result := Self.WzNode.FindNodeByPathA(Path, True).GetValueEx(DefaultValue);
end;

function GetPng(Self: WzStructure; Path: string): WzPng; extensionmethod;
begin
  Result := WzPng(Self.WzNode.GetNode(Path).ResolveUol.Value);
end;

function ExtractPng(Self: WzNode): Bitmap; extensionmethod;
begin
  if Self <> nil then
    Result := WzPng(Self.ResolveUol.Value).ExtractPng;
end;

function Png(Self: WzNode): WzPng; extensionmethod;
begin
  if Self <> nil then
    Result := WzPng(Self.ResolveUol.Value);
end;

function DumpPng(Self: WzPng): Bitmap; extensionmethod;
begin
  if Self <> nil then
    Result := self.ExtractPng;
end;

function ExtractPng(Self: WzStructure; Path: string): Bitmap; extensionmethod;
begin
  if Self.WzNode.GetNode(Path) <> nil then
    Result := WzPng(Self.WzNode.GetNode(Path).ResolveUol.Value).ExtractPng;
end;

function ExtractPng2(Self: WzNode): Bitmap; extensionmethod;
begin
  if Self.GetNode('_outlink') <> nil then
  begin
    var LinkData: string := Self.GetNode('_outlink').Value.ToString;
    var Split: array of string := LinkData.Split('/');
    var DestPath: string;
    case Split[0] of
      'Mob':
        begin
          DestPath := RegEx.Replace(LinkData, 'Mob/', '');
          if(MobWz <> nil) and (MobWz.GetNode(Split[1]) <> nil) then
            Result := WzPng(MobWz.GetNode(DestPath).Value).ExtractPng
          else if(Mob001Wz <> nil) and (Mob001Wz.GetNode(Split[1]) <> nil) then
            Result := WzPng(Mob001Wz.GetNode(DestPath).Value).ExtractPng
          else 
            Result := WzPng(Mob2Wz.GetNode(DestPath).Value).ExtractPng;
        end;
      'Map':
        begin
          if Split[1]='Map' then
            DestPath:= LinkData.Remove(0,4)
          else
            DestPath := RegEx.Replace(LinkData, 'Map/', '');
          if(MapWz <> nil) and (MapWz.GetNode(Split[1] + '/' + Split[2]) <> nil) then
            Result := Wzpng(MapWZ.GetNode(DestPath).Value).ExtractPng
          else if(Map001Wz <> nil) and (Map001Wz.GetNode(Split[1] + '/' + Split[2]) <> nil) then
            Result := WzPng(Map001Wz.GetNode(DestPath).Value).ExtractPng
          else if(Map002Wz <> nil) and (Map002Wz.GetNode(Split[1] + '/' + Split[2]) <> nil) then
            Result := WzPng(Map002Wz.GetNode(DestPath).Value).ExtractPng
          else 
            Result := WzPng(Map2Wz.GetNode(DestPath).Value).ExtractPng;
        end;
      'Skill':
        begin
          DestPath := RegEx.Replace(LinkData, 'Skill/', '');
          if(SkillWz <> nil) and (SkillWz.GetNode(Split[1]) <> nil) then
            Result := SkillWZ.GetNode(DestPath).ExtractPng
          else if(Skill001Wz <> nil) and (Skill001Wz.GetNode(Split[1]) <> nil) then
            Result := Skill001Wz.GetNode(DestPath).ExtractPng
          else 
            Result := Skill002Wz.GetNode(DestPath).ExtractPng;
        end
    else
      begin
        DestPath := RegEx.Replace(LinkData, Self.WzName + '/', '');
        Result := WzPng(Self.GetNodeWzFile.WzStructure.GetNode(DestPath).Value).ExtractPng;
      end;
    end;  
  end
  else if Self.GetNode('_inlink') <> nil then
  begin
    var LinkData: string := Self.GetNode('_inlink').Value.ToString;
    Result := WzPng(Self.GetNodeWzImage.Node.GetNode(LinkData).Value).ExtractPng;
  end
  else if Self.GetNode('source') <> nil then
  begin
    var LinkData: string := Self.GetNode('source').Value.ToString;
    var DestPath := RegEx.Replace(LinkData, Self.WzName + '/', '');
    Result := WzPng(Self.GetNodeWzFile.WzStructure.GetNode(DestPath).Value).ExtractPng;
  end
  else
  begin
    if (Self.Value is WzUol) then
      Result := WzPng(Self.ResolveUol.Value).ExtractPng
    else
      Result := WzPng(Self.Value).ExtractPng;
  end;
end;

function FullPathToFileA(Self: WzNode): string; extensionmethod;
begin
  var Path := new Stack<string>;
  var Node: WzNode := Self;
  while Node <> nil do 
  begin
    if (Node.value is WzFile) then
    begin
      if (Node.text.EndsWith('.wz', StringComparison.OrdinalIgnoreCase)) then
        Path.Push(Node.Text.Substring(0, Node.Text.Length - 3))
      else
        Path.Push(Node.Text);
      break;
    end;
    
    Path.Push(Node.Text);
    
    var img := Node.GetValue&<WzImage>;
    if img <> nil then
      Node := img.OwnerNode;
    if (Node <> nil) then
      Node := Node.ParentNode;
  end; 
  Result := string.Join('/', Path.ToArray);
end;

function GetValue2<T>(Self: WzNode; Path: string; DefaultValue: T): T; extensionmethod;
begin
  if Self.FindNodeByPathA(Path, True) <> nil then
    Result := Self.FindNodeByPathA(Path, True).GetValueEx(DefaultValue)
  else
    Result := DefaultValue; 
end;

function GetNodeValue(Self: WzNode; Path: string): Object; extensionmethod;
begin
  Result := Self.GetNode(Path).Value;
end;
{
function GetNode2(Self: WzNode; Path: string): WzNode; extensionmethod;
begin
  case self.GetNode(Path).WzType of

    wtPng:
      begin
        if self.GetNode(Path + '/_inlink') <> nil then
        begin
          var Node := Self.GetNode(Path + '/_inlink');
          var InlinkData := Node.Value.ToString;
          var imgName: string := Node.imgName;
          Result := Self.GetNode(imgName + '/' + inlinkData);
        end
        else
          Result := self.GetNode(Path); 
      end;


    WtUOL:
      begin
        Result := self.GetNode(Path).ResolveUol; 
      end;
  else
    begin
      Result := self.GetNode(Path).ResolveUol;
    end;  

  end;
end;
}
function Nodes(Self: WzStructure): WzComparerR2.WzLib.Wz_Node.WzNodeCollection; extensionmethod;
begin
  Result := Self.WzNode.Nodes;
end;

end.