package com.grinder.render;

import ash.core.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Graphiclist;
import com.haxepunk.graphics.Image;
import com.grinder.render.FancyText;
import com.grinder.component.Name;
import com.grinder.component.Inventory;

class InventoryView extends View
{
	public static inline var lineFeed = 40;
	public static inline var fontSize = 40;

	private var font:String = "font/Unxgala.ttf";
	private var inventory:Inventory;
	private var background:Image;

	override public function begin()
	{
		background = new Image("art/list.png");
		background.scrollX = background.scrollY = 0;

		inventory = entity.get(Inventory);
	}

	public function clearText():   Void
	{
		graphic = new Graphiclist();
		addGraphic(background);
	}

	override public function nodeUpdate(): Void
	{
		if(!inventory.changed)
			return;

		inventory.changed = false;
		clearText();

		// trace("Filtering on " + (filter == null ? "nothing" : filter));
		for(i in 0...inventory.entities.length)
		{
			var ypos = HXP.halfHeight + (i - inventory.selected) * lineFeed - lineFeed / 2; 
			var e:Entity = inventory.entities[i];
			// trace(" Carrying:" + e.get(Name).text);
			var view = new FancyText(e.get(Name).text, (inventory.selected == i ? 0xFFFFFF : 0xFFFFCC), 
				fontSize, 0, ypos, 0, font);
			view.x = HXP.halfWidth - view.getWidth() / 2;
			addGraphic(view);
		}
	}
}