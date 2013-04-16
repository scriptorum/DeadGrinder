/*
 * Zombies adjacent to their target attack it
 */

package com.grinder.system;

import ash.core.Entity;
import ash.core.Engine;
import ash.core.System;
import ash.core.Node;

import com.scriptorum.Util;

import com.grinder.service.EntityService;
import com.grinder.node.PreyNode;
import com.grinder.component.GridPosition;
import com.grinder.component.GridVelocity;
import com.grinder.component.Collision;
import com.grinder.component.Health;
import com.grinder.component.Damager;

class EnemyAttackSystem extends TurnBasedSystem
{
	public var engine:Engine;
	public var factory:EntityService;

	public function new(engine:Engine, factory:EntityService)
	{
		super();
		this.engine = engine;
		this.factory = factory;
	}

	override public function takeTurn()
	{
	 	for(node in engine.getNodeList(PreyNode))
	 	{
	 		// Target is right here! Get'm, boys!
	 		if(node.position.adjacent(node.prey.position))
	 		{
	 			var msg = null;
	 			var entity = node.prey.entity;
	 			if(node.prey.entity.has(Health))
	 			{
	 				var damage = node.entity.get(Damager).rand();
					factory.mutateHealth(node.prey.entity, -damage);
	 				msg = "The " + factory.getName(node.entity) + " bites you for " + damage + " damage!";
	 			}
	 			else msg = "The zombie chews on the recently dead " + factory.getName(node.prey.entity) + ".";

	 			if(msg != null)
	 				factory.addMessage(msg);
	 		}
		}
 	}
}