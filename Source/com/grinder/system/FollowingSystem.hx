/*
 * Zombies with an interest in a target seek it out
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

class FollowingSystem extends TurnBasedSystem
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
	 		trace(node.entity.name);
	 		var interest = node.interest;
	 		// Shamble towards target, speed based on distance
	 		// TODO a creature shambling towards a position that hits a wall should look for a way around the wall
	 		var roll = Math.random() * 100;
 			if(roll <= interest.amount) // chance he shuffles towards you based on interest
 			{
 				var dx = Util.sign(interest.target.x - node.position.x);
 				var dy = Util.sign(interest.target.y - node.position.y);
 				if(!(dx == 0 && dy == 0))
 					node.entity.add(new GridVelocity(dx, dy));
 			}
 			// else growl
 		}
 	}
}