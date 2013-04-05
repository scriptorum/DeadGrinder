package com.grinder.service;

import com.haxepunk.HXP;

import ash.core.Engine;
import ash.core.Entity;
import ash.core.Node;
import ash.fsm.EntityStateMachine;

import com.grinder.component.Action;
import com.grinder.component.Actionable;
import com.grinder.component.CameraFocus;
import com.grinder.component.Carriable;
import com.grinder.component.Carried;
import com.grinder.component.Carrier;
import com.grinder.component.Closeable;
import com.grinder.component.Closed;
import com.grinder.component.Collision;
import com.grinder.component.Description;
import com.grinder.component.Display;
import com.grinder.component.Doorway;
import com.grinder.component.Equipment;
import com.grinder.component.Equipped;
import com.grinder.component.Equipper;
import com.grinder.component.Grid;
import com.grinder.component.GridPosition;
import com.grinder.component.GridSize;
import com.grinder.component.GridVelocity;
import com.grinder.component.Health;
import com.grinder.component.Image;
import com.grinder.component.Layer;
import com.grinder.component.Lockable;
import com.grinder.component.Locked;
import com.grinder.component.Message;
import com.grinder.component.Name;
import com.grinder.component.Open;
import com.grinder.component.Openable;
import com.grinder.component.Orientation;
import com.grinder.component.PlayerControl;
import com.grinder.component.InventoryControl;
import com.grinder.component.Position;
import com.grinder.component.Repeating;
import com.grinder.component.ScrollFactor;
import com.grinder.component.Size;
import com.grinder.component.Spawn;
import com.grinder.component.State;
import com.grinder.component.Tile;
import com.grinder.component.TiledImage;
import com.grinder.component.Unlockable;
import com.grinder.component.Unlocked;
import com.grinder.component.Velocity;

