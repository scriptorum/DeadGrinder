/*
 * Zombies with an interest in a target seek it out
 *
 * LEFT OFF:
 *  Added an eight directional check for an optimal course to follow to the target. It's not working right now.
 *  Get a zed to follow you and turn the corner, it gets confused and collides into a wall when there's an
 *  obvious way around. Right now it only checks the top three "most optimal" directions, but possibly it should
 *  check all directions, stopping when the checked direction is farther then just staying still. In this case
 *  though you'll have to calculate "score" differently than for sorting the direction fitness; the reason is
 *  direction fitness uses line of sight to order the best moves, but from a grid movement perspective, a higher
 *  score could actually have an equal number of grid moves. I think for grid moves your score is probably
 *  something like ox + oy.
 */

package com.grinder.system;

import ash.core.Entity;
import ash.core.Engine;
import ash.core.System;
import ash.core.Node;

import com.scriptorum.Util;

import com.grinder.service.EntityService;
import com.grinder.node.InterestNode;
import com.grinder.component.GridPosition;
import com.grinder.component.GridVelocity;
import com.grinder.component.Collision;
import com.grinder.component.Interest;

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
	 	for(node in engine.getNodeList(InterestNode))
	 	{
	 		// trace(node.entity.name);
	 		var interest = node.interest;

	 		// Adjacent?
	 		var dx = Util.diff(interest.target.x, node.position.x);
	 		var dy = Util.diff(interest.target.y, node.position.y);
			if (dx <= 1 && dy <= 1)
				continue; // adjacent to target, you're there

	 		var roll = Math.random() * 100;
 			if(roll <= interest.amount) // chance he shuffles towards you based on interest
 			{
		 		var ox = interest.target.x - node.position.x;
		 		var oy = interest.target.y - node.position.y;
		 		var stillScore = ox * ox + oy * oy; 

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
 			// else growl
 		}
 	}
}