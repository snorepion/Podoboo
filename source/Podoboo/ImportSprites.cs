using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Threading;
using System.Windows.Forms;
using System.IO;
using Podoboo.Properties;

namespace Podoboo
{
    public partial class ImportSprites : Form
    {
        public ImportSprites()
        {
            InitializeComponent();
        }
        int index_var = 0;
        /// PDBO sprite packages
        private void ImportSprites_Load(object sender, EventArgs e)
        {

        }
        private void button1_Click(object sender, EventArgs e)
        {
            string spritetool = "files/UnassignedSprites";
            if (radioButton1.Checked == true)
            {
                if (radioButton5.Checked == true)
                    spritetool = "files/rsprt/sprites";
                if (radioButton6.Checked == true)
                    spritetool = "files/rsprt/shooters";
                if (radioButton7.Checked == true)
                    spritetool = "files/rsprt/generators";
            }
            if (radioButton2.Checked == true)
            {
                if (radioButton5.Checked == true)
                    spritetool = "files/pixi/sprites";
                if (radioButton6.Checked == true)
                    spritetool = "files/rsprt/shooters";
                if (radioButton7.Checked == true)
                    spritetool = "files/rsprt/sprites";
            }
            if (radioButton3.Checked == true)
                spritetool = "files/owspt/osprites";
            if (radioButton4.Checked == true)
                spritetool = "files/clsptool/csprites";
            OpenFileDialog importSprites = new OpenFileDialog();
            importSprites.Filter = "Assembly sprites|*.asm";
            importSprites.Multiselect = true;
            importSprites.FileName = "Sprite.asm";
            importSprites.Title = "Import Sprites";
            if (importSprites.ShowDialog() == DialogResult.OK)
            {
                string[] files = importSprites.FileNames;
                foreach (string sprt in files)
                {
                    string filename = Path.GetFileNameWithoutExtension(importSprites.FileNames[index_var]);
                    File.Copy(importSprites.FileNames[index_var], Path.Combine(Settings.Default.installDirectory, spritetool, "/") + filename + ".asm");
                    File.Copy(Path.Combine(Path.GetDirectoryName(importSprites.FileName), "/") + filename + ".cfg", Path.Combine(Settings.Default.installDirectory, spritetool, "/") + filename + ".cfg", true);
                    index_var += 1;
                }
            }
        }
        private void button3_Click(object sender, EventArgs e)
        {
            Thread database = new Thread((ThreadStart)delegate { Application.Run(new SpriteDatabase()); });
            database.TrySetApartmentState(ApartmentState.STA);
            database.Start();
        }
    }
}
