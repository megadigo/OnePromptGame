# GAML Schema - Game AI Markup Language

## Overview

**GAML (Game AI Markup Language)** is a universal schema specification designed for single-prompt game generation. It provides a structured, declarative way to define game specifications that AI systems can interpret and use to generate complete, playable games.

## Purpose

The GAML schema enables:
- ✅ **Single-Prompt Game Generation** - Define entire games in one structured file
- ✅ **AI-Friendly Format** - Clear, unambiguous specifications for AI interpretation
- ✅ **Multi-Genre Support** - Works for RPGs, shooters, platformers, puzzles, and more
- ✅ **Validation** - JSON Schema validation ensures correctness
- ✅ **Consistency** - Standardized format across all game types

## Schema Location

**Current Version:** v0.0.1
**Schema URL:** `https://github.com/megadigo/gaml-schema/blob/main/v0.0.1/gaml-schema.json`
**Local Path:** `./gaml-schema.json`

## File Structure

Every GAML file must include:

```yaml
---
file: game_metadata.gaml           # Filename
version: "1.0"                     # GAML spec version
description: |                     # Multi-line description
  Game description here
schema: "https://github.com/megadigo/gaml-schema"  # Schema reference
```

## Core Sections

### 1. **Game Definition**
Defines the game's basic identity and type:
```yaml
game:
  name: "Game Name"
  type: "Action RPG"              # Genre
  extend: "classic_roguelike"     # Optional template
  version: "1.0"
  description: "Detailed description"
```

**Supported Game Types:**
- Action RPG, Maze Chase, 2D Shooter, Platformer, Puzzle
- Strategy, Racing, Fighting, Card Game, Tower Defense

### 2. **Project Configuration**
Specifies technical implementation details:
```yaml
project:
  name: "project_folder"
  target: "web_browser"           # or desktop, mobile, console
  page: "index.html"
  engine: "HTML5_Canvas"          # or WebGL, SVG, DOM
  language: "Javascript"          # or TypeScript, Python, etc.
```

### 3. **Assets**
Defines game resources:
```yaml
assets:
  - type: "image"                 # or audio, font, data
    id: "sprite_sheet"
    path: "assets/sprites.png"
    tile_size: 16
    grid_size: [16, 16]           # columns, rows
```

### 4. **Window/Canvas**
Display configuration:
```yaml
window:
  width: 1000
  height: 700
  title: "Game Title"
```

### 5. **Game World / Playground**
World generation and structure:

**For RPGs/Dungeon Crawlers:**
```yaml
game_world:
  dungeon:
    grid_size: 40
    rows: 15
    columns: 20
    offset_x: 20
    offset_y: 50
    generation_rules:
      algorithm: "Binary Space Partition"
      generation: "random"
      room_count: 6
      wall_color: "#2C1810"
      floor_color: "#4A3728"
```

**For Maze Games:**
```yaml
gameplayground:
  maze:
    grid_size: 20
    rows: 29
    columns: 29
    generation_rules:
      algorithm: "Depth-First Search"
      wall_color: "#0000FF"
      path_color: "#000000"
```

### 6. **Entities**
Game objects and characters:

**Player:**
```yaml
entities:
  player:
    name: "Hero"
    sprite_sheet_spec:
      sprite_sheet: "sprite_sheet"
      sprite_positions:
        right: { row: 6, col: 1 }
        down: { row: 6, col: 2 }
        up: { row: 6, col: 3 }
        left: { row: 6, col: 4 }
      scale: 2
    speed: 3
    stats:
      max_health: 100
      attack: 10
      defense: 5
```

**Enemies (List-based):**
```yaml
  enemies:
    list:
      - name: "Slime"
        type: "slimes"
        health: 30
        attack: 5
        speed: 1
        ai_behavior:
          detection_range: 50
          chase_player: false
```

**Items:**
```yaml
  items:
    list:
      - name: "health_potion"
        color: "#FF0000"
        size: { radius: 8 }
        effect: "restore_50_health"
```

### 7. **Resources**
Game state and input configuration:
```yaml
resources:
  game_state:
    initial_floor: 1
    max_floor: 10
    initial_gold: 0
  
  game_states:
    available: ["menu", "playing", "gameOver", "victory"]
    default: "menu"
  
  input_handling:
    keydown_events: true
    supported_keys: ["KeyW", "KeyA", "Space"]
    mouse_events: ["click"]
```

### 8. **Game States**
UI and rendering for each state:
```yaml
game_states:
  menu:
    canvas_rendering:
      background: "#1a1a1a"
      ui_elements:
        - text: "GAME TITLE"
          font: "bold 60px Arial"
          color: "#FFD700"
          position: { x: "center", y: 150 }
    input_transitions:
      space_key: "playing"
```

