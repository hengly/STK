package com.chaosTK.battle
{
    import com.chaosTK.resource.BattleResMgr;
    import com.chaosTK.resource.BattleDesc;
    import com.chaosTK.battle.events.SetFighterEvent;
    import com.chaosTK.util.assert;
    import com.chaosTK.battle.events.GapDetectedEvent;
    import com.chaosTK.battle.events.RemovalDetectEvent;
    import com.chaosTK.util.Random;

    import de.polygonal.ds.Array2;
    import de.polygonal.ds.Deque;
    import de.polygonal.ds.Itr;
    import de.polygonal.ds.LinkedDeque;

    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;

    public class FightersLayout extends EventDispatcher
    {
        private var fighters : Array2;
        private var instancedPlayer : InstancedPlayer;
        private var battle : Battle;

        public function FightersLayout(instancePlayer : InstancedPlayer, battle : Battle)
        {
            this.battle = battle;
            var battleDesc : BattleDesc = BattleResMgr.instance.battleDesc;
            fighters = new Array2(battleDesc.gridDimensionX, battleDesc.gridDimensionY);
            this.instancedPlayer = instancePlayer;
        }

        public function getFighter(x : int, y : int) : Fighter
        {
            return fighters.get(x, y) as Fighter;
        }

        public function setFighter(x : int, y : int, v : Fighter) : void
        {
            fighters.set(x, y, v);
            dispatchEvent(new SetFighterEvent(x, y, v));
        }

        private function fillTopRows(availLen : int, row : Array, iz : Array) : void
        {
            var i1 : int = Random.nextInt(availLen);
            iz[0] = i1;
            row[0] = instancedPlayer.createFighter(i1);
            var i2 : int = Random.nextInt(availLen);
            iz[1] = i2;
            row[1] = instancedPlayer.createFighter(i2);
            var i : int;
            for (i = 2; i < row.length; i++)
            {
                var idx : int;
                if (i1 == i2)
                {
                    do
                    {
                        idx = Random.nextInt(availLen);
                    }
                    while (i1 == idx);
                    i2 = idx;
                }
                else
                {
                    idx = Random.nextInt(availLen);
                    i1 = i2;
                    i2 = idx;
                }
                iz[i] = idx;
                row[i] = instancedPlayer.createFighter(idx);
            }
        }

        private function fillContentRows(availLen : int, row : Array, iz1 : Array, iz2 : Array) : void
        {
            var idx : int;
            var i1 : int;
            var i2 : int;
            if (iz1[0] == iz2[0])
            {
                do
                {
                    idx = Random.nextInt(availLen);
                }
                while (iz2[0] == idx);
            }
            else
            {
                idx = Random.nextInt(availLen);
                iz1[0] = iz2[0];
            }
            iz2[0] = idx;
            i1 = idx;
            row[0] = instancedPlayer.createFighter(idx);

            if (iz1[1] == iz2[1])
            {
                do
                {
                    idx = Random.nextInt(availLen);
                }
                while (iz2[1] == idx);
            }
            else
            {
                idx = Random.nextInt(availLen);
                iz1[1] = iz2[1];
            }
            iz2[1] = idx;
            i2 = idx;
            row[1] = instancedPlayer.createFighter(idx);

            for (var i : int = 2; i < row.length; i++)
            {
                if (i1 == i2)
                {
                    if (iz1[i] == iz2[i])
                    {
                        do
                        {
                            idx = Random.nextInt(availLen);
                        }
                        while (iz2[i] == idx || i2 == idx);
                    }
                    else
                    {
                        do
                        {
                            idx = Random.nextInt(availLen);
                        }
                        while (i2 == idx);
                        iz1[i] = iz2[i];
                    }
                    iz2[i] = idx;
                    i2 = idx;
                }
                else
                {
                    if (iz1[i] == iz2[i])
                    {
                        do
                        {
                            idx = Random.nextInt(availLen);
                        }
                        while (iz2[i] == idx);
                    }
                    else
                    {
                        idx = Random.nextInt(availLen);
                        iz1[i] = iz2[i];
                    }
                    iz2[i] = idx;
                    i1 = i2;
                    i2 = idx;
                }
                row[i] = instancedPlayer.createFighter(idx);
            }
        }

        public function fill() : void
        {
            var availLen : int = BattleResMgr.instance.battleDesc.wippedIndexCount;
            var i1s : Array = new Array(fighters.getW());
            var i2s : Array = new Array(fighters.getW());

            var row : Array = new Array(fighters.getW());
            fillTopRows(availLen, row, i1s);
            fighters.setRow(0, row);

            fillTopRows(availLen, row, i2s);
            fighters.setRow(1, row);

            for (var i : int = 2; i < fighters.getH(); i++)
            {
                fillContentRows(availLen, row, i1s, i2s);
                fighters.setRow(i, row);
            }
        }

        public function isValidPlacing(x : int, y : int, type : int) : Boolean
        {
            var start : int = y - 1;
            var fighter : Fighter;
            while (start >= 0 && (( fighter = (fighters.get(x, start) as Fighter)) != null && fighter.wipeOffIdentifier == type))
            {
                start -= 1;
            }
            start += 1;

            var end : int = y + 1;
            while (end < fighters.getH() && ((fighter = (fighters.get(x, end) as Fighter)) != null && fighter.wipeOffIdentifier == type))
            {
                end += 1;
            }
            if (end - start > 2)
            {
                return false;
            }
            start = x - 1;
            while (start >= 0 && ((fighter = (fighters.get(start, y) as Fighter)) != null && fighter.wipeOffIdentifier == type))
            {
                start -= 1;
            }
            start += 1;

            end = x + 1;
            while (end < fighters.getW() && ((fighter = (fighters.get(end, y) as Fighter)) != null && fighter.wipeOffIdentifier == type))
            {
                end += 1;
            }
            return (end - start <= 2);
        }

        public function tryMergeVertical(x : int, y : int, list : Deque, addSelf : Boolean = false) : Boolean
        {
            var cur : Fighter = fighters.get(x, y) as Fighter;
            var start : int = y - 1;
            while (start >= 0 && ((fighters.get(x, start) as Fighter).wipeOffIdentifier == cur.wipeOffIdentifier))
            {
                start -= 1;
            }
            start += 1;

            var end : int = y + 1;
            while (end < fighters.getH() && ((fighters.get(x, end) as Fighter).wipeOffIdentifier == cur.wipeOffIdentifier))
            {
                end += 1;
            }
            if (end - start > 2)
            {
                for (var i : int = start; i < y; i++)
                {
                    trace("vertical up:(" + x + "," + i + ")");
                    list.pushBack(new LocaledFighter(fighters.get(x, i) as Fighter, x, i));
                }
                if (addSelf)
                {
                    list.pushBack(new LocaledFighter(cur, i, y));
                }
                for (i = y + 1; i < end; i++)
                {
                    trace("vertical down:(" + x + "," + i + ")");
                    list.pushBack(new LocaledFighter(fighters.get(x, i) as Fighter, x, i));
                }
                return true;
            }
            return false;
        }

        public function tryMergeHorizontal(x : int, y : int, list : Deque, addSelf : Boolean = false) : Boolean
        {
            var cur : Fighter = fighters.get(x, y) as Fighter;
            var start : int = x - 1;
            while (start >= 0 && ((fighters.get(start, y) as Fighter).wipeOffIdentifier == cur.wipeOffIdentifier))
            {
                start -= 1;
            }
            start += 1;

            var end : int = x + 1;
            while (end < fighters.getW() && ((fighters.get(end, y) as Fighter).wipeOffIdentifier == cur.wipeOffIdentifier))
            {
                end += 1;
            }
            if (end - start > 2)
            {
                for (var i : int = start; i < x; i++)
                {
                    trace("horizontal left:(" + i + "," + y + ")");
                    list.pushBack(new LocaledFighter(fighters.get(i, y) as Fighter, i, y));
                }
                if (addSelf)
                {
                    list.pushBack(new LocaledFighter(cur, x, y));
                }
                for (i = x + 1; i < end; i++)
                {
                    trace("horizontal right:(" + i + "," + y + ")");
                    list.pushBack(new LocaledFighter(fighters.get(i, y) as Fighter, i, y));
                }
                return true;
            }
            return false;
        }

        public function tryMergeAtPos(x : int, y : int, list : Deque) : void
        {
            var ret1 : Boolean = tryMergeVertical(x, y, list);
            var ret2 : Boolean = tryMergeHorizontal(x, y, list);
            if (ret1 || ret2)
            {
                trace("self:(" + x + "," + y + ")");
                list.pushBack(new LocaledFighter(fighters.get(x, y) as Fighter, x, y));
            }
        }

        public function swap(x1 : int, y1 : int, x2 : int, y2 : int) : void
        {
            var first : Fighter = fighters.get(x1, y1) as Fighter;
            var second : Fighter = fighters.get(x2, y2) as Fighter;

            assert(first != null && second != null);

            setFighter(x1, y1, second);
            setFighter(x2, y2, first);
            if (first.wipeOffIdentifier == second.wipeOffIdentifier)
            {
                return;
            }
            var mergeGroup : LinkedDeque = new LinkedDeque();
            tryMergeAtPos(x1, y1, mergeGroup);
            tryMergeAtPos(x2, y2, mergeGroup);
            if (mergeGroup.size() > 0)
            {
                dispatchEvent(new RemovalDetectEvent(mergeGroup));
            }
        }

        public function remove(removalList : LinkedDeque) : void
        {
            var gapInfo : GapInfo;
            var fighter : LocaledFighter;
            var rowToGapInfo : Dictionary = new Dictionary();
            var itr : Itr = removalList.iterator();
            while (itr.hasNext())
            {
                fighter = (itr.next() as LocaledFighter);
                setFighter(fighter.battleX, fighter.battleY, null);
                gapInfo = rowToGapInfo[fighter.battleY] as GapInfo;
                if (gapInfo == null)
                {
                    gapInfo = new GapInfo();
                    gapInfo.idx = fighter.battleX - 1;
                    rowToGapInfo[fighter.battleY] = gapInfo;
                }
                else
                {
                    gapInfo.idx = Math.max(gapInfo.idx, fighter.battleX - 1);
                }
                gapInfo.movalGrid += 1;
            }
            for (var idxRow : * in rowToGapInfo)
            {
                gapInfo = rowToGapInfo[idxRow] as GapInfo;
                var moveStep : int = 1;
                while (gapInfo.idx >= 0 && (fighters.get(gapInfo.idx, idxRow) == null))
                {
                    gapInfo.idx -= 1;
                    moveStep += 1;
                }
                var idxCol : int = gapInfo.idx;
                while (idxCol >= 0)
                {
                    gapInfo.movalInfo.pushBack(new GapRow(idxCol, moveStep));
                    idxCol -= 1;
                    while (idxCol >= 0 && (fighters.get(idxCol, idxRow) == null))
                    {
                        moveStep += 1;
                        idxCol -= 1;
                    }
                }
            }
            dispatchEvent(new GapDetectedEvent(rowToGapInfo));
        }

        public function foreach(func : Function) : void
        {
            fighters.walk(func);
        }
    }
}