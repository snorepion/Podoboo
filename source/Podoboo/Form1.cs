using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Threading;
using Podoboo.Properties;


namespace Podoboo
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }
        bool readmemode;
        bool hidemode;
        private void Form1_Load(object sender, EventArgs e)
        {
            Podoboo.Properties.Settings.Default.hasCompletedSetup = true;
            Properties.Settings.Default.Save();
            if (Settings.Default.uiTheme == "blue") { coolTheme(); }
            if (Settings.Default.uiTheme == "red") { lavaTheme(); }
            if (Settings.Default.uiTheme == "dark") { darkTheme(); }
            if (Settings.Default.uiTheme == "light") { lightTheme(); }
        }

        private void listToolStripMenuItem_Click(object sender, EventArgs e)
        {

        }

        private void selectROMToolStripMenuItem_Click(object sender, EventArgs e)
        {
            // create OpenFileDialog that can only select ROMs, then save the ROM path to a location inside the program
            OpenFileDialog romPickerDialog = new OpenFileDialog();
            romPickerDialog.FileName = "Super Mario World.smc";
            romPickerDialog.Filter = "SMC files|*.smc|SFC files|*.sfc";
            romPickerDialog.RestoreDirectory = true;
            if (romPickerDialog.ShowDialog() == DialogResult.OK)
            {
                Podoboo.Properties.Settings.Default.romPath = romPickerDialog.FileName;
                Properties.Settings.Default.Save();
            }
        }

        private void yYCHRToolStripMenuItem1_Click(object sender, EventArgs e)
        {

        }

        private void blocksToolStripMenuItem_Click(object sender, EventArgs e)
        {

        }



        private void toolStripContainer1_ContentPanel_Load(object sender, EventArgs e)
        {

        }

        private void settingsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Thread settings2 = new Thread((ThreadStart)delegate { Application.Run(new Options()); });
            settings2.Start();
        }
        

        private void lightToolStripMenuItem_Click(object sender, EventArgs e)
        {
            lightTheme();
        }

        private void lavaToolStripMenuItem_Click(object sender, EventArgs e)
        {
            lavaTheme();
        }

        private void coolToolStripMenuItem_Click(object sender, EventArgs e)
        {
            coolTheme();
        }

        private void darkToolStripMenuItem_Click(object sender, EventArgs e)
        {
            darkTheme();
        }
        /// <summary>
        /// call any of the Theme() events on init or on a theme being set
        /// </summary>
        private void lavaTheme()
        {
            // sets theme without needing to restart program/form
            Podoboo.Properties.Settings.Default.uiTheme = "red";
            Properties.Settings.Default.Save();
            menuStrip1.BackColor = Color.OrangeRed;
            statusStrip1.BackColor = Color.OrangeRed;
            toolStripContainer1.ContentPanel.BackColor = Color.Orange;
            menuStrip1.Renderer = new ToolStripProfessionalRenderer(new RedTheme());
            darkToolStripMenuItem.Checked = false;
            coolToolStripMenuItem.Checked = false;
            lightToolStripMenuItem.Checked = false;
            lavaToolStripMenuItem.Checked = true;
            richTextBox1.BackColor = Color.OrangeRed;
            richTextBox1.ForeColor = Color.Black;
            this.BackColor = Color.Orange;
            menuStrip1.ForeColor = Color.Black;
            statusStrip1.ForeColor = Color.Black;
        }
        private void coolTheme()
        {
            Podoboo.Properties.Settings.Default.uiTheme = "blue";
            Properties.Settings.Default.Save();
            menuStrip1.BackColor = Color.FromArgb(255, 1, 188, 138);
            statusStrip1.BackColor = Color.FromArgb(255, 1, 188, 138);
            toolStripContainer1.ContentPanel.BackColor = Color.FromArgb(255, 1, 188, 64);
            menuStrip1.Renderer = new ToolStripProfessionalRenderer(new BlueTheme());
            darkToolStripMenuItem.Checked = false;
            coolToolStripMenuItem.Checked = true;
            lightToolStripMenuItem.Checked = false;
            lavaToolStripMenuItem.Checked = false;
            richTextBox1.BackColor = Color.Turquoise;
            richTextBox1.ForeColor = Color.Black;
            this.BackColor = Color.FromArgb(255, 1, 188, 64);
            menuStrip1.ForeColor = Color.Black;
            statusStrip1.ForeColor = Color.Black;
        }
        private void lightTheme()
        {
            Podoboo.Properties.Settings.Default.uiTheme = "light";
            Properties.Settings.Default.Save();
            menuStrip1.BackColor = Color.FromArgb(255, 223, 223, 223);
            statusStrip1.BackColor = Color.FromArgb(255, 223, 223, 223);
            toolStripContainer1.ContentPanel.BackColor = Color.FromArgb(255, 227, 46, 0);
            menuStrip1.Renderer = new ToolStripProfessionalRenderer(new LightTheme());
            darkToolStripMenuItem.Checked = false;
            coolToolStripMenuItem.Checked = false;
            lightToolStripMenuItem.Checked = true;
            lavaToolStripMenuItem.Checked = false;
            richTextBox1.BackColor = Color.White;
            richTextBox1.ForeColor = Color.Black;
            this.BackColor = Color.FromArgb(255, 227, 46, 0);
            menuStrip1.ForeColor = Color.Black;
            statusStrip1.ForeColor = Color.Black;
        }
        private void darkTheme()
        {
            Podoboo.Properties.Settings.Default.uiTheme = "dark";
            Properties.Settings.Default.Save();
            menuStrip1.BackColor = Color.FromArgb(255, 68, 71, 73);
            statusStrip1.BackColor = Color.FromArgb(255, 68, 71, 73);
            toolStripContainer1.ContentPanel.BackColor = Color.FromArgb(255, 45, 45, 45);
            menuStrip1.Renderer = new ToolStripProfessionalRenderer(new DarkTheme());
            darkToolStripMenuItem.Checked = true;
            coolToolStripMenuItem.Checked = false;
            lightToolStripMenuItem.Checked = false;
            lavaToolStripMenuItem.Checked = false;
            richTextBox1.BackColor = Color.FromArgb(255, 104, 104, 104);
            richTextBox1.ForeColor = Color.White;
            this.BackColor = Color.FromArgb(255, 45, 45, 45);
            menuStrip1.ForeColor = Color.White;
            statusStrip1.ForeColor = Color.White;
        }

        private void romisSpritetoolToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Settings.Default.spritetoolOption = "romi";
            Thread addsprites = new Thread((ThreadStart)delegate { Application.Run(new Sprites()); });
            addsprites.TrySetApartmentState(ApartmentState.STA);
            addsprites.Start();
        }

        private void pIXIToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Settings.Default.spritetoolOption = "pixi";
            Thread addsprites = new Thread((ThreadStart)delegate { Application.Run(new Sprites()); });
            addsprites.TrySetApartmentState(ApartmentState.STA);
            addsprites.Start();
        }

        private void clusterSpritetoolToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Settings.Default.spritetoolOption = "cst";
            Thread addsprites = new Thread((ThreadStart)delegate { Application.Run(new Sprites()); });
            addsprites.TrySetApartmentState(ApartmentState.STA);
            addsprites.Start();
        }

        private void overworldSpritetoolToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Settings.Default.spritetoolOption = "owst";
            Thread addsprites = new Thread((ThreadStart)delegate { Application.Run(new Sprites()); });
            addsprites.TrySetApartmentState(ApartmentState.STA);
            addsprites.Start();
        }

        private void tesseraToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Settings.Default.spritetoolOption = "tessera";
            Thread addsprites = new Thread((ThreadStart)delegate { Application.Run(new Sprites()); });
            addsprites.TrySetApartmentState(ApartmentState.STA);
            addsprites.Start();
        }

        private void spriteTIPToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Settings.Default.spritetoolOption = "";
            Thread addsprites = new Thread((ThreadStart)delegate { Application.Run(new Sprites()); });
            addsprites.TrySetApartmentState(ApartmentState.STA);
            addsprites.Start();
        }
    }
}
public class LightTheme : ProfessionalColorTable
{
    public override Color MenuItemSelected
    {
        get { return Color.LightGray; }
    }

