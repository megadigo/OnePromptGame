---
# RPG Dungeon - Complete Metadata Specification
# Single-prompt game recreation specification
file: rpg_dungeon_metadata.gaml # Name of this metadata file
version: "1.0" # Version number of this specification
description: | # Detailed description of what this file contains
  Complete metadata specification for an RPG Dungeon game project.
  This file outlines a working implementation using HTML5 Canvas.
  Top-down action RPG with procedural dungeons, combat, inventory, and progression.
schema: "https://github.com/megadigo/gaml-schema/blob/main/v0.0.1/gaml-schema.json" # URL to GAML schema definition

game:
  name: "RPG Dungeon" # Game title
  type: "Action RPG" # Genre
  extend: "classic_roguelike" # Base game type
  description: "Top-down dungeon crawler with procedural generation, combat, loot, and character progression" # Short description
  credits: 
    developer: "AI & megadigo (megadigo@gmail.com)" # Developer name
    contributors: ["Claude Sonnet 4.5", "Graphics Oryx (www.oryxdesignlab.com)"] # Contributors list
    license: "MIT" # License type

project:
  name: "rpg_dungeon" # Project folder name
  target: "web_browser" # Target platform
  page: "index.html" # Main HTML file
  engine: "HTML5_Canvas" # Game engine
  language: "Javascript" # Programming language

implementation: # Implementation details
  approach: "single_file_html" # Development approach
  dependencies: "none" # No external dependencies
  canvas_id: "game-canvas" # HTML canvas element ID

assets:
  - type: "image" # Sprite sheet for player and enemies
    id: "sprite_sheet" # Unique identifier
    path: "assets/tiny_dungeon_monsters.png" # Path to the image file
    tile_size: 16 # Each sprite is 16x16 pixels
    grid_size: [16, 16]  # 16 rows, 16 columns

window:
  width: 1000 # Canvas width in pixels
  height: 700 # Canvas height in pixels
  title: "RPG Dungeon"  # Browser window title

game_world:
  dungeon:
    grid_size: 40  # Each cell is 40x40 pixels
    rows: 15  # 600 pixels for dungeon
    columns: 20  # 800 pixels for dungeon
    offset_x: 20  # Left padding
    offset_y: 50  # Top padding for UI
    generation_rules:
      algorithm: "Binary Space Partition"  # BSP for room generation
      generation: "random_each_dungeon_level"  # Generate new dungeon each level
      rooms:
        room_count: 6  # Minimum rooms per level
        room_min_size: 3  # Minimum room dimension in grid cells
        room_max_size: 7  # Maximum room dimension in grid cells
        corridor_width: 1  # Width of corridors in grid cells
      floor_color: "#4A3728"  # Brown floor
      walls:
        color: "#2C1810"  # Dark brown walls
        render: "fillRect" # Rendering method for walls
      exit_stairs: # Configuration for exit stairs to next floor
        color: "#FFD700"  # Gold stairs
        spawn_rule: "farthest_room_from_player"  # Exit in farthest room
        requires: "all_enemies_defeated"  # Must defeat all enemies to spawn exit
        detection_radius: 50  # pixels - player proximity needed to trigger floor transition
        interaction: "automatic_on_proximity"  # Automatically advance when player is near

