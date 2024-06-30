/* TODO LIST

--> Items
    
    To be done prior to leaving for the week
        Warbanner
    
    Very easy, just time-consuming
        Filial Imprinting
        Ancient Scepter
    
    Still time-consuming, but less easy
        AtG
    
    Need to get a better understanding of this one
        Laser Turbine  
    
    Needs more moves added
        Ukelele
    
    Needs planning
        Legendary Spark
        57-Leaf Clover
        
    
        
        

--> List of missing assets on otherwise finished items
Lens' Maker's: Might need a gamefeel tell of some sort? idk
Soldier's Syringe: Bleed effect particles (?)
Kjaro's Band: HFX
Runald's Band: HFX
Locked Jewel/Predatory Instincts: possibly some sort of vfx?
Concussion Grenade: some form of visual idk
The Ol' Lopper: Visual
Shattering Justice: Visual




commando training mode menu
- probably hovers behind commando? 
- top panel is item list, bottom panel is descriptions + prompts
- how to implement word wrapping efficiently?

- when in training mode, add ignition tank to the item pool immediately

Text
default
- (A) Add item
- (B) Remove item

When no copies of an item are available, the (B) prompt simply disappears.
The (A) prompt can be replaced with text if it is unavailable
Max item quantity reached
Max rare quantity reached
Incompatible with [item name]


/* Warbanner handling

- Warbanner field should be colored with player color; it will be applied to teammates, too
- Warbanner owner is determined by which warbanner has the highest strength
- Whenever warbanner strength changes, commando_warbanner_updated flag is set to 1 as a signal
- This is technically compat, but I'll probably leave it undocumented

- Number of warbanner items is applied to warbanner during init as warbanner_strength; this remains constant until replaced
- Warbanner size scales with banners held
- Buffs applied by warbanner include:
    +(0.2*strength) damage multiplier (additive with crowbar)
    +1*strength move speed
    +2*strength attack speed

*/
