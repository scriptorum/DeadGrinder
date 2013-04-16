package com.grinder.service;

import com.grinder.component.Grid;

class MapGenerator
{
	public static inline var NOTHING:Int = 0;
	public static inline var PLAYER:Int = 1;
	public static inline var ZOMBIE:Int = 2;
	public static inline var CORPSE:Int = 3;

	public static inline var WEAPON:Int = 16;
	public static inline var FOOD:Int = 17;
	public static inline var SCRAP:Int = 18;

	public static inline var ASPHALT:Int = 32;
	public static inline var DOOR:Int = 33;
	public static inline var DOORWAY:Int = 34;
	public static inline var FLOOR:Int = 35;
	public static inline var WALL:Int = 36;

	public var grid:Grid;

	public function new(width:Int, height:Int, defaultTile:Int)
	{
		grid = new Grid(width, height, defaultTile);
	}

	public function generate(): Grid
	{
		throw("Must override MapGenerator in subclass");
		return grid;
	}
}
