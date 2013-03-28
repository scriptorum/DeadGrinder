
package com.grinder.system;

import ash.core.Engine;
import ash.core.System;
import ash.core.Entity;

import com.grinder.node.CollisionNode;
import com.grinder.node.ColliderNode;
import com.grinder.component.Display;
import com.grinder.component.Grid;
import com.grinder.component.GridVelocity;

class CollisionSystem extends System
{
	public var engine:Engine;

	public function new(engine:Engine)
	{
		super();
		this.engine = engine;
	}

	override public function update(_)
	{
		var map = engine.getEntityByName("map");
		if(map == null)
		{
			throw "Cannot locate map entity";
			return;
		}
		var grid = map.get(Grid);

	 	for(node in engine.getNodeList(ColliderNode))
		{
			if(isStopped(node))
				continue;

			var dx = node.position.x + node.velocity.x;
			var dy = node.position.y + node.velocity.y;

			if(isOutOfBounds(node, dx, dy, grid))
			{
				trace("That rubble is impossible to scramble over.");
				removeVelocity(node);
				return;
			}

			var collision = getCollision(node, dx, dy);
			if(collision == null)
				return;
			
			var message = collision.collision.type;
			trace(message);
			removeVelocity(node);
		}
	}

	private function getCollision(node:ColliderNode, dx:Int, dy:Int): CollisionNode
	{
		for(candidate in engine.getNodeList(CollisionNode))
		{
			// trace("Checking node " + node.entity.name + " against " + candidate.entity.name + " at pos " + dx + "," + dy);
			if(candidate.entity != node.entity && candidate.position.matches(dx, dy))
				return candidate;
		}
		return null;
	}

	private function removeVelocity(node:ColliderNode)
	{
		node.entity.remove(GridVelocity);
		if(node.entity.has(GridVelocity))
			throw "Failed to remove velocity component";
	}

	public function isStopped(node:ColliderNode): Bool
	{
		if(node.velocity.x == 0 && node.velocity.y == 0)
		{
			removeVelocity(node);
			return true;
		}
		return false;
	}

	public function isOutOfBounds(node:ColliderNode, dx:Float, dy:Float, grid:Grid): Bool
	{
		if(dx < 0 || dy < 0 || dx >= grid.width || dy >= grid.height)
			return true;
		return false;
	}
}