package com.grinder.render;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Backdrop;

import com.grinder.node.BackdropNode;
import com.grinder.component.Layer;

class BackdropView extends Entity
{
	public function new(node:BackdropNode)
	{
		super();

		var c = node.entity.get(Layer);
		if(c != null)
			this.layer = c.layer;

		// trace("Placing backdrop entity at layer " + layer);

		var backdrop = new Backdrop(node.image.path);
		graphic = backdrop;
	}
}