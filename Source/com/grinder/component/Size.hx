package com.grinder.component;

class Size
{
	public var width:Float = 0;
	public var height:Float = 0;

	public function new(width:Float, height:Float)
	{
		this.width = width;
		this.height = height;
	}

	public function matches(width:Float, height:Float): Bool
	{
		return (this.width == width && this.height == height);
	}
}