### 9. **Gameplay Systems**
Core game mechanics:
```yaml
gameplay_systems:
  player_movement:
    keys:
      up: ["KeyW", "ArrowUp"]
      down: ["KeyS", "ArrowDown"]
    speed: 3
    movement_type: "continuous"
    diagonal_movement: true
  
  combat_system:
    player_attack:
      type: "ranged_projectile"
      cooldown: 30
      damage_calculation: "base_attack * level_multiplier"
```

### 10. **Prompt Instruction**
Detailed AI instructions for implementation:
```yaml
prompt_instruction: |
  Create a complete game using this GAML specification.
  
  METADATA:
  - The schema file provides complete documentation
  - All properties must be implemented as specified
  
  CRITICAL REQUIREMENTS:
  1. Use specified engine (HTML5 Canvas, etc.)
  2. Match all colors, sizes, positions exactly
  3. Implement all systems described
  4. Create single-file or modular structure as specified
```

## Schema Validation

### Validating GAML Files

To validate your GAML files against the schema:

1. **Install Validation Tool:**
```bash
npm install -g ajv-cli
```

2. **Convert YAML to JSON:**
```bash
# Install js-yaml if needed
npm install -g js-yaml

# Convert GAML to JSON
js-yaml your_game.gaml > your_game.json
```

3. **Validate:**
```bash
ajv validate -s gaml-schema.json -d your_game.json
```

### Python Validation Example

```python
import yaml
import jsonschema
import json

# Load schema
with open('gaml-schema.json', 'r') as f:
    schema = json.load(f)

# Load and validate GAML file
with open('your_game.gaml', 'r') as f:
    gaml_data = yaml.safe_load(f)

# Validate
jsonschema.validate(instance=gaml_data, schema=schema)
print("✓ GAML file is valid!")
```

## Game Generation Workflow

### 1. Design Phase
- Define game concept and genre
- Choose engine and target platform
- Plan entities, systems, and progression

### 2. GAML Authoring
- Create `.gaml` file with complete specification
- Reference schema: `schema: "https://github.com/megadigo/gaml-schema"`
- Include detailed `prompt_instruction` section

### 3. Validation
- Validate GAML against schema
- Ensure all required fields present
- Check property types and formats

### 4. AI Generation
- Provide GAML file to AI system
- AI reads schema from URL/reference
- AI generates complete game code
- Output is immediately playable

### 5. Iteration
- Test generated game
- Update GAML specification
- Regenerate if needed

## Best Practices

### ✅ DO:
- **Reference the schema** - Always include schema URL
- **Be specific** - Detailed specifications = better results
- **Use colors correctly** - Hex format `#RRGGBB`
- **Document behavior** - Explain complex systems in comments
- **Test validation** - Validate before generation
- **Include prompt_instruction** - Guide AI implementation

### ❌ DON'T:
- **Skip required fields** - Schema enforces required properties
- **Use invalid enums** - Check schema for allowed values
- **Mix position types** - Be consistent (pixels OR grid)
- **Forget asset references** - Link entities to asset IDs
- **Omit AI instructions** - prompt_instruction is critical

## Examples

### Example 1: Simple Shooter
```yaml
game:
  name: "Space Shooter"
  type: "2D Shooter"
  engine: "HTML5_Canvas"
  
entities:
  player:
    shape: "triangle"
    speed: 5
    
  enemies:
    count: 50
    formation:
      rows: 5
      columns: 10
```

### Example 2: RPG
```yaml
game:
  name: "Dungeon Quest"
  type: "Action RPG"
  extend: "classic_roguelike"
  
game_world:
  dungeon:
    generation_rules:
      algorithm: "Binary Space Partition"
      
entities:
  enemies:
    list:
      - name: "Goblin"
        health: 30
        ai_behavior:
          chase_player: true
```

## Schema Extensions

The schema supports custom properties via `additionalProperties: true` in key sections:
- Custom entity types
- Custom gameplay systems
- Custom game states
- Genre-specific mechanics

## Version History

- **v0.0.1** (2025-10-23)
  - Initial schema release
  - Support for RPG, Shooter, Maze, Platformer genres
  - Universal entity and system definitions
  - Comprehensive validation rules

## Contributing

To propose schema changes:
1. Fork the repository
2. Update `gaml-schema.json`
3. Add examples demonstrating new features
4. Submit pull request with documentation

## License

GAML Schema is open source. See LICENSE file for details.

## Support

- **Issues:** GitHub Issues
- **Discussions:** GitHub Discussions
- **Examples:** See `*/` game folders for complete GAML examples

---

**Generated games are immediately playable with no setup required.**
