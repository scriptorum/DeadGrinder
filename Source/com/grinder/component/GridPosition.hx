package com.grinder.component;

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
}