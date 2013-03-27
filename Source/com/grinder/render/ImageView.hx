package com.grinder.render;

import com.grinder.component.TileImage;
import com.grinder.component.GridPosition;
import com.grinder.component.Collision;

import com.haxepunk.graphics.Image;

//  Should view classes such as this know about nodes?
class ImageView extends View
{
	override public function begin()
	{
		// trace("Placing sprite entity at layer " + this.layer);
		var tileImage = getComponent(TileImage);	
		var image = new Image(tileImage.path, tileImage.clip);
		graphic = image;

		if(entity.has(Collision))
		{
			setHitbox(image.width, image.height);
			type = getComponent(Collision).type;
			collidable = true;
		}
	}

	override public function nodeUpdate()
	{
		var position = getComponent(GridPosition);
		var tileImage = getComponent(TileImage);

		x = position.x * tileImage.clip.width;
		y = position.y * tileImage.clip.height;
	}
}