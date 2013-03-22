package com.grinder.behavior;
import com.grinder.behavior.Behavior;
import com.grinder.presence.Tangible;
import com.grinder.zone.Zone;
import com.haxepunk.HXP;

class BPlayer extends Behavior
{
	private var player:Tangible;

	public function new(player:Tangible)
	{
		super();
		this.player = player;
	}

	override public function added(): Void
	{
		summonCamera();
	}

	override public function invoke(zone:Zone): Void
	{
		summonCamera();
	}

	public function summonCamera(): Void
	{
		HXP.camera.x = player.x * player.getTileSize() - HXP.halfWidth;
		HXP.camera.y = player.y * player.getTileSize() - HXP.halfHeight;
	}
}