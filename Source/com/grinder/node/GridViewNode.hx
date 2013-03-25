package com.grinder.node;

import com.grinder.component.Position;
import com.grinder.component.Grid;
import com.grinder.component.TileImage;
import com.grinder.render.GridView;
import ash.core.Node;

class GridViewNode extends Node<GridViewNode>
{
	public var position:Position;
	public var grid:Grid;
	public var tileImage:TileImage;
	public var view:GridView;
}