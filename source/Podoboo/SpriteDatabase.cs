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
        int index = 0;
        List<string> list = new List<string>();
        string directory = Settings.Default.installDirectory;
        public SpriteDatabase()
        {
            InitializeComponent();
        }

        private void SpriteDatabase_Load(object sender, EventArgs e)
        {
            foreach (string s in Directory.GetFiles(directory, "*.cfg", SearchOption.AllDirectories))
            {
                list.Add(s.Remove(0, s.LastIndexOf(Path.DirectorySeparatorChar) + 1));
                textBox1.Text += list[index].ToString() + "\r\n";
                index += 1;
            }
        }
    }
}
