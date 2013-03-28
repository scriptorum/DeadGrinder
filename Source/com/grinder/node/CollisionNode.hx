package com.grinder.node;

import com.grinder.component.GridPosition;
import com.grinder.component.Collision;
import ash.core.Node;

class CollisionNode extends Node<CollisionNode>
{
	public var position:GridPosition;
	public var collision:Collision;
}