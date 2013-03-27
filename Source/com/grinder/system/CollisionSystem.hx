
package com.grinder.system;

import ash.core.Engine;
import ash.core.System;

import com.grinder.node.CollisionNode;
import com.grinder.render.View;
import com.grinder.component.Grid;
import com.grinder.component.GridVelocity;

import com.haxepunk.HXP;
import com.haxepunk.Entity;

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

	 	for(node in engine.getNodeList(CollisionNode))
		{
			trace("Checking for collisions with entity " + node.entity.name);
			trace("	- Checking if stopped");
			if(isStopped(node))
				continue;

			var view:View = node.display.view;
			var dx = node.position.x + node.velocity.x;
			var dy = node.position.y + node.velocity.y;

			if(isOutOfBounds(node, dx, dy, grid) || isColliding(node, dx, dy))
			{
				trace("You can't go that way");
				removeVelocity(node);
			}
		}
	}

	private function removeVelocity(node:CollisionNode)
	{
		node.entity.remove(GridVelocity);
		if(node.entity.has(GridVelocity))
			throw "Failed to remove velocity component";
	}

	public function isStopped(node:CollisionNode): Bool
	{
		if(node.velocity.x == 0 && node.velocity.y == 0)
		{
			removeVelocity(node);
			return true;
		}
		return false;
	}

	public function isOutOfBounds(node:CollisionNode, dx:Float, dy:Float, grid:Grid): Bool
	{
			trace("	- Checking boundaries");
		if(dx < 0 || dy < 0 || dx >= grid.width || dy >= grid.height)
			return true;
		return false;
	}

	public function isColliding(node:CollisionNode, dx:Float, dy:Float): Bool
	{
			trace("	- Checking collision at " + dx + "," + dy);
		var collider:Entity = node.display.view.collide("solid", dx, dy);
		trace("Collider:"+ collider);
		if(collider != null)
			return true;
		return false;
	}
}