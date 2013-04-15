/*
 * TO DO:
 *  - Change from ZombieNode to HunterNode or something like that.
 *  - Support generic prey targets, rather than just the player
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
import com.grinder.component.Prey;

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
	 		// TODO loop through all sounds, smells and living creatures...
	 		var losPrey:Prey = getLOSPrey(node, player);

	 		// Determine which prey to target and how much interest the hunter has
	 		var prey = node.entity.get(Prey);
	 		if(prey == null)
	 		{
	 			if(losPrey != null)
	 			{
	 				prey = losPrey;
	 				node.entity.add(prey);
	 				// trace("Setting new prey:" + prey);
	 			}
	 		}
	 		else
	 		{
	 			// Lost sight of previous prey and have no new position, gradually reduce prey
	 			if(losPrey == null)
	 			{
	 				prey.interest = Math.floor(prey.interest * 0.95);
	 				// trace("Losing prey:" + prey.interest);
	 			}

	 			// Found a stronger prey, switch preys
	 			else if(losPrey.interest > prey.interest)
	 			{
	 				prey.copy(losPrey);
	 				// trace("Switching to stronger prey:" + prey.interest);
	 			}

	 			// Still preyed in the same position but less so, strengthen prey slightly
	 			else if(losPrey.position.equals(prey.position))
	 			{
	 				prey.interest = Util.max(Math.floor(prey.interest * 1.1), 100);
	 				// trace("Intensifying prey:"  + prey.interest);
	 			}

	 			// If new prey is at least half as strong as the old prey, switch preys
	 			else if(losPrey.interest >= prey.interest / 2)
	 			{
	 				prey.copy(losPrey);
	 				// trace("Switching to lower prey because it's in LOS:" + prey.interest);
	 			}
	 		}

	 		// Maintain interest bounds for prey (0-100)
	 		if(node.entity.has(Prey))
	 		{
	 			var prey = node.entity.get(Prey);
	 			if(prey.interest <= 0) // eliminate prey component if interest <= 0
	 				node.entity.remove(Prey);
	 			else if(prey.interest > 100) // enforce max prey
	 				prey.interest = 100;
	 			// trace(" - Final prey:" + prey.interest);
 			}

	 		// trace("Prey:" + (!node.entity.has(Prey) ? "NOPE" : node.entity.get(Prey).interest ));
 		}
 	}

 	private function getLOSPrey(node:ZombieNode, player:Entity): Prey
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

 		var prey = 0;
 		if(course.length < 4)
 			prey = 100;
 		else prey = 95 - (course.length - 4) * Math.floor(95/20);
 		return new Prey(player, playerPos, prey);
 	}

	// Refactor out, or better yet use someone else's already tested line plotter implementation...
	// Node this plot is inclusive for the start and end points.
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