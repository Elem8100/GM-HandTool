unit DataGrid;

interface

uses System, System.Drawing, System.Windows.Forms, System.Reflection, System.Drawing.Imaging, System.IO;

type
  TGridType = (gtNormal, gtItem, gtMap, gtMob, gtSkill, gtNpc, gtMorph,gtFamiliar,gtDamageSkin,gtReactor);
  
  DataViewer = class(DataGridView)
    constructor Create(GridType: TGridType);
    begin
      Self.Dock := System.Windows.Forms.DockStyle.Fill;
      RowTemplate.Height := 80;
      
      //Self.AutoSizeColumnsMode := DataGridViewAutoSizeColumnsMode.Fill;
      var ID := new System.Windows.Forms.DataGridViewTextBoxColumn;
      var Icon := new System.Windows.Forms.DataGridViewImageColumn;
      var MorphIcon := new System.Windows.Forms.DataGridViewImageColumn;
     
      var Name := new System.Windows.Forms.DataGridViewTextBoxColumn;
      var Info := new System.Windows.Forms.DataGridViewTextBoxColumn;
      var Desc := new System.Windows.Forms.DataGridViewTextBoxColumn;
      var Level := new System.Windows.Forms.DataGridViewTextBoxColumn;
      var MapName := new System.Windows.Forms.DataGridViewTextBoxColumn;
      var StreetName := new System.Windows.Forms.DataGridViewTextBoxColumn;
      var Speak := new System.Windows.Forms.DataGridViewTextBoxColumn;
      var MorphID := new System.Windows.Forms.DataGridViewTextBoxColumn;
      var FamiliarSkillName := new System.Windows.Forms.DataGridViewTextBoxColumn;
      var FamiliarSkillDesc := new System.Windows.Forms.DataGridViewTextBoxColumn;
      var FamiliarCardID := new System.Windows.Forms.DataGridViewTextBoxColumn;
      var FamiliarIcon := new System.Windows.Forms.DataGridViewImageColumn;
      var Sample := new System.Windows.Forms.DataGridViewImageColumn;
      //  Self.ColumnHeadersHeightSizeMode := System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
      Self.DefaultCellStyle.Font := new System.Drawing.Font('Segoe UI', 8.5);  
      ID.DataPropertyName := 'ID';
      iD.HeaderText := 'ID';
      iD.Name := 'propID';
      ID.ReadOnly := true;
      id.DefaultCellStyle.Alignment := DataGridViewContentAlignment.MiddleCenter;
      ID.HeaderCell.Style.Alignment := DataGridViewContentAlignment.MiddleCenter;      
      ID.Width := 90;   
      
      MorphID.DataPropertyName := 'MorphID';
      MorphID.HeaderText := 'MorphID';
      MorphID.Name := 'propID';
      MorphID.ReadOnly := true;
      MorphID.DefaultCellStyle.Alignment := DataGridViewContentAlignment.MiddleCenter;
      MorphID.HeaderCell.Style.Alignment := DataGridViewContentAlignment.MiddleCenter;      
      MorphID.Width := 90;   
      
      Icon.DataPropertyName := 'Icon';
      Icon.HeaderText := 'Icon';
      Icon.Name := 'propBitmap';
      Icon.ReadOnly := true;
      Icon.HeaderCell.Style.Alignment := DataGridViewContentAlignment.MiddleCenter; 
      Icon.Width := 100;
      
      MorphIcon.DataPropertyName := 'MorphIcon';
      MorphIcon.HeaderText := 'MorphIcon';
      MorphIcon.Name := 'propBitmap';
      MorphIcon.ReadOnly := true;
      MorphIcon.HeaderCell.Style.Alignment := DataGridViewContentAlignment.MiddleCenter; 
      MorphIcon.Width := 100;
      
      FamiliarIcon.DataPropertyName := 'FamiliarIcon';
      FamiliarIcon.HeaderText := 'Familiar';
      FamiliarIcon.Name := 'propBitmap';
      FamiliarIcon.ReadOnly := true;
      FamiliarIcon.HeaderCell.Style.Alignment := DataGridViewContentAlignment.MiddleCenter; 
      FamiliarIcon.Width := 100;
      
      Sample.DataPropertyName := 'Sample';
      Sample.HeaderText := 'Sample';
      Sample.Name := 'propBitmap';
      Sample.ReadOnly := true;
      Sample.HeaderCell.Style.Alignment := DataGridViewContentAlignment.MiddleCenter; 
      Sample.Width := 280;
      
      Name.DataPropertyName := 'NameProperty';
      Name.HeaderText := 'Name';
      Name.Name := 'propName';
      Name.ReadOnly := true;
      Name.HeaderCell.Style.Alignment := DataGridViewContentAlignment.MiddleCenter; 
      Name.Width := 200;
      
      FamiliarSkillName.DataPropertyName := 'NameProperty';
      FamiliarSkillName.HeaderText := 'Skill Name';
      FamiliarSkillName.Name := 'propName';
      FamiliarSkillName.ReadOnly := true;
      FamiliarSkillName.HeaderCell.Style.Alignment := DataGridViewContentAlignment.MiddleCenter; 
      FamiliarSkillName.Width := 100;
      
      FamiliarSkillDesc.DataPropertyName := 'NameProperty';
      FamiliarSkillDesc.HeaderText := 'Skill Desc';
      FamiliarSkillDesc.Name := 'propName';
      FamiliarSkillDesc.ReadOnly := true;
      FamiliarSkillDesc.HeaderCell.Style.Alignment := DataGridViewContentAlignment.MiddleCenter; 
      FamiliarSkillDesc.Width := 100;
      
      FamiliarCardID.DataPropertyName := 'NameProperty';
      FamiliarCardID.HeaderText := 'Card ID';
      FamiliarCardID.Name := 'propName';
      FamiliarCardID.ReadOnly := true;
      FamiliarCardID.HeaderCell.Style.Alignment := DataGridViewContentAlignment.MiddleCenter; 
      FamiliarCardID.Width := 100;
      
      Desc.DataPropertyName := 'DescProperty';
      Desc.HeaderText := 'Description';
      Desc.Name := 'Desc';
      Desc.ReadOnly := true;
      Desc.HeaderCell.Style.Alignment := DataGridViewContentAlignment.MiddleCenter; 
      Desc.Width := 100;
      
      Level.DataPropertyName := 'LevelProperty';
      Level.HeaderText := 'Level';
      Level.Name := 'Level';
      Level.ReadOnly := true;
      Level.HeaderCell.Style.Alignment := DataGridViewContentAlignment.MiddleCenter; 
      Level.Width := 100;
      
      StreetName.DataPropertyName := 'StreetNameProperty';
      StreetName.HeaderText := 'StreetName';
      StreetName.Name := 'StreetName';
      StreetName.ReadOnly := True;
      StreetName.HeaderCell.Style.Alignment := DataGridViewContentAlignment.MiddleCenter; 
      StreetName.Width := 100;
      
      MapName.DataPropertyName := 'MapNameProperty';
      MapName.HeaderText := 'MapName';
      MapName.Name := 'MapName';
      Mapname.ReadOnly := True;
      MapName.HeaderCell.Style.Alignment := DataGridViewContentAlignment.MiddleCenter; 
      MapName.Width := 100;
      
      Speak.DataPropertyName := 'SpeakNameProperty';
      Speak.HeaderText := 'Speak';
      Speak.Name := 'Speak';
      Speak.ReadOnly := True;
      Speak.HeaderCell.Style.Alignment := DataGridViewContentAlignment.MiddleCenter; 
      Speak.Width := 800;  
      
      Info.DataPropertyName := 'PropertiesProperty';
      Info.HeaderText := 'Info';
      Info.Name := 'propProperties';
      Info.ReadOnly := true;
      Info.Width := 350;
      Info.HeaderCell.Style.Alignment := DataGridViewContentAlignment.MiddleCenter; 
      Info.AutoSizeMode := System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
      DefaultCellStyle.WrapMode := DataGridViewTriState.True;
       ColumnHeadersHeight := 28; 
      case GridType of
        gtNormal:
          begin
            RowTemplate.Height := 40;
            Desc.Width := 600;
            Info.Width := 200;
           
            Self.Columns.AddRange(ID, Icon, Name, Info);
          end;
        gtItem: 
          begin
            RowTemplate.Height := 40;
            Desc.Width := 600;
            Info.Width := 200;
           
            Self.Columns.AddRange(ID, icon, Name, Desc, Info);
          end;
        gtMap: 
          begin
            RowTemplate.Height := 60;
            Desc.Width := 600;
            Info.Width := 200;
            StreetName.Width:=200;
            MapName.Width:=200;
            Self.Columns.AddRange(ID, Icon, StreetName, MapName, Info);
          end;
        gtMob: 
          begin
            RowTemplate.Height := 80;
            Icon.Width := 150;
            Desc.Width := 600;
            Info.Width := 200;
           
            Self.Columns.AddRange(ID, Icon, Name, Info);
          end;
        gtSkill: 
          begin
            RowTemplate.Height := 60;
            Icon.Width := 80;
            Desc.Width := 400;
            Info.Width := 200;
            Level.width:=450;
            Self.Columns.AddRange(ID, Icon, Name, Desc, Level, Info);
          end; 
        gtNpc:
          begin
            RowTemplate.Height := 70;
            Desc.Width := 600;
            Info.Width := 200;
            Self.Columns.AddRange(ID, Icon, Name, Speak, Info);
          end;
        gtMorph:
          begin
            RowTemplate.Height := 70;
            Desc.Width := 600;
            Self.Columns.AddRange(ID, Icon, MorphID, MorphIcon, Name, Desc, Info);
          end;       
        gtFamiliar:
          begin
            RowTemplate.Height := 70;
            ColumnHeadersHeight := 28; 
            Desc.Width := 300;
            FamiliarSkillName.Width:=150;
            FamiliarSkillDesc.Width:=350;
            Info.AutoSizeMode := System.Windows.Forms.DataGridViewAutoSizeColumnMode.None;
            Name.AutoSizeMode := System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            Info.Width := 300;
            Self.Columns.AddRange(ID, FamiliarIcon,Info,FamiliarSkillName,FamiliarSkillDesc,FamiliarCardID,Icon, Name);
          end;
          gtDamageSkin:
          begin
            RowTemplate.Height := 50;
            ColumnHeadersHeight := 28; 
            Name.Width:=250;
            Desc.Width := 600;
            Desc.AutoSizeMode := System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            Self.Columns.AddRange(ID, Icon, Name,Sample,Desc);
          end;  
          gtReactor:
          begin
            RowTemplate.Height := 80;
            Info.Width := 300;
            Self.Columns.AddRange(ID, Icon, Info);
          end;
         
      end;
      if (not System.Windows.Forms.SystemInformation.TerminalServerSession) then
      begin
        var dgvType := Self.GetType();
        var pi: PropertyInfo := dgvType.GetProperty('DoubleBuffered', BindingFlags.Instance or BindingFlags.NonPublic);
        pi.SetValue(Self, True, nil);
      end;
    end;
  end;


