package com.grinder.render;

import ash.core.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Image;
import com.grinder.render.FancyText;
import com.grinder.component.Name;

class InventoryView extends View
{
	override public function begin()
	{
		x = 0;
		y = 0;

		var img = new Image("art/list.png");
		img.scrollX = img.scrollY = 0;
		addGraphic(img);

		var filter = parameters.filter;
		var entities = cast(parameters.entities, Array<Dynamic>);

		// trace("Filtering on " + (filter == null ? "nothing" : filter));
		var font = "font/Unxgala.ttf";
		var ypos = 0;
		for(e in entities)
		{
			// trace(" Carrying:" + e.get(Name).text);
			var view = new FancyText(e.get(Name).text, 0xFFFFCC, 30, 50, (ypos++ * 30), 0, font);
			view.x = HXP.halfWidth - view.getWidth() / 2;
			addGraphic(view);
		}
	}
}