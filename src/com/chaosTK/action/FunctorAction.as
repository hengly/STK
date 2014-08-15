package com.chaosTK.action
{
    public class FunctorAction implements IAction
    {
        private var func : Function;
        private var params : Array = new Array();

        public function FunctorAction(func : Function, ...params)
        {
            this.func = func;
            this.params = params;
        }

        public function start() : void
        {
            func(params);
        }

        public function tick(timeInMills : Number) : Boolean
        {
            return false;
        }

        public function end() : void
        {
        }
    }
}