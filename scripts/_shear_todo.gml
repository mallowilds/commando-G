/* TODO LIST

--> Items
    
    Very easy, just time-consuming
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
Headstompers: Needs vfx. (Would sfx be good too?)
Lens' Maker's: Some sort of gamefeel tell might be appropriate
Kjaro's Band: HFX
Runald's Band: HFX
Locked Jewel/Predatory Instincts: possibly some sort of vfx?
Concussion Grenade: some form of visual idk
The Ol' Lopper: Visual
Shattering Justice: Visual
Classified Access Codes: bomb. also probably needs a new explosion, given that the mollo bomb has the symbol




commando training mode menu

When no copies of an item are available, the (B) prompt simply disappears.
The (A) prompt can be replaced with text if it is unavailable
Max item quantity reached
Max rare quantity reached
Incompatible with [item name]



NSpec reqs
provided requirements:
    Normally, it just shoots a single beam, which acts as a large disjointed hitbox (projectile). It should be segmented into 2 hitboxes, with the further one having reduced power.
    Attack Speed: Every stack of attack speed adds a multihit to it, using the 'multihit hold' window. The hits should be extremely fast and dont need to be segmented into 2 hitboxes, since they should just be weak and very low hitpause.
    Ancient Scepter: The beam will get larger, and the final hit will have more knockback, along with not having KB falloff. It will also have 3 or so frames reduced startup (if needed? just think it'd be cool)
    Laser Turbine: When you fill up the meter for Laser Turbine to activate, No matter your attack speed, it will be replaced with a single, large laser, that doesnt have falloff.
personal notes:
    Base implmentation is done at this point
    Probably farm out ancient scepter/laser turbine procs to separate attack indices?
