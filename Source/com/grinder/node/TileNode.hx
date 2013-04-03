package com.grinder.node;

import com.grinder.component.GridPosition;
import com.grinder.component.Tile;
import ash.core.Node;

class TileNode extends Node<TileNode>
{
	public var position:GridPosition;
	public var tile:Tile;
}