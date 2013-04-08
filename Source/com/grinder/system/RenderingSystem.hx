
package com.grinder.system;

import ash.core.Engine;
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
import com.grinder.node.ImageNode;
import com.grinder.node.TileNode;
import com.grinder.node.BackdropNode;
import com.grinder.node.GridNode;
import com.grinder.node.DisplayNode;
import com.grinder.node.MessageNode;
import com.grinder.node.SpawnNode;
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

		engine.getNodeList(ImageNode).nodeAdded.add(imageNodeAdded);
		engine.getNodeList(TileNode).nodeAdded.add(tileNodeAdded);
		engine.getNodeList(BackdropNode).nodeAdded.add(backdropNodeAdded);
		engine.getNodeList(GridNode).nodeAdded.add(gridNodeAdded);
		engine.getNodeList(MessageNode).nodeAdded.add(messageNodeAdded);
		engine.getNodeList(SpawnNode).nodeAdded.add(spawnNodeAdded);

		engine.getNodeList(DisplayNode).nodeRemoved.add(displayNodeRemoved);
	}

	private function tileNodeAdded(node:TileNode): Void
	{
		trace("Adding image view (tile) for entity " + node.entity.name);
		trace("Layer is " + (node.entity.has(Layer) ? node.entity.get(Layer).layer : "default"));
		var e = new ImageView(node.entity);
		HXP.world.add(e);
		node.entity.add(new Display(e));
	}

	private function imageNodeAdded(node:ImageNode): Void
	{
		trace("Adding image view (clip) for entity " + node.entity.name);
		trace("Layer is " + (node.entity.has(Layer) ? node.entity.get(Layer).layer : "default"));
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

	private function messageNodeAdded(node:MessageNode): Void
	{
		var messageHud = engine.getEntityByName("messageHud");
		if(messageHud == null)
			trace("HUD Not available: " + node.message.text);
		else messageHud.get(Display).view.addMessage(node.message);
		engine.removeEntity(node.entity);
	}

	// Move to SpawnSystem
	private function spawnNodeAdded(node:SpawnNode): Void
	{
		switch(node.spawn.type)
		{
			case "messageHud":
			var e = new MessageView(node.entity);
			HXP.world.add(e);
			node.entity.add(new Display(e));

			case "inventory":
			var e = new InventoryView(node.entity);
			HXP.world.add(e);
			node.entity.add(new Display(e));
		}
	}

	private function displayNodeRemoved(node:DisplayNode): Void
	{
		trace("Removing a display node for entity " + node.entity.name);
		HXP.world.remove(node.display.view);
	}

	// TO DO respond to move events
	override public function update(_)
	{
	 	for(node in engine.getNodeList(DisplayNode))
			node.display.view.nodeUpdate(); // TODO call Entity.update instead
	}
}