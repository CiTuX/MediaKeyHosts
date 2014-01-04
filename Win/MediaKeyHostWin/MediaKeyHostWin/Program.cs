using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;



namespace MediaKeyHostWin
{
    public partial class Form1 : Form
    {
        System.IO.Stream stdout;

        [DllImport("user32.dll")]
        public static extern bool RegisterHotKey(IntPtr hWnd, int id, int fsModifiers, int vlc);
        public Form1()
        {
            RegisterHotKey(this.Handle, 0, 0, 0xB3); // PlayPause
            RegisterHotKey(this.Handle, 1, 0, 0xB0); // Next
            RegisterHotKey(this.Handle, 2, 0, 0xB1); // Previous
            BeginInvoke(new MethodInvoker(delegate
            {
                this.Visible = false;
            }));
            stdout = Console.OpenStandardOutput();
        }

        public void SendMessage(string msg)
        {
            System.Text.ASCIIEncoding encoding = new System.Text.ASCIIEncoding();
            String json = "{action:\"" + msg + "\"}";
            Byte[] bytes = encoding.GetBytes(json);
            Int32 len = bytes.Length;
            byte[] lengthBytes = BitConverter.GetBytes(len);
            Debug.WriteLine("Length " + lengthBytes.Length);
            stdout.Write(lengthBytes, 0, lengthBytes.Length);
            stdout.Write(bytes, 0, bytes.Length);
        }

        protected override void WndProc(ref Message msg)
        {
            if (msg.Msg == 0x0312)
            {
                int id = msg.WParam.ToInt32();
                if (id == 0)
                {
                    // pause
                    Debug.WriteLine("PAUSE");
                    SendMessage("play");
                    return;
                }
                else if (id == 1)
                {
                    // next
                    SendMessage("next");
                    return;
                }
                else if (id == 2)
                {
                    // previous
                    SendMessage("back");
                    return;
                }
            }
            base.WndProc(ref msg);
        }
    }

    class Program
    {
        static void Main(string[] args)
        {
            Form1 form = new Form1();
            form.SendMessage("ack");
            System.Windows.Forms.Application.Run(form);
        }


    }
}