entities:

  player:
    name: "Hero"  # Player character name
    type: "player" # Entity type
    sprite_sheet_spec:          
      sprite_sheet: "sprite_sheet" # Use main sprite sheet           
      sprite_positions:
        right: { row: 3, col: 8 }  # Sprite position for facing right 
        down: { row: 3, col: 9 }    # Sprite position for facing down
        up: { row: 3, col: 10 }   # Sprite position for facing up
        left: { row: 3, col: 11 }  # Sprite position for facing left
      size: { width: 16, height: 16 } # Size of each sprite in pixels
      scale: 2  # Scale up 2x for better visibility
    size: 
      radius: 12  # Collision radius
    spawn_position: 
      rule: "first_room_center" # Start in center of first room
    speed: 3  # pixels per frame
    stats:
      max_health: 100 # Initial maximum health        
      health: 100   # Initial health
      attack: 20    # Initial attack power
      defense: 5  # Initial defense power
      level: 1     # Starting level
      experience: 0 # Starting experience
      experience_to_next_level: 100 # XP needed for level up
    combat:
      attack_range: 50  # pixels    
      attack_cooldown: 30  # frames
      attack_damage_multiplier: 1.0 # Base damage multiplier
      shooting_behavior: "auto_fire_when_space_held"  # Continuously shoots while space is pressed
      projectile_direction: "based_on_player_facing_direction"  # Shoots in direction player is facing
    inventory:
      max_slots: 10 # Maximum inventory slots
      gold: 0 # Initial gold
      potions: 3  # Initial health potions

  enemies:
    list:
      - name: "Acid Slime" # Enemy type name
        type: "slimes"  # Enemy category
        sprite_sheet: "sprite_sheet"  # Use main sprite sheet
        sprite_sheet_spec:
          sprite_positions:
            right: { row: 16, col: 8 } # Sprite position for facing right
            down: { row: 16, col: 9 }   # Sprite position for facing down
            up: { row: 16, col: 10 }     # Sprite position for facing up
            left: { row: 16, col: 11 }   # Sprite position for facing left
          size: { width: 16, height: 16 }  # Sprite size
          scale: 2  # Scale up 2x for better visibility
        collision_size: { radius: 10 }  # Collision radius
        color: "#00FF00"    # Bright green color
        health: 30  # Health points
        attack: 5 # Attack power
        defense: 2  # Defense power
        speed: 0.5  # Movement speed
        experience_value: 20  # XP granted on defeat
        gold_drop: { min: 5, max: 15 }  # Gold dropped on defeat
        spawn_chance: 0.5 # Spawn probability
        ai_behavior:    
          detection_range: 30  # pixels
          chase_player: true  # Enable chasing behavior
          attack_range: 15  # pixels
          attack_cooldown: 60  # frames 
      - name: "Deadly Skeleton" # Enemy type name
        type: "skeletons" # Enemy category
        sprite_sheet: "sprite_sheet" # Use main sprite sheet
        sprite_sheet_spec:
          sprite_positions:
            right: { row: 8, col: 4 } # Sprite position for facing right
            down: { row: 8, col: 5 } # Sprite position for facing down
            up: { row: 8, col: 6 } # Sprite position for facing up
            left: { row: 8, col: 7 } # Sprite position for facing left
          size: { width: 16, height: 16 } # Sprite size
          scale: 2 # Scale up 2x for better visibility
        collision_size: { radius: 10 } # Collision radius 
        color: "#CCCCCC" # Light gray color
        health: 50 # Health points
        attack: 8 # Attack power
        defense: 4 # Defense power
        speed: 1.5 # Movement speed
        experience_value: 35 # XP granted on defeat
        gold_drop: { min: 10, max: 25 } # Gold dropped on defeat
        spawn_chance: 0.3 # Spawn probability
        ai_behavior:
          detection_range: 100  # pixels
          chase_player: true  # Enable chasing behavior
          attack_range: 20  # pixels
          attack_cooldown: 60  # frames 
      - name: "Enourmous Orc" # Enemy type name
        type: "orcs" # Enemy category
        sprite_sheet: "sprite_sheet" # Use main sprite sheet
        sprite_sheet_spec:
          sprite_positions:
            right: { row: 6, col: 0 } # Sprite position for facing right
            down: { row: 6, col: 1 } # Sprite position for facing down
            up: { row: 6, col: 2 } # Sprite position for facing up
            left: { row: 6, col: 3 } # Sprite position for facing left
          size: { width: 6, height: 16 } # Sprite size
          scale: 2 # Scale up 2x for better visibility
        collision_size: { radius: 10 } # Collision radius
        color: "#228B22" # Dark green color
        health: 80 # Health points
        attack: 12 # Attack power
        defense: 6 # Defense power
        speed: 1.2 # Movement speed
        experience_value: 50 # XP granted on defeat
        gold_drop: { min: 20, max: 40 } # Gold dropped on defeat
        spawn_chance: 0.2 # Spawn probability
        ai_behavior:
          detection_range: 200  # pixels
          chase_player: true  # Enable chasing behavior 
          attack_range: 40  # pixels
          attack_cooldown: 60  # frames 
    spawn_rules:  
      enemies_per_room: { min: 1, max: 3 } # Number of enemies per room
      scale_with_level: true # Scale enemy stats with dungeon level
      exclude_player_room: true # Exclude player room from enemy spawns
      exclude_exit_room: true # Exclude exit room from enemy spawns

  items:
    list:
      - name: "health_potion" # Item type name
        sprite_sheet: "sprite_sheet" # Use main sprite sheet
        sprite_sheet_spec: 
          sprite_positions:
            full: { row: 28, col:13 } # Sprite position for full potion
          size: { width: 16, height: 16 } # Sprite size
          scale: 2 # Scale up 2x for better visibility
        collision_size: { radius: 12 } # Collision radius
        effect: "restore_50_health" # Effect on use
        spawn_chance: 0.3 # Spawn probability
      - name: "chest" # Item type name
        sprite_sheet: "sprite_sheet" # Use main sprite sheet
        sprite_sheet_spec:
          sprite_positions:
            open: { row: 23, col: 5 } # Sprite position for open chest
            close: { row: 22, col: 5 } # Sprite position for closed chest
          size: { width: 6, height: 16 } # Sprite size
          scale: 2 # Scale up 2x for better visibility
        collision_size: { radius: 12 } # Collision radius
        contains:
          gold: { min: 30, max: 100 } # Gold contained in chest
          potion_chance: 0.5  # Chance to contain a potion
        spawn_per_level: { min: 2, max: 4 } # Number of chests per dungeon level

  projectiles: # Projectile configuration for player and enemy attacks
    player_attack: # Player projectile specifications
      shape: "circle" # Projectile shape  
      size: { radius: 5 } # Projectile size
      color: "#FFFF00" # Yellow color
      speed: 8 # pixels per frame
      lifetime: 30  # frames 
      damage_base: 10 # Base damage
    enemy_attack: # Enemy projectile specifications
      shape: "circle" # Projectile shape
      size: { radius: 5 } # Projectile size
      color: "#FF0000" # Red color
      speed: 5 # pixels per frame
      lifetime: 30  # frames

