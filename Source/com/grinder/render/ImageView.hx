package com.grinder.render;

import com.grinder.component.Tile;
import com.grinder.component.GridPosition;
import com.grinder.component.Position;
import com.grinder.component.Image;

class ImageView extends View
{
	private var tile:Tile;
	private var image:Image;

	override public function begin()
	{
		// trace("Placing sprite entity at layer " + this.layer);
		if(hasComponent(Tile))
			setTile();

		else if(hasComponent(Image))
			setImage();

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

	private function setTile()
	{
		tile = getComponent(Tile);
		graphic = new com.haxepunk.graphics.Image(tile.tiledImage.imagePath, tile.rect());
	}

	private function setImage()
	{
		image = getComponent(Image);
		graphic = new com.haxepunk.graphics.Image(image.path);
	}

	override public function nodeUpdate()
	{
		// TileNode
		if(hasComponent(GridPosition) && hasComponent(Tile))
		{
			if(this.tile != getComponent(Tile))
				setTile();
			var gpos = getComponent(GridPosition);
			var tileSize = getComponent(Tile).tiledImage.tileSize;
			x = gpos.x * tileSize.width;
			y = gpos.y * tileSize.height;
			visible = true;
		}

		// ImageNode
		else if(hasComponent(Position))
		{
			if(this.image != getComponent(Image))
				setImage();
			var pos = getComponent(Position);
			x = pos.x;
			y = pos.y;
			visible = true;
		}

		else { visible = false;}
	}
}