package com.grinder.world;

import com.grinder.SoundMan;
import com.grinder.InputMan;
import com.grinder.CameraMan;
import com.grinder.zone.Outdoors;
import com.grinder.zone.Zone;
import com.grinder.entity.Background;
import com.grinder.entity.Hud;
import com.grinder.presence.Presence;
import com.grinder.presence.Tangible;
import com.grinder.entity.TangibleEntity;

import com.haxepunk.World;
import com.haxepunk.graphics.Backdrop;

class GameWorld extends World
{
	public var map:Outdoors;
	public var hud:Hud;

	public function new()
	{
		super();
		CameraMan.init();
	}

	override public function begin()
	{
		super.update();

		hud = new Hud();
		add(hud);
		hud.setMessage("There's no going back now.");

		map = new Outdoors();
		map.tangibleAdded.bind(tangibleAdded);
		
		var bd = new Backdrop("img/rubble.png");
		var bg = new Background(map);
		addGraphic(bg, 1000);

		map.init();

		addGraphic(bd, 2000);
	}	

	public function tangibleAdded(presence:Presence)
	{
		if(Std.is(presence, Tangible))
		{
			var e = new TangibleEntity(cast(presence,Tangible));
			add(e);		
			presence.added();
		}
	}

	override public function update()
	{
		super.update();

		var ox:Int = 0;
		var oy:Int = 0;

		if(InputMan.pressed(InputMan.N)) { oy--; }
		else if(InputMan.pressed(InputMan.E)) { ox++; } 
		else if(InputMan.pressed(InputMan.W)) { ox--; }
		else if(InputMan.pressed(InputMan.S)) { oy++; }
		else if(InputMan.pressed(InputMan.NE)) { oy--; ox++; }
		else if(InputMan.pressed(InputMan.NW)) { oy--; ox--; }
		else if(InputMan.pressed(InputMan.SW)) { oy++; ox--; }
		else if(InputMan.pressed(InputMan.SE)) { oy++; ox++; }
		if(ox != 0 || oy != 0)
		{
			if(map.canPlayerMoveRel(ox,oy) == false)
				hud.setMessage("You can't find a way through.");
			else map.player.moveRel(ox, oy);
			updateSim();
		}
	}

	public function updateSim(): Void
	{
		map.update();
	}
}