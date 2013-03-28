package com.grinder.world;

import com.haxepunk.HXP;
import com.haxepunk.World;

import ash.core.Engine;
import ash.core.Entity;
import ash.core.System;
import ash.core.SystemList;

import com.grinder.SoundMan;
import com.grinder.InputMan;
import com.grinder.CameraMan;

import com.grinder.system.ActionSystem;
import com.grinder.system.RenderingSystem;
import com.grinder.system.MovementSystem;
import com.grinder.system.CameraSystem;
import com.grinder.system.CollisionSystem;

import com.grinder.service.EntityService;
import com.grinder.service.ComponentService;

import com.grinder.component.Grid;

class GameWorld extends World
{
	private var ash:Engine;
	private var systems:SystemList;
	private var nextSystemPriority:Int = 0;

	public function new()
	{
		super();
		CameraMan.init();
	}

	override public function begin()
	{
		super.update();

		initAsh();
		initSystems();
		initEntities();

		updateSim();
	}

	private function initAsh()
	{
		ash = new Engine();
	}

	private function initSystems()
	{
		// Define turn-based systems.
		// Don't add these to the engine, we'll update them when the turn advances.
		systems = new SystemList();
		addSystem(new ActionSystem(ash));
		addSystem(new CollisionSystem(ash));
		addSystem(new MovementSystem(ash));
		addSystem(new RenderingSystem(ash));
		addSystem(new CameraSystem(ash, 32));

		// TODO Define real-time systems.
		// These would be added directly to Ash, using ash.addSystem()
	}	

	private function initEntities()
	{
		var factory = new EntityService(ash);
		factory.spawnEntity("player", "player");
		factory.spawnEntity("backdrop", "backdrop");
		var map:Entity = factory.spawnEntity("map", "map");
		var grid:Grid = map.get(Grid);
		grid.setRect(2, 2, 7, 7, 36);
		grid.setRect(3, 3, 5, 5, 35);

		grid.set(5, 2, 33);
		grid.set(5, 8, 33);
		grid.set(2, 5, 33);
		grid.set(8, 5, 33);

		for(y in 0...grid.height)
		for(x in 0...grid.width)
		{
			var value = grid.get(x,y);
			switch(value)
			{
				case 36:
				var wall = factory.spawnEntity("wall");
				var pos = wall.get(com.grinder.component.GridPosition);
				pos.x = x;
				pos.y = y;
				grid.set(x, y, 34);

				case 33:
				var wall = factory.spawnEntity("door");
				var pos = wall.get(com.grinder.component.GridPosition);
				pos.x = x;
				pos.y = y;
				grid.set(x, y, 34);
			}
		}

	}

	public function updateSim(): Void
	{
		// Update turn-based systems
		for(system in systems)
			system.update(0);
	}

	// Add a new turn-based system
    public function addSystem(system:System):Void
    {
        system.priority = nextSystemPriority++;
        system.addToEngine(ash);
        systems.add(system);
    }

    // Real-time update
	override public function update()
	{
		super.update();

		var ox:Int = 0;
		var oy:Int = 0;

		if(InputMan.pressed(InputMan.N)) { oy--; }
		else if(InputMan.pressed(InputMan.E)) { ox++; } 
		else if(InputMan.pressed(InputMan.W)) { ox--; }
		else if(InputMan.pressed(InputMan.S)) { oy++; }
		else if(InputMan.pressed(InputMan.NE)) { oy--; ox++; }
		else if(InputMan.pressed(InputMan.NW)) { oy--; ox--; }
		else if(InputMan.pressed(InputMan.SW)) { oy++; ox--; }
		else if(InputMan.pressed(InputMan.SE)) { oy++; ox++; }
		if(ox != 0 || oy != 0)
		{
			var player = ash.getEntityByName("player");
			if(player == null)
				throw("Cannot find player component");

			if(InputMan.check(com.haxepunk.utils.Key.SHIFT))
			{
				var pos = player.get(com.grinder.component.GridPosition);
				player.add(ComponentService.getComponent("Action", [com.grinder.component.Action.OPEN, 
					ComponentService.getComponent("GridPosition", [pos.x + ox, pos.y + oy])]));
			}
			else player.add(ComponentService.getComponent("GridVelocity", [ox, oy]));

			updateSim();
		}

		if(InputMan.pressed(InputMan.DEBUG))
			beginDebug();

		// Update real-time systems.
		ash.update(HXP.elapsed);
	}

	private static function beginDebug()
	{
		#if DEBUGGER
			trace("Starting debugger");
	    	new hxcpp.DebugStdio(true);
		#else
			trace("Debugger not enabled");
		#end	
	}
}