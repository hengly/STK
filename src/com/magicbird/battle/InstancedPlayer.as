package com.chaosTK.battle
{
    import com.chaosTK.game.AvailFighterContainer;
    import com.chaosTK.resource.BattleDesc;
    import com.chaosTK.resource.BattleResMgr;
    import com.chaosTK.resource.FighterInfo;
    import com.chaosTK.script.SFighterInfo;
    import com.chaosTK.script.SInstancedPlayer;
    import com.chaosTK.util.Random;

    public class InstancedPlayer implements SInstancedPlayer
    {
        private var _wippedIndexedSolder : Vector.<ColoredFighterInfo>;
        private var _wippedIndexedGeneral : Vector.<ColoredFighterInfo>;
        private var propOfGeneral : Number;
        private var _isPlayerSide : Boolean;
        private var _life : int;
		private var _player : AvailFighterContainer;
		
		public function get life() : int
		{
			return _life;
		}
		
		public function get availFighter() : Vector.<SFighterInfo>
		{
			return Vector.<SFighterInfo>(_player.availFighters);
		}
		
        public function InstancedPlayer(player : AvailFighterContainer, isPlayerSide : Boolean, propOfGeneral : Number)
        {
            var battleDesc : BattleDesc = BattleResMgr.instance.battleDesc;
            _isPlayerSide = isPlayerSide;
            _wippedIndexedSolder = new Vector.<ColoredFighterInfo>(battleDesc.colorCount * battleDesc.typeIndexCount);
            _wippedIndexedGeneral = new Vector.<ColoredFighterInfo>(battleDesc.colorCount * battleDesc.typeIndexCount);
            this.propOfGeneral = propOfGeneral;
            _life = player.life;
            for each (var fighterInfo : FighterInfo in player.availFighters)
            {
                for (var colorIndex : int = 0; colorIndex < battleDesc.colorCount; colorIndex++)
                {
                    var i : int = fighterInfo.typeIndex + (colorIndex * battleDesc.typeIndexCount);
                    if (fighterInfo.isGeneral)
                    {
                        _wippedIndexedGeneral[i] = new ColoredFighterInfo(colorIndex, fighterInfo);
                    }
                    else
                    {
                        _wippedIndexedSolder[i] = new ColoredFighterInfo(colorIndex, fighterInfo);
                    }
                }
            }
        }

        public function onDamage(damage : int) : Boolean
        {
            _life -= damage;
            trace((isPlayerSide ? "playerSide" : "otherSide") + " is attacked by " + damage + " new life is:" + _life);
            return _life > 0;
        }

        public function get isPlayerSide() : Boolean
        {
            return _isPlayerSide;
        }

        public function createFighter(wippedIndex : int) : Fighter
        {
            var isGeneral : Boolean = Random.nextBoolean(propOfGeneral);
            if (isGeneral && _wippedIndexedGeneral[wippedIndex] != null)
            {
                return new Fighter(_wippedIndexedGeneral[wippedIndex].fighterInfo, _wippedIndexedGeneral[wippedIndex].color, !_isPlayerSide);
            }
            else
            {
                return new Fighter(_wippedIndexedSolder[wippedIndex].fighterInfo, _wippedIndexedSolder[wippedIndex].color, !_isPlayerSide);
            }
        }
    }
}
import com.chaosTK.resource.FighterInfo;

class ColoredFighterInfo
{
    public var color : int;
    public var fighterInfo : FighterInfo;

    public function ColoredFighterInfo(color : int, fighterInfo : FighterInfo)
    {
        this.color = color;
        this.fighterInfo = fighterInfo;
    }
}