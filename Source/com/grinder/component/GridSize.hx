package com.grinder.component;

class GridSize
{
	public var width:Int = 0;
	public var height:Int = 0;

	public function new(width:Int, height:Int)
	{
		this.width = width;
		this.height = height;
	}

	public function matches(width:Int, height:Int): Bool
	{
		return (this.width == width && this.height == height);
	}
}