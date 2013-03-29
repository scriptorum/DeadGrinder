package com.grinder.system;

import ash.core.Engine;
import ash.core.System;
import ash.core.Node;

import com.grinder.service.EntityService;
import com.grinder.node.ActionNode;
import com.grinder.component.Action;
import com.grinder.component.GridPosition;
import com.grinder.component.State;
import com.grinder.component.Collision;

class ActionSystem extends System
{
	public var engine:Engine;
	public var factory:EntityService;

	public function new(engine:Engine, factory:EntityService)
	{
		super();
		this.engine = engine;
		this.factory = factory;
	}

	override public function update(_)
	{
	 	for(node in engine.getNodeList(ActionNode))
	 	{
	 		var msg = null;
	 		switch(node.action.type)
	 		{
	 			case Action.OPEN:
	 				msg = "You can't open that.";
	 				if(node.entity.has(Collision))
	 				{
	 					var target:Collision = node.entity.get(Collision);
		 				if(target.type == Collision.CLOSED)
		 				{
		 					msg = "You open the door.";
		 					if(node.entity.has(State))
		 						node.entity.get(State).fsm.changeState("open");
		 					else msg = "The door is stuck";

		 				}
		 				else if(target.type == Collision.LOCKED)
		 					msg = "It seems to be locked.";
	 				}
	 				node.entity.remove(Action);
	 		}

	 		if(msg != null)
	 			factory.addMessage(msg);
	 	}
	}
}