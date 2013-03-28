package com.grinder.component;

class GridPosition
{
	public var x:Int;
	public var y:Int;

	public function new(x:Int, y:Int)
	{
		this.x = x;
		this.y = y;
	}

	public function matches(x:Int, y:Int): Bool
	{
		return (this.x == x && this.y == y);
	}
}