Config = {}

-- General Settings
Config.Debug = true -- Enable debug mode
Config.DefaultUseTime = 3000 -- Default time in ms for using items

-- Inventory System Configuration
Config.InventorySystem = 'ox_inventory' -- Options: 'ox_inventory' or 'qb_inventory'

-- Usable Items Configuration
Config.UsableItems = {
    -- Simple usable item (just gives notification)
    ['phone'] = {
        label = 'Phone',
        useTime = 2000,
        message = 'You used your phone!',
        removeOnUse = false, -- Set to true if you want to Remove the item when used
        animation = {
            dict = 'cellphone@',
            anim = 'cellphone_text_in',
            flag = 49
        }
    },

    -- Item that gives another item after use
    ['laptop'] = {
        label = 'Laptop',
        useTime = 5000,
        message = 'You hacked the laptop and found some data!',
        removeOnUse = false,
        reward = {
            items = {
                {item = 'usb_stick', amount = 1, chance = 100}, -- 100% chance to get usb_stick
                {item = 'laptop_parts', amount = 2, chance = 75}, -- 75% chance to get laptop_parts
                {item = 'cash', amount = 500, chance = 50} -- 50% chance to get cash
            }
        },
        animation = {
            dict = 'anim@heists@ornate_bank@hack',
            anim = 'hack_loop',
            flag = 1
        }
    },

    -- Item that requires another item to use
    ['lockpick'] = {
        label = 'Lockpick',
        useTime = 3000,
        message = 'You successfully picked the lock!',
        removeOnUse = true,
        requiredItem = {
            item = 'screwdriver',
            amount = 1,
            consume = false -- Set to true if you want to consume the required item
        },
        animation = {
            dict = 'anim@heists@fleeca_bank@ig_7_jetski_owner',
            anim = 'owner_idle',
            flag = 6
        }
    },

    -- Item with multiple requirements
    ['advanced_toolkit'] = {
        label = 'Advanced Toolkit',
        useTime = 8000,
        message = 'You used the advanced toolkit to craft some parts!',
        removeOnUse = true,
        requiredItem = {
            item = 'basic_toolkit',
            amount = 1,
            consume = true
        },
        reward = {
            items = {
                {item = 'repair_parts', amount = 3, chance = 75},
                {item = 'advanced_components', amount = 1, chance = 25},
                {item = 'cash', amount = 1000, chance = 10}
            }
        },
        animation = {
            dict = 'amb@world_human_welding@male@base',
            anim = 'base',
            flag = 1
        }
    },

    -- Food item example
    ['sandwich'] = {
        label = 'Sandwich',
        useTime = 4000,
        message = 'You ate the sandwich and feel refreshed!',
        removeOnUse = true, -- Consumes the sandwich when eaten
        reward = {
            items = {
                {item = 'health_boost', amount = 1, chance = 100},
                {item = 'stamina_boost', amount = 1, chance = 50}
            }
        },
        animation = {
            dict = 'mp_player_inteat@burger',
            anim = 'mp_player_int_eat_burger',
            flag = 49
        }
    },

    -- Drink item example
    ['water_bottle'] = {
        label = 'Water Bottle',
        useTime = 3000,
        message = 'You drank the water and feel hydrated!',
        removeOnUse = true, -- Consumes the water bottle when drunk
        reward = {
            items = {
                {item = 'stamina_boost', amount = 1, chance = 100},
                {item = 'health_boost', amount = 1, chance = 25}
            }
        },
        animation = {
            dict = 'mp_player_intdrink',
            anim = 'loop_bottle',
            flag = 49
        }
    },

    -- Medical item example
    ['bandage'] = {
        label = 'Bandage',
        useTime = 6000,
        message = 'You applied the bandage and feel better!',
        removeOnUse = true, -- Consumes the bandage when used
        reward = {
            items = {
                {item = 'health_boost', amount = 1, chance = 100},
                {item = 'painkillers', amount = 1, chance = 30}
            }
        },
        animation = {
            dict = 'amb@world_human_clipboard@male@idle_a',
            anim = 'idle_c',
            flag = 49
        }
    },

    -- Tool item example
    ['wrench'] = {
        label = 'Wrench',
        useTime = 4000,
        message = 'You used the wrench to tighten some bolts!',
        removeOnUse = false, -- Doesn't consume the wrench
        animation = {
            dict = 'amb@world_human_welding@male@base',
            anim = 'base',
            flag = 1
        }
    },

    -- Example with single reward (backward compatibility)
    ['simple_item'] = {
        label = 'Simple Item',
        useTime = 2000,
        message = 'You used the simple item!',
        removeOnUse = true,
        reward = {
            item = 'reward_item', -- Single item (old format still supported)
            amount = 1,
            chance = 100
        },
        animation = {
            dict = 'anim@heists@ornate_bank@hack',
            anim = 'hack_loop',
            flag = 1
        }
    }
}

-- Notification Settings
Config.Notifications = {
    success = {
        type = 'success',
        duration = 5000
    },
    error = {
        type = 'error',
        duration = 5000
    },
    info = {
        type = 'inform',
        duration = 3000
    }
}

-- Progress Bar Settings
Config.ProgressBar = {
    position = 'bottom',
    width = 300,
    height = 20
}
