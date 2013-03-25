
package com.grinder.system;

import ash.core.Engine;
import ash.core.System;
import ash.core.Node;
import ash.core.NodeList;

import com.haxepunk.HXP;

import com.grinder.render.ImageView;
import com.grinder.node.ImageNode;
import com.grinder.node.ImageViewNode;

import com.grinder.render.BackdropView;
import com.grinder.node.BackdropNode;
import com.grinder.node.BackdropViewNode;

import com.grinder.render.GridView;
import com.grinder.node.GridNode;
import com.grinder.node.GridViewNode;

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

		engine.getNodeList(ImageNode).nodeAdded.add(imageNodeAdded);
		engine.getNodeList(ImageViewNode).nodeRemoved.add(imageViewNodeRemoved);

		engine.getNodeList(GridNode).nodeAdded.add(gridNodeAdded);
		engine.getNodeList(GridViewNode).nodeRemoved.add(gridViewNodeRemoved);
	}

	private function imageNodeAdded(node:ImageNode): Void
	{
		if(node.entity.get(ImageView) != null)
			return;

		var e = new ImageView(node);
		HXP.world.add(e);
		node.entity.add(e);
	}

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

	private function gridNodeAdded(node:GridNode): Void
	{
		var e = new GridView(node);
		HXP.world.add(e);
		node.entity.add(e);
	}

	private function gridViewNodeRemoved(node:GridViewNode): Void
	{
		HXP.world.remove(node.view);
	}

	// TO DO respond to move events
	override public function update(_)
	{
	 	for(node in engine.getNodeList(ImageViewNode))
			node.view.updatePosition();

	 	for(node in engine.getNodeList(GridViewNode))
			node.view.updateNode();
	}
}