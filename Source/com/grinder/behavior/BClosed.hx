package com.grinder.behavior;
import com.grinder.behavior.Behavior;
import com.grinder.presence.Tangible;
import com.grinder.zone.Zone;
import com.haxepunk.HXP;

class BClosed extends Behavior
{
	private var gameObject:Tangible;

	public function new(gameObject:Tangible)
	{
		super();
		this.gameObject = gameObject;
	}

	override public function added(): Void
	{
	}

	override public function invoke(zone:Zone): Void
	{
	}
}