resources: # Game resource definitions
  game_state: # Initial game state values
    initial_floor: 1 # Starting floor
    max_floor: 10  # Maximum dungeon floors
    initial_gold: 0 # Starting gold
    initial_potions: 3 # Starting health potions
  
  game_states: # Available game states
    available: ["menu", "howToPlay", "playing", "levelUp", "victory", "gameOver"] # List of game states
    default: "menu" # Default starting state
    
  input_handling: # Keyboard input configuration
    keydown_events: true # Enable keydown events
    keyup_events: true # Enable keyup events
    supported_keys: ["KeyW", "KeyA", "KeyS", "KeyD", "ArrowUp", "ArrowLeft", "ArrowDown", "ArrowRight", "Space", "KeyE", "KeyQ", "KeyR", "KeyH", "Escape","KeyS"] # Supported keys

game_states: # Configuration for each game state screen
  menu: # Main menu screen configuration
    canvas_rendering: # Rendering settings for this state
      background: "#1a1a1a"  # Dark gray background
      ui_elements: # List of UI elements to render
        - text: "RPG DUNGEON" # Game title
          font: "bold 60px Arial" # Font style
          color: "#FFD700"  # Gold
          position: 
            x: "center" # Centered horizontally
            y: 150
        - text: "AI-Generated Game" # Subtitle
          font: "22px Arial" # Font style
          color: "#CCCCCC"  # Light gray
          position:
            x: "center" # Centered horizontally
            y: 200 # Position below title
        - text: "Press S to Start" # Start game prompt
          font: "bold 30px Arial" # Font style
          color: "#00FF00"  # Green
          position:
            x: "center" # Centered horizontally
            y: 300
        - text: "Press H for How to Play" # How to play prompt
          font: "24px Arial" # Font style
          color: "#FFD700"  # Gold
          position:
            x: "center"
            y: 350
        - text: "Controls:" # Controls header
          font: "24px Arial" # Font style
          color: "#FFFFFF" # White
          position:
            x: "center" # Centered horizontally
            y: 430 # Position below prompts
        - text: "WASD/Arrows: Move | Space: Attack | E: Use Potion | Q: Interact" # Controls description
          font: "18px Arial" # Font style
          color: "#CCCCCC" # Light gray
          position:
            x: "center"
            y: 470 # Position below header
        - text: "Defeat all enemies and find the stairs!" # Game objective
          font: "20px Arial" # Font style
          color: "#FF6600" # Orange
          position:
            x: "center" # Centered horizontally
            y: 530 # Position below controls
    input_transitions: # Key press transitions to other states
      s_key: "playing" # Start game on S key
      h_key: "howToPlay" # Go to how to play on H key

  howToPlay: # How to play instructions screen
    canvas_rendering: # Rendering settings for this state
      background: "#1a1a1a"  # Dark gray background
      ui_elements: # List of UI elements to render
        - text: "HOW TO PLAY" # Page title
          font: "bold 50px Arial" # Font style
          color: "#FFD700"  # Gold color
          position:
            x: "center" # Centered horizontally
            y: 60 # Top position
        - text: "OBJECTIVE" # Objective section header
          font: "bold 28px Arial" # Font style
          color: "#00FF00" # Green color
          position:
            x: "center" # Centered horizontally
            y: 120 # Position below title
        - text: "Navigate through 10 procedurally generated dungeon floors." # Objective description line 1
          font: "18px Arial" # Font style
          color: "#CCCCCC" # Light gray color
          position:
            x: "center" # Centered horizontally
            y: 155 # Position below header
        - text: "Defeat all enemies on each floor to unlock the exit stairs." # Objective description line 2
          font: "18px Arial" # Font style
          color: "#CCCCCC" # Light gray color
          position:
            x: "center" # Centered horizontally
            y: 180 # Position below previous line
        - text: "CONTROLS" # Controls section header
          font: "bold 28px Arial" # Font style
          color: "#00FF00" # Green color
          position:
            x: "center" # Centered horizontally
            y: 230 # Position below objective section
        - text: "WASD or Arrow Keys - Move your hero" # Control description
          font: "18px Arial" # Font style
          color: "#CCCCCC" # Light gray color
          position:
            x: "center" # Centered horizontally
            y: 265 # Position below header
        - text: "SPACE - Shoot projectiles to attack enemies" # Control description
          font: "18px Arial" # Font style
          color: "#CCCCCC" # Light gray color
          position:
            x: "center" # Centered horizontally
            y: 290 # Position below previous line
        - text: "E - Use a health potion to restore 50 HP" # Control description
          font: "18px Arial" # Font style
          color: "#CCCCCC" # Light gray color
          position:
            x: "center" # Centered horizontally
            y: 315 # Position below previous line
        - text: "Q - Interact with chests and pick up items" # Control description
          font: "18px Arial" # Font style
          color: "#CCCCCC" # Light gray color
          position:
            x: "center" # Centered horizontally
            y: 340 # Position below previous line
        - text: "GAMEPLAY MECHANICS" # Gameplay section header
          font: "bold 28px Arial" # Font style
          color: "#00FF00" # Green color
          position:
            x: "center" # Centered horizontally
            y: 390 # Position below controls section
        - text: "• Collect gold from chests and defeated enemies" # Gameplay mechanic description
          font: "18px Arial" # Font style
          color: "#CCCCCC" # Light gray color
          position:
            x: "center" # Centered horizontally
            y: 425 # Position below header
        - text: "• Gain experience to level up and increase your stats" # Gameplay mechanic description
          font: "18px Arial" # Font style
          color: "#CCCCCC" # Light gray color
          position:
            x: "center" # Centered horizontally
            y: 450 # Position below previous line
        - text: "• Enemies get stronger as you progress through floors" # Gameplay mechanic description
          font: "18px Arial" # Font style
          color: "#CCCCCC" # Light gray color
          position:
            x: "center" # Centered horizontally
            y: 475 # Position below previous line
        - text: "• Health potions and chests spawn throughout the dungeon" # Gameplay mechanic description
          font: "18px Arial" # Font style
          color: "#CCCCCC" # Light gray color
          position:
            x: "center" # Centered horizontally
            y: 500 # Position below previous line
        - text: "TIPS" # Tips section header
          font: "bold 28px Arial" # Font style
          color: "#00FF00" # Green color
          position:
            x: "center" # Centered horizontally
            y: 550 # Position below gameplay section
        - text: "Use walls for cover and kite enemies with ranged attacks" # Tip description
          font: "18px Arial" # Font style
          color: "#CCCCCC" # Light gray color
          position:
            x: "center" # Centered horizontally
            y: 585 # Position below header
        - text: "Save health potions for tough encounters" # Tip description
          font: "18px Arial" # Font style
          color: "#CCCCCC" # Light gray color
          position:
            x: "center" # Centered horizontally
            y: 610 # Position below previous line
        - text: "Press ESC to Return to Menu" # Navigation instruction
          font: "bold 22px Arial" # Font style
          color: "#FFD700" # Gold color
          position:
            x: "center" # Centered horizontally
            y: 680 # Bottom position
    input_transitions: # Key press transitions to other states
      escape_key: "menu" # Return to menu on ESC key
      s_key: "playing" # Start game on S key

  playing: # Main gameplay state
    canvas_rendering: # Rendering settings for this state
      background: "#000000"  # Black background
      dungeon_floor_color: "#4A3728"  # Brown floor color
      dungeon_wall_color: "#2C1810"  # Dark brown wall color
      ui_elements: # List of HUD elements to render
        - text: "HP: {health}/{max_health}" # Health display with variable replacement
          font: "bold 18px Arial" # Font style
          color: "#FF0000" # Red color
          position: 
            x: 20 # Left side of screen
            y: 25 # Top position
            align: "left" # Left-aligned text
        - text: "Floor: {floor}" # Current floor display
          font: "bold 18px Arial" # Font style
          color: "#FFD700" # Gold color
          position:
            x: 200 # Position in HUD
            y: 25 # Top position
            align: "left" # Left-aligned text
        - text: "Level: {level}" # Player level display
          font: "bold 18px Arial" # Font style
          color: "#00FFFF" # Cyan color
          position:
            x: 340 # Position in HUD
            y: 25 # Top position
            align: "left" # Left-aligned text
        - text: "EXP: {exp}/{exp_needed}" # Experience display
          font: "bold 18px Arial" # Font style
          color: "#9370DB" # Purple color
          position:
            x: 480 # Position in HUD
            y: 25 # Top position
            align: "left" # Left-aligned text
        - text: "Gold: {gold}" # Gold display
          font: "bold 18px Arial" # Font style
          color: "#FFD700" # Gold color
          position:
            x: 720 # Position in HUD
            y: 25 # Top position
            align: "left" # Left-aligned text
        - text: "Potions: {potions}" # Potion count display
          font: "bold 18px Arial" # Font style
          color: "#FF1493" # Pink color
          position:
            x: 860 # Position in HUD
            y: 25 # Top position
            align: "left" # Left-aligned text
    
    controls: # Key bindings for gameplay
      movement: ["KeyW", "KeyA", "KeyS", "KeyD", "ArrowUp", "ArrowLeft", "ArrowDown", "ArrowRight"] # Movement keys
      attack: ["Space"]  # Hold to continuously shoot in facing direction
      use_potion: ["KeyE"] # Key to use health potion
      interact: ["KeyQ"] # Key to interact with objects
    
    collision_systems: # List of active collision detection systems
      - "player_vs_walls" # Player cannot pass through walls
      - "player_vs_enemies" # Detect player-enemy collisions
      - "player_vs_items" # Detect item pickup
      - "player_vs_chests" # Detect chest interaction
      - "player_vs_exit" # Detect exit stairs reached
      - "projectile_vs_enemies" # Detect projectile hits on enemies
      - "enemy_projectile_vs_player" # Detect enemy projectile hits on player
    
  levelUp: # Level up notification state
    duration: 90  # frames to display level up message
    canvas_rendering: # Rendering settings for this state
      background: "transparent_overlay" # Semi-transparent overlay over game
      ui_elements: # List of UI elements to render
        - text: "LEVEL UP!" # Level up announcement
          font: "bold 50px Arial" # Font style
          color: "#FFD700" # Gold color
          position:
            x: "center" # Centered horizontally
            y: 250 # Center position
        - text: "Level {level} | +10 HP | +2 ATK | +1 DEF" # Stat gains display
          font: "28px Arial" # Font style
          color: "#00FF00" # Green color
          position:
            x: "center" # Centered horizontally
            y: 320 # Position below announcement
    auto_transition: # Automatic state transition
      target_state: "playing" # Return to playing state
      delay: 90 # After 90 frames

  victory: # Victory screen state
    canvas_rendering: # Rendering settings for this state
      background: "#1a1a1a" # Dark gray background
      ui_elements: # List of UI elements to render
        - text: "VICTORY!" # Victory announcement
          font: "bold 60px Arial" # Font style
          color: "#FFD700" # Gold color
          position:
            x: "center" # Centered horizontally
            y: 200 # Top position
        - text: "You've conquered the dungeon!" # Victory message
          font: "32px Arial" # Font style
          color: "#00FF00" # Green color
          position:
            x: "center" # Centered horizontally
            y: 280 # Position below title
        - text: "Final Level: {level}" # Final level display
          font: "28px Arial" # Font style
          color: "#FFFFFF" # White color
          position:
            x: "center" # Centered horizontally
            y: 350 # Position below message
        - text: "Final Floor: {floor}" # Final floor display
          font: "28px Arial" # Font style
          color: "#FFFFFF" # White color
          position:
            x: "center" # Centered horizontally
            y: 390 # Position below level
        - text: "Gold Collected: {gold}" # Total gold display
          font: "28px Arial" # Font style
          color: "#FFD700" # Gold color
          position:
            x: "center" # Centered horizontally
            y: 430 # Position below floor
        - text: "Press R to Restart" # Restart instruction
          font: "24px Arial" # Font style
          color: "#00FF00" # Green color
          position:
            x: "center" # Centered horizontally
            y: 520 # Bottom position
    input_transitions: # Key press transitions to other states
      r_key: "playing" # Restart game on R key

  gameOver: # Game over screen state
    canvas_rendering: # Rendering settings for this state
      background: "#1a1a1a" # Dark gray background
      ui_elements: # List of UI elements to render
        - text: "GAME OVER" # Game over announcement
          font: "bold 60px Arial" # Font style
          color: "#FF0000" # Red color
          position:
            x: "center" # Centered horizontally
            y: 200 # Top position
        - text: "You have fallen..." # Defeat message
          font: "32px Arial" # Font style
          color: "#CCCCCC" # Light gray color
          position:
            x: "center" # Centered horizontally
            y: 280 # Position below title
        - text: "Final Level: {level}" # Final level display
          font: "28px Arial" # Font style
          color: "#FFFFFF" # White color
          position:
            x: "center" # Centered horizontally
            y: 350 # Position below message
        - text: "Floors Cleared: {floor}" # Floors cleared display
          font: "28px Arial" # Font style
          color: "#FFFFFF" # White color
          position:
            x: "center" # Centered horizontally
            y: 390 # Position below level
        - text: "Gold Collected: {gold}" # Total gold display
          font: "28px Arial" # Font style
          color: "#FFD700" # Gold color
          position:
            x: "center" # Centered horizontally
            y: 430 # Position below floor
        - text: "Press R to Restart" # Restart instruction
          font: "24px Arial" # Font style
          color: "#00FF00" # Green color
          position:
            x: "center" # Centered horizontally
            y: 520 # Bottom position
    input_transitions: # Key press transitions to other states
      r_key: "playing" # Restart game on R key

