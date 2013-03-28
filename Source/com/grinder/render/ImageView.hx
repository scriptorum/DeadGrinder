package com.grinder.render;

import com.grinder.component.Tile;
import com.grinder.component.GridPosition;
import com.grinder.component.Collision;

import com.haxepunk.graphics.Image;

//  Should view classes such as this know about nodes?
class ImageView extends View
{
	override public function begin()
	{
		// trace("Placing sprite entity at layer " + this.layer);
		var tile = getComponent(Tile);	
		var image = new Image(tile.tiledImage.imagePath, tile.rect());
		graphic = image;

		// if(entity.has(Collision))
		// {
		// 	setHitbox(image.width, image.height);
		// 	type = getComponent(Collision).type;
		// 	collidable = true;
		// }
	}

	override public function nodeUpdate()
	{
		var position = getComponent(GridPosition);
		var tile = getComponent(Tile);

		x = position.x * tile.tiledImage.tileSize.width;
		y = position.y * tile.tiledImage.tileSize.height;
	}
}