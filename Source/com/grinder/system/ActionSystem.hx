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
import com.grinder.component.Lockable;
import com.grinder.component.Unlockable;
import com.grinder.component.Openable;
import com.grinder.component.Closeable;
import com.grinder.component.Locked;
import com.grinder.component.Description;

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
	 				if(node.entity.has(Openable))
	 				{
	 					msg = "You open it.";
	 					if(node.entity.has(State))
	 						node.entity.get(State).fsm.changeState("open");
	 					else msg = "It's stuck closed!";
	 				}
					else if(node.entity.has(Locked))
						msg = "It seems to be locked.";

	 			case Action.CLOSE:
	 				msg = "You can't close that.";
	 				if(node.entity.has(Closeable))
	 				{
	 					msg = "You close it.";
	 					if(node.entity.has(State))
	 						node.entity.get(State).fsm.changeState("closed");
	 					else msg = "It's stuck open!";
	 				}

	 			case Action.LOCK:
	 				msg = "You can't lock that.";
	 				if(node.entity.has(Lockable))
	 				{
	 					msg = "You lock it.";
	 					if(node.entity.has(State))
	 						node.entity.get(State).fsm.changeState("locked");
	 					else msg = "You can't; the lock is broken!";
	 				}

	 			case Action.UNLOCK:
	 				msg = "You can't unlock that.";
	 				if(node.entity.has(Unlockable))
	 				{
	 					msg = "You unlock it.";
	 					if(node.entity.has(State))
	 						node.entity.get(State).fsm.changeState("closed");
	 					else msg = "You can't; the lock is broken!";
	 				}

	 			case Action.EXAMINE:
	 				if(node.entity.has(Description))
	 					msg = node.entity.get(Description).text;
	 				else msg = "There is nothing interesting about that.";

	 			default:
	 				msg = "This action (" + node.action.type + ") is not implemented.";
	 		}

			node.entity.remove(Action);
	 		if(msg != null)
	 			factory.addMessage(msg);
	 	}
	}
}