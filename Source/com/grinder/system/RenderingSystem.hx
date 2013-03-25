
package com.grinder.system;

import ash.core.Engine;
import ash.core.System;
import ash.core.Node;
import ash.core.NodeList;

import com.haxepunk.HXP;

import com.grinder.node.ImageNode;
import com.grinder.node.ImageViewNode;
import com.grinder.node.BackdropNode;
import com.grinder.node.BackdropViewNode;
import com.grinder.render.ImageView;
import com.grinder.render.BackdropView;

class RenderingSystem extends System
{
	public var engine:Engine;

	public function new(engine:Engine)
	{
		super();
		this.engine = engine;

		engine.getNodeList(ImageNode).nodeAdded.add(imageNodeAdded);
		engine.getNodeList(ImageViewNode).nodeRemoved.add(imageViewNodeRemoved);
		engine.getNodeList(BackdropNode).nodeAdded.add(backdropNodeAdded);
		engine.getNodeList(BackdropViewNode).nodeRemoved.add(backdropViewNodeRemoved);
	}

	// Add a corresponding HaxePunk ImageView to the entity
	private function imageNodeAdded(node:ImageNode): Void
	{
		var e = new ImageView(node);
		HXP.world.add(e);
		node.entity.add(e);
	}

	// Remove the associated ImageView from the entity
	private function imageViewNodeRemoved(node:ImageViewNode): Void
	{
		HXP.world.remove(node.view);
	}

	private function backdropNodeAdded(node:BackdropNode): Void
	{
		var e = new BackdropView(node);
		HXP.world.add(e);
		node.entity.add(e);
	}

	private function backdropViewNodeRemoved(node:BackdropViewNode): Void
	{
		HXP.world.remove(node.view);
	}

	override public function update(_)
	{
	 	for(node in engine.getNodeList(ImageViewNode))
			node.view.updatePosition();
	}
}