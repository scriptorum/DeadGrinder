package com.grinder.node;

import ash.core.Node;

import com.grinder.component.Carried;
import com.grinder.component.Name;

class InventoryNode extends Node<InventoryNode>
{
	public var carried:Carried;
	public var name:Name;
}