gameplay_systems: # Core gameplay mechanics definitions

  player_movement: # Player movement system configuration
    keys: # Key bindings for directional movement
      up: ["KeyW", "ArrowUp"] # Keys for moving up
      down: ["KeyS", "ArrowDown"] # Keys for moving down
      left: ["KeyA", "ArrowLeft"] # Keys for moving left
      right: ["KeyD", "ArrowRight"] # Keys for moving right
    speed: 3  # pixels per frame movement speed
    movement_type: "continuous" # Movement style (continuous vs grid-based)
    collision: "wall_detection" # Enable collision detection with walls
    diagonal_movement: true # Allow diagonal movement
  
  combat_system: # Combat mechanics configuration
    player_attack: # Player attack specifications
      type: "ranged_projectile" # Attack type
      trigger: "continuous_while_space_held"  # Auto-fire while holding space
      direction: "player_facing_direction"  # Shoots in the direction player is currently facing
      cooldown: 30  # frames between attacks
      damage_calculation: "base_attack * level_multiplier" # Damage formula
      knockback: 5  # pixels of knockback effect
    enemy_attack: # Enemy attack specifications
      type: "melee_and_ranged" # Attack types available
      trigger: "automatic_when_in_range" # Attacks automatically when player in range
      melee_range: 30  # pixels for melee attacks
      ranged_range: 200  # pixels for ranged attacks
      cooldown: 60  # frames between attacks
    damage_formula: "max(1, attacker.attack - defender.defense)" # Damage calculation formula
  
  experience_system: # Experience and leveling system
    level_up_formula: "100 * level" # XP required for next level
    stat_gains_per_level: # Stat increases per level up
      max_health: 10 # Max health increase
      attack: 2 # Attack increase
      defense: 1 # Defense increase
    health_restore_on_level: "full" # Restore full health on level up
  
  loot_system: # Loot drop configuration
    gold_drops: true # Enable gold drops from enemies
    item_drops: true # Enable item drops
    chest_contents: "random_gold_and_items" # Chest loot generation method
  
  progression_system: # Floor progression configuration
    floors: 10 # Total number of floors
    difficulty_scaling: # Difficulty increase per floor
      enemy_health_multiplier: 1.2  # per floor health increase
      enemy_attack_multiplier: 1.15  # per floor attack increase
      enemy_count_increase: 0.5  # per floor enemy count increase
  
  text_rendering: # Text rendering configuration
    context: "canvas_2d" # Rendering context type
    alignment_support: ["left", "right", "center"] # Supported text alignments

