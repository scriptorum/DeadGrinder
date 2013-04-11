
package com.grinder.system;

import ash.core.Engine;
import ash.core.System;
import ash.core.Entity;

import com.grinder.node.CollisionNode;
import com.grinder.node.ColliderNode;
import com.grinder.component.Display;
import com.grinder.component.Grid;
import com.grinder.component.GridVelocity;
import com.grinder.component.Player;
import com.grinder.component.Zombie;
import com.grinder.service.EntityService;
import com.grinder.system.TurnBasedSystem;

class CollisionSystem extends TurnBasedSystem
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
		var map = engine.getEntityByName("map");
		if(map == null)
		{
			throw "Cannot locate map entity";
			return;
		}
		var grid = map.get(Grid);

	 	for(node in engine.getNodeList(ColliderNode))
		{
			// trace("Checking collision for " + node.entity.name);
			if(isStopped(node))
				continue;

			var dx = node.position.x + node.velocity.x;
			var dy = node.position.y + node.velocity.y;

			if(isOutOfBounds(node, dx, dy, grid))
			{
				if(node.entity.has(Player))
	 				factory.addMessage("That rubble is impossible to scramble over.");
	 			// else if(node.entity.has(Zombie)) && YouCanSeeZombie
	 			// 	factory.addMessage("The zombie slips on the rubble.");
	 			// else trace("Zombie tried to go out of bounds");
				removeVelocity(node);
				continue;
			}


			var collision = getCollision(node, dx, dy);
			if(collision == null)
				continue;
			
			if(node.entity.has(Player))
			{
				var message = collision.collision.type; // Ugh, refactor this
				factory.addMessage(message);
			}
			// else trace("Zombie collided into something:" + collision.collision.type);
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