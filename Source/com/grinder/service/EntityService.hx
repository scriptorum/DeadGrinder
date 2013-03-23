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
				["TileImage", ["art/catalog.png", new Rectangle(32, 0, 32, 32)]],
				["CameraFocus", null]
			];
			
			default:
			throw("Entity ID not recognized: " + id);
		}

		for(arr in data)
			e.add(ComponentService.getComponent(arr[0], arr[1]));
	}

}