gameplay_conditions: # Conditions for game events

  level_progression: # Floor transition configuration
    trigger: "reach_exit_stairs" # What triggers floor advancement
    requirement: "all_enemies_defeated" # Requirement to spawn exit
    action: "increment_floor_and_generate_dungeon" # Action on transition
    difficulty_increase: true # Enable difficulty scaling
    detection_behavior: # Exit detection settings
      radius: 50  # pixels proximity needed to trigger
      check_frequency: "every_frame" # How often to check for proximity
      priority: "high" # Priority level of detection
      rule: "Check even during level up animation to prevent getting stuck" # Special detection rules
    
  game_over_conditions: # Conditions that trigger game over
    - "player_health <= 0" # Player dies when health reaches zero

  win_condition: # Conditions that trigger victory
    - "floor >= 10 AND reached_exit" # Win by completing floor 10

prompt_instruction: 

  STEPS:
  - Delete the previous code and create a new implementation from scratch
  - Create the game using this GAML specification.
  - The game must be immediately playable without any setup or compilation.

  METADATA:
  - The description of this file is provided by a meta file mention in the schema property. 
  - The meta file in a network location accessible to the AI in a github project. 
  - The meta file should be used to generate the game as specified and to understand the requirements.

  STRUCTURE: 
  - HTML with canvas element (id="game-canvas")
  - Show credits on main menu
  - CSS for styling and layout
  - All colors, positions, and sizes must match specification exactly
  - JavaScript game implementation with proper game loop
  - Use sprite sheet for all graphics
  - Game loop using requestAnimationFrame()
  - Keyboard event listeners MUST be set up in a function called at the END of the script
  - Game state management (menu/howToPlay/playing/levelUp/victory/gameOver)
  - Audio management (background music/sound effects)
  - Set up keyboard event listeners AFTER all functions are defined to avoid reference errors
  - Add preventDefault() for all game control keys to prevent default browser behaviors

  IMPLEMENTATION_REQUIREMENTS:
  - Ensure all game states transition correctly based on user input and game events
  - Ensure procedural dungeon generation works as specified
  - Ensure player and enemies movement and collision detection function correctly
  - Ensure combat mechanics (attacking, enemy AI, health management) function correctly
  - Ensure loot system (gold drops, item pickups, chest interactions) function correctly
  - Ensure level progression and difficulty scaling function correctly

  FIX:
  