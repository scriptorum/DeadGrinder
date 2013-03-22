package com.grinder.entity;

import com.grinder.graphic.FancyText;
import com.haxepunk.Entity;

class Hud extends Entity
{
	private var text:FancyText;
	public function new()
	{
		super();
		layer = 20;
		text = new FancyText("You feel a chill.", 0x88FF88, 14, 5, 5);
		addGraphic(text);
	}

	public function setMessage(str:String): Void
	{
		text.setString(str);
	}
}