package com.grinder.component;

class Size
{
	public var width:Float;
	public var height:Float;

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