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
import com.grinder.node.InterestNode;
import com.grinder.component.GridPosition;
import com.grinder.component.GridVelocity;
import com.grinder.component.Collision;
import com.grinder.component.Interest;

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
	 	for(node in engine.getNodeList(InterestNode))
	 	{
	 		// Target is right here! Get'm, boys!
	 		if(node.position.adjacent(node.interest.target))
	 		{
 				trace("TODO: Zombie attack!");
	 		}
		}
 	}
}