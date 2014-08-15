package com.chaosTK.battle.controller
{
    import com.chaosTK.battle.Fighter;
    import com.chaosTK.battle.InstancedPlayer;
    import com.chaosTK.battle.LocaledFighter;

    import flash.events.MouseEvent;
    import flash.geom.Point;

    public class UserBattleSideController extends BattleSideController
    {
        private var selected : LocaledFighter;
        private var current : LocaledFighter;

        public function UserBattleSideController(instancedPlayer : InstancedPlayer)
        {
            super(instancedPlayer);
        }

        override public function start() : void
        {
            super.start();
            _battle.battleScene.addEventListener(MouseEvent.CLICK, onClicked, true);
        }

        override public function dispose() : void
        {
            super.dispose();
            _battle.battleScene.removeEventListener(MouseEvent.CLICK, onClicked, true);
        }

        private function onClicked(e : MouseEvent) : void
        {
            var pos : Point = _battleSide.locationCaculator.toGridLocation(_battle.battleScene.mouseX, _battle.battleScene.mouseY);
            if (pos == null)
            {
                trace("click out of bound");
                return;
            }
            trace("click pos:" + pos.x + "," + pos.y);
            var fighter : Fighter = _battleSide.fighterLayout.getFighter(pos.x, pos.y);
            current = new LocaledFighter(fighter, pos.x, pos.y);
            if (selected == null)
            {
                selected = current;
                return;
            }
            if (Math.abs(current.battleX - selected.battleX) + Math.abs(current.battleY - selected.battleY) != 1)
            {
                selected = current;
                return;
            }
            operate();
        }

        override protected function doOperate() : void
        {
            _battleSide.move(selected.battleX, selected.battleY, current.battleX, current.battleY);
            selected = null;
        }
    }
}