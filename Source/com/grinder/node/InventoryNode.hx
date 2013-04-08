package com.grinder.node;

import ash.core.Node;

import com.grinder.component.Inventory;
import com.grinder.component.Position;

class InventoryNode extends Node<InventoryNode>
{
	public var inventory:Inventory;
	public var position:Position;
}