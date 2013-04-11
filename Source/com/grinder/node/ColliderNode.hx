package com.grinder.node;

import com.grinder.component.GridPosition;
import com.grinder.component.GridVelocity;
import com.grinder.component.Display;
import com.grinder.component.Collision;
import ash.core.Node;

class ColliderNode extends Node<ColliderNode>
{
	public var position:GridPosition;
	public var velocity:GridVelocity;
	public var collision:Collision;
}