
package com.grinder.system;

import ash.core.Engine;
import ash.core.Entity;
import ash.core.System;
import ash.core.Node;
import ash.core.NodeList;

import com.haxepunk.HXP;

import com.grinder.service.ConfigService;

import com.grinder.render.ImageView;
import com.grinder.render.BackdropView;
import com.grinder.render.GridView;
import com.grinder.render.MessageView;
import com.grinder.render.InventoryView;
import com.grinder.render.View;

import com.grinder.node.ImageNode;
import com.grinder.node.TileNode;
import com.grinder.node.BackdropNode;
import com.grinder.node.InventoryNode;
import com.grinder.node.GridNode;
import com.grinder.node.DisplayNode;
import com.grinder.node.MessageNode;
import com.grinder.node.MessageHudNode;

import com.grinder.component.Display;
import com.grinder.component.TiledImage;
import com.grinder.component.Layer;

class RenderingSystem extends System
{
	public var engine:Engine;
	public var tiledImage:TiledImage;

	public function new(engine:Engine)
	{
		super();
		this.engine = engine;
		tiledImage = ConfigService.getTiledImage();
		engine.getNodeList(DisplayNode).nodeRemoved.add(displayNodeRemoved);
	}

	private function displayNodeRemoved(node:DisplayNode): Void
	{
		// trace("Removing a display node for entity " + node.entity.name);
		HXP.world.remove(node.display.view);
	}

	// TO DO respond to move events
	override public function update(_)
	{
		updateViews(BackdropNode, BackdropView);
		updateViews(GridNode, GridView);
		updateViews(TileNode, ImageView);
		updateViews(ImageNode, ImageView);
		updateViews(InventoryNode, InventoryView);
		updateViews(MessageHudNode, MessageView);
	}

	private function updateViews<TNode:Node<TNode>>(nodeClass:Class<TNode>, viewClass:Class<View>)
	{
		// Loop through all nodes for this node class
	 	for(node in engine.getNodeList(nodeClass))
	 	{
	 		var entity = node.entity;

			// Create view if it does not exist
	 		if(!entity.has(Display))
	 		{
	 			var view:View = Type.createInstance(viewClass, [entity]);
				HXP.world.add(view);
				entity.add(new Display(view));
	 		}

	 		// Update the view
	 		entity.get(Display).view.nodeUpdate();
		}
	}	
}