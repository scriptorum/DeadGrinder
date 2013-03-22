package com.grinder.zone;

import com.grinder.presence.Presence;
import com.grinder.presence.Tangible;
import hsl.haxe.direct.DirectSignaler;
import hsl.haxe.Signaler;

class Zone
{
	private static var nextId:Int = 1;
	private var map:Array<Int>;
	private var parent:Zone;
	private var presences:Array<Presence>;
	private var zones:IntHash<Zone>;

	public var id(default,null):Int;
	public var width(default,null):Int;
	public var height(default,null):Int;
	public var x(default,null):Int; // offsets from origin
	public var y(default,null):Int; // defaults to 0

	public var initialized(default,null):Signaler<Zone>; // Mass change at initialization
	public var tangibleAdded(default,null):Signaler<Tangible>;

	// Assign listeners, then call init()
	// x/y = offset from parent
	public function new(width:Int, height:Int, ?x:Int = 0, ?y:Int = 0, ?parent:Zone = null)
	{
		this.id = nextId++;
		this.width = width;
		this.height = height;
		this.x = x;
		this.y = y;
		this.parent = parent;

		initialized = new DirectSignaler(this);
		tangibleAdded = new DirectSignaler(this);

		map = new Array<Int>();
		presences = new Array<Presence>();
		zones = new IntHash<Zone>();
	}

	public function setBackground(x:Int, y:Int, tile:Int)
	{
		if(x < 0 || y < 0 || x >= width || y >= width)
		{
			trace("Cannot set background at " + x + "," + y + "; it is out of bounds.");
			return;
		}

		// trace("Setting position " + x +"," + y + " to " + tile);		
		map[y * width + x] = tile;
	}

	public function getBackground(x:Int, y:Int): Int
	{
		if(x < 0 || y < 0 || x >= width || y >= width)
			return 0; // null tile

		// trace("Getting background position " + x + "," + y + ", index " + y*width+x + " value " + map[y*width+x]);
		return map[y * width + x];
	}

	public function addZone(zone:Zone): Void // adds a sub-Zone to the UL coordinate
	{
		zones.set(zone.id,zone);
		// trace("adding zone " + zone.id + " with dim " + zone.width + "x" + zone.height + " and offset " + zone.x + "," + zone.y);
		for(y in 0...zone.width)
		for(x in 0...zone.height)
		{
			var tile = zone.getBackground(x,y);
			// trace(" - Copying tile " + tile + " from " + x + "," + y); 
			setBackground(x + zone.x, y + zone.y, tile);
		}
	}

	public function addPresence(presence:Presence): Void
	{
		if(parent != null)
		{
			presence.x += x;
			presence.y += y;
			parent.addPresence(presence);
		}

		else
		{
			presences.push(presence);
			presence.init();

			if(Std.is(presence, Tangible))
				tangibleAdded.dispatch(cast(presence, Tangible));
		}
	}

	public function removePresence(presence:Presence): Void
	{
		if(parent != null)
			parent.removePresence(presence);

		else
		{
			presences.remove(presence);	
			presence.remove();
		}
	}

	public function init(): Void // override, then call super.init()
	{
		initialized.dispatch(this);
	}

	public function update(): Void
	{
		for(p in presences)
			p.update(this);

		for(z in zones.iterator())
			z.update();
	}
}