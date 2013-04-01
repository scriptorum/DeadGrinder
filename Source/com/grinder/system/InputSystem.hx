package com.grinder.system;

import ash.core.Engine;
import ash.core.System;
import ash.core.Node;

import com.grinder.service.EntityService;
import com.grinder.node.PlayerControlNode;
import com.grinder.component.Action;
import com.grinder.component.GridPosition;
import com.grinder.component.GridVelocity;

class InputSystem extends System
{
	public var engine:Engine;
	public var factory:EntityService;
	private var pendingAction:String = null;

	public function new(engine:Engine, factory:EntityService)
	{
		super();
		this.engine = engine;
		this.factory = factory;
	}

	override public function update(_)
	{
		var nextPendingAction = null;
	 	for(node in engine.getNodeList(PlayerControlNode))
	 	{
			var ox:Int = 0;
			var oy:Int = 0;

			if(InputMan.released(InputMan.OPEN))
				nextPendingAction = Action.OPEN;
			else if(InputMan.released(InputMan.CLOSE))
				nextPendingAction = Action.CLOSE;
			else if(InputMan.released(InputMan.LOCK))
				nextPendingAction = Action.LOCK;
			else if(InputMan.released(InputMan.UNLOCK))
				nextPendingAction = Action.UNLOCK;
			else if(InputMan.released(InputMan.ATTACK))
				nextPendingAction = Action.ATTACK;
			else if(InputMan.released(InputMan.ABORT))
			{
				pendingAction = null;
				factory.addMessage("Nevermind.");
			}
			else if(InputMan.released(InputMan.MOVE_N)) { oy--; }
			else if(InputMan.released(InputMan.MOVE_E)) { ox++; } 
			else if(InputMan.released(InputMan.MOVE_W)) { ox--; }
			else if(InputMan.released(InputMan.MOVE_S)) { oy++; }
			else if(InputMan.released(InputMan.MOVE_NE)) { oy--; ox++; }
			else if(InputMan.released(InputMan.MOVE_NW)) { oy--; ox--; }
			else if(InputMan.released(InputMan.MOVE_SW)) { oy++; ox--; }
			else if(InputMan.released(InputMan.MOVE_SE)) { oy++; ox++; }

			if(ox != 0 || oy != 0)
			{
				var player = engine.getEntityByName("player");
				if(player == null)
					throw("Cannot find player component");
				var pos = player.get(GridPosition);
				var dx = pos.x + ox;
				var dy = pos.y + oy;

				if(InputMan.check(com.haxepunk.utils.Key.SHIFT))
				{
					// TODO put up action selector
					var actionTypes = factory.getLegalActions(dx, dy);
					var chosenActionType = actionTypes[0];
					// trace("Valid actions:" + actionTypes + " Chose:" + chosenActionType);
					factory.addActionAt(dx, dy, new Action(chosenActionType));
				}

				else if(pendingAction != null)
				{
					factory.addActionAt(dx,dy, new Action(pendingAction));
					pendingAction = null;
				}

				else player.add(new GridVelocity(ox, oy));
			}
			else if(nextPendingAction != null && nextPendingAction != pendingAction)
			{
				factory.addMessage("Choose a direction."); 		
				pendingAction = nextPendingAction;
			}
	 	}
	}
}