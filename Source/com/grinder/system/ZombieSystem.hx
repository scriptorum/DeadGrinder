package com.grinder.system;

import ash.core.Entity;
import ash.core.Engine;
import ash.core.System;
import ash.core.Node;

import com.grinder.service.EntityService;
import com.grinder.node.ZombieNode;
import com.grinder.component.GridPosition;
import com.grinder.component.GridVelocity;
import com.grinder.component.Collision;

class ZombieSystem extends TurnBasedSystem
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
	 		var blocked:Bool = false;
	 		var course:Array<GridPosition> = plotCourse(node.position.x, node.position.y, player.get(GridPosition).x, player.get(GridPosition).y);
			course.shift(); // remove zombie's position 		
			var zedway:GridPosition = course[0]; // could be intervening space, could be player space
			course.pop(); // remove player's position
	 		for(pos in course)
	 		{
	 			// trace("Checking pos " + pos.x + "," + pos.y);
	 			for(entity in factory.getEntitiesAt(pos.x, pos.y))
	 			{
	 				// trace("- Found entity " + entity.name);
	 				if(entity.has(Collision))
	 				{
	 					var c = entity.get(Collision);
	 					// trace("  * Entity has collision:" + c.type);
	 					if(c.type == Collision.SHEER || c.type == Collision.CLOSED || c.type == Collision.LOCKED)
	 					{
	 						blocked = true;
	 						break;
	 					}
	 				}
	 			}

				if(blocked)
					break;
	 		}
	 		if(blocked)
	 		{
	 			if(true)//Math.random() < .5) // 50% chance he doesn't do anything
	 			{
	 				var ox = rndRange(-1,1);
	 				var oy = rndRange(-1,1);
	 				if(!(ox == 0 && oy == 0))
	 					node.entity.add(new GridVelocity(ox,oy)); // zed moves randomly
	 				// else trace("Zombie confused");
	 			}
	 			// trace("Zombie " + node.entity.name + " does not see you");
	 		}
	 		else if(course.length == 0)
			{
				// TODO
				trace("Zombie is attacking you!");
			}
	 		else 
	 		{
	 			if(Math.random() < .8) // 80% chance he shuffles towards yo
	 				node.entity.add(zedway);
	 			// trace("Zombie " + node.entity.name + " can see you");
	 		}
	 	}
	}

	// Refactor out, or better yet use someone else's already tested implementation...
	private function plotCourse(x0:Int, y0:Int, x1:Int, y1:Int): Array<GridPosition>
	{
		// trace("Plotting a course from " + x0 +"," + y0 + " to " + x1 + "," + y1);
		var line:Array<GridPosition> = new Array<GridPosition>();
		var dx:Int = abs(x1 - x0);
		var dy:Int = abs(y1 - y0);
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

	private function abs(num:Int): Int
	{
		return (num < 0 ? -num : num);
	}

	private function diff(a:Int, b:Int): Int
	{
		return (a > b ? a - b : b - a);
	}

	private function rndRange(start:Int, end:Int): Int
	{
		return Math.floor(Math.random() * (diff(end, start) + 1)) + start;
	}
}