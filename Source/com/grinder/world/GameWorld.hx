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
   - Player movement should have priority over zombie movement, so either add the MovementSystem twice or add
     some sort of priority system.
   - Issue: Player disappears on death, should turn to special corpse or stay put.
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
import com.grinder.system.EnemyAttackSystem;
import com.grinder.system.CameraSystem;
import com.grinder.system.CollisionSystem;
import com.grinder.system.HealthSystem;
import com.grinder.system.InputSystem;
import com.grinder.system.MessageSystem;

#if profiler
	import com.grinder.system.ProfileSystem;
	import com.grinder.component.Control;
#end

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

		#if profiler
			var e = new Entity();
			e.add(new ProfileControl());
			ash.addEntity(e);
		#end
	}

	private function initSystems()
	{
		addSystem(new InputSystem(ash, factory)); // Collect player/inventory input
		addSystem(new ActionSystem(ash, factory)); // Resolve actions on entities
		addSystem(new HealthSystem(ash, factory)); // Better called the DeathSystem
		addSystem(new CollisionSystem(ash, factory)); // Entities whose velocity puts them into obstacles stop moving
		addSystem(new MovementSystem(ash, factory)); // Entities with velocity move
		addSystem(new TargetingSystem(ash, factory));  // Zombies look for humans to chase
		addSystem(new WanderingSystem(ash, factory)); // Zombies without targets go wandering
		addSystem(new FollowingSystem(ash, factory)); // Zombies with targets go after them
		addSystem(new EnemyAttackSystem(ash, factory)); // Zombies next to targets attack them
		addSystem(new CollisionSystem(ash, factory)); // DUPLICATE SYSTEM for enemies
		addSystem(new MovementSystem(ash, factory)); // DUPLICATE SYSTEM for enemies
		addSystem(new HealthSystem(ash, factory)); // DUPLICATE SYSTEM for enemies
		addSystem(new RenderingSystem(ash)); // Display entities are created/destroyed and positions updated
		addSystem(new CameraSystem(ash, 32)); // The camera follows the player
		addSystem(new MessageSystem(ash)); // Messages to player are updated
	}	

    public function addSystem(system:System):Void
    {
    	#if profiler
    		var starter = new ProfileSystem(system);
    		var closer = new ProfileSystem(system, starter.profile);
    		ash.addSystem(starter, nextSystemPriority++);
    	#end

        ash.addSystem(system, nextSystemPriority++);

    	#if profiler
    		ash.addSystem(closer, nextSystemPriority++);
    	#end
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
			// for(e in ash.get_entities()) // My ash hack
			// 	trace(e.name + ":" + ArchiveService.serializeEntity(e));
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