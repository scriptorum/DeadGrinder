package com.grinder.system;

import ash.core.Engine;
import ash.core.System;
import ash.core.Entity;

import com.grinder.node.ColliderNode;
import com.grinder.component.Collision;
import com.grinder.component.Grid;
import com.grinder.component.GridVelocity;
import com.grinder.component.GridPosition;
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
		var grid = engine.getEntityByName("map").get(Grid);

		// Process player collisions
	 	for(node in engine.getNodeList(PlayerColliderNode))
			checkCollision(node.entity, node.position, node.velocity, grid);

		// Process zombie collisions afterward
	 	for(node in engine.getNodeList(ZombieColliderNode))
			checkCollision(node.entity, node.position, node.velocity, grid);
	}

	private function checkCollision(entity:Entity, position:GridPosition, velocity:GridVelocity, grid:Grid)
	{
		if(isStopped(entity, velocity))
			return;

		var dx = position.x + velocity.x;
		var dy = position.y + velocity.y;

		if(isOutOfBounds(dx, dy, grid))
		{
			if(entity.has(Player))
 				factory.addMessage("That rubble is impossible to scramble over.");
 			// else if(entity.has(Zombie)) && YouCanSeeZombie
 			// 	factory.addMessage("The zombie slips on the rubble.");
 			// else trace("Zombie tried to go out of bounds");
			removeVelocity(entity);
			return;
		}

		var collision = getCollision(entity, dx, dy); // what we collided into
		if(collision == null)
			return;
		
		if(entity.has(Player))
		{
			var message = collision.type; // Ugh, refactor this
			factory.addMessage(message);
		}

		// else trace("Zombie collided into something:" + collision.collision.type);
		removeVelocity(entity);
	}

	// Similar to EntityService.getCollision, but excludes the specified entity
	private function getCollision(entity:Entity, tx:Int, ty:Int): Collision
	{
		for(e in factory.getEntitiesAt(tx,ty))
		{
			if(entity != e && e.has(Collision))
				return e.get(Collision);
		}
		return null;
	}

	private function removeVelocity(entity:Entity)
	{
		entity.remove(GridVelocity);
		if(entity.has(GridVelocity))
			trace("Failed to remove GridVelocity from " + entity.name);
	}

	public function isStopped(entity:Entity, velocity:GridVelocity): Bool
	{
		if(velocity.x == 0 && velocity.y == 0)
		{
			removeVelocity(entity);
			return true;
		}
		return false;
	}

	public function isOutOfBounds(dx:Float, dy:Float, grid:Grid): Bool
	{
		if(dx < 0 || dy < 0 || dx >= grid.width || dy >= grid.height)
			return true;
		return false;
	}
}