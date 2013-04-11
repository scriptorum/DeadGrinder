package com.grinder.system;

import ash.core.Entity;
import ash.core.Engine;
import ash.core.System;
import ash.core.Node;

import com.grinder.service.EntityService;
import com.grinder.node.ZombieNode;
import com.grinder.component.GridPosition;
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
	 		for(pos in plotCourse(node.position.x, node.position.y, player.get(GridPosition).x, player.get(GridPosition).y))
	 		{
	 			trace("Checking pos " + pos.x + "," + pos.y);
	 			for(entity in factory.getEntitiesAt(pos.x, pos.y))
	 			{
	 				trace("- Found entity " + entity.name);
	 				if(entity.has(Collision))
	 				{
	 					var c = entity.get(Collision);
	 					trace("  * Entity has collision:" + c.type);
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
	 			trace("Zombie " + node.entity.name + " is meandering");
	 		}
	 		else 
	 		{
	 			trace("Zombie " + node.entity.name + " can see you");
	 		}
	 	}
	}

	// Refactor out, or better yet use someone else's already tested implementation...
	private function plotCourse(x0:Int, y0:Int, x1:Int, y1:Int): Array<GridPosition>
	{
		trace("Plotting a course from " + x0 +"," + y0 + " to " + x1 + "," + y1);
		var line:Array<GridPosition> = new Array<GridPosition>();
		var steep:Bool = Math.abs(y1 - y0) > Math.abs(x1 - x0);
		if(steep)
		{
			var t0 = x0; x0 = y0; y0 = t0;
			var t1 = x1; x1 = y1; y1 = t1;
		}
		if(x0 > x1)
		{
			var tx = x0; x0 = x1; x0 = tx;
			var ty = y0; y0 = y1; y0 = ty;
		}
		var deltax:Int = x1 - x0;
		var deltay:Int = Math.floor(Math.abs(y1 - y0));
		var error:Int = Math.floor(deltax / 2);
		var ystep:Int = (y0 < y1 ? 1 : -1);
		var xstep:Int = (x0 < x1 ? 1 : -1);
		var y:Int = y0;
		var x:Int = x0;
		trace("Start error:" +error);
		// trace(" - (Adjusted) " + x0 +"," + y0 + " to " + x1 + "," + y1);
		while(x != x1 + xstep)
		{
			line.push(new GridPosition(steep ? y : x, steep ? x : y));
			error -= deltay;	
			trace("Loop over " + x + "," + y + " with error:" + error);
			if(error < 0)
			{
				y += ystep;
				error += deltax;
			}
			else trace("Loop over " + x + "," + y + " ERROR IS NEGATIVE, so skipping y increment");
			x += xstep;
		}
		trace("Plotted a course:" + line);
		return line;
	}
}