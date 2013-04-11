package com.grinder.system;

import ash.core.System;

import com.grinder.service.ConfigService;

class TurnBasedSystem extends System
{
	private var turn:Int = 0;

	public function new()
	{
		super();
	}

	override public function update(time:Float)
	{
		// Only run when the turn changes
		if(ConfigService.getTurn() == turn)
			return;
		turn = ConfigService.getTurn();

		takeTurn(); // take turn in child
	}

	public function takeTurn()
	{
		throw "TurnBasedSystem.turn() must be overridden";
	}
}