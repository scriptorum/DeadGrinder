package com.grinder.presence;

import com.grinder.zone.Zone;
import com.grinder.behavior.Behavior;
import hsl.haxe.direct.DirectSignaler;
import hsl.haxe.Signaler;

// An object that exists at a position on the map, but may or may not be tangible (a dog vs a bark)
class Presence
{
	private static var nextId:Int = 1;

	public var initialized(default,null):Signaler<Presence>;
	public var moved(default,null):Signaler<Presence>;
	public var removed(default,null):Signaler<Presence>; 

	private var _x:Int;
	private var _y:Int;
	private var behaviors:Array<Behavior>;

	public var x(getX,setX):Int; // offsets from origin
	public var y(getY,setY):Int; // defaults to 0
	public var id(default,null):Int;

	public function new(x:Int, y:Int)
	{
		this.id = nextId++;
		_x = x;
		_y = y;
		// trace("Assigning x/y directly:" + _x +"," + _y);
		initialized = new DirectSignaler(this);
		moved = new DirectSignaler(this);
		removed = new DirectSignaler(this);
	}

	public function init(): Void
	{
		initialized.dispatch(this);
	}

	public function setX(x:Int): Int
	{
		// trace("Called setX _x:" + _x + " x:" + x);
		_x = x;
		moved.dispatch(this);
		return _x;
	}

	public function setY(y:Int): Int
	{
		// trace("Called setY _y:" + _y + " y:" + y);
		_y = y;
		moved.dispatch(this);
		return _y;
	}

	public function getX(): Int { return _x; }
	public function getY(): Int { return _y; }

	public function moveTo(x:Int, y:Int): Void
	{
		// trace("Called moveTo " + x + "," + y);
		_x = x;
		_y = y;
		moved.dispatch(this);
	}

	public function moveRel(x:Int, y:Int): Void
	{
		moveTo(_x + x, _y + y);
	}

	public function remove() : Void
	{
		removed.dispatch(this);
	}

	public function hasBehavior(type:Class<Behavior>): Bool
	{
		if(behaviors == null)
			return false;

		for(b in behaviors)
			if(Std.is(b, type))
				return true;
		return false;
	}

	public function added(): Void
	{
		if(behaviors == null)
			return;

		for(b in behaviors)
			b.added();
	}

	public function addBehavior(behavior:Behavior): Void
	{
		if(behaviors == null)
			behaviors = new Array<Behavior>();

		behaviors.push(behavior);
	}

	public function removeBehavior(behavior:Behavior): Void	
	{
		if(behaviors == null)
		{
			trace("ERROR: Attempt to remove non-existent behavior");
			return;
		}

		behaviors.remove(behavior);
	}

	public function update(zone:Zone)
	{
		if(behaviors == null)
			return;

		for(b in behaviors)
			b.invoke(zone);
	}
}