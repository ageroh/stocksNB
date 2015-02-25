using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using Newsbeast.ContentUpdateService.Newspapers;

namespace Newsbeast.ContentUpdateService
{
    public partial class Service : ServiceBase
    {
        private IContainer components;
        private List<ITask> Tasks = new List<ITask>();

        protected override void Dispose(bool disposing)
        {
            if (disposing && this.components != null)
            {
                this.components.Dispose();
            }
            base.Dispose(disposing);
        }

        private void InitializeComponent()
        {
            this.components = new Container();
            base.ServiceName = "Service1";
        }

        public Service()
        {
            this.Tasks.Add(new NewspapersService());
            this.InitializeComponent();
        }
        public void Start()
        {
            this.OnStart(new string[0]);
        }
        protected override void OnStart(string[] args)
        {
            foreach (ITask current in this.Tasks)
            {
                current.Start();
            }
        }

        protected override void OnStop()
        {
            foreach (ITask current in this.Tasks)
            {
                current.Stop();
            }
        }
    }
}
