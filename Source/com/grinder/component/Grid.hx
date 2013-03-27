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

	public function setRect(x:Int, y:Int, width:Int, height:Int, value:Int)
	{
		for(_x in x...width + x)
		for(_y in y...height + y)
			set(_x, _y, value);
	}

	public function load(str:String, delimiter:String = ",", eol = ";", x:Int = 0, y:Int = 0): Void
	{
		var _x = x;
		var _y = y;
		for(line in com.scriptorum.Util.split(str, eol))
		{
			for(n in com.scriptorum.Util.split(line, delimiter))
			{
				if(n != "")
					set(_x++, _y, Std.parseInt(n));
			}
			_y++;
			_x = x;
		}
	}
}