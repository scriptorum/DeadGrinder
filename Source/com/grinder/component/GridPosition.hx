package com.grinder.component;

import com.scriptorum.Util;

class GridPosition
{
	public var x:Int = 0;
	public var y:Int = 0;

	public function new(x:Int, y:Int)
	{
		this.x = x;
		this.y = y;
	}

	public function matches(x:Int, y:Int): Bool
	{
		return (this.x == x && this.y == y);
	}

	public function equals(pos:GridPosition): Bool
	{
		return matches(pos.x, pos.y);
	}

	public function adjacent(pos:GridPosition): Bool
	{
		if(equals(pos))
			return false;

		var dx = Util.diff(pos.x, x);
		var dy = Util.diff(pos.y, y);
		return (dx <= 1 && dy <= 1);
	}

	public function clone(): GridPosition
	{
		return new GridPosition(x,y);
	}
}