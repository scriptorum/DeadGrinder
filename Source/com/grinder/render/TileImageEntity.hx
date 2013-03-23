package com.grinder.render;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Image;

import com.grinder.node.TileImageNode;

class TileImageEntity extends Entity
{
	public function new(node:TileImageNode)
	{
		super();
		var image = new Image(node.tileImage.image, node.tileImage.rect);
		graphic = image;
		updatePosition(node);
	}

	// Move haxepunk entity to a grid position
	public function updatePosition(node:TileImageNode)
	{
		x = node.position.x * node.tileImage.rect.width;
		y = node.position.y * node.tileImage.rect.height;
	}
}