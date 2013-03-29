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

import com.grinder.component.Grid;
import com.grinder.component.GridPosition;
import com.grinder.component.GridVelocity;
import com.grinder.component.Action;

class GameWorld extends World
{
	private var ash:Engine;
	private var systems:SystemList;
	private var nextSystemPriority:Int = 0;
	private var factory:EntityService;
	private var pendingAction:String = null;

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

		updateSim();
	}


	private function initSystems()
	{
		// Define turn-based systems.
		// Don't add these to the engine, we'll update them when the turn advances.
		systems = new SystemList();
		addSystem(new ActionSystem(ash, factory));
		addSystem(new CollisionSystem(ash, factory));
		addSystem(new MovementSystem(ash, factory));
		addSystem(new RenderingSystem(ash));
		addSystem(new CameraSystem(ash, 32));

		// TODO Define real-time systems.
		// These would be added directly to Ash, using ash.addSystem()
	}	

	private function initEntities()
	{
		factory.addMessageHud();
		factory.addPlayer(5, 5);
		factory.addBackdrop();

		var map = factory.addMap();
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
				factory.addWall(x, y);
				grid.set(x, y, 34);

				case 33:
				factory.addDoor(x, y);
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


		if(InputMan.pressed(InputMan.OPEN))
			pendingAction = Action.OPEN;
		else if(InputMan.pressed(InputMan.CLOSE))
			pendingAction = Action.CLOSE;
		else if(InputMan.pressed(InputMan.LOCK))
			pendingAction = Action.LOCK;
		else if(InputMan.pressed(InputMan.UNLOCK))
			pendingAction = Action.UNLOCK;
		else if(InputMan.pressed(InputMan.ABORT))
			pendingAction = null;
		else if(InputMan.pressed(InputMan.MOVE_N)) { oy--; }
		else if(InputMan.pressed(InputMan.MOVE_E)) { ox++; } 
		else if(InputMan.pressed(InputMan.MOVE_W)) { ox--; }
		else if(InputMan.pressed(InputMan.MOVE_S)) { oy++; }
		else if(InputMan.pressed(InputMan.MOVE_NE)) { oy--; ox++; }
		else if(InputMan.pressed(InputMan.MOVE_NW)) { oy--; ox--; }
		else if(InputMan.pressed(InputMan.MOVE_SW)) { oy++; ox--; }
		else if(InputMan.pressed(InputMan.MOVE_SE)) { oy++; ox++; }
		if(ox != 0 || oy != 0)
		{
			var player = ash.getEntityByName("player");
			if(player == null)
				throw("Cannot find player component");
			var pos = player.get(GridPosition);
			var dx = pos.x + ox;
			var dy = pos.y + oy;

			if(InputMan.check(com.haxepunk.utils.Key.SHIFT))
			{
				// TODO put up action selector
				var actionTypes = factory.getLegalActions(dx, dy);
				var chosenActionType = actionTypes[0];
				// trace("Valid actions:" + actionTypes + " Chose:" + chosenActionType);
				factory.addActionAt(dx, dy, new Action(chosenActionType));
			}

			else if(pendingAction != null)
			{
				factory.addActionAt(dx,dy, new Action(pendingAction));
				pendingAction = null;
			}

			else player.add(new GridVelocity(ox, oy));

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