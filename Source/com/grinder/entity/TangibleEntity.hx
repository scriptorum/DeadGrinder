package com.grinder.entity;

import com.grinder.zone.Zone;
import com.grinder.presence.Tangible;
import com.grinder.presence.Presence;
import com.haxepunk.graphics.Image;
import com.haxepunk.utils.Ease;
import com.haxepunk.Entity;
import com.haxepunk.Tween;
import com.haxepunk.HXP;

import com.haxepunk.graphics.atlas.Atlas;

class TangibleEntity extends Entity
{
	public function new(tangible:Tangible)
	{		
		layer = 50;
		var sz:Int = tangible.getTileSize();
		super(tangible.x * sz, tangible.y * sz);

		var bm = HXP.getBitmap(tangible.getTileSet());
		var tile:Int = tangible.getState().tile;
		var tsw:Int= Math.floor(bm.width / sz);
		var rect = new flash.geom.Rectangle(tile % tsw * sz, Math.floor(tile / tsw) * sz, sz, sz);
		var image = new Image(tangible.getTileSet(), rect);
		graphic = image;

		// graphic = new Image(tangible.getTileSet(), rect);
		// graphic = new com.haxepunk.graphics.Stamp("img/cell.png");
		// graphic = Image.createCircle(16, 0xFF0000);

		tangible.removed.bind(tangibleRemoved);
		tangible.moved.bind(tangibleMoved);
	}

	public function tangibleRemoved(presence:Presence)
	{
		world.remove(this);
	}

	public function tangibleMoved(presence:Presence)
	{
		var tangible = cast(presence,Tangible);
		var animate = false;

		var dx = tangible.x * tangible.getTileSize();
		var dy = tangible.y * tangible.getTileSize();

		if(animate)
			HXP.tween(this, { x:dx, y:dy }, 0.2, { ease:Ease.circInOut, type:TweenType.OneShot });
		else { x = dx; y = dy; }
	}	
}