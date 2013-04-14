/*
   - Add article selector to getName()
   - Create ActionService to handle most of these actions, leaving EntityService to handle factory stuff only
     Or split ActionSystem into several systems.
   - The CollisionSystem is not protecting multiple things from entering the same space simultaneously.
     The priority should be player > people > zeds.
   - Left the game running for an hour, came back and it was running REALLY slow, delays between arrow presses.
     Pressed TAB to see the contents of the entities and found nothing unusual. 
   - Perhaps neko.vm.Gc.stats()/run()? Test under flash and CPP. If no slow down, don't worry about it.
   - Can you run Sys.println() to print to stdout from Flash? Praaaaaaahbobly not.
   - If zombies hit an obstacle they stop moving, either the CollisionSystem or the ZombieSystem needs to allow 
     zombies to look for a way around. First off, you should probably split ZombieSystem into an TargetSystem
     (for updating "interests") and a TrackingSystem (for handling movement specific to tracking targets).
   - Should the Collision System just be limited to player movement then?
*/

package com.grinder.world;

import com.haxepunk.HXP;
import com.haxepunk.World;

import ash.core.Engine;
import ash.core.Entity;
import ash.core.System;

import com.grinder.service.SoundService;
import com.grinder.service.InputService;
import com.grinder.service.CameraService;
import com.grinder.service.EntityService;
import com.grinder.service.MapService;
import com.grinder.service.ArchiveService;

import com.grinder.system.ActionSystem;
import com.grinder.system.RenderingSystem;
import com.grinder.system.MovementSystem;
import com.grinder.system.TargetingSystem;
import com.grinder.system.FollowingSystem;
import com.grinder.system.WanderingSystem;
import com.grinder.system.ZombieAttackSystem;
import com.grinder.system.CameraSystem;
import com.grinder.system.CollisionSystem;
import com.grinder.system.HealthSystem;
import com.grinder.system.InputSystem;
import com.grinder.system.MessageSystem;

class GameWorld extends World
{
	private var ash:Engine;
	private var nextSystemPriority:Int = 0;
	private var factory:EntityService;

	public function new()
	{
		super();
		CameraService.init();
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
		addSystem(new TargetingSystem(ash, factory));
		addSystem(new WanderingSystem(ash, factory));
		addSystem(new FollowingSystem(ash, factory));
		addSystem(new ZombieAttackSystem(ash, factory));
		addSystem(new CollisionSystem(ash, factory));
		addSystem(new MovementSystem(ash, factory));
		addSystem(new RenderingSystem(ash));
		addSystem(new CameraSystem(ash, 32));
		addSystem(new MessageSystem(ash));
	}	

    public function addSystem(system:System):Void
    {
        ash.addSystem(system, nextSystemPriority++);
    }

	private function initEntities()
	{
		factory.addBackdrop();
		factory.addMessageHud();
		factory.addHealthHud();
		factory.addPlayer(1, 1);
		factory.addMap(); // causes doors and walls to be added		
		MapService.spawnZombies(factory, 1);
		MapService.spawnItems(factory, 10);
	}

    // Real-time update
	override public function update()
	{
		super.update();

		if(InputService.pressed(InputService.DEBUG))
		{
			for(e in ash.get_entities())
				trace(e.name + ":" + ArchiveService.serializeEntity(e));
			// beginDebug();
		}

		ash.update(HXP.elapsed); // update entity system
	}

	// private static function beginDebug()
	// {
	// 	#if DEBUGGER
	// 		trace("Starting debugger");
	//     	new hxcpp.DebugStdio(true);
	// 	#else
	// 		trace("Debugger not enabled");
	// 	#end	
	// }
}