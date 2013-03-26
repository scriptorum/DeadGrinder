package com.grinder.render;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Tilemap;

import com.grinder.node.GridNode;
import com.grinder.component.Layer;

//  Should view classes such as this know about nodes?
class GridView extends Entity
{
	public var tileMap:Tilemap;
	public var node:GridNode;

	public function new(node:GridNode)
	{
		super();

		var c = node.entity.get(Layer);
		if(c != null)
			this.layer = c.layer;

		var tileWidth = Std.int(node.tileImage.clip.width);
		var tileHeight = Std.int(node.tileImage.clip.height);

		// trace("Placing grid entity at layer " + this.layer + " with grid size:" + node.grid.width + "x" + node.grid.height + 
		// 	" tile size:" + tileWidth + "x" + tileHeight + " and image:" + node.tileImage.path);

		// TODO get standard tile dimensions from some other source than the image clipping rectangle??
		this.tileMap = new Tilemap(node.tileImage.path, tileHeight * node.grid.width, tileWidth * node.grid.height,
			tileWidth, tileHeight);
		graphic = tileMap;
		this.node = node;

		updateGrid();
		updatePosition();
	}

	public function updateNode()
	{
		updateGrid();
		updatePosition();
	}

	public function updateGrid()
	{
		// trace("Updating grid");
		var g = node.grid;
		for(y in 0...g.height)
		for(x in 0...g.width)
			tileMap.setTile(x, y, g.get(x, y));
	}

	// Move haxepunk entity to a grid position
	public function updatePosition()
	{
		x = node.position.x * node.tileImage.clip.width;
		y = node.position.y * node.tileImage.clip.height;
	}
}