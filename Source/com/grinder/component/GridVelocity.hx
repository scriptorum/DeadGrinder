package com.grinder.component;

class GridVelocity
{
	public var x:Int = 0;
	public var y:Int = 0;

	public function new(x:Int, y:Int)
	{
		this.x = x;
		this.y = y;
	}

	public function clear(): Void
	{
		x = y = 0;
	}

	public function stopped(): Bool
	{
		return (x == 0 && y == 0);
	}
}