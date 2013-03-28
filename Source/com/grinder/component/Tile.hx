package com.grinder.component;

import nme.geom.Rectangle;
import com.grinder.component.TiledImage;

class Tile
{
	public var tiledImage:TiledImage;
	public var tile:Int;

	public function new(tiledImage:TiledImage, tile:Int)
	{
		this.tiledImage = tiledImage;
		this.tile = tile;
	}

	public function x(): Int
	{
		return tile % tiledImage.tilesAcross;
	}

	public function y(): Int
	{
		return Math.floor(tile / tiledImage.tilesAcross);
	}

	public function rect(): Rectangle
	{
		var x = x();
		var y = y();
		return new Rectangle(x * tiledImage.tileSize.width, y * tiledImage.tileSize.height, 
			tiledImage.tileSize.width, tiledImage.tileSize.height);
	}
}