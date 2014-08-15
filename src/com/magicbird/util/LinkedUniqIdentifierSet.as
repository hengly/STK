package com.chaosTK.util
{
    import de.polygonal.ds.Collection;
    import de.polygonal.ds.DA;
    import de.polygonal.ds.Deque;
    import de.polygonal.ds.Itr;
    import de.polygonal.ds.LinkedDeque;

    import flash.utils.Dictionary;

    public class LinkedUniqIdentifierSet implements Deque
    {
        private var queue : LinkedDeque = new LinkedDeque();
        private var intMap : Dictionary = new Dictionary();
        private var mapIntFunc : Function;

        public function asLinkedDeque() : LinkedDeque
        {
            return queue;
        }

        public function LinkedUniqIdentifierSet(mapIntFunc : Function)
        {
            this.mapIntFunc = mapIntFunc;
        }

        public function contains(x : Object) : Boolean
        {
            var i : int = mapIntFunc(x);
            var prev : * = intMap[i];
            return (prev != undefined && prev != null);
        }

        public function containsKey(i : int) : Boolean
        {
            var prev : * = intMap[i];
            return (prev != undefined && prev != null);
        }

        public function pushFront(x : Object) : void
        {
            var i : int = mapIntFunc(x);
            var prev : * = intMap[i];
            if (prev == undefined || prev == null)
            {
                intMap[i] = x;
                queue.pushFront(x);
            }
        }

        public function pushBack(x : Object) : void
        {
            var i : int = mapIntFunc(x);
            var prev : * = intMap[i];
            if (prev == undefined || prev == null)
            {
                intMap[i] = x;
                queue.pushBack(x);
            }
        }

        public function popFront() : Object
        {
            var ret : Object = queue.popFront();
            if (ret != null)
            {
                var i : int = mapIntFunc(ret);
                delete intMap[i];
            }
            return ret;
        }

        public function popBack() : Object
        {
            var ret : Object = queue.popBack();
            if (ret != null)
            {
                var i : int = mapIntFunc(ret);
                delete intMap[i];
            }
            return ret;
        }

        public function front() : Object
        {
            return queue.front();
        }

        public function back() : Object
        {
            return queue.back();
        }

        public function clear(purge : Boolean = undefined) : void
        {
            queue.clear(purge);
            intMap = new Dictionary();
        }

        public function clone(assign : Boolean, copier : Object = null) : Collection
        {
            throw new NotImplementedError();
        }

        public function free() : void
        {
            throw new NotImplementedError();
        }

        public function isEmpty() : Boolean
        {
            return false;
        }

        public function iterator() : Itr
        {
            throw new NotImplementedError();
        }

        public function remove(x : Object) : Boolean
        {
            var ret : Boolean = queue.remove(x);
            if (ret)
            {
                var i : int = mapIntFunc(x);
                delete intMap[i];
            }
            return ret;
        }

        public function size() : int
        {
            return queue.size();
        }

        public function toArray() : Array
        {
            return queue.toArray();
        }

        public function toDA() : DA
        {
            return queue.toDA();
        }

        public function toVector() : Vector.<Object>
        {
            return queue.toVector();
        }
    }
}