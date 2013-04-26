# Dead Grinder

Ideally, this would be a fully-playable undead survival roguelike, but right now it's just a pile of filthy code in Haxe. It uses the HaxePunk game library (http://haxepunk.com) and the Haxe port (http://github.com/nadako/Ash-HaXe) of Richard Lord's Ash entity system (http://www.ashframework.org).

## Building
It was written with Haxe 2.10, HaxePunk 1.72a, NME 3.5.4, and Neko 1.8.2. It only works properly with these lib versions, and targeted to Flash. The Neko target has a performance issue in the Ash lib; you can try it anyhow, but it'll slow down quickly on Ash-Haxe 1.4. I imagine 1.5 will fix that issue. The CPP target does not display right in HaxePunk 1.72a - you'll have to comment out the Backdrop (see GameWorld.initEntities). You could also just move to HaxePunk 2.2, however as of this writing that version has some text rendering issues the author is addressing. So ah ... there you go, nothing's perfect. I said it's just a pile of filthy code. Lots of stuff is not working.

## Playing
Move with the arrow keys or a numeric keypad, so you can go diagonally. with 7/9/1/3. Many keys require a direction to follow. 

(o)pen door
(c)lose door
(u)nlock door (where'd you get the key???)
(l)ock door
(a)ttack zombie
(i)nventory
(w)ield weapon
(e)at food
. = wait
Shift + Direction = examine

The map is procedurally generated like crap, using my proprietary "make a map look like crap - instantly!" technology. I'm working on some better designs. The weapons and food have the capability to use different stats, but right now they're identical. 

## Code Analysis
This code makes heavy use of the entity system provided by Ash. I have too many components and too few systems. I made the decision early on to eschew direct event handling, which Richard Lord discourages. There's only one location where I've got an event handler, inside RenderingSystem, which seemed to be a harmless way to remove view objects when their corresponding entity is destroyed. I've been messing around with alternatives, which include the presence of a component to indicate action is required, a flag inside a component that indicates the component values have changed, and in some cases I can use the component values themselves, comparing them against view objects for example to see if they've changed. It's hodge podge. There's also a fourth way to workaround events, which is don't - just reprocess the entity. In many cases I found that approach had no side effect, but it's not suitable for all situations. The components are very lightweight. Nearly all the logic is in the systems.

My GridService is a mess, it's a way to index entities by their position on the grid. I currently don't have a convenient way to keep that updated. I'm using GridPosition and GridVelocity components to manage changes within the grid, and a global "map" entity contains the grid boundaries and static tile data. This is a turn based game; some systems are extended from TurnBasedSystem which in turn looks at the "turn number" to determine if they should execute, so most of the time they're just returning quickly. When the player moves, the turn number is advanced. To support both human and zombie movement in the same turn I've got duplicate movement, health, and collision systems registered, but I don't like it. Blech. Ptooey. I'd rather have a human turn and a zombie turn, and also I need to give acting entities a speed component. Really I'm looking for more of a Night of the Living Dead than a 28 Days Later zombie, although I have love for both.

One thing I like about this setup is I can just add an Image component and a Position (free form position) or GridPosition (aligned to the map) to any entity and it will display on the screen. If I remove the Image, it will hide, although the entity still exists. If I add a Collision, the collision system will detect collisions with other collidable entities (well, theorically). If I alter the Layer component the display z-order will change (well, also theoretically). But the point is I change the configuration with a single interface and everything else magically works. Very nice.
 
## Profiler
I put in a basic profiler in there. To enable it, add the profiler definition to the nmml and use the [ key to dump the profile results to console (or to screen for flash). You can add any arbitrary block of code to the ProfileService, which was helpful in tracking down some performance issues.

## See Also
If this kind of thing is interesting to you, be sure to check out Dan Korostelev's Haxe Dungeons (https://github.com/nadako/Ash-HaXe), the author of the Ash Haxe port, which is also a roguelike game. (And a fair bit more playable than mine.)