    public override Color MenuBorder  
    {
        get { return Color.White; }
    }
    public override Color ButtonPressedHighlight
    {
        get { return Color.Orange; }
    }
    public override Color ButtonSelectedBorder
    {
        get { return Color.White; }
    }
    public override Color MenuItemBorder
    {
        get { return Color.LightGray; }
    }
}
public class DarkTheme : ProfessionalColorTable
{
    public override Color MenuItemSelected
    {
        get { return Color.FromArgb(255, 60, 81, 112); }
    }
    public override Color MenuBorder 
    {
        get { return Color.FromArgb(255, 60, 81, 112); }
    }
    public override Color ButtonPressedHighlight
    {
        get { return Color.DarkGray; }
    }
    public override Color ButtonSelectedBorder
    {
        get { return Color.FromArgb(255, 86, 86, 86); }
    }
    public override Color MenuItemBorder
    {
        get { return Color.FromArgb(255, 60, 81, 112); }
    }
    public override Color MenuItemPressedGradientBegin
    {
        get { return Color.FromArgb(255, 60, 81, 112); }
    }
    public override Color MenuItemPressedGradientEnd
    {
        get { return Color.FromArgb(255, 60, 81, 112); }
    }
    public override Color MenuStripGradientBegin
    {
       get { return Color.FromArgb(255, 60, 81, 112); }
    }
    public override Color MenuStripGradientEnd
    {
        get { return Color.FromArgb(255, 60, 81, 112); }
    }
}

public class RedTheme : ProfessionalColorTable
{
    public override Color MenuItemSelected
    {
        get { return Color.FromArgb(255, 232, 59, 2); }
    }

    public override Color MenuBorder  
    {
        get { return Color.FromArgb(255, 232, 59, 2); }
    }
    public override Color ButtonPressedHighlight
    {
        get { return Color.Orange; }
    }
    public override Color ButtonSelectedBorder
    {
        get { return Color.FromArgb(255, 232, 59, 2); }
    }
    public override Color MenuItemBorder
    {
        get { return Color.FromArgb(255, 232, 59, 2); }
    }

}
public class BlueTheme : ProfessionalColorTable
{
    public override Color MenuItemSelected
    {
        get { return Color.LightSeaGreen; }
    }

    public override Color MenuBorder  
    {
        get { return Color.Teal; }
    }
    public override Color ButtonPressedHighlight
    {
        get { return Color.Teal;  }
    }
    public override Color ButtonSelectedBorder
    {
        get { return Color.LightSeaGreen; }
    }
    public override Color MenuItemBorder
    {
        get { return Color.LightSeaGreen; }
    }
}
