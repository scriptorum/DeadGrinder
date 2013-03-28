package com.grinder.service;

import nme.geom.Rectangle;

import ash.core.Engine;
import ash.core.Entity;
import ash.fsm.EntityStateMachine;

import com.grinder.service.ComponentService;
import com.grinder.service.ConfigService;
import com.grinder.node.GridPositionNode;
import com.grinder.component.Collision;
import com.grinder.component.TiledImage;
import com.grinder.component.GridPosition;
import com.grinder.component.Layer;
import com.grinder.component.Tile;
import com.grinder.component.State;
import com.grinder.component.Action;

class EntityService
{
	public var ash:Engine;

	public function new(ash:Engine)
	{
		this.ash = ash;
	}

	public function getEntitiesAt(x:Int, y:Int): Array<Entity>
	{
		var a = new Array<Entity>();
		for(node in ash.getNodeList(GridPositionNode))
		{
			if(node.position.matches(x,y))
				a.push(node.entity);
		}
		return a;
	}

	public function addActionAt(x:Int, y:Int, action:Action): Array<Entity>
	{
		var list = getEntitiesAt(x, y);
		for(entity in list)
			entity.add(new Action(Action.OPEN));		
		return list;
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
		var tiledImage:TiledImage = ConfigService.getTiledImage();
		var data;
		switch(id)
		{
			case "player":
			data = [
				["GridPosition", [0, 0]],
				["Tile", [tiledImage, 1]],
				["Layer", [ 30 ]],
				["Collision", [Collision.PERSON]],
				["CameraFocus"]
			];

			case "map":
			data = [
				[tiledImage],
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
				["Tile", [tiledImage, 36]],
				["Collision", [Collision.SHEER]],
				["Layer", [ 50 ]],
				["GridPosition", [ 0, 0 ]],
			];

			case "door":
			var fsm = new EntityStateMachine(e);
			var pos = new GridPosition(0,0);
			var layer = new Layer(50);
			fsm.createState("open")
				.add(Tile).withInstance(new Tile(tiledImage, 34))
				.add(Layer).withInstance(layer)
				.add(GridPosition).withInstance(pos)
				.add(State).withInstance(new State(fsm, "open"));
			fsm.createState("closed")
				.add(Tile).withInstance(new Tile(tiledImage, 33))
				.add(Collision).withInstance(new Collision(Collision.CLOSED))
				.add(Layer).withInstance(layer)
				.add(GridPosition).withInstance(pos)
				.add(State).withInstance(new State(fsm, "closed"));
			fsm.createState("locked")
				.add(Tile).withInstance(new Tile(tiledImage, 33))
				.add(Collision).withInstance(new Collision(Collision.LOCKED))
				.add(Layer).withInstance(layer)
				.add(GridPosition).withInstance(pos)
				.add(State).withInstance(new State(fsm, "locked"));
			data = [
				["State", [fsm, "init", "closed"]],
			];

			default:
			throw("Entity ID not recognized: " + id);
		}

		for(arr in data)
		{
			var c:Dynamic = (Std.is(arr[0], String) ? ComponentService.getComponent(arr[0], arr[1]) : arr[0]);
			e.add(c);

			if(e.has(State))
			{
				var state = e.get(State);
				if(state.next != null)
					state.fsm.changeState(state.next);
			}
		}

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

