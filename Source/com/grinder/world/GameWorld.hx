package com.grinder.world;

import com.haxepunk.HXP;
import com.haxepunk.World;

import ash.core.Engine;
import ash.core.Entity;
import ash.core.System;

import com.grinder.SoundMan;
import com.grinder.InputMan;
import com.grinder.CameraMan;
import com.grinder.system.ActionSystem;
import com.grinder.system.RenderingSystem;
import com.grinder.system.MovementSystem;
import com.grinder.system.CameraSystem;
import com.grinder.system.CollisionSystem;
import com.grinder.system.HealthSystem;
import com.grinder.system.InputSystem;
import com.grinder.service.EntityService;
import com.grinder.service.MapService;

class GameWorld extends World
{
	private var ash:Engine;
	private var nextSystemPriority:Int = 0;
	private var factory:EntityService;

	public function new()
	{
		super();
		CameraMan.init();
	}

	override public function begin()
	{
		super.update();

		ash = new Engine();
		factory = new EntityService(ash);

		initSystems();
		initEntities();
	}

	private function initSystems()
	{
		addSystem(new InputSystem(ash, factory));
		addSystem(new ActionSystem(ash, factory));
		addSystem(new HealthSystem(ash, factory));
		addSystem(new CollisionSystem(ash, factory));
		addSystem(new MovementSystem(ash, factory));
		addSystem(new RenderingSystem(ash));
		addSystem(new CameraSystem(ash, 32));
	}	

    public function addSystem(system:System):Void
    {
        ash.addSystem(system, nextSystemPriority++);
    }

	private function initEntities()
	{
		factory.addMessageHud();
		factory.addPlayer(1, 1);
		factory.addBackdrop();
		factory.addMap(); // causes doors and walls to be added
		MapService.spawnZombies(factory, 10);
		MapService.spawnItems(factory, 3);
	}

    // Real-time update
	override public function update()
	{
		super.update();

		if(InputMan.pressed(InputMan.DEBUG))
			beginDebug();

		ash.update(HXP.elapsed); // update entity system
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