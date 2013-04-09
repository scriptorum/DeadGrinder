package com.grinder.node;

import ash.core.Node;

import com.grinder.component.Equipped;
import com.grinder.component.Name;

class EquippedNode extends Node<EquippedNode>
{
	public var equipped:Equipped;
	public var name:Name;
}