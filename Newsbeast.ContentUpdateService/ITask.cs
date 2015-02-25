using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Newsbeast.ContentUpdateService
{
    public interface ITask
    {
        // Methods
        void Start();
        void Stop();
    }

}
