package com.grinder.service;

import nme.geom.Rectangle;

import ash.core.Engine;
import ash.core.Entity;
import ash.fsm.EntityStateMachine;

import com.grinder.component.Action;
import com.grinder.component.Actionable;
import com.grinder.component.CameraFocus;
import com.grinder.component.Closeable;
import com.grinder.component.Closed;
import com.grinder.component.Collision;
import com.grinder.component.Display;
import com.grinder.component.Doorway;
import com.grinder.component.Grid;
import com.grinder.component.GridPosition;
import com.grinder.component.GridSize;
import com.grinder.component.GridVelocity;
import com.grinder.component.Health;
import com.grinder.component.Image;
import com.grinder.component.PlayerControl;
import com.grinder.component.Inventory;
import com.grinder.component.Layer;
import com.grinder.component.Lockable;
import com.grinder.component.Locked;
import com.grinder.component.Message;
import com.grinder.component.Open;
import com.grinder.component.Openable;
import com.grinder.component.Orientation;
import com.grinder.component.Position;
import com.grinder.component.Repeating;
import com.grinder.component.Size;
import com.grinder.component.Spawn;
import com.grinder.component.State;
import com.grinder.component.Tile;
import com.grinder.component.TiledImage;
import com.grinder.component.Unlockable;
import com.grinder.component.Unlocked;
import com.grinder.component.Velocity;
import com.grinder.component.Description;

import com.grinder.node.GridPositionNode;
import com.grinder.service.ConfigService;
import com.grinder.service.MapService;

class EntityService
{
	private var actionables:Array<Class<Actionable>>;
	private var nextId:Int = 0;

	public var ash:Engine;

	public function new(ash:Engine)
	{
		this.ash = ash;
		actionables = [Openable, Closeable, Lockable, Unlockable];
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

	public function getLegalActions(x:Int, y:Int): Array<String>
	{
		var a = new Array<String>();
		for(node in ash.getNodeList(GridPositionNode))
		{
			if(node.position.matches(x,y))
			{
				if(node.entity.has(Description))
					a.push(Action.EXAMINE);
				for(actionable in actionables)
				{
					if(node.entity.has(actionable))
						a.push(node.entity.get(actionable).type);
				}
				break;
			}
		}
		return a;
	}

	public function addActionAt(x:Int, y:Int, action:Action): Array<Entity>
	{
		var list = getEntitiesAt(x, y);
		if(list.length > 0)
		{
			for(entity in list)
				entity.add(action);
		}
		else addMessage("There's nothing there.");
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
		e.add(new Tile(ConfigService.getTiledImage(), MapService.PLAYER));
		e.add(new Collision(Collision.PERSON));
		e.add(new CameraFocus());
		e.add(new PlayerControl());
		e.add(new Description("You have looked better."));
		ash.addEntity(e);
		return e;
	}

	public function addZombie(x:Int, y:Int): Entity
	{
		var e = new Entity("zombie" + nextId++);
		e.add(new GridPosition(x, y));
		e.add(new Layer(40));
		e.add(new Tile(ConfigService.getTiledImage(), MapService.ZOMBIE));
		e.add(new Collision(Collision.CREATURE));
		e.add(new Description("It's hideous."));
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
		e.add(MapService.generateGrid(this));
		e.add(new Layer(100));
		e.add(new Position(0,0));
		e.add(ConfigService.getTiledImage());
		ash.addEntity(e);
		return e;
	}

	private var wallDescriptions:Array<Description>;
	public function addWall(x:Int, y:Int): Entity
	{
		if(wallDescriptions == null)
		{
			wallDescriptions = new Array<Description>();
			wallDescriptions.push(new Description("The paint on this wall has worn down."));
			wallDescriptions.push(new Description("The writing on this wall proclaims the end is near."));
			wallDescriptions.push(new Description("It's just a wall. Holds up the building."));
		}
		var e = new Entity();
		e.add(new GridPosition(x, y));
		e.add(new Layer(50));
		e.add(new Tile(ConfigService.getTiledImage(), 36));
		e.add(new Collision(Collision.SHEER));
		e.add(com.haxepunk.HXP.choose(wallDescriptions));
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
		// TODO Replace collision component with Blocked?
		fsm.createState("open")
			.add(Open).withSingleton()
			.add(Closeable).withSingleton()
			.add(Tile).withInstance(new Tile(tiledImage, 34))
			.add(Layer).withInstance(layer)
			.add(GridPosition).withInstance(pos)
			.add(State).withInstance(new State(fsm, "open"))
			.add(Description).withInstance(new Description("You see an open doorway."));
		fsm.createState("closed")
			.add(Closed).withSingleton()
			.add(Openable).withSingleton()
			.add(Lockable).withSingleton()
			.add(Tile).withInstance(new Tile(tiledImage, 33))
			.add(Collision).withInstance(new Collision(Collision.CLOSED))
			.add(Layer).withInstance(layer)
			.add(GridPosition).withInstance(pos)
			.add(State).withInstance(new State(fsm, "closed"))
			.add(Description).withInstance(new Description("You see a closed door."));
		fsm.createState("locked")
			.add(Locked).withSingleton()
			.add(Closed).withSingleton()
			.add(Unlockable).withSingleton()
			.add(Tile).withInstance(new Tile(tiledImage, 33))
			.add(Collision).withInstance(new Collision(Collision.LOCKED))
			.add(Layer).withInstance(layer)
			.add(GridPosition).withInstance(pos)
			.add(State).withInstance(new State(fsm, "locked"))
			.add(Description).withInstance(new Description("You see a closed door. It's locked."));
		fsm.changeState(state);
		ash.addEntity(e);
		return e;
	}
}