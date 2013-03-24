
package com.grinder.system;

import ash.core.Engine;
import ash.core.System;

import com.haxepunk.HXP;

import com.grinder.node.SpriteNode;
import com.grinder.component.Sprite;
import com.grinder.render.SpriteEntity;

class RenderingSystem extends System
{
	public var engine:Engine;

	public function new(engine:Engine)
	{
		super();
		this.engine = engine;
	}

	override public function update(_)
	{
		// Update tile-based images
	 	for(node in engine.getNodeList(SpriteNode))
	 	{
	 		var sprite = node.entity.get(Sprite);
	 		if(sprite == null)
 			{
 				var e = new SpriteEntity(node);
				HXP.world.add(e);

 				sprite = new Sprite(e);
 				node.entity.add(sprite);
 			}
 			else
 				cast(sprite.entity, SpriteEntity).updatePosition(node);
	 	}
	}
}