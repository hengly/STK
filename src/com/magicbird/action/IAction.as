package com.chaosTK.action
{
    public interface IAction
    {
        function start() : void;

        function tick(timeInMills : Number) : Boolean;

        function end() : void;
    }
}