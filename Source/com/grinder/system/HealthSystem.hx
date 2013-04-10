package com.grinder.system;

import nme.geom.Rectangle;

import com.haxepunk.HXP;

import ash.core.Engine;
import ash.core.System;

import com.grinder.node.HealthNode;
import com.grinder.component.Health;
import com.grinder.component.Name;
import com.grinder.component.Image;
import com.grinder.component.GridPosition;
import com.grinder.component.Position;
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
	 	for(node in engine.getNodeList(HealthNode))
	 	{
	 		if(node.health.amount < 0)
 			{
				if(node.entity.has(Name) && node.entity.get(Name).text == "zombie")
				{
					factory.addMessage("It falls down and stops moving.");
					var pos = node.entity.get(GridPosition);
					engine.removeEntity(node.entity);
					factory.addCorpse(pos.x, pos.y);
				}
				else 
				{
					factory.addMessage("It's dead, Jim.");
			 		node.entity.remove(Health);
				}
 			}

 			// Update player health hud ... fugly ... TODO check for changed prop
 			if(node.entity.name == "player")
 			{
	 			var healthHud = engine.getEntityByName("healthHud");
	 			var hudImage = healthHud.get(Image);
	 			var bm = HXP.getBitmap(hudImage.path);
	 			var hudWidth = node.health.amount / 100 * bm.width;
	 			hudImage.clip = new Rectangle(bm.width - hudWidth, 0, hudWidth, bm.height);
	 			healthHud.add(new Position(HXP.width - hudWidth - 20, HXP.height - bm.height - 20));
	 		}
	 	}
	}
}