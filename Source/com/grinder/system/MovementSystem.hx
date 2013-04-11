package com.grinder.system;

import ash.core.Engine;
import ash.core.System;

import com.grinder.node.MoveNode;
import com.grinder.component.GridVelocity;
import com.grinder.service.EntityService;
import com.grinder.system.TurnBasedSystem;

/*
 * Anything with a GridPosition and a GridVelocity will be touched by this turn-based system.
 * The velocity component is removed by this action bringing it to stop. It's turn-based after all.
 * TODO Rename to TurnMovementSystem
 */
class MovementSystem extends TurnBasedSystem
{
	public var factory:EntityService;
	public var engine:Engine;

	public function new(engine:Engine, factory:EntityService)
	{
		super();
		this.engine = engine;
		this.factory = factory;
	}

	override public function takeTurn()
	{
	 	for(node in engine.getNodeList(MoveNode))
	 	{
	 		// trace("Adjusting movement for " + node.entity.name + " pos:" + node.position + " vel:" + node.velocity);
	 		node.position.x += node.velocity.x;
	 		node.position.y += node.velocity.y;

	 		node.entity.remove(GridVelocity);
	 	}
	}
}