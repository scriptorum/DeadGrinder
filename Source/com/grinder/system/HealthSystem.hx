package com.grinder.system;

import ash.core.Engine;
import ash.core.System;

import com.grinder.node.HealthNode;
import com.grinder.component.Health;
import com.grinder.component.State;
import com.grinder.service.EntityService;

class HealthSystem extends System
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
	 	for(node in engine.getNodeList(HealthNode))
	 	{
	 		if(node.health.amount < 0)
 			{
				if(node.entity.has(State))
				{
					factory.addMessage("It falls down and stops moving.");
					node.entity.get(State).fsm.changeState("dead");
				}
				else 
				{
					factory.addMessage("It's dead, Jim.");
			 		node.entity.remove(Health);
				}
 			}
	 	}
	}
}