package com.grinder.node;

import ash.core.Node;

import com.grinder.component.Health;
import com.grinder.component.HealthMutation;

class HealthMutationNode extends Node<HealthMutationNode>
{
	public var health:Health;
	public var mutation:HealthMutation;
}