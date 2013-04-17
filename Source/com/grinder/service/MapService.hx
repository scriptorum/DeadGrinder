package com.grinder.service;

import ash.core.Engine;
import com.grinder.render.Grimoire;
import com.grinder.component.Grid;
import com.grinder.component.GridPosition;
import com.grinder.service.EntityService;

class MapService
{
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
				if(Std.random(2) == 0)
					factory.addWeaponTo(x, y);
				else
					factory.addFoodTo(x, y);
				continue;
			}
			if(++fails > 1000)
				throw "Too many zombies, too little space";
		}
	}

	public static function spawnMapElements(factory:EntityService, grid:Grid): Grid
	{
		for(y in 0...grid.height)
		for(x in 0...grid.width)
		{
			var value = grid.get(x,y);
			switch(value)
			{
				case Grimoire.WALL:
				factory.addWall(x, y);
				grid.set(x, y, Grimoire.ASPHALT);

				case Grimoire.DOOR:
				factory.addDoor(x, y);
				grid.set(x, y, Grimoire.WALL);
			}
		}

		return grid;			
	}

	public static function generateGrid(factory:EntityService): Grid
	{
		//var gen = new DemoMapGenerator();
		var gen = new MapGenerator();
		var grid = gen.generate();
		spawnMapElements(factory, grid);
		return grid;
	}
}
