package com.chaosTK.battle
{
    import com.chaosTK.resource.BattleResMgr;
    import com.chaosTK.script.SArenaGrid;
    import com.chaosTK.script.SArenaSide;
    import com.chaosTK.script.SFighter;
    import com.chaosTK.util.Disposable;
    
    import de.polygonal.ds.Array2;
    
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.geom.ColorTransform;
    import flash.geom.Point;

    public class ArenaSideLayout extends Sprite implements Disposable, SArenaSide
    {
        private var fighters : Array2;
        private var userSide : Boolean;
        private var _locationCaculator : BattleLocationCaculator;
		
        public function ArenaSideLayout(userSide : Boolean, locationCaculator : BattleLocationCaculator)
        {
            fighters = new Array2(BattleResMgr.instance.battleDesc.typeIndexCount, BattleResMgr.instance.battleDesc.gridDimensionY);
            this.userSide = userSide;
            _locationCaculator = locationCaculator;
        }

        private function _setFighter(row : int, typeIndex : int, fighter : Fighter) : int
        {
            var arenaFighter : ArenaGrid = fighters.get(typeIndex, row) as ArenaGrid;
            if (arenaFighter == null)
            {
                arenaFighter = new ArenaGrid();
                fighters.set(typeIndex, row, arenaFighter);
            }
            arenaFighter.addFighter(fighter);
            return arenaFighter.size;
        }

        public function getArenaGrid(row : int, typeIndex : int) : SArenaGrid
        {
            return fighters.get(typeIndex, row) as SArenaGrid;
        }

        public function clearArenaGrid(row : int, typeIndex : int) : void
        {
            fighters.set(typeIndex, row, null);
        }

        override public function removeChild(child : DisplayObject) : DisplayObject
        {
            if (child as Fighter != null)
                trace((child as Fighter).idx + " removed");
            return super.removeChild(child);
        }

        override public function addChild(child : DisplayObject) : DisplayObject
        {
            if (child as Fighter != null)
                trace((child as Fighter).idx + " added");
            return super.addChild(child);
        }

        public function addFighter(row : int, typeIndex : int, _fighter : SFighter) : void
        {
			var fighter : Fighter = _fighter as Fighter;
            var showingFighter : Fighter;
            if (fighter.isGeneral)
            {
                var fighters : ArenaGrid = getArenaGrid(row, typeIndex) as ArenaGrid;
                if (fighters != null && fighters.size > 0)
                {
                    removeChild(fighters.referee);
                }
            }
            var currentCount : int = _setFighter(row, typeIndex, fighter);
            if (currentCount == 1 || fighter.isGeneral)
            {
                var pos : Point = _locationCaculator.toArenaLocation(row, typeIndex);
                fighter.alpha = 1.0;
                fighter.x = pos.x;
                fighter.y = pos.y;
                addChild(fighter);
                fighter.play("idle");
                showingFighter = fighter;
				showingFighter.removeColorMask();
            }
            else
            {
                showingFighter = (getArenaGrid(row, typeIndex) as ArenaGrid).referee;
            }
            showingFighter.showTextInfo((currentCount).toString());
        }

		public function dispose():void
		{
			fighters.clear(true);
			_locationCaculator = null;
			if(parent != null)
			{
				parent.removeChild(this);
			}
		}
    }
}


