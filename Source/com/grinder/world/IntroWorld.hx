package com.grinder.world;

import com.grinder.Main;
import com.grinder.InputMan;
import com.haxepunk.HXP;
import com.haxepunk.World;
import com.haxepunk.graphics.Image;

class IntroWorld extends World
{
	public function new()
	{
		super();
	}

	override public function begin()
	{
		addGraphic(new Image("img/intro.png"), 100);
	}	

	override public function update()
	{
		super.update();

		if(InputMan.clicked || InputMan.pressed(InputMan.ABORT))
		{
			cast(HXP.engine, Main).nextWorld();
		}
	}
}