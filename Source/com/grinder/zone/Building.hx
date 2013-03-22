package com.grinder.zone;

import com.grinder.zone.Zone;
import com.grinder.presence.Tangible;

class Building extends Zone
{
	public static inline var BUILDING_INTERIOR:Int = 7;
	public static inline var WALL:Int = 1;
	public static inline var BUILDING_EXTERIOR:Int = BUILDING_INTERIOR + WALL * 2;

	public function new(width:Int, height:Int, ?x:Int = 0, ?y:Int = 0, ?parent:Zone = null)
	{
		super(width,height,x,y,parent);
	}

	override public function init()
	{
		for(y in 0...height)
		for(x in 0...width)
		{
			var isEdgeV = (y == 0 || y == height-1);
			var isEdgeH = (x == 0 || x == width-1);
			var isDoorV = (y == Math.floor(height/2));
			var isDoorH = (x == Math.floor(width/2));
			var tile = Tile.WOOD;
			if(isEdgeV || isEdgeH)
			{
				if(isEdgeV && isDoorH)
					tile = -1;
				else if(isEdgeH && isDoorV)
					tile = -1;
				else tile = Tile.BRICK;
			}
			if(tile == -1)
			{
				tile = Tile.WOOD;
				var obj = new Tangible("door", x, y);
				obj.setState("closed");
				addPresence(obj);
			}
			setBackground(x, y, tile);
		}
	}	
}