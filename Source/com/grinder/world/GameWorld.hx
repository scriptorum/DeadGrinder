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
import com.grinder.system.InputSystem;

import com.grinder.service.EntityService;

import com.grinder.component.Grid;

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