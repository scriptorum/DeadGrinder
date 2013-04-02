package com.grinder.system;

import ash.core.Engine;
import ash.core.System;
import ash.core.Node;

import com.haxepunk.utils.Key;

import com.grinder.component.Action;
import com.grinder.component.GridPosition;
import com.grinder.component.GridVelocity;
import com.grinder.component.Description;
import com.grinder.node.PlayerControlNode;
import com.grinder.node.InventoryNode;
import com.grinder.service.EntityService;
import com.grinder.service.InputService;

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

			switch(InputService.lastKey())
			{
				case Key.O:
					nextPendingAction = Action.OPEN;
				case Key.C:
					nextPendingAction = Action.CLOSE;
				case Key.L:
					nextPendingAction = Action.LOCK;
				case Key.U:
					nextPendingAction = Action.UNLOCK;
				case Key.A:
					nextPendingAction = Action.ATTACK;
				case '.'.charCodeAt(0), Key.NUMPAD_DECIMAL:
					// TODO wait
				case 188, Key.P, Key.T: // 188=","" ??? that's odd
					var pos = engine.getEntityByName("player").get(GridPosition);
					factory.addActionAt(pos.x, pos.y, new Action(Action.TAKE));
				case Key.ESCAPE:
					if(pendingAction != null)
					{
						pendingAction = null;
						factory.addMessage("Nevermind.");
					}
				case Key.I:
					var player = engine.getEntityByName("player");
					var carrier = player.get(com.grinder.component.Carrier);
					for(node in engine.getNodeList(InventoryNode))
					{
						if(node.carried.carrier == carrier.id)
							trace(" - " + node.entity.get(Description).text);
					}
				case Key.UP, Key.DIGIT_8, Key.NUMPAD_8:
					oy--;
				case Key.DOWN, Key.DIGIT_2, Key.NUMPAD_2:
					oy++;
				case Key.RIGHT, Key.DIGIT_6, Key.NUMPAD_6:
					ox++;
				case Key.LEFT, Key.DIGIT_4, Key.NUMPAD_4:
					ox--;
				case Key.DIGIT_7, Key.NUMPAD_7:
					ox--;
					oy--;
				case Key.DIGIT_9, Key.NUMPAD_9:
					ox++;
					oy--;
				case Key.DIGIT_1, Key.NUMPAD_1:
					ox--;
					oy++;
				case Key.DIGIT_3, Key.NUMPAD_3:
					ox++;
					oy++;
				// default:
				// if(InputService.lastKey() != null)
				// 	trace("Untrapped key:" + InputService.lastKey() + " char:" + String.fromCharCode(InputService.lastKey()));
			}
			InputService.clearLastKey();

			if(ox != 0 || oy != 0)
			{
				var player = engine.getEntityByName("player");
				if(player == null)
					throw("Cannot find player component");
				var pos = player.get(GridPosition);
				var dx = pos.x + ox;
				var dy = pos.y + oy;

				if(InputService.check(com.haxepunk.utils.Key.SHIFT))
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