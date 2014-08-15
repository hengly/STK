package com.chaosTK.battle.controller
{
    import com.chaosTK.battle.controller.BaseAIBattleSideController;
    import com.chaosTK.battle.InstancedPlayer;
    import com.chaosTK.util.Random;

    public class SimplestAiBattleSideController extends BaseAIBattleSideController
    {
        public function SimplestAiBattleSideController(instancedPlayer : InstancedPlayer)
        {
            super(instancedPlayer);
        }

        override protected function doOperate() : void
        {
            var i : int;
            var j : int;
            for (i = 0; i < w - 1; i++)
            {
                for (j = 0; j < h - 1; j++)
                {
                    if (tryMove(i, j, true) || tryMove(i, j, false))
                    {
                        return;
                    }
                }
            }
            j = h - 1;
            for (i = 0; i < w - 1; i++)
            {
                if (tryMove(i, j, false))
                {
                    return;
                }
            }
            i = w - 1;
            for (j = 0; j < h - 1; j++)
            {
                if (tryMove(i, j, true))
                {
                    return;
                }
            }
            var x : int = Random.nextInt(w - 1) + 1;
            var y : int = Random.nextInt(h);
            _battleSide.move(x, y, x - 1, y);
        }
    }
}
