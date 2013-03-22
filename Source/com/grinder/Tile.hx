package com.grinder;

class Tile
{
	public static inline var NULL:Int = 0;
	public static inline var COBBLESTONE:Int = 1;
	public static inline var GRASS:Int = 2;
	public static inline var WOOD:Int = 3;
	public static inline var BRICK:Int = 4;
	public static inline var RUBBLE:Int = 5;
	public static inline var DOORWAY:Int = 6;

	public static function isWalkable(tile:Int): Bool
	{
		return (tile == COBBLESTONE || tile == GRASS || tile == WOOD || tile == DOORWAY);
	}


}
