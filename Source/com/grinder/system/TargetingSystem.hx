/*
 * TODO Change from ZombieNode to HunterNode or something like that. Also
 *  change Interest to Target.
 */

package com.grinder.system;

import ash.core.Entity;
import ash.core.Engine;
import ash.core.System;
import ash.core.Node;

import com.scriptorum.Util;

import com.grinder.service.EntityService;
import com.grinder.node.ZombieNode;
import com.grinder.component.GridPosition;
import com.grinder.component.Collision;
import com.grinder.component.Interest;

class TargetingSystem extends TurnBasedSystem
{
	public var engine:Engine;
	public var factory:EntityService;

	public function new(engine:Engine, factory:EntityService)
	{
		super();
		this.engine = engine;
		this.factory = factory;
	}

	override public function takeTurn()
	{
		var player = factory.player();
 	 	for(node in engine.getNodeList(ZombieNode))
	 	{
	 		// TODO loop through all sounds and living creatures...
	 		var losInterest:Interest = getLOSInterest(node, player);

	 		var interest = node.entity.get(Interest);
	 		if(interest == null)
	 		{
	 			if(losInterest != null)
	 			{
	 				interest = losInterest;
	 				node.entity.add(interest);
	 				trace("Setting new interest:" + interest);
	 			}
	 		}
	 		else
	 		{
	 			// Lost sight of previous interest and have no new target, gradually reduce interest
	 			if(losInterest == null)
	 			{
	 				interest.amount = Math.floor(interest.amount * 0.95);
	 				// trace("Losing interest:" + interest.amount);
	 			}

	 			// Found a stronger interest, switch interests
	 			else if(losInterest.amount > interest.amount)
	 			{
	 				interest.copy(losInterest);
	 				// trace("Switching to stronger interest:" + interest.amount);
	 			}

	 			// Still interested in the same position but less so, strengthen interest slightly
	 			else if(losInterest.target.equals(interest.target))
	 			{
	 				interest.amount = Util.max(Math.floor(interest.amount * 1.1), 100);
	 				// trace("Intensifying interest:"  + interest.amount);
	 			}

	 			// If new interest is at least half as strong as the old interest, switch interests
	 			else if(losInterest.amount >= interest.amount / 2)
	 			{
	 				interest.copy(losInterest);
	 				// trace("Switching to lower interest because it's in LOS:" + interest.amount);
	 			}
	 		}

	 		if(node.entity.has(Interest))
	 		{
	 			var interest = node.entity.get(Interest);
	 			if(interest.amount <= 0) // eliminate interest component if amount <= 0
	 				node.entity.remove(Interest);
	 			else if(interest.amount > 100) // enforce max interest
	 				interest.amount = 100;
	 			// trace(" - Final interest:" + interest.amount);
 			}

	 		// trace("Interest:" + (!node.entity.has(Interest) ? "NOPE" : node.entity.get(Interest).amount ));
 		}
 	}

 	private function getLOSInterest(node:ZombieNode, player:Entity): Interest
 	{
 		var blocked:Bool = false;
 		var playerPos:GridPosition = player.get(GridPosition);
 		var course:Array<GridPosition> = plotCourse(node.position.x, node.position.y, playerPos.x, playerPos.y);
		course.shift(); // remove zombie's position 		
		course.pop(); // remove player's position
 		for(pos in course)
 		{
 			for(entity in factory.getEntitiesAt(pos.x, pos.y))
 			{
 				if(entity.has(Collision))
 				{
 					var c = entity.get(Collision);
 					if(c.type == Collision.SHEER || c.type == Collision.CLOSED || c.type == Collision.LOCKED)
 						return null;
 				}
 			}
 		}

 		var interest = 0;
 		if(course.length < 4)
 			interest = 100;
 		else interest = 95 - (course.length - 4) * Math.floor(95/20);
 		return new Interest(playerPos, interest);
 	}

	// Refactor out, or better yet use someone else's already tested implementation...
	private function plotCourse(x0:Int, y0:Int, x1:Int, y1:Int): Array<GridPosition>
	{
		// trace("Plotting a course from " + x0 +"," + y0 + " to " + x1 + "," + y1);
		var line:Array<GridPosition> = new Array<GridPosition>();
		var dx:Int = Util.abs(x1 - x0);
		var dy:Int = Util.abs(y1 - y0);
		var sx = (x0 < x1 ? 1 : -1);
		var sy = (y0 < y1 ? 1 : -1);
		var err:Int = dx - dy;
		while(true)
		{
			line.push(new GridPosition(x0, y0));
			if(x0 == x1 && y0 == y1)
				break;
			var e2:Int = 2 * err;
			if(e2 > -dy)
			{
				err -= dy;
				x0 += sx;
			}
			if(e2 < dx)
			{
				err += dx;
				y0 += sy;
			}
		}

		return line;
	}
}