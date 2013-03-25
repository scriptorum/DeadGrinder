package com.grinder.render;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

import com.grinder.node.GridNode;
import com.grinder.component.Layer;

//  Should view classes such as this know about nodes?
class GridView extends Entity
{
	public function new(grid:Grid)
	{
		super();

		var c = node.entity.get(Layer);
		if(c != null)
			this.layer = c.layer;

		// trace("Placing sprite entity at layer " + layer);

		var image = new Image(node.tileImage.path, node.tileImage.clip);
		graphic = image;
		updatePosition(node);
	}

	// Move haxepunk entity to a grid position
	public function updatePosition(node:SpriteNode)
	{
		x = node.position.x * node.tileImage.clip.width;
		y = node.position.y * node.tileImage.clip.height;
	}
}