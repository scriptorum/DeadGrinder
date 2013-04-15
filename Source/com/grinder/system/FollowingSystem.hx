/*
 * Zombies with an prey in a target seek it out.
 */

package com.grinder.system;

import ash.core.Entity;
import ash.core.Engine;
import ash.core.System;
import ash.core.Node;

import com.scriptorum.Util;

import com.grinder.service.EntityService;
import com.grinder.node.PreyNode;
import com.grinder.component.GridPosition;
import com.grinder.component.GridVelocity;
import com.grinder.component.Collision;
import com.grinder.component.Prey;

class FollowingSystem extends TurnBasedSystem
{
	public var engine:Engine;
	public var factory:EntityService;
	private var adjacents:Array<Array<Int>>;

	public function new(engine:Engine, factory:EntityService)
	{
		super();
		this.engine = engine;
		this.factory = factory;

		adjacents = [[-1, -1], [0, -1], [1,-1],
					 [-1,  0],          [1, 0],
					 [-1,  1], [0,  1], [1, 1]]; 
	}

	override public function takeTurn()
	{
	 	for(node in engine.getNodeList(PreyNode))
	 	{
	 		// trace(node.entity.name);
	 		var prey = node.prey;

	 		// Adjacent?
	 		var dx = Util.diff(prey.position.x, node.position.x);
	 		var dy = Util.diff(prey.position.y, node.position.y);
			if (dx <= 1 && dy <= 1)
				continue; // adjacent to target, you're there

	 		var roll = Math.random() * 100;
 			if(roll <= prey.interest) // chance he shuffles towards you based on prey
 			{
		 		var ox = prey.position.x - node.position.x;
		 		var oy = prey.position.y - node.position.y;
		 		var stillScore = ox * ox + oy * oy; // roughly, based on distance to target without moving 

				// Make list of all possible directions zed could go and rate by closeness
				var best = [];
				for(pt in adjacents)
				{
					var x = ox - pt[0];
					var y = oy - pt[1];
					var o = { rx:pt[0], ry:pt[1], score:0 };
					o.score = x * x + y * y;
					best.push(o);
				}
				best.sort(function(a,b) { 
					if(a.score < b.score)
						return -1;
					if(b.score < a.score)
						return 1;
					return 0;
				});

				// Try the top three directions
				// trace("Best avenues are:" + best);
				for(o in best)
				{
					// Nah, this move is suboptimal, so the others must be as well because the list is sorted
					if(o.score > stillScore)
						break;

					// Make sure we can do this move and it's not blocked
					var collision:Collision = factory.getCollisionAt(o.rx + node.position.x, o.ry + node.position.y);
					if(collision == null)
					{						
						node.entity.add(new GridVelocity(o.rx, o.ry));
						// trace(" - Determined best follow dir is " + o.rx + "," + o.ry);
						break;
					}
				}

			}
 			// else growl burp something
 		}
 	}
}