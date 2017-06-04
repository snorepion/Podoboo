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

        private void button1_Click(object sender, EventArgs e)
        {
            OpenFileDialog importSprites = new OpenFileDialog();
            importSprites.Filter = "Assembly sprites|*.asm|Sprite configuration files|*.cfg|All files|*.*";
            importSprites.Multiselect = true;
            importSprites.FileName = "Sprite.asm";
            importSprites.Title = "Import Sprites";
            
        }

        private void button3_Click(object sender, EventArgs e)
        {
            Thread database = new Thread((ThreadStart)delegate { Application.Run(new SpriteDatabase()); });
            database.TrySetApartmentState(ApartmentState.STA);
            database.Start();
        }
    }
}
