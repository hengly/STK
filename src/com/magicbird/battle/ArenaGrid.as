package com.chaosTK.battle
{
    import com.chaosTK.script.SArenaGrid;
    import com.chaosTK.script.SFighter;
    
    import de.polygonal.ds.LinkedDeque;

    public class ArenaGrid implements SArenaGrid
    {
        private var _life : int;
        [TypeHint(Fighter)]
        public var fighters : LinkedDeque = new LinkedDeque();
        private var _maxLife : int;
        private var _atk : int;
        private var _def : Number;
        private var _speed : int;
		
		public function get commander() : SFighter
		{
			return referee;
		}
		
		public function get speed():int
		{
			return _speed;
		}

		public function set speed(value:int):void
		{
			_speed = value;
		}

		public function get def():Number
		{
			return _def;
		}

		public function set def(value:Number):void
		{
			_def = value;
		}

		public function get atk():int
		{
			return _atk;
		}

		public function set atk(value:int):void
		{
			_atk = value;
		}

		public function get maxLife():int
		{
			return _maxLife;
		}

		public function set maxLife(value:int):void
		{
			_maxLife = value;
		}

		public function get life():int
		{
			return _life;
		}

		public function set life(value:int):void
		{
			_life = value;
		}

        public function containsFighter() : Boolean
        {
            return fighters.size() > 0;
        }

        public function get size() : int
        {
            return fighters.size();
        }

        public function addFighter(fighter : Fighter) : void
        {
            if (fighter.isGeneral || fighters.size() == 0)
            {
                fighters.pushFront(fighter);
                def = fighter.fighterConfig.def;
            }
            else
            {
                fighters.pushBack(fighter);
            }
            life += fighter.fighterConfig.life;
            maxLife += fighter.fighterConfig.life;
            atk += fighter.fighterConfig.atk;
            speed += fighter.fighterConfig.speed;
        }

        public function get referee() : Fighter
        {
            if (fighters.size() == 0)
            {
                return null;
            }
            return fighters.front() as Fighter;
        }

        private function clear() : void
        {
            life = 0;
            atk = 0;
            def = 0;
            speed = 0;
            fighters.clear(true);
        }

        public function onDamage(damage : int) : int
        {
            var ret : int = 0;
            life -= damage;
            if (life <= 0)
            {
                ret = fighters.size();
                clear();
                return ret;
            }
            var fighter : Fighter;

            while (fighters.size() > 0 && (fighter = fighters.front() as Fighter).fighterConfig.life < maxLife - life)
            {
                ret += 1;
                fighters.popFront();
                maxLife -= fighter.fighterConfig.life;
                atk -= fighter.fighterConfig.atk;
                speed -= fighter.fighterConfig.speed;
            }
            def = referee.fighterConfig.def;
            return ret;
        }
    }
}
