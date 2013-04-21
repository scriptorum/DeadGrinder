package com.grinder.render;

import com.grinder.component.Tile;
import com.grinder.component.GridPosition;
import com.grinder.component.Position;
import com.grinder.component.Image;
import nme.geom.Rectangle;

class ImageView extends View
{
	private var tile:Tile;
	private var image:Image;
	private var clip:Rectangle;
	private var gx:Int;
	private var gy:Int;

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
		updateScrollFactor();
	}

	private function setImage()
	{
		image = getComponent(Image);
		graphic = new com.haxepunk.graphics.Image(image.path, image.clip);
		clip = image.clip;
		updateScrollFactor();
	}

	override public function nodeUpdate()
	{
		// TileNode
		if(hasComponent(GridPosition) && hasComponent(Tile))
		{
			if(this.tile != getComponent(Tile))
				setTile();
			var gpos = getComponent(GridPosition);

			if(gpos.x != gx || gpos.y != gy)
			{
				var tileSize = getComponent(Tile).tiledImage.tileSize;
				gx = gpos.x;
				gy = gpos.y;
				x = gx * tileSize.width;
				y = gy * tileSize.height;
				visible = true;
			}
		}

		// ImageNode
		else if(hasComponent(Position) && hasComponent(Image))
		{
			var nextImage = getComponent(Image);
			if(this.image != nextImage || nextImage.clip != this.clip)
				setImage();
			var pos = getComponent(Position);
			if(pos.x != x || pos.y != y)
			{
				x = pos.x;
				y = pos.y;
				visible = true;
			}
		}

		else { visible = false; }
	}
}