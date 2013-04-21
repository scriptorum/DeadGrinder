package com.grinder.render;

import com.grinder.component.TiledImage;
import com.grinder.component.Position;
import com.grinder.component.Grid;

import com.haxepunk.graphics.Tilemap;

//  Should view classes such as this know about nodes?
class GridView extends View
{
	public var tileMap:Tilemap;
	public var tileWidth:Int;
	public var tileHeight:Int;

	override public function begin()	
	{
		var tiledImage = getComponent(TiledImage);
		var grid = getComponent(Grid);

		tileWidth = tiledImage.tileSize.width;
		tileHeight = tiledImage.tileSize.height;

		// TODO get standard tile dimensions from some other source than the image clipping rectangle??
		tileMap = new Tilemap(tiledImage.imagePath, tileWidth * grid.width, tileHeight * grid.height,
			tileWidth, tileHeight);
		graphic = tileMap;

		// trace("Made a tilemap with tileDim:" + tileWidth + "x" + tileHeight + " gridDim:" + grid.width + "x" + grid.height +
		// 	" image:" + tiledImage.imagePath);
	}

	override public function nodeUpdate()
	{
		updateGrid();
		updatePosition();
	}

	public function updateGrid()
	{
		// trace("Updating grid");
		var g = getComponent(Grid);
		if(g.changed)
		{
			for(y in 0...g.height)
			for(x in 0...g.width)
				tileMap.setTile(x, y, g.get(x, y));
			g.changed = false;
		}
	}

	public function updatePosition()
	{
		var position = getComponent(Position);
		if(position.x != x || position.y != y)
		{
			x = position.x;
			y = position.y;
		}
	}
}