package com.grinder.node;

import com.grinder.component.GridPosition;
import com.grinder.component.GridVelocity;
import com.grinder.component.Display;
import com.grinder.component.Collision;
import com.grinder.component.Player;
import com.grinder.component.Zombie;
import ash.core.Node;

class PlayerColliderNode extends Node<PlayerColliderNode>
{
	public var position:GridPosition;
	public var velocity:GridVelocity;
	public var collision:Collision;
	public var player:Player;
}

class ZombieColliderNode extends Node<ZombieColliderNode>
{
	public var position:GridPosition;
	public var velocity:GridVelocity;
	public var collision:Collision;
	public var zombie:Zombie;
}