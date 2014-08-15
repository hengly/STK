package com.chaosTK.resource
{
    public class ObjectSerialable
    {
        public function ObjectSerialable(obj : Object)
        {
            for (var propName : String in obj)
            {
                this[propName] = obj[propName];
            }
        }
    }
}
