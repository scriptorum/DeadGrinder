/*
 * Much of the below should be broken down into subsystems, but I haven't decided how I should do that yet.trace
 * Also much of this assumes the player is the source doing the action to the target, but that won't always be
 * true. Probably need to create a LanguageService that puts together messages more smartly than this.
 */
package com.grinder.system;

import ash.core.Entity;
import ash.core.Engine;
import ash.core.System;
import ash.core.Node;

import com.grinder.service.EntityService;
import com.grinder.node.ActionNode;
import com.grinder.node.CarriedNode;
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
import com.grinder.component.Health;
import com.grinder.component.Carriable;
import com.grinder.component.Carrier;
import com.grinder.component.Carried;
import com.grinder.component.Display;
import com.grinder.component.Damager;
import com.grinder.component.Nutrition;
import com.grinder.component.Equipment;
import com.grinder.component.Equipped;
import com.grinder.component.Equipper;

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
	 		// trace("Action " + node.action.type + " on  " + node.entity.name);
	 		var persist = false;
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

	 			case Action.ATTACK:
	 				if(node.entity.has(Health))
	 				{
	 					// TODO Determine weapon equipped, get damage from that
	 					var source:Entity = node.action.source;
	 					if(source.has(Damager))
	 					{
	 						var damage = source.get(Damager).rand();
		 					// TODO Check for weapon break
		 					// TODO Check for knockback
		 					node.entity.get(Health).amount -= damage;
		 					msg = "You hit it.";
		 				}
		 				else msg = "You couldn't hurt a fly in your condition.";
	 				}
	 				else msg = "You can't attack that.";

	 			case Action.TAKE:
	 				if(node.entity.has(Carriable))
	 				{
	 					if(node.action.source.has(Carrier))
	 					{
	 						var carrier = node.action.source.get(Carrier);
	 						var carriable = node.entity.get(Carriable);

	 						// Get some inventory limit stats
	 						var holding = factory.getEquipmentFor(node.action.source);
	 						var quantity = carriable.quantity;
	 						var weight = carriable.weight;
							for(inv in engine.getNodeList(CarriedNode))
	 						{
	 							if(inv.carried.carrier == carrier.id)
	 							{
		 							quantity += inv.carriable.quantity;
		 							weight += inv.carriable.weight;
	 							}
	 						}

	 						if(carrier.maxQuantity != Carrier.UNRESTRICTED && quantity > carrier.maxQuantity)
	 							msg = "Your backpack is too full.";
	 						else if(carrier.maxWeight != Carrier.UNRESTRICTED && weight > carrier.maxWeight)
	 							msg = "It's just too heavy.";
	 						else
	 						{
		 						node.entity.add(new Carried(carrier.id)); // now being carried
		 						node.entity.remove(GridPosition); // not on the grid any more
		 						node.entity.remove(Display); // not displayed any more
		 						var name = factory.getName(node.entity,null);
		 						msg = (name == null ? "You pick it up." : "You pick up a " + name);
		 					}
	 					}
	 					else msg = "You can't pick anything up!";
	 				}

	 			case Action.DROP:
	 				if(node.entity.has(Carried))
	 				{
	 					if(node.action.source.has(Carrier))
	 					{
	 						var name = factory.getName(node.entity,null);
	 						var carrier = node.action.source.get(Carrier);
	 						if(carrier.id == node.entity.get(Carried).carrier)
	 						{
	 							node.entity.remove(Equipped); // unequip if necessary
	 							node.entity.remove(Carried); // remove from inventory
	 							var gp = node.action.source.get(GridPosition);
	 							if(gp != null)
	 							{
		 							node.entity.add(new GridPosition(gp.x, gp.y)); // add to floor
		 							msg = "You drop the " + name;
		 						}
		 						else msg = "You drop the " + name + " and it disappears!";
	 						}
	 						else msg = "You're not carrying the " + name + " " + carrier.id + "/" + node.entity.get(Carried).id;
	 					}
	 					else msg = "You can't drop anything!";
	 				}

	 			// TODO Refactor most of these action details into an ActionService, or WeaponSystem .. or what??
	 			case Action.UNWIELD:
					var weaponsEquipped = factory.getEquipmentFor(node.action.source, "weapon");
					for(weapon in weaponsEquipped)
					{
						if(weapon == node.entity)
						{
							node.entity.remove(Equipped);
							msg = "You are no longer wielding the " + factory.getName(node.entity);
							break;
						}
					}

					if(msg == null)
						msg = "You must wield something in order to unwield it";

	 			case Action.WIELD:
					if(node.entity.has(Equipment) && node.entity.get(Equipment).type == Equipment.WEAPON)
					{
						var weaponLimit = node.action.source.get(Equipper).getLimit("weapon");
						var weaponsEquipped = factory.getEquipmentFor(node.action.source, "weapon");

						// Auto dequip only weapon
						var unequipped = null;
						if(weaponsEquipped.length == weaponLimit && weaponLimit == 1)
						{
							unequipped = weaponsEquipped[0];
							weaponsEquipped[0].remove(Equipped);
						}

						if(unequipped == null && weaponsEquipped.length >= weaponLimit)
						{
							if(weaponLimit == 0)
								msg = "You can't wield anything!";
							else msg = "You are already wielding the maximum number of weapons.";
						}
						else
						{
							// Equip the weapon
							node.entity.add(new Equipped(node.action.source.get(Carrier).id));
							msg = (unequipped == null ? "" : "(Unequipping " + factory.getName(unequipped) + " first) ");
							msg += "You are now wielding a " + factory.getName(node.entity);	 
						}
					}	
					if(msg == null)
						msg = "You can't wield the " + factory.getName(node.entity);

	 			case Action.EAT:
 					if(!node.entity.has(Nutrition))
						factory.addMessage("You can't eat the " + factory.getName(node.entity));
					else
					{
						var nutrition = node.entity.get(Nutrition).amount;
						var health = node.action.source.get(Health);
						if(health == null)
							msg = "The " + factory.getName(node.action.source) + 
								" is trying to eat the " + factory.getName(node.entity);
						else
						{
							health.amount += nutrition;
							if(health.amount > health.max)
							{
								health.amount = health.max;
								factory.addMessage("Eating the " + factory.getName(node.entity) + " brings you to full health");
							}
							else factory.addMessage("You eat a " + factory.getName(node.entity) + " for " + nutrition + " HP");
						}
						engine.removeEntity(node.entity);
					}

	 			default:
	 				msg = "This action (" + node.action.type + ") is not implemented.";
	 		}

	 		if(!persist)
				node.entity.remove(Action);
	 		if(msg != null)
	 			factory.addMessage(msg);
	 	}
	}
}