package 
{
	import flash.events.Event;
	import flash.display.Sprite;
	
	public class Rope extends Sprite
	{
		private var line : Line = new Line(100, 100, 300, 300); 
		public function Rope()
		{
			addEventListener(Event.ENTER_FRAME, onFrame);
			addChild(line);
		}
		
		public function onFrame(event : Event) : void
		{
			line.update();
		}
	}
}

import flash.display.Shape;

class Line extends Shape
{
	public var points : Vector.<LinePoint>;
	public var constraints : Vector.<LineConstraint>;
	
	public function Line(startX : Number, startY : Number, endX : Number, endY : Number)
	{
		var len : int = 60;
		points = new Vector.<LinePoint>(len);
		var dx : Number = (endX - startX) / len;
		var dy : Number = (endY - startY) / len;
		var dxLen : Number = Math.sqrt(dx * dx + dy * dy);
		var curX : Number = startX;
		var curY : Number = startY;
		for(var i : int = 0; i < points.length; i++)
		{
			points[i] = new LinePoint(curX, curY);
			curX += dx;
			curY += dy;
		}
		points[0].isAnchored = true;
		points[0].anchorX = startX;
		points[0].anchorY = startY;
		points[len-1].isAnchored = true;
		points[len-1].anchorX = 240;
		points[len-1].anchorY = 240;
		constraints = new Vector.<LineConstraint>(len-1);
		for(i = 0; i < constraints.length; i++)
		{
			constraints[i] = new LineConstraint(points[i], points[i+1], dxLen);
		}
	}
	
	public var v : Number = 0;
	public var vMax : Number = 0.5;
	public var a : Number = 0.05;
	public var deltaA : Number = 0.01;
	public function update() : void
	{
		points[0].y += 0.4;
		points[0].update();
		for(var i : int = 1; i < points.length; i++)
		{
			points[i].y += (i == 10 ?  v : 0.4);
			points[i].update();
			constraints[i-1].update();
		}
		v += a;
		var nextA : Number = a - deltaA;
		if(v > vMax)
		{
			a = 0;
			deltaA = 0.01;
		}
		else if(v < -vMax)
		{
			a = 0;
			deltaA = -0.01;
		}
		a = nextA;
		
		for(var j : int = 0; j < 11; j++)
		{
			for(i = 0; i < constraints.length; i++)
			{
				constraints[i].update();
			}	
		}
		
		graphics.clear();
		graphics.lineStyle(1,0x999999,1,false,"normal","round","round");
		graphics.moveTo(constraints[0].p1.x, constraints[0].p1.y);				
		for(i = 0; i < constraints.length; i++)
		{
			graphics.lineTo(constraints[i].p2.x, constraints[i].p2.y);	
		}
	}
}

class LinePoint
{
	public var x : Number;
	public var y : Number;
	
	public var oldX : Number;
	public var oldY : Number;
	
	public var anchorX : Number;
	public var anchorY : Number;
	
	public var isAnchored : Boolean;
	
	public function LinePoint(x : Number, y : Number) 
	{
		this.x = x;
		this.y = y;
		oldX = x;
		oldY = y;
	}
	
	public function update() : void
	{
		if(!isAnchored)
		{
			var vx : Number = (x - oldX) ;
			var vy : Number = (y - oldY) ;
			oldX = x;
			oldY = y;
			x += vx;
			y += vy;
		}
		else
		{
			x = anchorX;
			y = anchorY;
		}
	}
}

class LineConstraint
{
	public var p1 : LinePoint;
	public var p2 : LinePoint;
	public var len : Number;
	
	public function LineConstraint(p1 : LinePoint, p2 : LinePoint, len : Number)
	{
		this.p1 = p1;
		this.p2 = p2;
		this.len = len;
	}
	
	public function update() : void
	{
		var dx : Number = p1.x - p2.x;
		var dy : Number = p1.y - p2.y;
		var curLen : Number = Math.sqrt(dx*dx + dy*dy);
		var diff : Number = curLen - len;
		var offsetX : Number = (diff / (2 *curLen)) * dx;
		var offsetY : Number = (diff / (2 * curLen)) * dy;
		
		p1.x = p1.x - offsetX;
		p1.y = p1.y - offsetY;
		
		p2.x = p2.x + offsetX;
		p2.y = p2.y + offsetY;
	}
}