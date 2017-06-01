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
    public partial class Asar_ : Form
    {
        public Asar_()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            // inefficient, fix?
            string asarinstall1;
            asarinstall1 = "cd C:/Program Files/Podoboo/files/asar";
            string asarinstall2;
            asarinstall2 = "asar.exe " + textBox1.Text + " " + Podoboo.Properties.Settings.Default.romPath;
            string asarinstall3;
            asarinstall3 = asarinstall1 + " && " + asarinstall2;
            System.Diagnostics.Process.Start("CMD.exe", asarinstall3);
        }
    }
}
