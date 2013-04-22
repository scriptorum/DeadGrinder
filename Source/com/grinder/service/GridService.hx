package com.grinder.service;

import ash.core.Engine;
import ash.core.Entity;
import com.scriptorum.Array2D;
import com.grinder.component.GridPosition;

/*
 * Indexes entities by grid position.
 */
class GridService
{
	private static var engine:Engine;
	public static var grid:Array2D<Array<String>>;

	public static function init(_engine:Engine, width:Int = 0, height:Int = 0): Void
	{
		engine = _engine;
		clear(width, height);
	}

	public static function clear(width:Int, height:Int): Void
	{
		grid = new Array2D<Array<String>>(width, height, null);
	}

	public static function getFirst(x:Int, y:Int): Entity
	{
		var a = grid.get(x, y);
		if(a== null || a.length == 0)
			return null;
		var e = engine.getEntityByName(a[0]);
		if(e == null)
			removeName(x, y, a[0]);
		return e;
	}

	// Warning: array return value is the original held by the GridService, do not modify
	public static function getNames(x:Int, y:Int): Array<String>
	{
		// Nothing at xy
		var arr = grid.get(x, y);
		if(arr == null)
			return [];

		// One or more entities at xy
		return arr;
	}

	public static function get(x:Int, y:Int): Array<Entity>
	{
		var a = new Array<Entity>();
		for(s in getNames(x, y))
		{
			var e = engine.getEntityByName(s);			
			if(e == null) 
				removeName(x, y, s); // Hrm, entity was removed from the engine, remove it from the GridService
			else a.push(e);
		}
		return a;
	}

	public static function add(x:Int, y:Int, e:Entity): Void
	{
		var str = e.name;
		var arr = grid.get(x, y);
		if(arr == null)
		{
			arr = new Array<String>();
			grid.set(x, y, arr);
		}
		arr.push(str);
	}

	public static function removeName(x:Int, y:Int, str:String): Void
	{
		var arr = grid.get(x, y);
		if(arr == null)
			return;

		arr.remove(str);
	}

	public static function remove(x:Int, y:Int, e:Entity): Void
	{
		removeName(x, y, e.name);
	}

	public static function move(e:Entity, x:Int, y:Int)
	{
		var pos = e.get(GridPosition);
		if(pos == null)
			throw "Cannot move entity " + e.name + " because it doesn't exist in grid space";

		remove(pos.x, pos.y, e);
		add(x, y, e);
	}
}