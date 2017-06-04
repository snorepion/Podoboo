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
using System.Diagnostics;
using System.IO;

namespace Podoboo
{
    public partial class Sprites : Form
    {
        public Sprites()
        {
            InitializeComponent();
        }
        private void Sprites_Load(object sender, EventArgs e)
        {
            // check used sprites
            if (!string.IsNullOrEmpty(Properties.Settings.Default.usedSprites))
            {
                Properties.Settings.Default.usedSprites.Split(',')
                    .ToList()
                    .ForEach(item =>
                    {
                        var index = this.checkedListBox1.Items.IndexOf(item);
                        this.checkedListBox1.SetItemChecked(index, true);
                    });
            }
            string spritetooltouse = Properties.Settings.Default.spritetoolOption;
            if (spritetooltouse == "romi")
            {
                radioButton1.Checked = true;
                radioButton2.Checked = false;
                radioButton3.Checked = false;
                radioButton4.Checked = false;
                textBox1.Text = File.ReadAllText(Properties.Settings.Default.installDirectory + "files/owspt/osprites.txt");
            }
            
            if (spritetooltouse == "owst")
            {
                radioButton1.Checked = false;
                radioButton2.Checked = false;
                radioButton3.Checked = true;
                radioButton4.Checked = false;
                textBox1.Text = File.ReadAllText(Properties.Settings.Default.installDirectory + "files/pixi/list.txt");
            }
            if (spritetooltouse == "cst")
            {
                radioButton1.Checked = false;
                radioButton2.Checked = false;
                radioButton3.Checked = false;
                radioButton4.Checked = true;
                textBox1.Text = File.ReadAllText(Properties.Settings.Default.installDirectory + "files/clsptool/csprites.txt");
            }
            if (spritetooltouse == "pixi")
            {
                radioButton1.Checked = false;
                radioButton2.Checked = true;
                radioButton3.Checked = false;
                radioButton4.Checked = false;
                textBox1.Text = File.ReadAllText(Properties.Settings.Default.installDirectory + "files/pixi/list.txt");
            }
            textBox2.Text = File.ReadAllText(Properties.Settings.Default.installDirectory + "files/spritetip/list.txt");
        }

        private void button1_Click(object sender, EventArgs e)
        {
            var sprites = this.checkedListBox1.CheckedItems.Cast<string>().ToArray();
            Properties.Settings.Default.usedSprites = string.Join(",", sprites);
            Properties.Settings.Default.Save();
        }

        private void button6_Click(object sender, EventArgs e)
        {
            var proc = new Process();
            proc.StartInfo.FileName = Properties.Settings.Default.installDirectory + "files/tweaker/tweaker.exe";
            proc.StartInfo.WorkingDirectory = Properties.Settings.Default.installDirectory + "files/tweaker/";
            proc.Start();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            SaveFileDialog listDotTxtSave = new SaveFileDialog();
            listDotTxtSave.InitialDirectory = Properties.Settings.Default.installDirectory;
            listDotTxtSave.Title = "Export List.txt";
            listDotTxtSave.DefaultExt = ".txt";
            listDotTxtSave.Filter = "Text files|*.txt";
            if (listDotTxtSave.ShowDialog() == DialogResult.OK)
            {
                System.IO.File.WriteAllText(listDotTxtSave.FileName, textBox1.Text);
            }
        }

        private void button5_Click(object sender, EventArgs e)
        {
            SaveFileDialog stSave = new SaveFileDialog();
            stSave.InitialDirectory = Properties.Settings.Default.installDirectory + "files/spritetip";
            stSave.Title = "Export SpriteTIP list";
            stSave.DefaultExt = ".txt";
            stSave.Filter = "Text files|*.txt";
            if (stSave.ShowDialog() == DialogResult.OK)
            {
                System.IO.File.WriteAllText(stSave.FileName, textBox2.Text);
            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            var proc = new Process();
            System.IO.File.WriteAllText(Properties.Settings.Default.installDirectory + "files/spritetip/list.txt", textBox2.Text);
            proc.StartInfo.FileName = Properties.Settings.Default.installDirectory + "files/spritetip/SpriteTip.exe";
            proc.StartInfo.WorkingDirectory = Properties.Settings.Default.installDirectory + "files/spritetip/";
            proc.Start();
        }

        private void button8_Click(object sender, EventArgs e)
        {
            Thread import = new Thread((ThreadStart)delegate { Application.Run(new ImportSprites()); });
            import.TrySetApartmentState(ApartmentState.STA);
            import.Start();
        }
    }
}
