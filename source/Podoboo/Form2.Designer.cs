namespace Podoboo
{
    partial class Form2
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form2));
            this.label1 = new System.Windows.Forms.Label();
            this.checkedListBox1 = new System.Windows.Forms.CheckedListBox();
            this.button1 = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(1, 9);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(504, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "Hi there, and welcome to Podoboo! Let\'s get you set up. First, let\'s choose the t" +
    "ools you would like to use.";
            // 
            // checkedListBox1
            // 
            this.checkedListBox1.FormattingEnabled = true;
            this.checkedListBox1.Items.AddRange(new object[] {
            "Asar",
            "Asar+ (Asar with GUI)",
            "xkas",
            "+kas (xkas with GUI)",
            "UberASM",
            "Romi\'s Spritetool",
            "Tessera",
            "PIXI",
            "SpriteTIP",
            "Cluster Spritetool",
            "Iggy and Larry Editor",
            "Overworld Spritetool",
            "Sprite Config Editor",
            "Sprite GFX Creator",
            "Tweaker",
            "Gopher Popcorn Stew",
            "Blockreator",
            "AddmusicK",
            "VGMtrans",
            "spcplay",
            "BRR Player",
            "LevelMusic",
            "MML Editing Tool",
            "PetiteMM",
            "snesbrr",
            "SPCtoMML",
            "STEAR",
            "Edit GFX27",
            "Player Tilemap Editor",
            "Palette Editor",
            "Palette Generator",
            "Mario and Luigi Live Palette Editor",
            "Effect Tool",
            "Terra Stripe",
            "Enemy Name Importer/Exporter",
            "Miscellaneous Text Editor",
            "Thank You Message Importer",
            "Status Effect",
            "Status Bar Editor",
            "Graphic Editor",
            "MassRotate",
            "YY-CHR",
            "SnesGFX",
            "Lunar IPS",
            "Floating IPS",
            "Snes9x",
            "ZSNES",
            "bsnes/Higan",
            "ZMZ",
            "Lunar Address",
            "Lunar Compress",
            "Interaction Editor",
            "Recover Lunar Magic",
            "ROMclean",
            "SMW Customizer"});
            this.checkedListBox1.Location = new System.Drawing.Point(13, 37);
            this.checkedListBox1.Name = "checkedListBox1";
            this.checkedListBox1.Size = new System.Drawing.Size(482, 274);
            this.checkedListBox1.TabIndex = 1;
            this.checkedListBox1.TabStop = false;
            this.checkedListBox1.SelectedIndexChanged += new System.EventHandler(this.checkedListBox1_SelectedIndexChanged);
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(420, 317);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(75, 23);
            this.button1.TabIndex = 2;
            this.button1.Text = "Next";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // Form2
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(507, 351);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.checkedListBox1);
            this.Controls.Add(this.label1);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MaximizeBox = false;
            this.Name = "Form2";
            this.Text = "Podoboo Setup";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.CheckedListBox checkedListBox1;
        private System.Windows.Forms.Button button1;
    }
}