
package com.grinder.system;

import ash.core.Engine;
import ash.core.System;
import ash.core.Node;
import ash.core.NodeList;

import com.haxepunk.HXP;

import com.grinder.render.ImageView;
import com.grinder.node.ImageNode;

import com.grinder.render.BackdropView;
import com.grinder.node.BackdropNode;

import com.grinder.render.GridView;
import com.grinder.node.GridNode;

import com.grinder.component.Display;
import com.grinder.node.DisplayNode;

class RenderingSystem extends System
{
	public var engine:Engine;

	public function new(engine:Engine)
	{
		super();
		this.engine = engine;

		engine.getNodeList(ImageNode).nodeAdded.add(imageNodeAdded);
		engine.getNodeList(BackdropNode).nodeAdded.add(backdropNodeAdded);
		engine.getNodeList(GridNode).nodeAdded.add(gridNodeAdded);

		engine.getNodeList(DisplayNode).nodeRemoved.add(displayNodeRemoved);
	}

	private function imageNodeAdded(node:ImageNode): Void
	{
		var e = new ImageView(node.entity);
		HXP.world.add(e);
		node.entity.add(new Display(e));
	}

	private function backdropNodeAdded(node:BackdropNode): Void
	{
		var e = new BackdropView(node.entity);
		HXP.world.add(e);
		node.entity.add(new Display(e));
	}

	private function gridNodeAdded(node:GridNode): Void
	{
		var e = new GridView(node.entity);
		HXP.world.add(e);
		node.entity.add(new Display(e));
	}

	private function displayNodeRemoved(node:DisplayNode): Void
	{
		HXP.world.remove(node.display.view);
	}

	// TO DO respond to move events
	override public function update(_)
	{
	 	for(node in engine.getNodeList(DisplayNode))
			node.display.view.nodeUpdate();
	}
}