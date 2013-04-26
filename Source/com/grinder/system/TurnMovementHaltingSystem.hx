/*
 * Removes any GridVelocity objects still on entities. Turn based movement means you wait, bitches.
 */

package com.grinder.system;

import ash.core.Entity;
import ash.core.Engine;

import com.grinder.component.GridVelocity;
import com.grinder.node.TurnMovementNode;
import com.grinder.system.TurnBasedSystem;

class TurnMovementHaltingSystem extends TurnBasedSystem
{
	public var engine:Engine;

	public function new(engine:Engine)
	{
		super();
		this.engine = engine;
	}

	override public function takeTurn()
	{
	 	for(node in engine.getNodeList(TurnMovementNode))
	 		node.entity.remove(GridVelocity);
	}
}