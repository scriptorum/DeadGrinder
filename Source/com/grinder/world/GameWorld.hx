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

import com.grinder.system.RenderingSystem;
import com.grinder.system.MovementSystem;
import com.grinder.system.CameraSystem;

import com.grinder.service.EntityService;
import com.grinder.service.ComponentService;

class GameWorld extends World
{
	private var ash:Engine;
	private var systems:SystemList;

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
		addSystem(new MovementSystem(ash), 10);
		addSystem(new RenderingSystem(ash), 20);
		addSystem(new CameraSystem(ash, 32), 30);

		// TODO Define real-time systems.
		// These would be added directly to Ash, using ash.addSystem()
	}	

	private function initEntities()
	{
		var factory = new EntityService(ash);
		factory.spawnEntity("player", "player");
		factory.spawnEntity("backdrop", "backdrop");
	}

	public function updateSim(): Void
	{
		// Update turn-based systems
		for(system in systems)
			system.update(0);
	}

	// Add a new turn-based system
    public function addSystem(system:System, priority:Int):Void
    {
        system.priority = priority;
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
			player.add(ComponentService.getComponent("GridVelocity", [ox, oy]));
			updateSim();
		}

		// Update real-time systems.
		ash.update(HXP.elapsed);
	}
}