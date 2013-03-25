package com.grinder.component;

class Grid
{
	public var width:Int;
	public var height:Int;
	public var grid:Array<Int>;
	public var throwOnError:Bool;
	public var failValue:Int;

	public function new(width:Int, height:Int, initValue:Int = 0, throwOnError:Bool = true, failValue = -1)
	{
		this.width = width;
		this.height = height;
		this.throwOnError = throwOnError;
		this.failValue = failValue; // only on gets

		clear(initValue);
	}

	private function domainIsValid(x:Int, y:Int): Bool
	{
		if (x >= 0 && x < width && y >= 0 && y < height)
			return true;
		if(throwOnError)
			throw("Grid position " + x + "," + y +" is out of bounds");
		return false;
	}

	public function get(x:Int, y:Int): Int
	{
		if(!domainIsValid(x,y))
			return failValue;

		return grid[x + y * width];
	}

	public function set(x:Int, y:Int, value:Int): Int
	{
		if(!domainIsValid(x,y))
			return failValue;

		grid[x + y * width] = value;
		return value;
	}

	public function clear(value:Int): Void
	{
		// trace("Filling grid with value " + value);
		grid = new Array<Int>();
		for(i in 0...width * height)
			grid.push(value);
	}
}