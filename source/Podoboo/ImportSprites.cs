using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Podoboo
{
    public partial class ImportSprites : Form
    {
        public ImportSprites()
        {
            InitializeComponent();
        }
        StringBuilder pdbspContents = new StringBuilder();
        /// PDBSP sprite packages
        /// PDBSP reads line 1 as the Spritetool to use. @rs is Romi's ST, @px is PIXI, @ow is Overworld ST, and @ct is Cluster ST.
        private void radioButton1_CheckedChanged(object sender, EventArgs e)
        {
            if (radioButton1.Checked)
            {
                pdbspContentsTextBox.Lines[1] = "@rs;";
            }
        }

        private void radioButton2_CheckedChanged(object sender, EventArgs e)
        {
            if (radioButton2.Checked) {
                pdbspContentsTextBox.Lines[1] = "@px;";
            }
        }

        private void radioButton3_CheckedChanged(object sender, EventArgs e)
        {
            if (radioButton3.Checked)
            {
                pdbspContentsTextBox.Lines[1] = "@ow;";
            }
        }

        private void radioButton4_CheckedChanged(object sender, EventArgs e)
        {
            if (radioButton4.Checked)
            {
                pdbspContentsTextBox.Lines[1] = "@ct";
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog findPdbspDir = new FolderBrowserDialog();
            findPdbspDir.ShowNewFolderButton = true;
            if (findPdbspDir.ShowDialog() == DialogResult.OK)
            {
                pdbspContentsTextBox.Lines[4] = findPdbspDir.SelectedPath;

            }

        }

        private void radioButton5_CheckedChanged(object sender, EventArgs e)
        {
           if (radioButton5.Checked)
            {
                pdbspContentsTextBox.Lines[5] = "type: standard";
            }
        }

        private void radioButton6_CheckedChanged(object sender, EventArgs e)
        {
            if (radioButton6.Checked)
            {
                pdbspContentsTextBox.Lines[5] = "type: shooter";
            }
        }

        private void radioButton7_CheckedChanged(object sender, EventArgs e)
        {
            if (radioButton7.Checked)
            {
                pdbspContentsTextBox.Lines[5] = "type: gen";
            }
        }

        private void button4_Click(object sender, EventArgs e)
        {
            if (textBox1.Text != "Sprite name without .asm or .cfg")
            {
                if (pdbspContentsTextBox.Lines[6] == "sprite1, sprite2, bosses/boss1, bosses/boss2/boss2") { pdbspContentsTextBox.Lines[6] = ""; }
                pdbspContentsTextBox.Lines[6] += textBox1.Text + ", ";
            }
        }

        private void checkBox1_CheckedChanged(object sender, EventArgs e)
        {
            if (checkBox1.Checked)
            {
                checkBox2.Visible = false;
                button1.Visible = false;
                checkBox2.Checked = false;
                pdbspContentsTextBox.Lines[2] = "thisdir: true";
                pdbspContentsTextBox.Lines[3] = "pdir: false";
                pdbspContentsTextBox.Lines[4] = "";
            }
            if (!checkBox1.Checked & !checkBox2.Checked) { checkBox1.Visible = true; checkBox2.Visible = true; button1.Visible = true; }
        }

        private void checkBox2_CheckedChanged(object sender, EventArgs e)
        {
            if (checkBox2.Checked)
            {
                checkBox1.Visible = false;
                button1.Visible = false;
                checkBox1.Checked = false;
                pdbspContentsTextBox.Lines[2] = "thisdir: false";
                pdbspContentsTextBox.Lines[3] = "pdir: true";
                pdbspContentsTextBox.Lines[4] = "";
            }
            if (!checkBox1.Checked & !checkBox2.Checked) { checkBox1.Visible = true; checkBox2.Visible = true; button1.Visible = true; }
        }

        private void ImportSprites_Load(object sender, EventArgs e)
        {
            
        }
    }
}