implementation

procedure SaveBin(Self: DataViewer; Path: string); extensionmethod;
begin
  var BinWriter: BinaryWriter := new BinaryWriter(System.IO.File.Open(Path, FileMode.Create));
  BinWriter.Write(Self.Columns.Count);
  BinWriter.Write(Self.Rows.Count);
  foreach var Row: DataGridViewRow in Self.Rows do
  begin
    for var j := 0 to Self.Columns.Count - 1 do
    begin
      var val: object := Row.Cells[j].Value;
      if val is string then
      begin
        BinWriter.Write('str');
        BinWriter.Write(val.ToString);
      end 
      else 
      if val is Bitmap then
      begin
        BinWriter.Write('Bitmap');
        var MemStream: MemoryStream := new MemoryStream;
        Bitmap(Val).Save(MemStream, System.Drawing.Imaging.ImageFormat.Png);
        var Buffer: array of Byte := MemStream.GetBuffer;
        BinWriter.Write(Buffer.Length);
        BinWriter.Write(Buffer);
      end;
    end;
  end;
  BinWriter.Close;
end;

procedure LoadBin(Self: DataViewer; Path: string); extensionmethod;
begin
  var BinReader: BinaryReader := new BinaryReader(System.IO.File.Open(Path, FileMode.Open));
  var n: Integer := BinReader.ReadInt32;
  var m: Integer := BinReader.ReadInt32;
  for var i := 0 to m - 2 do
  begin
    Self.Rows.Add;
    for var j := 0 to n - 1 do
    begin
      if BinReader.ReadString = 'str' then
        Self.Rows[i].Cells[j].Value := BinReader.ReadString
      else 
      begin
        var BufferLength: Integer := BinReader.ReadInt32;
        var Buffer: array of Byte := BinReader.ReadBytes(BufferLength);
        var MemStream: MemoryStream := new MemoryStream(Buffer);
        var LImage: Image := Image.FromStream(MemStream);
        var Bmp: Bitmap := new Bitmap(LImage.Width, LImage.Height, PixelFormat.Format16bppRgb555);
        Bmp.MakeTransparent;
        var g := Graphics.FromImage(Bmp);
        g.DrawImage(LImage, new Rectangle(0, 0, LImage.Width, LImage.Height));
        Self.Rows[i].Cells[j].Value := Bmp; 
      end;
    end;
  end;
  BinReader.Close;
end;


end.