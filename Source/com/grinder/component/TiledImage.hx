package com.grinder.component;

import com.grinder.component.GridSize;
import nme.geom.Rectangle;

class TiledImage
{
	public var imagePath:String;
	public var tileSize:GridSize;
	public var tilesAcross:Int;

	public function new(imagePath:String, tileSize:GridSize, tilesAcross:Int)
	{
		this.imagePath = imagePath;
		this.tileSize = tileSize;
		this.tilesAcross = tilesAcross;
	}
}