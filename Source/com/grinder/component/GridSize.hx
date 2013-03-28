package com.grinder.component;

class GridSize
{
	public var width:Int;
	public var height:Int;

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