/*
   - GridService is not being kept updated. Killing a zombie can result in:
			Called from com/grinder/system/TurnBasedSystem.hx line 23
			Called from com/grinder/system/TargetingSystem.hx line 40
		Called from com/grinder/system/TargetingSystem.hx line 113
			Called from com/grinder/service/EntityService.hx line 96
			Called from com/grinder/service/GridService.hx line 57
			Uncaught exception - Found non-existant entity (zombie4889) at 65,54
	 This should probably be changed to a regular TRACE, since it can fixed programatically.
   - Examine action is broken, fix and remove getLegalActions() thing for now
   - Add Spawn and Despawn components and use Systems to track changes to GridService
   - Backdrop doesn't show properly on CPP targets (layers in front), at least on HXP 172a
   - Add article selector to getName(). Or add ProseService.
   - Create ActionService to handle most of these actions, leaving EntityService to handle factory stuff only
     Or split ActionSystem into several systems.
   - Can you run Sys.println() to print to stdout from Flash? Praaaaaaahbobly not.
   - Issue: Player disappears on death, should turn to special corpse or stay put.
   - Get the collision system to respect the game grid, then you can remove some entities.
   - Preloader assets should be added even if not in debug.
   - Add more rigorous turn/phase handler.  All results post-user-input happen simultaneously, but we 
     should be able to break it down into each acting entity getting a turn. As it is, it's possible 
     for the player to get one more move in after should be killed. PlayerControls should be removed
     while non-player turns are being resolved.
   - Solving the zombie-into-zombie collision problem caused some indifference on some of zed's part.
     Sometimes a zed will ignore you and go into wandering mode even though you have a clear line of
     sight. This is either an issue with the GridService not removing stale entities (quite possible),
     or a logic problem in one or more of the systems.
   - Also zombies whose line of sight is broken by other zombies are jerks. Stupid zombies. However
     maybe this is not an issue when you add the sound system later, as they'll be interested in
     the noise commotion.
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
import com.grinder.service.GridService;
import com.grinder.service.AnimationService;

import com.grinder.system.ActionSystem;
import com.grinder.system.RenderingSystem;
import com.grinder.system.TurnMovementSystem;
import com.grinder.system.TargetingSystem;
import com.grinder.system.FollowingSystem;
import com.grinder.system.WanderingSystem;
import com.grinder.system.EnemyAttackSystem;
import com.grinder.system.CameraSystem;
import com.grinder.system.HealthSystem;
import com.grinder.system.MovementSystem;
import com.grinder.system.InputSystem;
import com.grinder.system.MessageSystem;
import com.grinder.system.TurnMovementHaltingSystem;
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
		AnimationService.init();
		GridService.init(ash);

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
		addSystem(new HealthSystem(ash, factory)); // x1 Healing from food and damage from attacks
		addSystem(new PlayerMovementSystem(ash, factory)); // Player moves/collides
		addSystem(new TargetingSystem(ash, factory));  // Zombies look for humans to chase
		addSystem(new WanderingSystem(ash, factory)); // Zombies without targets go wandering
		addSystem(new FollowingSystem(ash, factory)); // Zombies with targets go after them
		addSystem(new ZombieMovementSystem(ash, factory)); // Zombies move/collide
		addSystem(new EnemyAttackSystem(ash, factory)); // Zombies who didn't move and next to targets attack them
		addSystem(new HealthSystem(ash, factory)); // x2 Healing from food and damage from attacks
		addSystem(new MovementSystem(ash, factory)); // Real-time entity movement
		addSystem(new RenderingSystem(ash)); // Display entities are created/destroyed/updated
		addSystem(new CameraSystem(ash, 32)); // The camera follows the player
		addSystem(new MessageSystem(ash)); // Messages to player are updated
		addSystem(new TurnMovementHaltingSystem(ash)); // Stop grid velocity on turn-based entities
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
		factory.addBackdrop();
		factory.addMessageHud();
		factory.addHealthHud();
		factory.addMap(); // causes doors and walls to be added, sets up GridService
		MapService.spawnZombies(factory, 300);
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

		ash.update(HXP.elapsed); // Update Ash (entity system)
		super.update(); // Update HaxePunk (game library)
	}

	// #if profiler
	// 	override public function render()
	// 	{		
	// 		var prof = ProfileService.getOrCreate("World.render()"); // [ to dump log and reset profiles

	// 		prof.open();
	// 		super.render();
	// 		prof.close();
	// 	}
	// #end

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