package com.grinder.system;

import ash.core.Engine;
import ash.core.System;

import com.grinder.node.MoveNode;

class MovementSystem extends System
{
	public var engine:Engine;

	public function new(engine:Engine)
	{
		super();
		this.engine = engine;
	}

	override public function update(_)
	{
	 	for(node in engine.getNodeList(MoveNode))
	 	{
	 		node.position.x += node.velocity.x;
	 		node.position.y += node.velocity.y;

	 		node.entity.remove(com.grinder.component.GridVelocity);
	 	}
	}
}