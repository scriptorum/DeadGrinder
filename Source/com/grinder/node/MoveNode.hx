package com.grinder.node;

import com.grinder.component.GridPosition;
import com.grinder.component.GridVelocity;
import ash.core.Node;

class MoveNode extends Node<MoveNode>
{
	public var position:GridPosition;
	public var velocity:GridVelocity;
}