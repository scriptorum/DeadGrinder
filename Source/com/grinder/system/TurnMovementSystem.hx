/*
 *  Handles both turn based collision and movement.
 */

package com.grinder.system;

import ash.core.Engine;
import ash.core.System;
import ash.core.Entity;

import com.grinder.node.TurnMovementNode;
import com.grinder.component.Collision;
import com.grinder.component.Grid;
import com.grinder.component.GridVelocity;
import com.grinder.component.GridPosition;
import com.grinder.component.Player;
import com.grinder.component.Zombie;
import com.grinder.service.EntityService;
import com.grinder.service.GridService;
import com.grinder.system.TurnBasedSystem;

// TODO Consider velocity of collision target when determining collisions

class TurnMovementSystem extends TurnBasedSystem
{
	public var engine:Engine;
	public var factory:EntityService;

	public function new(engine:Engine, factory:EntityService)
	{
		super();
		this.engine = engine;
		this.factory = factory;
	}

	override public function takeTurn(): Void
	{
		var map = engine.getEntityByName("map");
		if(map == null)
		{
			throw "Cannot locate map entity";
			return;
		}
		var grid = engine.getEntityByName("map").get(Grid);
		process(grid);
	}

	private function process(grid:Grid): Void
	{
		throw "TurnMovementSystem.process must be overridden";
	}

	private function handleMovement(entity:Entity, position:GridPosition, velocity:GridVelocity, grid:Grid)
	{
		if(velocity.stopped())
			return;

		var dx = position.x + velocity.x;
		var dy = position.y + velocity.y;

		if(isOutOfBounds(dx, dy, grid))
		{
			if(entity.has(Player))
 				factory.addMessage("That rubble is impossible to scramble over.");
 			// else if(entity.has(Zombie)) && YouCanSeeZombie
 			// else factory.addMessage("The zombie slips on the rubble.");
 			// else trace("Zombie tried to go out of bounds");
			return;
		}

		var collision = getCollision(entity, dx, dy); // what we collided into
		if(collision == null)
		{
	 		// Update grid service
	 		GridService.move(entity, dx, dy);

			// No collision, move now
	 		position.x = dx;
	 		position.y = dy;
	 		// trace("Setting position of " + entity.name + " to " + position.x + "," + position.y + (position.moved ? " MOVED" : "STILL"));
			return;
		}
		
		// Player collision, say sumtin'
		if(entity.has(Player))
		{
			var message = collision.type; // Ugh, refactor this
			factory.addMessage(message);
		}

		// trace("Zombie collided into something:" + collision.type);
	}

	// Similar to EntityService.getCollision, but excludes the specified entity
	private function getCollision(entity:Entity, tx:Int, ty:Int): Collision
	{
		for(e in factory.getEntitiesAt(tx,ty))
		{
			// Get all colliders at the destination
			if(entity != e && e.has(Collision))
			{
				return e.get(Collision);
			}
		}
		return null;
	}

	public function isOutOfBounds(dx:Float, dy:Float, grid:Grid): Bool
	{
		if(dx < 0 || dy < 0 || dx >= grid.width || dy >= grid.height)
			return true;
		return false;
	}
}

class PlayerMovementSystem extends TurnMovementSystem
{
	override public function process(grid:Grid): Void
	{
		// Process player movement
	 	for(node in engine.getNodeList(PlayerMovementNode))
			handleMovement(node.entity, node.position, node.velocity, grid);
	}
}

class ZombieMovementSystem extends TurnMovementSystem
{
	override public function process(grid:Grid): Void
	{
		// Process zombie collisions afterward
	 	for(node in engine.getNodeList(ZombieMovementNode))
			handleMovement(node.entity, node.position, node.velocity, grid);
	}
}