import com.grinder.node.GridPositionNode;
import com.grinder.node.InventoryNode;
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
		e.add(new Layer(Layer.HUD));
		ash.addEntity(e);
		return e;
	}

	public function addPlayer(x:Int, y:Int): Entity
	{
		var e = new Entity("player");
		e.add(new GridPosition(x, y));
		e.add(new Layer(34));
		e.add(new Tile(ConfigService.getTiledImage(), MapService.PLAYER));
		e.add(new Collision(Collision.PERSON));
		e.add(new CameraFocus());
		e.add(new PlayerControl());
		e.add(new Health(100));
		e.add(new Carrier(50, 10));
		e.add(new Equipper({ weapon:1, armor:0 }));
		e.add(new Description("You have looked better."));
		ash.addEntity(e);
		return e;
	}

	public function addZombie(x:Int, y:Int, state:String = "alive"): Entity
	{
		var e = new Entity("zombie" + nextId++);
		var fsm = new EntityStateMachine(e);
		var pos = new GridPosition(x, y);
		var tiledImage = ConfigService.getTiledImage();
		fsm.createState("alive")
			.add(GridPosition).withInstance(pos)
			.add(Tile).withInstance(new Tile(tiledImage, MapService.ZOMBIE))
			.add(Layer).withInstance(new Layer(Layer.ABOVE))
			.add(Collision).withInstance(new Collision(Collision.CREATURE))
			.add(Health).withInstance(new Health(100))
			.add(State).withInstance(new State(fsm, "alive"))
			.add(Description).withInstance(new Description("It's hideous."))
			.add(Name).withInstance(new Name("zombie"));
		fsm.createState("dead")
			.add(GridPosition).withInstance(pos)
			.add(Tile).withInstance(new Tile(tiledImage, MapService.CORPSE))
			.add(Layer).withInstance(new Layer(Layer.BELOW))
			.add(Description).withInstance(new Description("It's dead. I mean really dead."))
			.add(Name).withInstance(new Name("corpse"));
		fsm.changeState(state);
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

   	public function popupInventory(equipmentType:String = null): Void
	{
		var player = ash.getEntityByName("player");
		var carrierId = player.get(Carrier).id;
		var entities:Array<Entity> = new Array<Entity>();
		for(node in ash.getNodeList(InventoryNode))
		{
			if(node.carried.carrier != carrierId)
			{
				trace("Removing " + node.entity.name + " from inventory; it's not held by the player.");
				continue; // not held by player
			}

			if(equipmentType != null)
			{
				if(!node.entity.has(Equipment))
				{
					trace("Removing " + node.entity.name + " from inventory; it's not equipment, and we're filtering on equipment.");
					continue; // This carried item is not "equipment"
				}

				var equipment = node.entity.get(Equipment);
				if(equipment.type != equipmentType)
				{
					trace("Removing " + node.entity.name + " from inventory; the equipment does not match the filter.");
					continue; // This carried equipment is of a different "type"
				}
			}

			entities.push(node.entity);
		}

		addMessage(entities.length > 0 ? 
			"Opening inventory..." :
			(equipmentType == null ? "Nothing" : "No " + equipmentType) + " in inventory.");

		if(entities.length == 0)
			return;

		player.remove(PlayerControl);
		player.add(new InventoryControl());

		var e = new Entity("inventory");
		e.add(new Spawn("inventory", { filter:equipmentType, entities:entities } ));
		e.add(new Position(0, 0));
		e.add(new Layer(Layer.POPUP));
		// e.add(new Description("Select a weapon to equip"));
		ash.addEntity(e);
	}

	public function closeInventory(): Void
	{
		ash.removeEntity(ash.getEntityByName("inventory"));
		var player = ash.getEntityByName("player");
		player.remove(InventoryControl);
		player.add(new PlayerControl());
		addMessage("Never mind.");
	}

	// public function addList(): Entity
	// {
	// 	var e = new Entity("list");
	// 	e.add(new Image("art/list.png"));
	// 	e.add(new Layer(Layer.POPUP)); // In front of everyone
	// 	// e.add(new Position(0,0));
	// 	e.add(new ScrollFactor());
	// 	ash.addEntity(e);
	// 	return e;
	// }

	// public function addText(text:String, x:Float, y:Float): Entity
	// {
	// 	var e = new Entity("list");
	// 	e.add(new Text(text));
	// 	e.add(new Layer(Layer.HUD)); // In front of everyone
	// 	e.add(new Position(x,y));
	// 	e.add(new ScrollFactor());
	// 	ash.addEntity(e);
	// 	return e;
	// }

	public function addMap(): Entity
	{
		var e = new Entity("map");
		e.add(MapService.generateGrid(this));
		e.add(new Layer(Layer.MAP));
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
		var e = new Entity("wall" + nextId++);
		e.add(new GridPosition(x, y));
		e.add(new Layer(Layer.ABOVE));
		e.add(new Tile(ConfigService.getTiledImage(), 36));
		e.add(new Collision(Collision.SHEER));
		e.add(com.haxepunk.HXP.choose(wallDescriptions));
		ash.addEntity(e);
		return e;
	}

	public function addDoor(x:Int, y:Int, state:String = "closed"): Entity
	{
		var e = new Entity("door" + nextId++);
		var fsm = new EntityStateMachine(e);
		var pos = new GridPosition(x, y);
		var layer = new Layer(Layer.BELOW);
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

	public function addWeapon(): Entity
	{
		var weapons = ["wooden bat", "tree branch", "aluminum bat", "piece of wood", "hammer",
			"crowbar", "knife", "axe", "pipe wrench", "rolling pin", "shovel"];
		var weapon = HXP.choose(weapons);

		var e = new Entity("weapon" + nextId++);
		e.add(new Layer(Layer.BELOW));
		e.add(new Tile(ConfigService.getTiledImage(), MapService.WEAPON));
		e.add(new Description("It's a " + weapon));
		e.add(new Name(weapon));
		e.add(new Equipment(Equipment.WEAPON));
		e.add(new Carriable(1.8));
		ash.addEntity(e);
		return e;
	}

	public function addWeaponTo(x:Int, y:Int): Entity
	{
		var e = addWeapon();
		e.add(new GridPosition(x, y));
		return e;
	}
}