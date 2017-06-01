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

namespace Podoboo
{
    public partial class Options : Form
    {
        public Options()
        {
            InitializeComponent();
         
        }

        private void radioButton1_CheckedChanged(object sender, EventArgs e)
        {
            // set backup setting on and off when radio button is changed
            if (radioButton1.Checked)
            {
                Podoboo.Properties.Settings.Default.backup = true;
            }
            if (radioButton1.Checked == false)
            {
                Podoboo.Properties.Settings.Default.backup = false;
            }
        }

        private void radioButton2_CheckedChanged(object sender, EventArgs e)
        {
            // same thing but reversed
            if (radioButton1.Checked == false)
            {
                Podoboo.Properties.Settings.Default.backup = true;
                Podoboo.Properties.Settings.Default.Save();
            }
            if (radioButton1.Checked)
            {
                Podoboo.Properties.Settings.Default.backup = false;
                Podoboo.Properties.Settings.Default.Save();
            }
        }

        private void Options_Load(object sender, EventArgs e)
        {
            // only show the next button if setup hasn't been completed
            if (Podoboo.Properties.Settings.Default.hasCompletedSetup == false) {
                button4.Visible = true;
            }
            if (Podoboo.Properties.Settings.Default.hasCompletedSetup == true)
            {
                button4.Visible = false;
            }
        }

        private void button4_Click(object sender, EventArgs e)
        {
            // finish setup
            if (Podoboo.Properties.Settings.Default.hasCompletedSetup == false)
            {
                Thread finishSetup = new Thread((ThreadStart)delegate { Application.Run(new Form1()); });
                finishSetup.Start();
                this.Close();
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            Properties.Settings.Default.newItemString = textBox1.Text;
            MessageBox.Show("Restart Podoboo for these changes to take effect.");
        }
    }
}
