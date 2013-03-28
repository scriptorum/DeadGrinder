package com.grinder.node;

import ash.core.Node;
import com.grinder.component.Action;
import com.grinder.component.Collision;

class ActionNode extends Node<ActionNode>
{
	public var action:Action;
	public var collision:Collision;
}