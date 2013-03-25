
package com.grinder.system;

import ash.core.Engine;
import ash.core.System;

import com.haxepunk.HXP;

import com.grinder.node.ImageNode;
import com.grinder.node.BackdropNode;
import com.grinder.render.ImageView;
import com.grinder.render.BackdropView;

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
	 	for(node in engine.getNodeList(ImageNode))
	 	{
	 		var view = node.entity.get(ImageView);
	 		if(view == null)
 			{
 				var e = new ImageView(node);
				HXP.world.add(e);
 				node.entity.add(e);
 			}
 			else view.updatePosition(node);
	 	}

	 	for(node in engine.getNodeList(BackdropNode))
	 	{
	 		var view = node.entity.get(BackdropView);
	 		if(view == null)
 			{
 				var e = new BackdropView(node);
				HXP.world.add(e);
 				node.entity.add(e);
 			}
	 	}
	}
}