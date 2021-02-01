procedure InitializeComponent;
    begin
        self.components := new System.ComponentModel.Container();
        var resources: System.ComponentModel.ComponentResourceManager := new System.ComponentModel.ComponentResourceManager(typeof(MainForm));
        self.panel1 := new System.Windows.Forms.Panel();
        self.label2 := new System.Windows.Forms.Label();
        self.label1 := new System.Windows.Forms.Label();
        self.SearchBox := new System.Windows.Forms.TextBox();
        self.SaveButton := new System.Windows.Forms.Button();
        self.LoadButton := new System.Windows.Forms.Button();
        self.SelectFolderBox := new System.Windows.Forms.TextBox();
        self.comboBox1 := new System.Windows.Forms.ComboBox();
        self.tabControl1 := new System.Windows.Forms.TabControl();
        self.Cash := new System.Windows.Forms.TabPage();
        self.Consume := new System.Windows.Forms.TabPage();
        self.Weapon := new System.Windows.Forms.TabPage();
        self.Cap := new System.Windows.Forms.TabPage();
        self.Coat := new System.Windows.Forms.TabPage();
        self.Longcoat := new System.Windows.Forms.TabPage();
        self.Pants := new System.Windows.Forms.TabPage();
        self.Shoes := new System.Windows.Forms.TabPage();
        self.Glove := new System.Windows.Forms.TabPage();
        self.Ring := new System.Windows.Forms.TabPage();
        self.Cape := new System.Windows.Forms.TabPage();
        self.Accessory := new System.Windows.Forms.TabPage();
        self.Shield := new System.Windows.Forms.TabPage();
        self.TamingMob := new System.Windows.Forms.TabPage();
        self.Hair := new System.Windows.Forms.TabPage();
        self.Face := new System.Windows.Forms.TabPage();
        self.Map1 := new System.Windows.Forms.TabPage();
        self.Map2 := new System.Windows.Forms.TabPage();
        self.Map3 := new System.Windows.Forms.TabPage();
        self.Mob := new System.Windows.Forms.TabPage();
        self.Mob001 := new System.Windows.Forms.TabPage();
        self.Mob2 := new System.Windows.Forms.TabPage();
        self.Skill := new System.Windows.Forms.TabPage();
        self.Skill001 := new System.Windows.Forms.TabPage();
        self.Skill002 := new System.Windows.Forms.TabPage();
        self.Npc := new System.Windows.Forms.TabPage();
        self.Pet := new System.Windows.Forms.TabPage();
        self.Install := new System.Windows.Forms.TabPage();
        self.Android := new System.Windows.Forms.TabPage();
        self.Mechanic := new System.Windows.Forms.TabPage();
        self.PetEquip := new System.Windows.Forms.TabPage();
        self.Bits := new System.Windows.Forms.TabPage();
        self.MonsterBattle := new System.Windows.Forms.TabPage();
        self.Totem := new System.Windows.Forms.TabPage();
        self.Morph := new System.Windows.Forms.TabPage();
        self.Familiar := new System.Windows.Forms.TabPage();
        self.DamageSkin := new System.Windows.Forms.TabPage();
        self.Etc := new System.Windows.Forms.TabPage();
        self.Reactor := new System.Windows.Forms.TabPage();
        self.folderBrowserDialog1 := new System.Windows.Forms.FolderBrowserDialog();
        self.imageList1 := new System.Windows.Forms.ImageList(self.components);
        self.panel1.SuspendLayout();
        self.tabControl1.SuspendLayout();
        self.SuspendLayout();
        // 
        // panel1
        // 
        self.panel1.BorderStyle := System.Windows.Forms.BorderStyle.FixedSingle;
        self.panel1.Controls.Add(self.label2);
        self.panel1.Controls.Add(self.label1);
        self.panel1.Controls.Add(self.SearchBox);
        self.panel1.Controls.Add(self.SaveButton);
        self.panel1.Controls.Add(self.LoadButton);
        self.panel1.Controls.Add(self.SelectFolderBox);
        self.panel1.Controls.Add(self.comboBox1);
        self.panel1.Dock := System.Windows.Forms.DockStyle.Top;
        self.panel1.Location := new System.Drawing.Point(0, 0);
        self.panel1.Name := 'panel1';
        self.panel1.Size := new System.Drawing.Size(1149, 34);
        self.panel1.TabIndex := 2;
        // 
        // label2
        // 
        self.label2.Font := new System.Drawing.Font('Verdana', 9, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, (System.Byte(0)));
        self.label2.Location := new System.Drawing.Point(719, 6);
        self.label2.Name := 'label2';
        self.label2.Size := new System.Drawing.Size(61, 23);
        self.label2.TabIndex := 6;
        self.label2.Text := 'Search';
        // 
        // label1
        // 
        self.label1.Font := new System.Drawing.Font('Verdana', 8);
        self.label1.Location := new System.Drawing.Point(193, 4);
        self.label1.Margin := new System.Windows.Forms.Padding(0);
        self.label1.Name := 'label1';
        self.label1.Size := new System.Drawing.Size(134, 25);
        self.label1.TabIndex := 5;
        self.label1.Text := 'MapleStory Folder';
        self.label1.TextAlign := System.Drawing.ContentAlignment.MiddleLeft;
        // 
        // SearchBox
        // 
        self.SearchBox.Location := new System.Drawing.Point(779, 4);
        self.SearchBox.Name := 'SearchBox';
        self.SearchBox.Size := new System.Drawing.Size(145, 25);
        self.SearchBox.TabIndex := 4;
        self.SearchBox.TextChanged += SearchBox_TextChanged;
        // 
        // SaveButton
        // 
        self.SaveButton.Font := new System.Drawing.Font('Verdana', 8);
        self.SaveButton.Location := new System.Drawing.Point(1022, 3);
        self.SaveButton.Name := 'SaveButton';
        self.SaveButton.Size := new System.Drawing.Size(80, 25);
        self.SaveButton.TabIndex := 3;
        self.SaveButton.Text := 'Save BIN';
        self.SaveButton.UseVisualStyleBackColor := true;
        self.SaveButton.Click += SaveButton_Click;
        // 
        // LoadButton
        // 
        self.LoadButton.Font := new System.Drawing.Font('Verdana', 8);
        self.LoadButton.Location := new System.Drawing.Point(501, 3);
        self.LoadButton.Name := 'LoadButton';
        self.LoadButton.Size := new System.Drawing.Size(87, 26);
        self.LoadButton.TabIndex := 2;
        self.LoadButton.Text := 'Load WZ';
        self.LoadButton.UseVisualStyleBackColor := true;
        self.LoadButton.Click += LoadButton_Click;
        // 
        // SelectFolderBox
        // 
        self.SelectFolderBox.Location := new System.Drawing.Point(326, 4);
        self.SelectFolderBox.Name := 'SelectFolderBox';
        self.SelectFolderBox.Size := new System.Drawing.Size(139, 25);
        self.SelectFolderBox.TabIndex := 1;
        self.SelectFolderBox.Click += SelectFolderBox_Click;
        self.SelectFolderBox.TextChanged += SelectFolderBox_TextChanged;
        // 
        // comboBox1
        // 
        self.comboBox1.Font := new System.Drawing.Font('Verdana', 8);
        self.comboBox1.FormattingEnabled := true;
        self.comboBox1.Items.AddRange(new System.Object[2]('Load From WZ', 'Load From BIN'));
        self.comboBox1.Location := new System.Drawing.Point(20, 5);
        self.comboBox1.Name := 'comboBox1';
        self.comboBox1.Size := new System.Drawing.Size(123, 24);
        self.comboBox1.TabIndex := 1;
        self.comboBox1.Text := 'Load From WZ';
        self.comboBox1.SelectedIndexChanged += comboBox1_SelectedIndexChanged;
        // 
        // tabControl1
        // 
        self.tabControl1.Controls.Add(self.Cash);
        self.tabControl1.Controls.Add(self.Consume);
        self.tabControl1.Controls.Add(self.Weapon);
        self.tabControl1.Controls.Add(self.Cap);
        self.tabControl1.Controls.Add(self.Coat);
        self.tabControl1.Controls.Add(self.Longcoat);
        self.tabControl1.Controls.Add(self.Pants);
        self.tabControl1.Controls.Add(self.Shoes);
        self.tabControl1.Controls.Add(self.Glove);
        self.tabControl1.Controls.Add(self.Ring);
        self.tabControl1.Controls.Add(self.Cape);
        self.tabControl1.Controls.Add(self.Accessory);
        self.tabControl1.Controls.Add(self.Shield);
        self.tabControl1.Controls.Add(self.TamingMob);
        self.tabControl1.Controls.Add(self.Hair);
        self.tabControl1.Controls.Add(self.Face);
        self.tabControl1.Controls.Add(self.Map1);
        self.tabControl1.Controls.Add(self.Map2);
        self.tabControl1.Controls.Add(self.Map3);
        self.tabControl1.Controls.Add(self.Mob);
        self.tabControl1.Controls.Add(self.Mob001);
        self.tabControl1.Controls.Add(self.Mob2);
        self.tabControl1.Controls.Add(self.Skill);
        self.tabControl1.Controls.Add(self.Skill001);
        self.tabControl1.Controls.Add(self.Skill002);
        self.tabControl1.Controls.Add(self.Npc);
        self.tabControl1.Controls.Add(self.Pet);
        self.tabControl1.Controls.Add(self.Install);
        self.tabControl1.Controls.Add(self.Android);
        self.tabControl1.Controls.Add(self.Mechanic);
        self.tabControl1.Controls.Add(self.PetEquip);
        self.tabControl1.Controls.Add(self.Bits);
        self.tabControl1.Controls.Add(self.MonsterBattle);
        self.tabControl1.Controls.Add(self.Totem);
        self.tabControl1.Controls.Add(self.Morph);
        self.tabControl1.Controls.Add(self.Familiar);
        self.tabControl1.Controls.Add(self.DamageSkin);
        self.tabControl1.Controls.Add(self.Etc);
        self.tabControl1.Controls.Add(self.Reactor);
        self.tabControl1.Dock := System.Windows.Forms.DockStyle.Fill;
        self.tabControl1.Font := new System.Drawing.Font('Verdana', 8.5);
        self.tabControl1.ImageList := self.imageList1;
        self.tabControl1.ItemSize := new System.Drawing.Size(30, 30);
        self.tabControl1.Location := new System.Drawing.Point(0, 34);
        self.tabControl1.Name := 'tabControl1';
        self.tabControl1.SelectedIndex := 0;
        self.tabControl1.Size := new System.Drawing.Size(1149, 647);
        self.tabControl1.TabIndex := 3;
        self.tabControl1.Selected += tabControl1_Selected;
        // 
        // Cash
        // 
        self.Cash.ImageIndex := 0;
        self.Cash.Location := new System.Drawing.Point(4, 34);
        self.Cash.Name := 'Cash';
        self.Cash.Padding := new System.Windows.Forms.Padding(3);
        self.Cash.Size := new System.Drawing.Size(1141, 609);
        self.Cash.TabIndex := 0;
        self.Cash.Text := 'Cash';
        self.Cash.UseVisualStyleBackColor := true;
        // 
        // Consume
        // 
        self.Consume.BackgroundImageLayout := System.Windows.Forms.ImageLayout.None;
        self.Consume.ImageIndex := 1;
        self.Consume.Location := new System.Drawing.Point(4, 34);
        self.Consume.Name := 'Consume';
        self.Consume.Padding := new System.Windows.Forms.Padding(3);
        self.Consume.Size := new System.Drawing.Size(1197, 711);
        self.Consume.TabIndex := 1;
        self.Consume.Text := 'Cousume';
        self.Consume.UseVisualStyleBackColor := true;
        // 
        // Weapon
        // 
        self.Weapon.ImageIndex := 2;
        self.Weapon.Location := new System.Drawing.Point(4, 34);
        self.Weapon.Name := 'Weapon';
        self.Weapon.Padding := new System.Windows.Forms.Padding(3);
        self.Weapon.Size := new System.Drawing.Size(1197, 711);
        self.Weapon.TabIndex := 2;
        self.Weapon.Text := 'Weapon';
        self.Weapon.UseVisualStyleBackColor := true;
        // 
        // Cap
        // 
        self.Cap.ImageIndex := 3;
        self.Cap.Location := new System.Drawing.Point(4, 34);
        self.Cap.Name := 'Cap';
        self.Cap.Padding := new System.Windows.Forms.Padding(3);
        self.Cap.Size := new System.Drawing.Size(1197, 711);
        self.Cap.TabIndex := 3;
        self.Cap.Text := 'Cap';
        self.Cap.UseVisualStyleBackColor := true;
        // 
        // Coat
        // 
        self.Coat.ImageIndex := 4;
        self.Coat.Location := new System.Drawing.Point(4, 34);
        self.Coat.Name := 'Coat';
        self.Coat.Padding := new System.Windows.Forms.Padding(3);
        self.Coat.Size := new System.Drawing.Size(1197, 711);
        self.Coat.TabIndex := 4;
        self.Coat.Text := 'Coat';
        self.Coat.UseVisualStyleBackColor := true;
        // 
        // Longcoat
        // 
        self.Longcoat.ImageIndex := 5;
        self.Longcoat.Location := new System.Drawing.Point(4, 34);
        self.Longcoat.Name := 'Longcoat';
        self.Longcoat.Size := new System.Drawing.Size(1197, 711);
        self.Longcoat.TabIndex := 5;
        self.Longcoat.Text := 'Longcoat';
        self.Longcoat.UseVisualStyleBackColor := true;
        // 
        // Pants
        // 
        self.Pants.ImageIndex := 6;
        self.Pants.Location := new System.Drawing.Point(4, 34);
        self.Pants.Name := 'Pants';
        self.Pants.Padding := new System.Windows.Forms.Padding(3);
        self.Pants.Size := new System.Drawing.Size(1197, 711);
        self.Pants.TabIndex := 6;
        self.Pants.Text := 'Pants';
        self.Pants.UseVisualStyleBackColor := true;
        // 
        // Shoes
        // 
        self.Shoes.ImageIndex := 7;
        self.Shoes.Location := new System.Drawing.Point(4, 34);
        self.Shoes.Name := 'Shoes';
        self.Shoes.Padding := new System.Windows.Forms.Padding(3);
        self.Shoes.Size := new System.Drawing.Size(1197, 711);
        self.Shoes.TabIndex := 7;
        self.Shoes.Text := 'Shoes';
        self.Shoes.UseVisualStyleBackColor := true;
        // 
        // Glove
        // 
        self.Glove.ImageIndex := 8;
        self.Glove.Location := new System.Drawing.Point(4, 34);
        self.Glove.Name := 'Glove';
        self.Glove.Padding := new System.Windows.Forms.Padding(3);
        self.Glove.Size := new System.Drawing.Size(1197, 711);
        self.Glove.TabIndex := 8;
        self.Glove.Text := 'Glove';
        self.Glove.UseVisualStyleBackColor := true;
        // 
        // Ring
        // 
        self.Ring.ImageIndex := 9;
        self.Ring.Location := new System.Drawing.Point(4, 34);
        self.Ring.Name := 'Ring';
        self.Ring.Padding := new System.Windows.Forms.Padding(3);
        self.Ring.Size := new System.Drawing.Size(1197, 711);
        self.Ring.TabIndex := 9;
        self.Ring.Text := 'Ring';
        self.Ring.UseVisualStyleBackColor := true;
        // 
        // Cape
        // 
        self.Cape.ImageIndex := 10;
        self.Cape.Location := new System.Drawing.Point(4, 34);
        self.Cape.Name := 'Cape';
        self.Cape.Padding := new System.Windows.Forms.Padding(3);
        self.Cape.Size := new System.Drawing.Size(1197, 711);
        self.Cape.TabIndex := 10;
        self.Cape.Text := 'Cape';
        self.Cape.UseVisualStyleBackColor := true;
        // 
        // Accessory
        // 
        self.Accessory.ImageIndex := 11;
        self.Accessory.Location := new System.Drawing.Point(4, 34);
        self.Accessory.Name := 'Accessory';
        self.Accessory.Padding := new System.Windows.Forms.Padding(3);
        self.Accessory.Size := new System.Drawing.Size(1197, 711);
        self.Accessory.TabIndex := 11;
        self.Accessory.Text := 'Accessory';
        self.Accessory.UseVisualStyleBackColor := true;
        // 
        // Shield
        // 
        self.Shield.ImageIndex := 12;
        self.Shield.Location := new System.Drawing.Point(4, 34);
        self.Shield.Name := 'Shield';
        self.Shield.Padding := new System.Windows.Forms.Padding(3);
        self.Shield.Size := new System.Drawing.Size(1197, 711);
        self.Shield.TabIndex := 12;
        self.Shield.Text := 'Shield';
        self.Shield.UseVisualStyleBackColor := true;
        // 
        // TamingMob
        // 
        self.TamingMob.ImageIndex := 13;
        self.TamingMob.Location := new System.Drawing.Point(4, 34);
        self.TamingMob.Name := 'TamingMob';
        self.TamingMob.Padding := new System.Windows.Forms.Padding(3);
        self.TamingMob.Size := new System.Drawing.Size(1197, 711);
        self.TamingMob.TabIndex := 13;
        self.TamingMob.Text := 'Mount';
        self.TamingMob.UseVisualStyleBackColor := true;
        // 
        // Hair
        // 
        self.Hair.ImageIndex := 14;
        self.Hair.Location := new System.Drawing.Point(4, 34);
        self.Hair.Name := 'Hair';
        self.Hair.Padding := new System.Windows.Forms.Padding(3);
        self.Hair.Size := new System.Drawing.Size(1197, 711);
        self.Hair.TabIndex := 14;
        self.Hair.Text := 'Hair';
        self.Hair.UseVisualStyleBackColor := true;
        // 
        // Face
        // 
        self.Face.ImageIndex := 15;
        self.Face.Location := new System.Drawing.Point(4, 34);
        self.Face.Name := 'Face';
        self.Face.Padding := new System.Windows.Forms.Padding(3);
        self.Face.Size := new System.Drawing.Size(1197, 711);
        self.Face.TabIndex := 15;
        self.Face.Text := 'Face';
        self.Face.UseVisualStyleBackColor := true;
        // 
        // Map1
        // 
        self.Map1.ImageIndex := 16;
        self.Map1.Location := new System.Drawing.Point(4, 34);
        self.Map1.Name := 'Map1';
        self.Map1.Padding := new System.Windows.Forms.Padding(3);
        self.Map1.Size := new System.Drawing.Size(1197, 711);
        self.Map1.TabIndex := 16;
        self.Map1.Text := 'Map(1)';
        self.Map1.UseVisualStyleBackColor := true;
        // 
        // Map2
        // 
        self.Map2.ImageIndex := 16;
        self.Map2.Location := new System.Drawing.Point(4, 34);
        self.Map2.Name := 'Map2';
        self.Map2.Padding := new System.Windows.Forms.Padding(3);
        self.Map2.Size := new System.Drawing.Size(1197, 711);
        self.Map2.TabIndex := 37;
        self.Map2.Text := 'Map(2)';
        self.Map2.UseVisualStyleBackColor := true;
        // 
        // Map3
        // 
        self.Map3.ImageIndex := 16;
        self.Map3.Location := new System.Drawing.Point(4, 34);
        self.Map3.Name := 'Map3';
        self.Map3.Padding := new System.Windows.Forms.Padding(3);
        self.Map3.Size := new System.Drawing.Size(1197, 711);
        self.Map3.TabIndex := 38;
        self.Map3.Text := 'Map(3)';
        self.Map3.UseVisualStyleBackColor := true;
        // 
        // Mob
        // 
        self.Mob.ImageIndex := 17;
        self.Mob.Location := new System.Drawing.Point(4, 34);
        self.Mob.Name := 'Mob';
        self.Mob.Padding := new System.Windows.Forms.Padding(3);
        self.Mob.Size := new System.Drawing.Size(1197, 711);
        self.Mob.TabIndex := 17;
        self.Mob.Text := 'Mob';
        self.Mob.UseVisualStyleBackColor := true;
        // 
        // Mob001
        // 
        self.Mob001.ImageIndex := 17;
        self.Mob001.Location := new System.Drawing.Point(4, 34);
        self.Mob001.Name := 'Mob001';
        self.Mob001.Padding := new System.Windows.Forms.Padding(3);
        self.Mob001.Size := new System.Drawing.Size(1197, 711);
        self.Mob001.TabIndex := 18;
        self.Mob001.Text := 'Mob001';
        self.Mob001.UseVisualStyleBackColor := true;
        // 
        // Mob2
        // 
        self.Mob2.ImageIndex := 17;
        self.Mob2.Location := new System.Drawing.Point(4, 34);
        self.Mob2.Name := 'Mob2';
        self.Mob2.Padding := new System.Windows.Forms.Padding(3);
        self.Mob2.Size := new System.Drawing.Size(1197, 711);
        self.Mob2.TabIndex := 19;
        self.Mob2.Text := 'Mob2';
        self.Mob2.UseVisualStyleBackColor := true;
        // 
        // Skill
        // 
        self.Skill.ImageIndex := 18;
        self.Skill.Location := new System.Drawing.Point(4, 34);
        self.Skill.Name := 'Skill';
        self.Skill.Padding := new System.Windows.Forms.Padding(3);
        self.Skill.Size := new System.Drawing.Size(1197, 711);
        self.Skill.TabIndex := 20;
        self.Skill.Text := 'Skill';
        self.Skill.UseVisualStyleBackColor := true;
        // 
        // Skill001
        // 
        self.Skill001.ImageIndex := 18;
        self.Skill001.Location := new System.Drawing.Point(4, 34);
        self.Skill001.Name := 'Skill001';
        self.Skill001.Padding := new System.Windows.Forms.Padding(3);
        self.Skill001.Size := new System.Drawing.Size(1197, 711);
        self.Skill001.TabIndex := 21;
        self.Skill001.Text := 'Skill001';
        self.Skill001.UseVisualStyleBackColor := true;
        // 
        // Skill002
        // 
        self.Skill002.ImageIndex := 18;
        self.Skill002.Location := new System.Drawing.Point(4, 34);
        self.Skill002.Name := 'Skill002';
        self.Skill002.Padding := new System.Windows.Forms.Padding(3);
        self.Skill002.Size := new System.Drawing.Size(1197, 711);
        self.Skill002.TabIndex := 22;
        self.Skill002.Text := 'Skill002';
        self.Skill002.UseVisualStyleBackColor := true;
        // 
        // Npc
        // 
        self.Npc.ImageIndex := 19;
        self.Npc.Location := new System.Drawing.Point(4, 34);
        self.Npc.Name := 'Npc';
        self.Npc.Padding := new System.Windows.Forms.Padding(3);
        self.Npc.Size := new System.Drawing.Size(1197, 711);
        self.Npc.TabIndex := 23;
        self.Npc.Text := 'Npc';
        self.Npc.UseVisualStyleBackColor := true;
        // 
        // Pet
        // 
        self.Pet.ImageIndex := 20;
        self.Pet.Location := new System.Drawing.Point(4, 34);
        self.Pet.Name := 'Pet';
        self.Pet.Padding := new System.Windows.Forms.Padding(3);
        self.Pet.Size := new System.Drawing.Size(1197, 711);
        self.Pet.TabIndex := 24;
        self.Pet.Text := 'Pet';
        self.Pet.UseVisualStyleBackColor := true;
        // 
        // Install
        // 
        self.Install.ImageIndex := 21;
        self.Install.Location := new System.Drawing.Point(4, 34);
        self.Install.Name := 'Install';
        self.Install.Padding := new System.Windows.Forms.Padding(3);
        self.Install.Size := new System.Drawing.Size(1197, 711);
        self.Install.TabIndex := 25;
        self.Install.Text := 'Install';
        self.Install.UseVisualStyleBackColor := true;
        // 
        // Android
        // 
        self.Android.ImageIndex := 22;
        self.Android.Location := new System.Drawing.Point(4, 34);
        self.Android.Name := 'Android';
        self.Android.Padding := new System.Windows.Forms.Padding(3);
        self.Android.Size := new System.Drawing.Size(1197, 711);
        self.Android.TabIndex := 26;
        self.Android.Text := 'Android';
        self.Android.UseVisualStyleBackColor := true;
        // 
        // Mechanic
        // 
        self.Mechanic.ImageIndex := 23;
        self.Mechanic.Location := new System.Drawing.Point(4, 34);
        self.Mechanic.Name := 'Mechanic';
        self.Mechanic.Padding := new System.Windows.Forms.Padding(3);
        self.Mechanic.Size := new System.Drawing.Size(1197, 711);
        self.Mechanic.TabIndex := 27;
        self.Mechanic.Text := 'Mechanic';
        self.Mechanic.UseVisualStyleBackColor := true;
        // 
        // PetEquip
        // 
        self.PetEquip.ImageIndex := 24;
        self.PetEquip.Location := new System.Drawing.Point(4, 34);
        self.PetEquip.Name := 'PetEquip';
        self.PetEquip.Padding := new System.Windows.Forms.Padding(3);
        self.PetEquip.Size := new System.Drawing.Size(1197, 711);
        self.PetEquip.TabIndex := 28;
        self.PetEquip.Text := 'Pep Equip';
        self.PetEquip.UseVisualStyleBackColor := true;
        // 
        // Bits
        // 
        self.Bits.ImageIndex := 25;
        self.Bits.Location := new System.Drawing.Point(4, 34);
        self.Bits.Name := 'Bits';
        self.Bits.Padding := new System.Windows.Forms.Padding(3);
        self.Bits.Size := new System.Drawing.Size(1197, 711);
        self.Bits.TabIndex := 29;
        self.Bits.Text := 'Bits';
        self.Bits.UseVisualStyleBackColor := true;
        // 
        // MonsterBattle
        // 
        self.MonsterBattle.ImageIndex := 26;
        self.MonsterBattle.Location := new System.Drawing.Point(4, 34);
        self.MonsterBattle.Name := 'MonsterBattle';
        self.MonsterBattle.Padding := new System.Windows.Forms.Padding(3);
        self.MonsterBattle.Size := new System.Drawing.Size(1197, 711);
        self.MonsterBattle.TabIndex := 30;
        self.MonsterBattle.Text := 'Monster Battle';
        self.MonsterBattle.UseVisualStyleBackColor := true;
        // 
        // Totem
        // 
        self.Totem.ImageIndex := 27;
        self.Totem.Location := new System.Drawing.Point(4, 34);
        self.Totem.Name := 'Totem';
        self.Totem.Padding := new System.Windows.Forms.Padding(3);
        self.Totem.Size := new System.Drawing.Size(1197, 711);
        self.Totem.TabIndex := 31;
        self.Totem.Text := 'Totem';
        self.Totem.UseVisualStyleBackColor := true;
        // 
        // Morph
        // 
        self.Morph.ImageIndex := 28;
        self.Morph.Location := new System.Drawing.Point(4, 34);
        self.Morph.Name := 'Morph';
        self.Morph.Padding := new System.Windows.Forms.Padding(3);
        self.Morph.Size := new System.Drawing.Size(1197, 711);
        self.Morph.TabIndex := 33;
        self.Morph.Text := 'Morph';
        self.Morph.UseVisualStyleBackColor := true;
        // 
        // Familiar
        // 
        self.Familiar.ImageIndex := 29;
        self.Familiar.Location := new System.Drawing.Point(4, 34);
        self.Familiar.Name := 'Familiar';
        self.Familiar.Padding := new System.Windows.Forms.Padding(3);
        self.Familiar.Size := new System.Drawing.Size(1197, 711);
        self.Familiar.TabIndex := 34;
        self.Familiar.Text := 'Familiar';
        self.Familiar.UseVisualStyleBackColor := true;
        // 
        // DamageSkin
        // 
        self.DamageSkin.ImageIndex := 30;
        self.DamageSkin.Location := new System.Drawing.Point(4, 34);
        self.DamageSkin.Name := 'DamageSkin';
        self.DamageSkin.Padding := new System.Windows.Forms.Padding(3);
        self.DamageSkin.Size := new System.Drawing.Size(1197, 711);
        self.DamageSkin.TabIndex := 32;
        self.DamageSkin.Text := 'Damage Skin';
        self.DamageSkin.UseVisualStyleBackColor := true;
        // 
        // Etc
        // 
        self.Etc.ImageIndex := 31;
        self.Etc.Location := new System.Drawing.Point(4, 34);
        self.Etc.Name := 'Etc';
        self.Etc.Padding := new System.Windows.Forms.Padding(3);
        self.Etc.Size := new System.Drawing.Size(1197, 711);
        self.Etc.TabIndex := 35;
        self.Etc.Text := 'Etc';
        self.Etc.UseVisualStyleBackColor := true;
        // 
        // Reactor
        // 
        self.Reactor.ImageIndex := 32;
        self.Reactor.Location := new System.Drawing.Point(4, 34);
        self.Reactor.Name := 'Reactor';
        self.Reactor.Padding := new System.Windows.Forms.Padding(3);
        self.Reactor.Size := new System.Drawing.Size(1197, 711);
        self.Reactor.TabIndex := 36;
        self.Reactor.Text := 'Reactor';
        self.Reactor.UseVisualStyleBackColor := true;
        // 
        // folderBrowserDialog1
        // 
        self.folderBrowserDialog1.ShowNewFolderButton := false;
        // 
        // imageList1
        // 
        self.imageList1.ImageStream := (System.Windows.Forms.ImageListStreamer(resources.GetObject('imageList1.ImageStream')));
        self.imageList1.TransparentColor := System.Drawing.Color.Transparent;
        self.imageList1.Images.SetKeyName(0, 'cash_.png');
        self.imageList1.Images.SetKeyName(1, 'iconRaw.png');
        self.imageList1.Images.SetKeyName(2, 'weapon.png');
        self.imageList1.Images.SetKeyName(3, 'iconRaw.png');
        self.imageList1.Images.SetKeyName(4, 'iconRaw.png');
        self.imageList1.Images.SetKeyName(5, 'iconRaw.png');
        self.imageList1.Images.SetKeyName(6, 'iconRaw.png');
        self.imageList1.Images.SetKeyName(7, 'iconRaw.png');
        self.imageList1.Images.SetKeyName(8, 'iconRaw.png');
        self.imageList1.Images.SetKeyName(9, 'iconRaw.png');
        self.imageList1.Images.SetKeyName(10, 'iconRaw.png');
        self.imageList1.Images.SetKeyName(11, 'iconRaw.png');
        self.imageList1.Images.SetKeyName(12, 'iconRaw.png');
        self.imageList1.Images.SetKeyName(13, 'iconRaw.png');
        self.imageList1.Images.SetKeyName(14, 'hairOverHead.png');
        self.imageList1.Images.SetKeyName(15, 'face.png');
        self.imageList1.Images.SetKeyName(16, 'Ludibrium.png');
        self.imageList1.Images.SetKeyName(17, '00.png');
        self.imageList1.Images.SetKeyName(18, 'icon.png');
        self.imageList1.Images.SetKeyName(19, 'iconRaw3.png');
        self.imageList1.Images.SetKeyName(20, 'iconRawD.png');
        self.imageList1.Images.SetKeyName(21, 'iconRaw.png');
        self.imageList1.Images.SetKeyName(22, 'iconRawD.png');
        self.imageList1.Images.SetKeyName(23, 'icon.png');
        self.imageList1.Images.SetKeyName(24, 'iconRaw.png');
        self.imageList1.Images.SetKeyName(25, 'icon.png');
        self.imageList1.Images.SetKeyName(26, 'iconRaw.png');
        self.imageList1.Images.SetKeyName(27, 'iconRaw.png');
        self.imageList1.Images.SetKeyName(28, 'icon.png');
        self.imageList1.Images.SetKeyName(29, 'icon.png');
        self.imageList1.Images.SetKeyName(30, 'icon.png');
        self.imageList1.Images.SetKeyName(31, 'iconRaw.png');
        self.imageList1.Images.SetKeyName(32, '0.png');
        // 
        // MainForm
        // 
        self.ClientSize := new System.Drawing.Size(1149, 681);
        self.Controls.Add(self.tabControl1);
        self.Controls.Add(self.panel1);
        self.Name := 'MainForm';
        self.Text := 'GMHandTool';
        self.WindowState := System.Windows.Forms.FormWindowState.Maximized;
        self.Load += MainForm_Load;
        self.panel1.ResumeLayout(false);
        self.panel1.PerformLayout();
        self.tabControl1.ResumeLayout(false);
        self.ResumeLayout(false);
    end;
