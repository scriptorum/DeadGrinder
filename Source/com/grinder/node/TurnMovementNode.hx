package com.grinder.node;

import com.grinder.component.GridPosition;
import com.grinder.component.GridVelocity;
import com.grinder.component.Display;
import com.grinder.component.Player;
import com.grinder.component.Zombie;
import ash.core.Node;

class TurnMovementNode extends Node<TurnMovementNode>
{
	public var position:GridPosition;
	public var velocity:GridVelocity;
}

class PlayerMovementNode extends Node<PlayerMovementNode>
{
	public var position:GridPosition;
	public var velocity:GridVelocity;
	public var player:Player;
}

class ZombieMovementNode extends Node<ZombieMovementNode>
{
	public var position:GridPosition;
	public var velocity:GridVelocity;
	public var zombie:Zombie;
}