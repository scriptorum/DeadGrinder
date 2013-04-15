/*
 * Zombies with no interest in a target go wandering
 */

package com.grinder.system;

import ash.core.Entity;
import ash.core.Engine;
import ash.core.System;
import ash.core.Node;

import com.scriptorum.Util;

import com.grinder.service.EntityService;
import com.grinder.node.ZombieNode;
import com.grinder.component.GridVelocity;
import com.grinder.component.Prey;

class WanderingSystem extends TurnBasedSystem
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
	 	for(node in engine.getNodeList(ZombieNode))
	 	{
	 		if(!node.entity.has(Prey))
	 		{
	 			if(Math.random() < .5) // 50% chance he doesn't do anything
	 			{
	 				var ox = Util.rnd(-1,1);
	 				var oy = Util.rnd(-1,1);
	 				if(!(ox == 0 && oy == 0))
	 					node.entity.add(new GridVelocity(ox,oy)); // zed moves randomly
	 				// else trace("Zombie confused");
	 			}
	 		}
	 	}
 	}
}