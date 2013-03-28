package com.grinder.service;

import nme.geom.Rectangle;

import ash.core.Engine;
import ash.core.Entity;

import com.grinder.service.ComponentService;
import com.grinder.component.Collision;

class EntityService
{
	public var ash:Engine;

	public function new(ash:Engine)
	{
		this.ash = ash;
	}

	public function spawnEntity(id:String, name:String = ""): Entity
	{
		var e = new Entity(name);
		spawnComponents(e, id);
		ash.addEntity(e);
		return e;
	}

	public static function spawnComponents(e:Entity, id:String): Entity
	{
		var data;
		switch(id)
		{
			case "player":
			data = [
				["GridPosition", [0, 0]],
				["TileImage", ["art/grimoire.png", tileRect(1)]],
				["Layer", [ 50 ]],
				["Collision", [Collision.PERSON]],
				["CameraFocus"]
			];

			case "map":
			data = [
				["TileImage", ["art/grimoire.png", tileRect(0)]],
				["Grid", [ 11, 11, 32, null, null ]],
				["Position", [ 0, 0 ]],
				["Layer", [ 100 ]]
			];

			case "backdrop":
			data = [
				["Image", ["art/rubble2.png"]],
				["Repeating"],
				["Layer", [ 1000 ]]
			];

			case "wall":
			data = [
				["TileImage", ["art/grimoire.png", tileRect(36)]],
				["Collision", [Collision.SHEER]],
				["Layer", [ 50 ]],
				["GridPosition", [ 0, 0 ]],
			];

			case "door":
			data = [
				["TileImage", ["art/grimoire.png", tileRect(33)]],
				["Collision", [Collision.CLOSED]],
				["Layer", [ 50 ]],
				["GridPosition", [ 0, 0 ]],
			];

			default:
			throw("Entity ID not recognized: " + id);
		}

		for(arr in data)
			e.add(ComponentService.getComponent(arr[0], arr[1]));

		return e;
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

/*
				["GridPosition", [0, 0]],
				["TileImage", ["art/grimoire.png", tileRect(1)]],
				["Layer", [ 50 ]],
				["Collision", [Collision.PERSON]],
				["CameraFocus"]


var name = "player";
var entity = new Entity(name);
ash.addEntity(entity);

var playerFsm = new EntityStateMachine(entity);
playerFsm.createState("alive")
	.add(GridPosition).withInstance(new GridPosition(0,0))
	.add(TileImage).withInstance(new TileImage("art/grimoire.png", tileRect(1))
	.add(Layer).withInstance(new Layer(50))
	.add("Collision").withInstance(new Collision(Collision.PERSON))
	.add("CameraFocus");
playerFsm.createState("dead")
	.add(GridPosition) // will it hold the last grid position if I do it this way? Try it out!
	.add(TileImage).withInstance(new TileImage())
var state = new State(playerFsm);
entity.add(state);

playerFsm.changeState("alive");



*/

