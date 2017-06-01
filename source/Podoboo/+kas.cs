using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Diagnostics;

namespace Podoboo
{
    public partial class _kas : Form
    {
        public _kas()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            //inefficient, fix?
            string xkasinstall1;
            xkasinstall1 = "cd C:/Program Files/Podoboo/files/xkas";
            string xkasinstall2;
            xkasinstall2 = "xkas.exe " + textBox1.Text + " " + Podoboo.Properties.Settings.Default.romPath;
            string xkasinstall3;
            xkasinstall3 = xkasinstall1 + " && " + xkasinstall2;
            Process.Start("CMD.exe", xkasinstall3);
        }
    }
}
