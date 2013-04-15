package com.grinder.node;

import ash.core.Node;

import com.grinder.component.Health;
import com.grinder.component.Damage;

class DamageNode extends Node<DamageNode>
{
	public var health:Health;
	public var damage:Damage;
}