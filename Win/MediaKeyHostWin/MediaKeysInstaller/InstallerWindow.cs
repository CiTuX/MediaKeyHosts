using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

using Microsoft.Win32;
using System.IO;

namespace WindowsFormsApplication1
{
    public partial class InstallerWindow : Form
    {
        public InstallerWindow()
        {
            InitializeComponent();
        }
        bool installed = false;
        private void button1_Click(object sender, EventArgs e)
        {
            if (installed)
            {
                Application.Exit();
                return;
            }

            string folder = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData), "Swayfm");
            System.IO.Directory.CreateDirectory(folder);
            CopyFile("MediaKeyHostWin.exe", folder);
            CopyFile("fm.sway.mediakeys.json", folder);

            RegistryKey key = Registry.CurrentUser.OpenSubKey("Software\\Google\\Chrome\\NativeMessagingHosts\\fm.sway.mediakeys", true);
            key.SetValue("", Path.Combine(folder, "fm.sway.mediakeys.json"));
            label1.Text = "You're all set!";
            installButton.Text = "Quit";
            installed = true;
        }

        public static void CopyFile(string filename, string folder)
        {
            System.Reflection.Assembly assembly = System.Reflection.Assembly.GetExecutingAssembly();
            string executablePath = Path.Combine(folder, filename);
            string resource = @"MediaKeysInstaller.Payload." + filename;
            using (Stream executableStream = assembly.GetManifestResourceStream(resource))
            using (Stream output = File.Create(executablePath))
            {
                CopyStream(executableStream, output);
            }
        }

        public static void CopyStream(Stream input, Stream output)
        {
            // Insert null checking here for production
            byte[] buffer = new byte[8192];

            int bytesRead;
            while ((bytesRead = input.Read(buffer, 0, buffer.Length)) > 0)
            {
                output.Write(buffer, 0, bytesRead);
            }
        }
    }


}
