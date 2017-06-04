using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;
using Podoboo.Properties;

namespace Podoboo
{
    public partial class SpriteDatabase : Form
    {
        string[] sprites;
        string directory = Settings.Default.installDirectory;
        public SpriteDatabase()
        {
            InitializeComponent();
        }

        private void SpriteDatabase_Load(object sender, EventArgs e)
        {
            sprites = Directory.GetFiles(directory, "*.cfg", SearchOption.AllDirectories); 
            textBox1.Text = string.Join("", sprites);
        }
    }
}
