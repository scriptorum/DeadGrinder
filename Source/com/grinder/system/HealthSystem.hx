/*
 * TODO:
 *  - Do not inflict damage directly to enemy's Health, instead grnt the entity a Damage component and
 *    let this system manage it.
 */

package com.grinder.system;

import nme.geom.Rectangle;

import com.haxepunk.HXP;

import ash.core.Engine;
import ash.core.System;

import com.grinder.node.HealthNode;
import com.grinder.component.Health;
import com.grinder.component.Zombie;
import com.grinder.component.Image;
import com.grinder.component.GridPosition;
import com.grinder.component.Position;
import com.grinder.component.PlayerControl;
import com.grinder.component.GameOverControl;
import com.grinder.service.EntityService;

class HealthSystem extends TurnBasedSystem
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
	 		var health:Int = (node.health.amount <= 0 ? 0 : node.health.amount);

	 		if(health == 0)
 			{
 				var msg = null;
				if(node.entity.has(Zombie))
				{
					msg = "It falls down and stops moving.";

					// Change to corpse
					engine.removeEntity(node.entity);
					var pos = node.entity.get(GridPosition);
					factory.addCorpse(pos.x, pos.y);
				}
				else if(node.entity.name == "player")
				{
					msg = "You feel its teeth sink into your neck. You die.";
					engine.removeEntity(node.entity);
					node.entity.remove(PlayerControl);
					node.entity.add(new GameOverControl());
			 		node.entity.remove(Health);
					// factory.addGameOver();
				}
				else 
				{
					msg = "It's dead, Jim.";
			 		node.entity.remove(Health);
				}

				if(msg != null)
					factory.addMessage(msg);
 			}

 			// Update player health hud ... fugly ... TODO check for changed prop
 			if(node.entity.name == "player")
 			{
	 			var healthHud = engine.getEntityByName("healthHud");
	 			var hudImage = healthHud.get(Image);
	 			var bm = HXP.getBitmap(hudImage.path);
	 			var hudWidth = health / 100 * bm.width;
	 			hudImage.clip = new Rectangle(bm.width - hudWidth, 0, hudWidth, bm.height);
	 			healthHud.add(new Position(HXP.width - hudWidth - 20, HXP.height - bm.height - 20));
	 		}
	 	}
	}
}