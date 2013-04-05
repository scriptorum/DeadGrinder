package com.grinder.service;

import ash.core.Engine;
import com.grinder.component.Grid;
import com.grinder.component.GridPosition;
import com.grinder.service.EntityService;

class MapService
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

	public static function generateGrid(factory:EntityService): Grid
	{
		var grid = new Grid(11, 11, ASPHALT);

		grid.setRect(2, 2, 7, 7, WALL);
		grid.setRect(3, 3, 5, 5, FLOOR);

		grid.set(5, 2, DOOR);
		grid.set(5, 8, DOOR);
		grid.set(2, 5, DOOR);
		grid.set(8, 5, DOOR);

		for(y in 0...grid.height)
		for(x in 0...grid.width)
		{
			var value = grid.get(x,y);
			switch(value)
			{
				case WALL:
				factory.addWall(x, y);
				grid.set(x, y, ASPHALT);

				case DOOR:
				factory.addDoor(x, y);
				grid.set(x, y, WALL);
			}
		}

		return grid;			
	}

	public static function spawnZombies(factory:EntityService, count:Int, radius:Int = 3): Void
	{
		var player = factory.ash.getEntityByName("player");
		var px = player.get(GridPosition).x;
		var py = player.get(GridPosition).x;

		var map = factory.ash.getEntityByName("map");
		var grid = map.get(Grid);

		var fails = 0;
		var spawned = 0;
		while(spawned < count)
		{
			var x = Std.random(grid.width);
			var y = Std.random(grid.height);
			var dx = Math.abs(px - x);
			var dy = Math.abs(py - y);
			var distFromPlayer:Float = Math.sqrt(dx * dx + dy * dy);
			if(distFromPlayer >= radius)
			{
				var obstacles = factory.getEntitiesAt(x, y);
				if(obstacles.length == 0)
				{
					++spawned;
					factory.addZombie(x, y);
					continue;
				}
			}
			if(++fails > 1000)
				throw "Too many zombies, too little space";
		}
	}

	public static function spawnItems(factory:EntityService, count:Int): Void
	{
		var map = factory.ash.getEntityByName("map");
		var grid = map.get(Grid);

		var fails = 0;
		var spawned = 0;
		while(spawned < count)
		{
			var x = Std.random(grid.width);
			var y = Std.random(grid.height);
			var obstacles = factory.getEntitiesAt(x, y);
			if(obstacles.length == 0)
			{
				++spawned;
				factory.addWeaponTo(x, y);
				continue;
			}
			if(++fails > 1000)
				throw "Too many zombies, too little space";
		}
	}
}