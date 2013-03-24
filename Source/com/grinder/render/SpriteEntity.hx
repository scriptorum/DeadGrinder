package com.grinder.render;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

import com.grinder.node.SpriteNode;
import com.grinder.component.Layer;

//  Should view classes such as this know about nodes?
class SpriteEntity extends Entity
{
	public function new(node:SpriteNode)
	{
		var c = node.entity.get(Layer);
		if(c != null)
			this.layer = c.layer;

		super();

		var image = new Image(node.tileImage.image, node.tileImage.rect);
		graphic = image;
		updatePosition(node);
	}

	// Move haxepunk entity to a grid position
	public function updatePosition(node:SpriteNode)
	{
		x = node.position.x * node.tileImage.rect.width;
		y = node.position.y * node.tileImage.rect.height;
	}
}