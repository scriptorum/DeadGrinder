package com.grinder.render;

import com.grinder.component.TileImage;
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
		var tileImage = getComponent(TileImage);
		var grid = getComponent(Grid);

		tileWidth = Std.int(tileImage.clip.width);
		tileHeight = Std.int(tileImage.clip.height);

		// TODO get standard tile dimensions from some other source than the image clipping rectangle??
		tileMap = new Tilemap(tileImage.path, tileHeight * grid.width, tileWidth * grid.height,
			tileWidth, tileHeight);
		graphic = tileMap;
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
		for(y in 0...g.height)
		for(x in 0...g.width)
			tileMap.setTile(x, y, g.get(x, y));
	}

	public function updatePosition()
	{
		var position = getComponent(Position);
		x = position.x;
		y = position.y;
	}
}