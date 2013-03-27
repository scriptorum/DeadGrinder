package com.grinder.node;

import com.grinder.component.GridPosition;
import com.grinder.component.GridVelocity;
import com.grinder.component.Display;
import ash.core.Node;

class CollisionNode extends Node<CollisionNode>
{
	public var position:GridPosition;
	public var velocity:GridVelocity;
	public var display:Display;
}