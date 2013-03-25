package com.grinder.service;

import nme.geom.Rectangle;

import ash.core.Engine;
import ash.core.Entity;

import com.grinder.service.ComponentService;

class EntityService
{
	public var ash:Engine;

	public function new(ash:Engine)
	{
		this.ash = ash;
	}

	public function spawnEntity(id:String, name:String = "")
	{
		var e = new Entity(name);
		spawnComponents(e, id);
		ash.addEntity(e);
	}

	public static function spawnComponents(e:Entity, id:String)
	{
		var data;
		switch(id)
		{
			case "player":
			data = [
				["GridPosition", [3, 3]],
				["TileImage", ["art/grimoire.png", tileRect(1)]],
				["Layer", [ 50 ]],
				["CameraFocus", null]
			];

			case "map":
			data = [
				["Grid", [ 15, 10 ]],
				["Layer", [ 100 ]]
			];

			case "backdrop":
			data = [
				["Image", ["art/rubble.png"]],
				["Repeating", null],
				["Layer", [ 1000 ]]
			];
			
			default:
			throw("Entity ID not recognized: " + id);
		}

		for(arr in data)
			e.add(ComponentService.getComponent(arr[0], arr[1]));
	}

	private static var TILES_ACROSS:Int = 8;
	private static var TILE_SIZE:Int = 32;
	private static function tileRect(tile): Rectangle
	{
		var tileX = tile % TILES_ACROSS;
		var tileY = Std.int(Math.floor(tile / TILES_ACROSS));
		return new Rectangle(tileX * TILE_SIZE, tileY * TILE_SIZE, TILE_SIZE, TILE_SIZE);
	}
}