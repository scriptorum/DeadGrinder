package com.grinder.system;

import ash.core.Engine;
import ash.core.System;

import com.grinder.node.MoveNode;
import com.grinder.component.GridVelocity;
import com.grinder.service.EntityService;

class MovementSystem extends System
{
	public var factory:EntityService;
	public var engine:Engine;

	public function new(engine:Engine, factory:EntityService)
	{
		super();
		this.engine = engine;
		this.factory = factory;
	}

	override public function update(_)
	{
	 	for(node in engine.getNodeList(MoveNode))
	 	{
	 		node.position.x += node.velocity.x;
	 		node.position.y += node.velocity.y;

	 		node.entity.remove(GridVelocity);
	 	}
	}
}