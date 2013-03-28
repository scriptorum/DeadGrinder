package com.grinder.system;

import ash.core.Engine;
import ash.core.System;
import ash.core.Node;

import com.grinder.node.ActionNode;
import com.grinder.node.CollisionNode;
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
	 			var a = getEntitiesAt(CollisionNode, node.action.target);
	 			if(a.length == 0)
	 				trace("There is nothing there to open.");
	 			else if(a.length > 1)
	 				throw "Multiple collidable entities found in one grid space";
	 			else 
	 			{
	 				var target:CollisionNode = cast(a[0], CollisionNode);
	 				if(target.collision.type == Collision.CLOSED)
	 				{
	 					trace("You open the door.");
	 					if(target.entity.has(State))
	 					{
	 						target.entity.get(State).fsm.changeState("open");
	 						node.entity.remove(Action);
	 					}
	 					else throw "No state object found on door";

	 				}
	 				else if(target.collision.type == Collision.LOCKED)
	 					trace("It seems to be locked.");

	 				else trace("You can't open that.");
	 			}
	 		}
	 	}
	}

	private function getEntitiesAt<T:Node<T>>(nodeType:Class<T>, position:GridPosition): Array<T>
	{
		var a = new Array<T>();
		for(node in engine.getNodeList(nodeType))
		{
			var p = node.entity.get(GridPosition);
			if(p == null)
				throw "getEntitiesAt: Must pass a node that includes a GridPosition";
			else if(p.equals(position))
				a.push(node);
		}
		return a;
	}
}