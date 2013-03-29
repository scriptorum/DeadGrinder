package com.grinder.service;

import nme.geom.Rectangle;

import ash.core.Engine;
import ash.core.Entity;
import ash.fsm.EntityStateMachine;

import com.grinder.component.Action;
import com.grinder.component.CameraFocus;
import com.grinder.component.Collision;
import com.grinder.component.Display;
import com.grinder.component.Doorway;
import com.grinder.component.Grid;
import com.grinder.component.GridPosition;
import com.grinder.component.GridSize;
import com.grinder.component.GridVelocity;
import com.grinder.component.Health;
import com.grinder.component.Image;
import com.grinder.component.InputControl;
import com.grinder.component.Inventory;
import com.grinder.component.Layer;
import com.grinder.component.Message;
import com.grinder.component.Orientation;
import com.grinder.component.Position;
import com.grinder.component.Repeating;
import com.grinder.component.Size;
import com.grinder.component.Spawn;
import com.grinder.component.State;
import com.grinder.component.Tile;
import com.grinder.component.TiledImage;
import com.grinder.component.Velocity;
import com.grinder.node.GridPositionNode;
import com.grinder.service.ConfigService;

class EntityService
{
	private var nextId:Int = 0;
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

	public function addMessage(str:String): Entity
	{
		var e = new Entity("message" + nextId++);
		e.add(new Message(str));
		ash.addEntity(e);
		return e;
	}

	public function addMessageHud(): Entity
	{
		var e = new Entity("messageHud");
		e.add(new Spawn("messageHud"));
		e.add(new Position(5, 5));
		e.add(new Layer(10));
		ash.addEntity(e);
		return e;
	}

	public function addPlayer(x:Int, y:Int): Entity
	{
		var e = new Entity("player");
		e.add(new GridPosition(x, y));
		e.add(new Layer(35));
		e.add(new Tile(ConfigService.getTiledImage(), 1));
		e.add(new Collision(Collision.PERSON));
		e.add(new CameraFocus());
		ash.addEntity(e);
		return e;
	}

	public function addBackdrop(): Entity
	{
		var e = new Entity("backdrop");
		e.add(new Image("art/rubble2.png"));
		e.add(new Repeating());
		e.add(new Layer(1000));
		ash.addEntity(e);
		return e;
	}

	public function addMap(): Entity
	{
		var e = new Entity("map");
		e.add(new Grid(11, 11, 32, null, null));
		e.add(new Layer(100));
		e.add(new Position(0,0));
		e.add(ConfigService.getTiledImage());
		ash.addEntity(e);
		return e;
	}

	public function addWall(x:Int, y:Int): Entity
	{
		var e = new Entity();
		e.add(new GridPosition(x, y));
		e.add(new Layer(50));
		e.add(new Tile(ConfigService.getTiledImage(), 36));
		e.add(new Collision(Collision.SHEER));
		ash.addEntity(e);
		return e;
	}

	public function addDoor(x:Int, y:Int, state:String = "closed"): Entity
	{
		var e = new Entity();
		var fsm = new EntityStateMachine(e);
		var pos = new GridPosition(x, y);
		var layer = new Layer(50);
		var tiledImage = ConfigService.getTiledImage();
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
		fsm.changeState(state);
		ash.addEntity(e);
		return e;
	}
}