package com.grinder.render;

import com.grinder.component.Tile;
import com.grinder.component.GridPosition;
import com.grinder.component.Position;
import com.grinder.component.Image;

class ImageView extends View
{
	override public function begin()
	{
		// trace("Placing sprite entity at layer " + this.layer);
		if(hasComponent(Tile))
		{
			var tile = getComponent(Tile);
			graphic = new com.haxepunk.graphics.Image(tile.tiledImage.imagePath, tile.rect());
		}

		else if(hasComponent(Image))
			graphic = new com.haxepunk.graphics.Image(getComponent(Image).path);

		else
			throw("ImageView requires either Tile or Image component");

		// if(entity.has(Collision))
		// {
		// 	setHitbox(image.width, image.height);
		// 	type = getComponent(Collision).type;
		// 	collidable = true;
		// }

		nodeUpdate();
	}

	override public function nodeUpdate()
	{
		// TileNode
		if(hasComponent(GridPosition) && hasComponent(Tile))
		{
			var gpos = getComponent(GridPosition);
			var tileSize = getComponent(Tile).tiledImage.tileSize;
			x = gpos.x * tileSize.width;
			y = gpos.y * tileSize.height;
			visible = true;
		}

		// ImageNode
		else if(hasComponent(Position))
		{
			var pos = getComponent(Position);
			x = pos.x;
			y = pos.y;
			visible = true;
		}

		else { visible = false;}
	}
}