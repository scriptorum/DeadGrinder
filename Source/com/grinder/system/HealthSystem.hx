package com.grinder.system;

import nme.geom.Rectangle;

import com.haxepunk.HXP;

import ash.core.Engine;
import ash.core.System;

import com.grinder.node.HealthMutationNode;
import com.grinder.component.Health;
import com.grinder.component.Zombie;
import com.grinder.component.Image;
import com.grinder.component.HealthMutation;
import com.grinder.component.GridPosition;
import com.grinder.component.Position;
import com.grinder.component.Control;
import com.grinder.component.Uninitialized;
import com.grinder.service.EntityService;

class HealthSystem extends System
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
		// Handle one time initialization of the Health Hud ... yuck
		var healthHud = engine.getEntityByName("healthHud");
		var player = engine.getEntityByName("player");
		if(player != null && healthHud != null && healthHud.has(Uninitialized))
		{
			healthHud.remove(Uninitialized);
			updateHud(player.get(Health).amount);
		}

	 	for(node in engine.getNodeList(HealthMutationNode))
	 	{
	 		// Apply damage/healing
	 		node.health.amount += node.mutation.amount;
	 		if(node.health.amount < 0)
	 			node.health.amount = 0;
	 		else if(node.health.amount > 100)
	 			node.health.amount = 100;	 			

	 		// Remove mutation
	 		node.entity.remove(HealthMutation);

	 		// Check for death
	 		if(node.health.amount <= 0)
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
 				updateHud(node.health.amount);
	 	}
	}

	public function updateHud(amount:Int): Void
	{
		var healthHud = engine.getEntityByName("healthHud");
		if(healthHud == null && amount > 0)
			healthHud = factory.addHealthHud();

		if(amount > 0)
		{
			var hudImage = healthHud.get(Image);
			var bm = HXP.getBitmap(hudImage.path);
			var hudWidth = amount / 100 * bm.width;
			hudImage.clip = new Rectangle(bm.width - hudWidth, 0, hudWidth, bm.height);
			healthHud.add(new Position(HXP.width - hudWidth - 20, HXP.height - bm.height - 20));
		}
		else engine.removeEntity(healthHud);
	}	
}