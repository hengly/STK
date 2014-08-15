package com.chaosTK.action
{
    import de.polygonal.ds.Itr;
    import de.polygonal.ds.LinkedDeque;

    public class ParalellAction implements IAction
    {
        private var list : LinkedDeque = new LinkedDeque();

        public function register(...parameters) : ParalellAction
        {
            for each (var i : IAction in parameters)
            {
                list.pushBack(i);
            }
            return this;
        }

        public function start() : void
        {
            var itr : Itr = list.iterator();
            while (itr.hasNext())
            {
                (itr.next() as IAction).start();
            }
        }

        public function tick(timeInMills : Number) : Boolean
        {
            var itr : Itr = list.iterator();
            while (itr.hasNext())
            {
                var current : IAction = (itr.next() as IAction);
                if (!current.tick(timeInMills))
                {
                    itr.remove();
                }
            }
            return (list.size() > 0);
        }

        public function end() : void
        {
        }
    }
}