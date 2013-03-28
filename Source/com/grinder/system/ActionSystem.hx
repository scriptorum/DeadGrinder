package com.grinder.system;

import ash.core.Engine;
import ash.core.System;
import ash.core.Node;

import com.grinder.node.ActionNode;
import com.grinder.component.Action;
import com.grinder.component.GridPosition;
import com.grinder.component.State;
import com.grinder.component.Collision;

class ActionSystem extends System
{
	public var engine:Engine;

	public function new(engine:Engine)
	{
		super();
		this.engine = engine;
	}

	override public function update(_)
	{
	 	for(node in engine.getNodeList(ActionNode))
	 	{
	 		switch(node.action.type)
	 		{
	 			case Action.OPEN:
	 				var msg = "You can't open that.";
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
	 				trace(msg);
	 		}
	 	}
	}
}