package com.grinder.node;

import ash.core.Node;

import com.grinder.component.Control;

class PlayerControlNode extends Node<PlayerControlNode>
{
	public var control:PlayerControl;
}

class InventoryControlNode extends Node<InventoryControlNode>
{
	public var control:InventoryControl;
}

class GameOverControlNode extends Node<GameOverControlNode>
{
	public var control:GameOverControl;
}

class ProfileControlNode extends Node<ProfileControlNode>
{
	public var control:ProfileControl;
}
