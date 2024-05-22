/* TODO LIST (ordered~)

Item system
- Item HUD display (toss in some beta icons)
- Item granting routine (no visuals for now)
    * func generate_item(common_weight, uncommon_weight, rare_weight)
        calls func apply_item(item_id)
        return item_id
    * func show_item_info()
        relies on below article
    * When ready, rebind to DSPEC as appropriate
- Item info display
    * External article, responsible for both in-game popups and training
      mode item-granting interface
    * Defaults to an ephemeral pop-up, but can be manually set to remain
      until despawned
    * Controlled externally for the most part, internal functions include
      drawing the panel and tracking lifetime
- Training mode item granting menu (bound to DOWN+TAUNT)
    * This is going to take a decent amount of effort, but it'll be a precondition to testing items
    * Allows adding up to 10 of each common, 3 of each uncommon, and 1 of each rare
        * The common limit isn't enforced outside of training mode, it's just a sanity barrier
    * Special warning popup when granting excessive rare items; should not show
      up repeatedly once overridden
- Lock tentative final item grid order
    * After this point, items can only safely be dummied out or added/moved to an empty/dummy slot
- Proceed with item functionality