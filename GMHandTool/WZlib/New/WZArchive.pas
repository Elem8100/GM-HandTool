unit WZArchive;

interface

uses Classes, SysUtils, WZReader, WZDirectory, WZIMGFile, Tools;

type
  TWZArchive = class
  private
    FReader: TWZReader;
    FRoot: TWZDirectory;
    FFileSize: UInt64;
    FHeaderSize, FVersion: Integer;
    FEncVer: Int16;
    FName, FPKG, FCopyright: string;

    procedure Load;
    procedure ParseDirectory(Dir: TWZDirectory);

    function GetVersionHash(Encoded, GameVer: Int16): Integer;
  public
    constructor Create(const FileName: string; LoadToMem: Boolean = False);
    destructor Destroy; override;

    function GetImgFile(const Path: string): TWZIMGFile;
    function ResolveFullPath(P: string): TWZIMGEntry;

    function ParseFile(F: TWZFile): TWZIMGFile;

    property Reader: TWZReader read FReader;
    property Root: TWZDirectory read FRoot;

    property Copyright: string read FCopyright;
    property FileSize: UInt64 read FFileSize;
    property HeaderSize: Integer read FHeaderSize;
    property Name: string read FName;
    property PKG: string read FPKG;
    property Version: Integer read FVersion;
    property EncVer: Int16 read FEncVer;
  end;

  EWrongHash = class(Exception)
  public
    constructor Create;
  end;

implementation

constructor TWZArchive.Create(const FileName: string; LoadToMem: Boolean = False);
begin
  FReader := TWZReader.Create(FileName, LoadToMem);

  FName := ExtractFileName(FileName);

  FRoot := TWZDirectory.Create(FName, 0, 0, 0, nil);
  FRoot.Archive := Self;

  Load;
end;

destructor TWZArchive.Destroy;
begin
  FRoot.Free;
  FReader.Free;

  inherited;
end;

procedure TWZArchive.Load;
const
  MAX_VERSION = 1000;
var
  Off: Int64;
  i: Int16;
  Hash: Integer;
begin
  FPKG := FReader.ReadString(4);
  FFileSize := FReader.ReadUInt64;
  FHeaderSize := FReader.ReadInt;
  FCopyright := FReader.ReadNullTerminatedString;
  FEncVer := FReader.ReadShort;

  FReader.HeaderSize := FHeaderSize;

  for i := 0 to MAX_VERSION do
  begin
    Hash := GetVersionHash(FEncVer, i);
    if Hash <> 0 then
    begin
      Off := FReader.Position;
      FReader.Hash := Hash;
      FRoot := TWZDirectory.Create(FName, 0, 0, 0, nil);
      FRoot.Archive := Self;
      try
        ParseDirectory(FRoot);
        FReader.Seek(FRoot.Files.First.Offset, soBeginning);
        if FReader.ReadByte in [$1B, $73] then
        begin
          FVersion := i;
          Break;
        end;
      except
        // Hash wrong, try next version
        FReader.Seek(Off, soBeginning);
        FRoot.Free;
      end;
    end;
  end;

  if i = MAX_VERSION + 1 then
  begin
    FRoot := nil;
    raise Exception.Create('Unable to determine version');
  end;
end;

function TWZArchive.GetVersionHash(Encoded, GameVer: Int16): Integer;
var
  Hash, i: Integer;
  Version: string;
begin
  Hash := 0;

  Version := IntToStr(GameVer);
  for i := 1 to Length(Version) do
    Hash := (Hash * 32) + Ord(Version[i]) + 1;

  if Encoded = not (Byte(Hash shr 24) xor Byte(Hash shr 16) xor Byte(Hash shr 8) xor Byte(Hash)) then
    Exit(Hash);

  Result := 0;
end;

procedure TWZArchive.ParseDirectory(Dir: TWZDirectory);
var
  EntryCount, i, Size, Checksum: Integer;
  Offset: Cardinal;
  Marker: Byte;
  Name: string;
  E: TWZEntry;
begin
  EntryCount := FReader.ReadValue;

  for i := 0 to EntryCount - 1 do
  begin
    Marker := FReader.ReadByte;

    case Marker of
      $01, $02:
      begin
        Name := FReader.ReadDecodedStringAtOffsetAndReset(FReader.ReadInt + FHeaderSize + 1);
      end;

      $03, $04:
      begin
        Name := FReader.ReadDecodedString;
      end;

      else raise Exception.CreateFmt('Unknown Marker at ParseDirectory(%s): ' + sLineBreak +
           'i = %d; Marker %d', [Dir.Name, i, Marker]);
    end;

    Size := FReader.ReadValue;
    Checksum := FReader.ReadValue;
    Offset := FReader.ReadOffset;
    if Offset > FFileSize + FHeaderSize + 3000000 then
      raise EWrongHash.Create; // fast-fail

    if Marker in [1, 3] then
    begin
      E := TWZDirectory.Create(Name, Size, Checksum, Offset, Dir);
      Dir.AddDirectory(TWZDirectory(E));
    end
    else
    begin
      E := TWZFile.Create(Name, Size, Checksum, Offset, Dir);
      Dir.AddFile(TWZFile(E));
    end;
  end;

  for i := 0 to Dir.SubDirs.Count - 1 do
    ParseDirectory(Dir.SubDirs[i]);
end;

function TWZArchive.GetImgFile(const Path: string): TWZIMGFile;
var
  Segments: TStringArray;
  i: Integer;
  Dir: TWZDirectory;
  Entry: TWZFile;
begin
  Segments := Explode('/', Path);

  Dir := FRoot;
  for i := 0 to High(Segments) - 1 do
  begin
    Dir := TWZDirectory(Dir.Entry[Segments[i]]);

    if Dir = nil then
      Exit(nil);
  end;

  Entry := TWZFile(Dir.Entry[Segments[High(Segments)]]);
  if Entry = nil then
    Exit(nil);

  Segments := nil;

  Result := ParseFile(Entry);
end;

function TWZArchive.ParseFile(F: TWZFile): TWZIMGFile;
begin
  if Assigned(F.IMGFile) then
    Exit(TWZIMGFile(F.IMGFile));

  FReader.LoadCache(F.Offset, F.Size);
  try
    Result := TWZIMGFile.Create(FReader, F);
    F.IMGFile := Result;
  finally
    FReader.ClearCache;
  end;
end;

function TWZArchive.ResolveFullPath(P: string): TWZIMGEntry;
var
  Split: TStringArray;
begin
  while P[1] <> '/' do
    Delete(P, 1, 1);
  Delete(P, 1, 1);

  Split := Explode('.img/', P);
  Result := GetImgFile(Split[0] + '.img').Root.Get(Split[1]);
end;

{ EWrongHash }

constructor EWrongHash.Create;
begin
  inherited Create('');
end;

end.

