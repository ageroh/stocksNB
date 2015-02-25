using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NLog;
using System.Threading;

namespace Newsbeast.ContentUpdateService
{
    public abstract class RecurringTask : ITask
    {
        private Thread LoopThread;
        private bool started;
        private Logger _Log;
        protected Logger Log
        {
            get
            {
                return this._Log;
            }
        }
        protected abstract int Interval
        {
            get;
        }
        public RecurringTask()
        {
            this._Log = LogManager.GetLogger(base.GetType().Name);
        }
        public void Start()
        {
            this.LoopThread = new Thread(new ParameterizedThreadStart(this.Loop));
            this.started = true;
            this.LoopThread.IsBackground = true;
            this.LoopThread.Start();
        }
        private void Loop(object args)
        {
            while (this.started)
            {
                try
                {
                    DateTime now = DateTime.Now;
                    this.Log.Trace("Task started: " + this.Log.Name);
                    this.ExecuteTask();
                    this.Log.Trace(string.Format("Task executed successfully in {0} ms: {1}", DateTime.Now.Subtract(now).TotalMilliseconds, this.Log.Name));
                }
                catch (Exception arg)
                {
                    this.Log.Fatal(string.Format("Exception on execute task {0}: {1}", this.Log.Name, arg));
                }
                Thread.Sleep(this.Interval);
            }
        }

        protected abstract void ExecuteTask();
        public void Stop()
        {
            this.started = false;
            this.LoopThread.Abort();
            this.LoopThread.Join();
            this.LoopThread = null;
        }
    }
}
