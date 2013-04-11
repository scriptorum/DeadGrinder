package com.grinder.node;

import ash.core.Node;

import com.grinder.component.Zombie;
import com.grinder.component.GridPosition;

class ZombieNode extends Node<ZombieNode>
{
	public var zombie:Zombie;
	public var position:GridPosition;
}