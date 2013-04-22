/*
 */
package com.grinder.system;

import ash.core.Engine;
import ash.core.System;

import com.grinder.node.MoveNode;
import com.grinder.component.GridVelocity;
import com.grinder.service.GridService;
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

 			var newx = node.position.x + node.velocity.x;
 			var newy = node.position.y + node.velocity.y;
	 		GridService.move(node.entity, newx, newy);
	 		node.position.x = newx;
	 		node.position.y = newy;

	 		node.entity.remove(GridVelocity);
	 	}
	}
}