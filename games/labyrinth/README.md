# Labyrinth Descent

A roguelike dungeon crawler for PICO-8, generated from a GAML (Game AI Metadata Language) specification.

## About

This project demonstrates how to use the GAML schema to define a complete game specification that can be used to generate a playable game. The game features:

- **Procedural dungeon generation** using Binary Space Partitioning
- **Turn-based combat** with multiple enemy types
- **RPG progression** with experience, leveling, and stat growth
- **Roguelike mechanics** including permadeath and dungeon exploration
- **Sprite-based graphics** with custom pixel art for all entities
- **10 floors** of increasing difficulty

## Files

- `labyrinth.gaml` - Complete game specification using GAML schema v0.0.1
- `labyrinth.p8` - Playable PICO-8 cartridge
- `README.md` - This file

## How to Play

### Running the Game

1. Install [PICO-8](https://www.lexaloffle.com/pico-8.php)
2. Open PICO-8 and type: `load labyrinth.p8`
3. Type: `run`

Or simply drag and drop `labyrinth.p8` onto the PICO-8 window.

### Controls

- **Arrow Keys** - Move your character
- **X Button** - Use health potion
- **ESC** - Exit to PICO-8 menu

### Gameplay

You are a hero exploring a dangerous labyrinth. Each floor is procedurally generated with rooms, corridors, monsters, and treasure.

**Goal**: Reach the exit stairs on floor 10 to escape the labyrinth.

**Enemies** (represented by pixel art sprites):
- **Rat** - Brown rodent (weak, common)
- **Skeleton** - White bones (moderate)
- **Orc** - Green warrior (strong)
- **Dragon** - Red wyrm (very strong, rare)

**Items** (represented by pixel art sprites):
- **Gold Pile** - Yellow coins (increases your wealth)
- **Health Potion** - Red bottle (restores 10 HP)
- **Chest** - Treasure chest (contains gold and possibly a potion)

**Combat**: Walk into an enemy to attack automatically. Damage is calculated based on your attack vs their defense. Enemies will chase and attack you when nearby.

**Leveling**: Defeating enemies grants experience. Level up to increase your max HP, attack, and defense. Your HP is fully restored on level up.

**HUD** (top of screen):
- **HP**: Current/Max Health
- **LV**: Character Level
- **FL**: Current Floor
- **$**: Gold Collected
- **!**: Potions Available

### Tips

- Use potions wisely - they're limited!
- Higher floors have tougher enemies
- Clear rooms before proceeding to the next floor
- Chests are rare but valuable
- Running away is sometimes the best strategy

## GAML Schema

This game was designed using the [GAML schema v0.0.1](https://github.com/megadigo/gaml-schema/blob/main/v0.0.1/gaml-schema.json), which provides a structured way to define:

- Game metadata and project structure
- Entity definitions (player, enemies, items)
- Game world configuration (dungeon generation)
- Gameplay systems (movement, combat, progression)
- Game states and UI
- Implementation requirements

The GAML file (`labyrinth.gaml`) serves as a complete specification that can be:
- Used by AI to generate game code
- Referenced for game design documentation
- Modified to create variants or expansions
- Validated against the schema for correctness

## Technical Details

**Platform**: PICO-8 (Fantasy Console)
**Language**: Lua
**Resolution**: 128x128 pixels
**Dungeon Size**: 16x16 tiles (8x8 pixels each)
**Graphics**: Custom 8x8 pixel sprites
**Token Count**: ~850 tokens (within PICO-8's 8192 limit)

**Dungeon Generation**:
- BSP-inspired room placement with corridor connections
- 5-7 rooms per floor
- Room sizes: 3-7 tiles
- Collision-free room placement with retry logic

**AI Behavior**:
- Enemies chase player when within 6 tiles
- Manhattan distance pathfinding
- Prefer moving along axis with greater distance

**Difficulty Scaling**:
- Enemy HP increases by 20% per floor
- Enemy attack increases by 20% per floor
- More enemies spawn in later floors

**Sprite Graphics**:
- Sprite 1: Player character (cyan hero)
- Sprites 16-19: Enemy types (rat, skeleton, orc, dragon)
- Sprites 32-34: Items (potion, gold, chest)
- Sprite 48: Exit stairs
- All sprites are 8x8 pixels with custom pixel art

## License

MIT License - Feel free to modify and share!

## Credits

- Game design: Generated from GAML schema
- Development: AI Assistant
- GAML Schema: https://github.com/megadigo/gaml-schema

## Future Enhancements

Possible additions (modify the GAML file and regenerate):
- More enemy types with unique behaviors
- Special abilities or spells
- Weapon and armor equipment
- Status effects (poison, stun, etc.)
- Shops between floors
- Different dungeon themes
- Boss battles on certain floors
- Unlockable characters
- Persistent achievements
