package com.chaosTK.action
{
    import de.polygonal.ds.LinkedDeque;

    public class SequenceAction implements IAction
    {
        private var list : LinkedDeque = new LinkedDeque();

        public function register(...parameters) : SequenceAction
        {
            for each (var i : IAction in parameters)
            {
                list.pushBack(i);
            }
            return this;
        }

        public function start() : void
        {
            (list.front() as IAction).start();
        }

        public function tick(timeInMills : Number) : Boolean
        {
            var current : IAction = list.front() as IAction;
            var shouldContinue : Boolean = current.tick(timeInMills);
            if (!shouldContinue)
            {
                list.popFront();
                if (list.size() == 0)
                {
                    return false;
                }
                (list.front() as IAction).start();
            }
            return true;
        }

        public function end() : void
        {
        }
    }
}