package com.grinder.system;

import ash.core.Engine;
import ash.core.System;
import ash.core.Node;
import ash.core.Entity;

import com.haxepunk.utils.Key;

import com.grinder.component.Action;
import com.grinder.component.GridPosition;
import com.grinder.component.GridVelocity;
import com.grinder.component.Inventory;
import com.grinder.component.Description;
import com.grinder.component.Name;
import com.grinder.component.Equipment;
import com.grinder.component.Control;
import com.grinder.node.ControlNode;
import com.grinder.service.EntityService;
import com.grinder.service.InputService;
import com.grinder.service.ConfigService;

class InputSystem extends System
{
	public var engine:Engine;
	public var factory:EntityService;
	private var pendingAction:Action = null;

	public function new(engine:Engine, factory:EntityService)
	{
		super();
		this.engine = engine;
		this.factory = factory;
	}

	override public function update(_)
	{
		var key = InputService.lastKey();
		if(key == 0)
			return;

		handlePlayerControl(key);
		handleInventoryControl(key);
		// handleGameOverControl(key);

		InputService.clearLastKey();
	}

	public function handleInventoryControl(key:Int)
	{
		if(key == 0)
			return;

	 	for(node in engine.getNodeList(InventoryControlNode)) // Should only be 0-1
	 	{
			switch(key)
			{
				case '.'.charCodeAt(0), 190, Key.NUMPAD_DECIMAL, Key.SPACE, Key.DIGIT_5, Key.NUMPAD_5, Key.ENTER:
					var inventory = engine.getEntityByName("inventory").get(Inventory);
					var item:Entity = inventory.entities[inventory.selected];
					if(inventory.actionType != null)
					{
						item.add(new Action(inventory.actionType, factory.player()));
						advanceTurn();
					}
					factory.closeInventory();

				case Key.ESCAPE:
					factory.closeInventory();
					factory.addMessage("Never mind.");

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
		}
	}

	public function handlePlayerControl(key:Int)
	{
		var shiftIsDown = InputService.check(com.haxepunk.utils.Key.SHIFT);
	 	for(node in engine.getNodeList(PlayerControlNode))
	 	{
	 		var pos:Array<Int> = null;
			switch(key)
			{
				case Key.O:
					pendingAction = new Action(Action.OPEN, factory.player());
				case Key.C:
					pendingAction = new Action(Action.CLOSE, factory.player());
				case Key.L:
					pendingAction = new Action(Action.LOCK, factory.player());
				case Key.U:
					pendingAction = new Action(Action.UNLOCK, factory.player());
				case Key.A:
					var weapons = factory.getEquipmentFor(factory.player(), Equipment.WEAPON);
					var damager = (weapons.length == 0 ? factory.player() : weapons[0]); // Player can wield only one weapon
					pendingAction = new Action(Action.ATTACK, damager);
				case '.'.charCodeAt(0), 190, Key.NUMPAD_DECIMAL: // 190="." ....wtf
					if(shiftIsDown)
						pos = [0, 0];
					else 
					{
						factory.addMessage("Waiting...");
						advanceTurn();
					}
				case 188, Key.P, Key.T: // 188="," ??? that's odd
					var source = factory.player();
					var gp = source.get(GridPosition);
					factory.addActionAt(gp.x, gp.y, new Action(Action.TAKE, source));
					advanceTurn();
				case Key.ESCAPE:
					if(pendingAction != null)
					{
						pendingAction = null;
						factory.addMessage("Never mind.");
					}
				case Key.I: // inventory
					factory.popupInventory();
				case Key.W: // wield
					factory.popupInventory(Action.WIELD, Equipment.WEAPON);					
				case Key.E: // eat
					factory.popupInventory(Action.EAT, Equipment.FOOD);
				case Key.D: // drop
					factory.popupInventory(Action.DROP);
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
			}

			if(pos != null)
			{
				var player = factory.player();
				var playerPos = player.get(GridPosition);
				var dx = playerPos.x + pos[0];
				var dy = playerPos.y + pos[1];

				// Right now SHIFT is only be used for an EXAMINE action
				// I think I'm going to keep it that way for a while, I might remove getLegalActions entirely
				if(shiftIsDown)
				{
					// TODO put up action selector
					var actionTypes = factory.getLegalActions(dx, dy);
					var chosenActionType = actionTypes[0];
					// trace("Valid actions:" + actionTypes + " Chose:" + chosenActionType);
					factory.addActionAt(dx, dy, new Action(chosenActionType, player));
				}

				else if(pendingAction != null)
				{
					factory.addActionAt(dx,dy, pendingAction);
					pendingAction = null;
					advanceTurn();
				}

				else 
				{
					player.add(new GridVelocity(pos[0], pos[1]));
					advanceTurn();
				}
			}

			else if(pendingAction != null)
				factory.addMessage("Choose a direction.");		
	 	}
	}

	private function advanceTurn()
	{
		ConfigService.advanceTurn();
		// trace("New turn:" + ConfigService.getTurn());
	}
}