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

        /// PDBSP sprite packages
        private void ImportSprites_Load(object sender, EventArgs e)
        {

        }
        /// PDBSP reads line 1 as the Spritetool to use. @rs is Romi's ST, @px is PIXI, @ow is Overworld ST, and @ct is Cluster ST.
        private void radioButton1_CheckedChanged(object sender, EventArgs e)
        {
            if (radioButton1.Checked)
            {

            }
        }

        private void radioButton2_CheckedChanged(object sender, EventArgs e)
        {
            if (radioButton2.Checked) {

            }
        }

        private void radioButton3_CheckedChanged(object sender, EventArgs e)
        {
            if (radioButton3.Checked)
            {

            }
        }

        private void radioButton4_CheckedChanged(object sender, EventArgs e)
        {
            if (radioButton4.Checked)
            {

            }
        }


        private void radioButton5_CheckedChanged(object sender, EventArgs e)
        {
           if (radioButton5.Checked)
            {

            }
        }

        private void radioButton6_CheckedChanged(object sender, EventArgs e)
        {
            if (radioButton6.Checked)
            {

            }
        }

        private void radioButton7_CheckedChanged(object sender, EventArgs e)
        {
            if (radioButton7.Checked)
            {

            }
        }

    }
}
