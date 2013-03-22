package com.grinder.zone;

import com.grinder.Tile;
import com.grinder.presence.Tangible;
import com.grinder.zone.Zone;
import com.grinder.zone.Building;
import com.grinder.Catalog;
import com.haxepunk.HXP;

class Outdoors extends Zone
{
	public static inline var STREET:Int = 3;
	public static inline var ALLEY:Int = 1;
	public static inline var BLOCK = Building.BUILDING_EXTERIOR * 2 + ALLEY + STREET;
	public static inline var BLOCKS_ACROSS:Int = 4;
	public static inline var BLOCKS_DOWN:Int = 3;

	public var player(default,null):Tangible;

	public function new()
	{
		var w = BLOCK * BLOCKS_ACROSS + STREET;
		var h = BLOCK * BLOCKS_DOWN + STREET;
		trace("Creating outdoors area dim " + w + "x" + h + ", block size is " + BLOCK);
		super(w, h); 
		var catalog = com.grinder.Catalog.getInstance();
	}

	override public function init()
	{
		for(y in 0...height)
		for(x in 0...width)
			setBackground(x, y, Tile.COBBLESTONE);

		for(yy in 0...2)
		for(xx in 0...2)
		for(y in 0...BLOCKS_DOWN)
		for(x in 0...BLOCKS_ACROSS)
		{
			var zone = new Building(Building.BUILDING_EXTERIOR, Building.BUILDING_EXTERIOR, 
				x * BLOCK + STREET + xx * (Building.BUILDING_EXTERIOR + ALLEY), 
				y * BLOCK + STREET + yy * (Building.BUILDING_EXTERIOR + ALLEY), this);
			zone.init();
			addZone(zone);
		}

		var catalog = Catalog.getInstance();
		var obj = catalog.getObject("player");
		player = new Tangible(obj, 1, 1); // add player
		addPresence(player);

		super.init();
	}

	public function canPlayerMoveRel(x:Int, y:Int): Bool
	{
		var dx = player.x + x;
		var dy = player.y + y;
		var tile = getBackground(dx, dy);
 		// trace("Player at " + x+"," + y + " is moving to " + dx +"," + dy + " and finds tile " + tile);
		if(Tile.isWalkable(tile))
			return true;
		return false;		
	}
}

