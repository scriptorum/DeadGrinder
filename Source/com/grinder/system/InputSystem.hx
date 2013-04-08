package com.grinder.system;

import ash.core.Engine;
import ash.core.System;
import ash.core.Node;

import com.haxepunk.utils.Key;

import com.grinder.component.Action;
import com.grinder.component.GridPosition;
import com.grinder.component.GridVelocity;
import com.grinder.component.Inventory;
import com.grinder.component.Description;
import com.grinder.component.Name;
import com.grinder.component.InventoryControl;
import com.grinder.component.PlayerControl;
import com.grinder.node.PlayerControlNode;
import com.grinder.node.InventoryControlNode;
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
		handlePlayerControl();
		handleInventoryControl();
	}

	public function handleInventoryControl()
	{
	 	for(node in engine.getNodeList(InventoryControlNode))
	 	{
			switch(InputService.lastKey())
			{
				case '.'.charCodeAt(0), 190, Key.NUMPAD_DECIMAL, Key.SPACE, Key.DIGIT_5, Key.NUMPAD_5:
					var inventory = engine.getEntityByName("inventory").get(Inventory);
					trace("TODO: You selected " + inventory.entities[inventory.selected].get(Name).text);
					// TODO If selected and equipmentType specified, add Equipped ... probably deequip first.
					factory.closeInventory();

				case Key.ESCAPE:
					factory.closeInventory();

				case Key.UP, Key.DIGIT_8, Key.NUMPAD_8:
					var inventory = engine.getEntityByName("inventory").get(Inventory);
					if(--inventory.selected < 0)
						inventory.selected = inventory.entities.length - 1;
					inventory.changed = true;

				case Key.DOWN, Key.DIGIT_2, Key.NUMPAD_2:
					var inventory = engine.getEntityByName("inventory").get(Inventory);
					if(++inventory.selected >= inventory.entities.length)
						inventory.selected = 0;
					inventory.changed = true;
			}
			InputService.clearLastKey();
		}
	}

	public function handlePlayerControl()
	{
		var shiftIsDown = InputService.check(com.haxepunk.utils.Key.SHIFT);
		var nextPendingAction = null;
	 	for(node in engine.getNodeList(PlayerControlNode))
	 	{
	 		var pos:Array<Int> = null;
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
				case '.'.charCodeAt(0), 190, Key.NUMPAD_DECIMAL: // 190="." ....wtf
					if(shiftIsDown)
						pos = [0, 0];
					else factory.addMessage("Waiting..."); // TODO
				case 188, Key.P, Key.T: // 188=","" ??? that's odd
					var gp = engine.getEntityByName("player").get(GridPosition);
					factory.addActionAt(gp.x, gp.y, new Action(Action.TAKE));
				case Key.ESCAPE:
					if(pendingAction != null)
					{
						pendingAction = null;
						factory.addMessage("Nevermind.");
					}
				case Key.I:
					factory.popupInventory();
					// var player = engine.getEntityByName("player");
					// var carrier = player.get(com.grinder.component.Carrier);
					// for(node in engine.getNodeList(InventoryNode))
					// {
					// 	if(node.carried.carrier == carrier.id)
					// 		trace(" - " + node.entity.get(Description).text);
					// }
				case Key.UP, Key.DIGIT_8, Key.NUMPAD_8:
					pos = [0, -1];
				case Key.DOWN, Key.DIGIT_2, Key.NUMPAD_2:
					pos = [0, 1];
				case Key.RIGHT, Key.DIGIT_6, Key.NUMPAD_6:
					pos = [1, 0];
				case Key.LEFT, Key.DIGIT_4, Key.NUMPAD_4:
					pos = [-1, 0];
				case Key.DIGIT_7, Key.NUMPAD_7:
					pos = [-1, -1];
				case Key.DIGIT_9, Key.NUMPAD_9:
					pos = [1, -1];
				case Key.DIGIT_1, Key.NUMPAD_1:
					pos = [-1, 1];
				case Key.DIGIT_3, Key.NUMPAD_3:
					pos = [1, 1];
				default:
				// if(InputService.lastKey() != null)
				// {
				// 	trace("Untrapped key:" + InputService.lastKey());
				// 	trace("As char:" + String.fromCharCode(InputService.lastKey()));
				// }
			}
			InputService.clearLastKey();

			if(pos != null)
			{
				var player = engine.getEntityByName("player");
				if(player == null)
					throw("Cannot find player component");
				var playerPos = player.get(GridPosition);
				var dx = playerPos.x + pos[0];
				var dy = playerPos.y + pos[1];

				if(shiftIsDown)
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

				else player.add(new GridVelocity(pos[0], pos[1]));
			}

			else if(nextPendingAction != null && nextPendingAction != pendingAction)
			{
				factory.addMessage("Choose a direction."); 		
				pendingAction = nextPendingAction;
			}
	 	}
	}

}