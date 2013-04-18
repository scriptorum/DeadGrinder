package com.scriptorum;

class Point2D<T>
{
	public var x:T;
	public var y:T;

	public function new(x:T, y:T)
	{
		this.x = x;
		this.y = y;
	}

	// Makes an array of Point2D objects from a flat array of x + y values
	public static function makeArray<T>(array:Array<T>): Array<Point2D<T>>
	{
		var result = new Array<Point2D<T>>();
		while(array.length > 0)
		{
			var v1 = array.shift();
			var v2 = array.shift();
			if(v2 == null)
				throw "Unbalanced set of x/y pairs passed to makeArray";
			result.push(new Point2D<T>(v1, v2));
		}

		return result;
	}
}