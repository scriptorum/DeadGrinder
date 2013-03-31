
package com.grinder.system;

import ash.core.Engine;
import ash.core.System;

import com.haxepunk.HXP;

import com.grinder.node.CameraFocusNode;

class CameraSystem extends System
{
	public var engine:Engine;
	public var tileSize:Int;
	public var halfTileSize:Int;

	// Pass in the tile size being used, or leave as 1 if CameraFocusNode is using GridPosition instead of Position
	public function new(engine:Engine, tileSize:Int = 1)
	{
		super();
		this.engine = engine;
		this.tileSize = tileSize;
		this.halfTileSize = Math.floor(tileSize / 2);
	}

	override public function update(_)
	{
		// TODO Add PlayerMoved entity or component, so this class can avoid adjusting the camera unless the
		// player has moved. Otherwise the RMB camera cheat doesn't work.
	 	for(node in engine.getNodeList(CameraFocusNode))
	 	{
	 		HXP.camera.x = tileSize * node.position.x - HXP.halfWidth + halfTileSize;
	 		HXP.camera.y = tileSize * node.position.y - HXP.halfHeight + halfTileSize;
	 	}
	}
}