package com.grinder.node;

import com.grinder.component.Position;
import com.grinder.component.Grid;
import com.grinder.component.TileImage;
import ash.core.Node;

class GridNode extends Node<GridNode>
{
	public var position:Position;
	public var grid:Grid;
	public var tileImage:TileImage;
}