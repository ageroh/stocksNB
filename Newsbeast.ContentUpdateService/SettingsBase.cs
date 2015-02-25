using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.ComponentModel;
using System.Reflection;
using System.Configuration;

namespace Newsbeast.ContentUpdateService
{
    internal class SettingsBase
    {
        public SettingsBase()
        {
            string name = base.GetType().Name;
            PropertyInfo[] properties = base.GetType().GetProperties();
            for (int i = 0; i < properties.Length; i++)
            {
                PropertyInfo propertyInfo = properties[i];
                if (propertyInfo.CanWrite)
                {
                    string name2 = string.Format("{0}.{1}", name, propertyInfo.Name);
                    string value = ConfigurationManager.AppSettings[name2];
                    if (!string.IsNullOrEmpty(value))
                    {
                        propertyInfo.SetValue(this, this.ConvertValue(value, propertyInfo.PropertyType), null);
                    }
                }
            }
        }

        private object ConvertValue(string Value, Type type)
        {
            TypeConverter converter = TypeDescriptor.GetConverter(type);
            object result;
            try
            {
                result = converter.ConvertFrom(Value);
            }
            catch (Exception ex)
            {
                throw new FormatException(string.Format("Input (({1})[{0}]) could not be converted to ({3}): {2}", new object[]
				{
					Value,
					Value.GetType().Name,
					ex.Message,
					type.Name
				}), ex);
            }
            return result;
        }
    }

}
