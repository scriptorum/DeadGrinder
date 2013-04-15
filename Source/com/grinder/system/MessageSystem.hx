
package com.grinder.system;

import ash.core.Engine;
import ash.core.Entity;
import ash.core.System;
import ash.core.Node;
import ash.core.NodeList;

import com.haxepunk.HXP;

import com.grinder.node.MessageNode;
import com.grinder.node.MessageHudNode;
import com.grinder.component.Display;

class MessageSystem extends System
{
	public var engine:Engine;

	public function new(engine:Engine)
	{
		super();
		this.engine = engine;
	}

	override public function update(_)
	{
	 	for(node in engine.getNodeList(MessageNode))
	 	{
			var messageHud = engine.getEntityByName("messageHud");
			if(messageHud == null || !messageHud.has(Display))
				HXP.log("Message HUD not available:" + node.message);

			else
			{
				messageHud.get(Display).view.addMessage(node.message);
				engine.removeEntity(node.entity); // message delivered, kill it
			}
		}
	}
}