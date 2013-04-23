/*
   - Attacking an empty space causes an exception, non-existent entity
   - Neko slows down over time, not sure why yet. Should you roll back neko?
   - NME 3.5.5 is not compatible with Neko 2, which you seem to still have despite trying to roll back.
     This definitely prevents you from targeting mobile. Fix!!! Either move to Git NME or try to
     manually remove Neko 2. See: http://www.nme.io/community/forums/installing-nme/uncaught-exception-failed-load-library/
   - Refactor profiling stuff into separate classes from ProfileSystem. Added profiling to GameWorld.render().
   - Examine action is broken, fix and remove getLegalActions() thing for now
   - Add Spawn and Despawn components and use Systems to track changes to GridService
   - Background doesn't show properly on CPP targets, currently turned off
   - Add article selector to getName()
   - Create ActionService to handle most of these actions, leaving EntityService to handle factory stuff only
     Or split ActionSystem into several systems.
   - Issue: Zombies moving into one space collalesce into a double zombie, occuping the same space.
   - Can you run Sys.println() to print to stdout from Flash? Praaaaaaahbobly not.
   - Issue: Player disappears on death, should turn to special corpse or stay put.
   - Get the collision system to respect the game grid; then you don't have to spawn 4000 wall objects,
     which this system obviously can't handle.
*/

package com.grinder.world;

import com.haxepunk.HXP;
import com.haxepunk.World;

import ash.core.Engine;
import ash.core.Entity;
import ash.core.System;
// import ash.tick.FrameTickProvider;

import com.grinder.service.SoundService;
import com.grinder.service.InputService;
import com.grinder.service.CameraService;
import com.grinder.service.EntityService;
import com.grinder.service.MapService;
import com.grinder.service.ArchiveService;
import com.grinder.service.GridService;

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
import com.grinder.component.Control;

#if profiler
	import com.grinder.system.ProfileSystem;
	import com.grinder.service.ProfileService;
#end

class GameWorld extends World
{
	private var ash:Engine;
	private var nextSystemPriority:Int = 0;
	private var factory:EntityService;

	public function new()
	{
		super();
	}

	override public function begin()
	{
		ash = new Engine();
		factory = new EntityService(ash);

		#if profiler
			ProfileService.init();
		#end

		CameraService.init();
		GridService.init(ash);

		initSystems();
		initEntities();

		#if profiler
			var e = new Entity();
			e.add(new ProfileControl());
			ash.addEntity(e);
		#end

        // var tickProvider = new FrameTickProvider(HXP.engine);
        // tickProvider.add(ash.update);
        // tickProvider.start();
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
    		var name = Type.getClassName(Type.getClass(system));
    		ash.addSystem(new ProfileSystem(name, true), nextSystemPriority++);
    	#end

        ash.addSystem(system, nextSystemPriority++);

    	#if profiler
    		ash.addSystem(new ProfileSystem(name, false), nextSystemPriority++);
    	#end
    }

	private function initEntities()
	{
		// factory.addBackdrop();
		factory.addMessageHud();
		factory.addHealthHud();
		factory.addMap(); // causes doors and walls to be added, sets up GridService
		// factory.addPlayer(1, 1); // spawned by map service
		MapService.spawnZombies(factory, 50);
		MapService.spawnItems(factory, 30);
	}

	override public function update()
	{
		if(InputService.pressed(InputService.DEBUG))
		{
			#if flash
				haxe.Log.clear();
			#end

			GridService.validate();
		}

		ash.update(HXP.elapsed); // update entity system
		//super.update(); // I'm not using HaxePunk's Entity.update(), so no need to call World.update()
	}

	#if profiler
		override public function render()
		{		
			var prof = ProfileService.getOrCreate("World.render()"); // [ to dump log and reset profiles
			
			prof.open();
			super.render();
			prof.close();
		}
	#end

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