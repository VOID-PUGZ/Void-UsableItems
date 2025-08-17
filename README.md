# Void UsableItems Script

A comprehensive and easy-to-use script for ox_inventory that allows players to use items with various features including required items, rewards, animations, and progress bars.

## Features

- ✅ **ox_inventory Integration** - Works seamlessly with ox_inventory
- ✅ **ox_lib Progress Bars** - Beautiful progress bars for item usage
- ✅ **QBCore Notifications** - Uses QBCore's notification system
- ✅ **Required Items** - Items can require other items to be used
- ✅ **Item Rewards** - Items can give other items after use
- ✅ **Multiple Rewards** - Support for multiple items with individual chances
- ✅ **Chance System** - Configurable chance for rewards
- ✅ **Remove on Use** - Option to consume items when used
- ✅ **Animations** - Custom animations for each item
- ✅ **Custom Messages** - Personalized messages for each item
- ✅ **Admin Commands** - Easy testing and management

## Dependencies

- ox_inventory
- ox_lib
- qb-core

## Installation

1. Place the script in your resources folder
2. Add `ensure Void-UsableItems` to your server.cfg
3. Restart your server

## Configuration

### Basic Item Structure

```lua
['item_name'] = {
    label = 'Display Name',
    useTime = 3000, -- Time in ms to use the item
    message = 'Custom message when used',
    removeOnUse = false, -- Set to true to consume the item when used
    animation = {
        dict = 'animation_dictionary',
        anim = 'animation_name',
        flag = 49
    }
}
```

### Item with Single Reward

```lua
['laptop'] = {
    label = 'Laptop',
    useTime = 5000,
    message = 'You hacked the laptop and found some data!',
    removeOnUse = false,
    reward = {
        item = 'usb_stick',
        amount = 1,
        chance = 100 -- 100% chance to get the item
    },
    animation = {
        dict = 'anim@heists@ornate_bank@hack',
        anim = 'hack_loop',
        flag = 1
    }
}
```

### Item with Multiple Rewards

```lua
['advanced_toolkit'] = {
    label = 'Advanced Toolkit',
    useTime = 8000,
    message = 'You used the advanced toolkit to craft some parts!',
    removeOnUse = true, -- Consumes the toolkit when used
    reward = {
        items = {
            {item = 'repair_parts', amount = 3, chance = 75}, -- 75% chance
            {item = 'advanced_components', amount = 1, chance = 25}, -- 25% chance
            {item = 'cash', amount = 1000, chance = 10} -- 10% chance
        }
    },
    animation = {
        dict = 'amb@world_human_welding@male@base',
        anim = 'base',
        flag = 1
    }
}
```

### Item with Required Item

```lua
['lockpick'] = {
    label = 'Lockpick',
    useTime = 3000,
    message = 'You successfully picked the lock!',
    removeOnUse = true, -- Consumes the lockpick when used
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
}
```

### Item with Both Requirements and Multiple Rewards

```lua
['sandwich'] = {
    label = 'Sandwich',
    useTime = 4000,
    message = 'You ate the sandwich and feel refreshed!',
    removeOnUse = true, -- Consumes the sandwich when eaten
    reward = {
        items = {
            {item = 'health_boost', amount = 1, chance = 100}, -- Always get health boost
            {item = 'stamina_boost', amount = 1, chance = 50} -- 50% chance for stamina boost
        }
    },
    animation = {
        dict = 'mp_player_inteat@burger',
        anim = 'mp_player_int_eat_burger',
        flag = 49
    }
}
```

## Configuration Options

### removeOnUse
- **true**: The item will be consumed (removed from inventory) when used
- **false**: The item will remain in inventory after use
- **Default**: false

### Multiple Rewards
- Use `items` array for multiple rewards
- Each reward has its own `item`, `amount`, and `chance`
- Individual chance calculation for each reward
- Backward compatible with single reward format

### Required Items
- Items can require other items to be used
- `consume` option determines if required item is consumed
- Multiple required items supported

## Admin Commands

### `/giveusableitem [id] [item] [amount]`
Gives a usable item to a player (Admin Only)

### `/listusableitems`
Lists all configured usable items

### `/reloadusableitems`
Reloads the configuration (Admin Only)

## Adding New Items

To add a new usable item:

1. Open `config.lua`
2. Add a new entry to `Config.UsableItems`
3. Configure the item properties
4. Restart the resource

Example:
```lua
['new_item'] = {
    label = 'New Item',
    useTime = 2000,
    message = 'You used the new item!',
    removeOnUse = true, -- Will be consumed when used
    reward = {
        items = {
            {item = 'reward1', amount = 1, chance = 100},
            {item = 'reward2', amount = 2, chance = 50}
        }
    },
    animation = {
        dict = 'anim@heists@ornate_bank@hack',
        anim = 'hack_loop',
        flag = 1
    }
}
```

## Animation Flags

Common animation flags:
- `0` - Normal
- `1` - Loop
- `6` - Upper body only
- `49` - Upper body + movement

## Progress Bar Options

The script uses ox_lib progress bars with these default settings:
- Duration: Configurable per item
- Position: Bottom
- Width: 300px
- Height: 20px
- Can be cancelled
- Disables movement, car, and combat while using

## Debug Mode

Enable debug mode in `config.lua`:
```lua
Config.Debug = true
```

This will show:
- Item registration logs
- Usage logs
- Reward distribution logs
- Item consumption logs
- Debug command output

## Support

For support or questions, please refer to the Void Scripts community.
