package com.grinder.entity;

import com.grinder.zone.Zone;
import com.haxepunk.graphics.Tilemap;

class Background extends Tilemap
{
	public static inline var TILESIZE:Int = 32;

	public function new(zone:Zone)
	{
		trace("Creating new Background with dim:" + zone.width + "x" + zone.height);
		super("img/tilemap.png", zone.width * TILESIZE, zone.height * TILESIZE, TILESIZE, TILESIZE);
		zone.initialized.bind(initialized);
	}

	public function initialized(zone:Zone)
	{
		trace("Model initialized, updating view");
		for(y in 0...zone.height)
		for(x in 0...zone.width)
		{
			var tile = zone.getBackground(x, y);
			this.setTile(x, y, tile);
		}
	}
}