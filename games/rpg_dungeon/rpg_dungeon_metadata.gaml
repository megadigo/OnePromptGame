---
# RPG Dungeon - Complete Metadata Specification
# Single-prompt game recreation specification
file: rpg_dungeon_metadata.gaml 
version: "1.0"
description: |
  Complete metadata specification for an RPG Dungeon game project.
  This file outlines a working implementation using HTML5 Canvas.
  Top-down action RPG with procedural dungeons, combat, inventory, and progression.
schema: "https://github.com/megadigo/gaml-schema/blob/main/v0.0.1/gaml-schema.json"
game:
  name: "RPG Dungeon"
  type: "Action RPG"
  extend: "classic_roguelike"
  version: "1.0"
  description: "Top-down dungeon crawler with procedural generation, combat, loot, and character progression"

project:
  name: "rpg_dungeon"
  target: "web_browser"
  page: "index.html"
  engine: "HTML5_Canvas"
  language: "Javascript"

assets:
  - type: "image"
    id: "sprite_sheet"
    path: "assets/pixelart.png"
    tile_size: 16
    grid_size: [16, 16]  # 16 rows, 16 columns

window:
  width: 1000
  height: 700
  title: "RPG Dungeon"

game_world:
  dungeon:
    grid_size: 40  # Each cell is 40x40 pixels
    rows: 15  # 600 pixels for dungeon
    columns: 20  # 800 pixels for dungeon
    offset_x: 20  # Left padding
    offset_y: 50  # Top padding for UI
    generation_rules:
      algorithm: "Binary Space Partition"  # BSP for room generation
      generation: "random"  # Generate new dungeon each level
      room_count: 6  # Minimum rooms per level
      room_min_size: 3  # Minimum room dimension in grid cells
      room_max_size: 7  # Maximum room dimension in grid cells
      corridor_width: 1  # Width of corridors
      wall_color: "#2C1810"  # Dark brown walls
      floor_color: "#4A3728"  # Brown floor
      wall_render: "fillRect"
      door_count: 3  # Doors to unlock per level
      door_color: "#8B4513"  # Saddle brown
      exit_stairs:
        color: "#FFD700"  # Gold stairs
        spawn_rule: "farthest_room_from_player"
        requires: "all_enemies_defeated"

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
      size: { width: 16, height: 16 }
      scale: 2  # Scale up 2x for better visibility
    size: 
      radius: 15
    spawn_position: 
      rule: "first_room_center"
    speed: 3  # pixels per frame
    stats:
      max_health: 100
      health: 100
      attack: 10
      defense: 5
      level: 1
      experience: 0
      experience_to_next_level: 100
    combat:
      attack_range: 50  # pixels
      attack_cooldown: 30  # frames
      attack_damage_multiplier: 1.0
    inventory:
      max_slots: 10
      gold: 0
      potions: 3
      keys: 0  

  enemies:
    list:
      - name: "Acid Slime"
        type: "slimes"
        sprite_sheet_spec:
          sprite_sheet: "sprite_sheet"
          sprite_positions:
            right: { row: 9, col: 17 }
            down: { row: 9, col: 18 }
            up: { row: 9, col: 19 }
            left: { row: 9, col: 20 }
            size: { width: 16, height: 16 }
        scale: 1.5
        size: { radius: 12 }
        color: "#00FF00"
        health: 30
        attack: 5
        defense: 2
        speed: 1
        experience_value: 20
        gold_drop: { min: 5, max: 15 }
        spawn_chance: 0.5
        ai_behavior:
          detection_range: 50  # pixels
          chase_player: false
          attack_range: 30  # pixels
          attack_cooldown: 60  # frames 
      - name: "Deadly Skeleton"
        type: "skeletons"
        sprite_sheet_spec:
          sprite_sheet: "sprite_sheet"
          sprite_positions:
            right: { row: 9, col: 5 }
            down: { row: 9, col: 6 }
            up: { row: 9, col: 7 }
            left: { row: 9, col: 8 }
          size: { width: 16, height: 16 }
          scale: 1.5
        size: { width: 20, height: 20 }
        color: "#CCCCCC"
        health: 50
        attack: 8
        defense: 4
        speed: 1.5
        experience_value: 35
        gold_drop: { min: 10, max: 25 }
        spawn_chance: 0.3
        ai_behavior:
          detection_range: 100  # pixels
          chase_player: true
          attack_range: 20  # pixels
          attack_cooldown: 60  # frames 
      - name: "Enourmous Orc"
        type: "orcs"
        sprite_sheet_spec:
          sprite_sheet: "sprite_sheet"
          sprite_positions:
            right: { row: 13, col: 7 }
            down: { row: 13, col: 8 }
            up: { row: 13, col: 9 }
            left: { row: 13, col: 10 }
          size: { width: 16, height: 16 }
          scale: 1.5
        size: { width: 25, height: 25 }
        color: "#228B22"
        health: 80
        attack: 12
        defense: 6
        speed: 1.2
        experience_value: 50
        gold_drop: { min: 20, max: 40 }
        spawn_chance: 0.2
        ai_behavior:
          detection_range: 200  # pixels
          chase_player: true
          attack_range: 40  # pixels
          attack_cooldown: 60  # frames 
    spawn_rules:
      enemies_per_room: { min: 1, max: 3 }
      scale_with_level: true
      exclude_player_room: true
      exclude_exit_room: true

  items:
    list:
      - name: "health_potion"
        color: "#FF0000"
        size: { radius: 8 }
        effect: "restore_50_health"
        spawn_chance: 0.3
      - name: "chest"
        color: "#8B4513"
        size: { width: 20, height: 15 }
        contains:
          gold: { min: 30, max: 100 }
          potion_chance: 0.5
        spawn_per_level: { min: 2, max: 4 }
      - name: "key"
        color: "#FFD700"
        size: { radius: 6 }
        effect: "unlock_door"
        spawn_per_level: 3

  projectiles:
    player_attack:
      shape: "circle"
      size: { radius: 5 }
      color: "#FFFF00"
      speed: 8
      lifetime: 30  # frames
      damage_base: 10
    enemy_attack:
      shape: "circle"
      size: { radius: 5 }
      color: "#FF0000"
      speed: 5
      lifetime: 30  # frames

resources:
  game_state:
    initial_floor: 1
    max_floor: 10
    initial_gold: 0
    initial_potions: 3
  
  game_states:
    available: ["menu", "playing", "levelUp", "victory", "gameOver"]
    default: "menu"
    
  input_handling:
    keydown_events: true
    keyup_events: true
    supported_keys: ["KeyW", "KeyA", "KeyS", "KeyD", "ArrowUp", "ArrowLeft", "ArrowDown", "ArrowRight", "Space", "KeyE", "KeyQ", "KeyR"]
    mouse_events: ["click"]

game_states:
  menu:
    canvas_rendering:
      background: "#1a1a1a"  # Dark gray
      ui_elements:
        - text: "RPG DUNGEON"
          font: "bold 60px Arial"
          color: "#FFD700"  # Gold
          position: 
            x: "center"
            y: 150
        - text: "AI-Generated Game"
          font: "22px Arial"
          color: "#CCCCCC"  # Light gray
          position:
            x: "center"
            y: 200
        - text: "Press SPACE to Start"
          font: "bold 30px Arial"
          color: "#00FF00"  # Green
          position:
            x: "center"
            y: 300
        - text: "Controls:"
          font: "24px Arial"
          color: "#FFFFFF"
          position:
            x: "center"
            y: 380
        - text: "WASD/Arrows: Move | Space: Attack | E: Use Potion | Q: Interact"
          font: "18px Arial"
          color: "#CCCCCC"
          position:
            x: "center"
            y: 420
        - text: "Defeat all enemies and find the stairs!"
          font: "20px Arial"
          color: "#FF6600"
          position:
            x: "center"
            y: 480
    input_transitions:
      space_key: "playing"

  playing:
    canvas_rendering:
      background: "#000000"  # Black
      dungeon_floor_color: "#4A3728"  # Brown
      dungeon_wall_color: "#2C1810"  # Dark brown
      ui_elements:
        - text: "HP: {health}/{max_health}"
          font: "bold 18px Arial"
          color: "#FF0000"
          position: 
            x: 20
            y: 25
            align: "left"
        - text: "Floor: {floor}"
          font: "bold 18px Arial"
          color: "#FFD700"
          position:
            x: 200
            y: 25
            align: "left"
        - text: "Level: {level}"
          font: "bold 18px Arial"
          color: "#00FFFF"
          position:
            x: 340
            y: 25
            align: "left"
        - text: "EXP: {exp}/{exp_needed}"
          font: "bold 18px Arial"
          color: "#9370DB"
          position:
            x: 480
            y: 25
            align: "left"
        - text: "Gold: {gold}"
          font: "bold 18px Arial"
          color: "#FFD700"
          position:
            x: 720
            y: 25
            align: "left"
        - text: "Potions: {potions}"
          font: "bold 18px Arial"
          color: "#FF1493"
          position:
            x: 860
            y: 25
            align: "left"
    
    controls:
      movement: ["KeyW", "KeyA", "KeyS", "KeyD", "ArrowUp", "ArrowLeft", "ArrowDown", "ArrowRight"]
      attack: ["Space"]
      use_potion: ["KeyE"]
      interact: ["KeyQ"]
    
    collision_systems:
      - "player_vs_walls"
      - "player_vs_enemies"
      - "player_vs_items"
      - "player_vs_chests"
      - "player_vs_doors"
      - "player_vs_exit"
      - "projectile_vs_enemies"
      - "enemy_projectile_vs_player"

  levelUp:
    duration: 90  # frames
    canvas_rendering:
      background: "transparent_overlay"
      ui_elements:
        - text: "LEVEL UP!"
          font: "bold 50px Arial"
          color: "#FFD700"
          position:
            x: "center"
            y: 250
        - text: "Level {level} | +10 HP | +2 ATK | +1 DEF"
          font: "28px Arial"
          color: "#00FF00"
          position:
            x: "center"
            y: 320
    auto_transition:
      target_state: "playing"
      delay: 90

  victory:
    canvas_rendering:
      background: "#1a1a1a"
      ui_elements:
        - text: "VICTORY!"
          font: "bold 60px Arial"
          color: "#FFD700"
          position:
            x: "center"
            y: 200
        - text: "You've conquered the dungeon!"
          font: "32px Arial"
          color: "#00FF00"
          position:
            x: "center"
            y: 280
        - text: "Final Level: {level}"
          font: "28px Arial"
          color: "#FFFFFF"
          position:
            x: "center"
            y: 350
        - text: "Final Floor: {floor}"
          font: "28px Arial"
          color: "#FFFFFF"
          position:
            x: "center"
            y: 390
        - text: "Gold Collected: {gold}"
          font: "28px Arial"
          color: "#FFD700"
          position:
            x: "center"
            y: 430
        - text: "Press R to Restart"
          font: "24px Arial"
          color: "#00FF00"
          position:
            x: "center"
            y: 520
    input_transitions:
      r_key: "playing"

  gameOver:
    canvas_rendering:
      background: "#1a1a1a"
      ui_elements:
        - text: "GAME OVER"
          font: "bold 60px Arial"
          color: "#FF0000"
          position:
            x: "center"
            y: 200
        - text: "You have fallen..."
          font: "32px Arial"
          color: "#CCCCCC"
          position:
            x: "center"
            y: 280
        - text: "Final Level: {level}"
          font: "28px Arial"
          color: "#FFFFFF"
          position:
            x: "center"
            y: 350
        - text: "Floors Cleared: {floor}"
          font: "28px Arial"
          color: "#FFFFFF"
          position:
            x: "center"
            y: 390
        - text: "Gold Collected: {gold}"
          font: "28px Arial"
          color: "#FFD700"
          position:
            x: "center"
            y: 430
        - text: "Press R to Restart"
          font: "24px Arial"
          color: "#00FF00"
          position:
            x: "center"
            y: 520
    input_transitions:
      r_key: "playing"

gameplay_systems:
  player_movement:
    keys: 
      up: ["KeyW", "ArrowUp"]
      down: ["KeyS", "ArrowDown"]
      left: ["KeyA", "ArrowLeft"]
      right: ["KeyD", "ArrowRight"]
    speed: 3  # pixels per frame
    movement_type: "continuous"
    collision: "wall_detection"
    diagonal_movement: true
  
  combat_system:
    player_attack:
      type: "ranged_projectile"
      cooldown: 30  # frames
      damage_calculation: "base_attack * level_multiplier"
      knockback: 5  # pixels
    enemy_attack:
      type: "melee_and_ranged"
      melee_range: 30  # pixels
      ranged_range: 200  # pixels
      cooldown: 60  # frames
    damage_formula: "max(1, attacker.attack - defender.defense)"
  
  experience_system:
    level_up_formula: "100 * level"
    stat_gains_per_level:
      max_health: 10
      attack: 2
      defense: 1
    health_restore_on_level: "full"
  
  loot_system:
    gold_drops: true
    item_drops: true
    chest_contents: "random_gold_and_items"
  
  progression_system:
    floors: 10
    difficulty_scaling:
      enemy_health_multiplier: 1.2  # per floor
      enemy_attack_multiplier: 1.15  # per floor
      enemy_count_increase: 0.5  # per floor
  
  text_rendering:
    context: "canvas_2d"
    alignment_support: ["left", "right", "center"]

level_progression:
  trigger: "reach_exit_stairs"
  requirement: "all_enemies_defeated"
  action: "increment_floor_and_generate_dungeon"
  difficulty_increase: true
  
game_over_conditions:
  - "player_health <= 0"

win_condition:
  - "floor >= 10 AND reached_exit"

prompt_instruction: |
  Create a complete top-down RPG Dungeon game using this GAML specification.
  
  METADATA:
  - The description of this file is provided by a meta file mention in the schema property. 
  - The meta file in a network location accessible to the AI in a github project. 
  - The meta file should be used to generate the game as specified and to understand the requirements.

  CRITICAL IMPLEMENTATION REQUIREMENTS:
  1. Use HTML5 Canvas with vanilla JavaScript - NO external libraries
  2. Create a single file with embedded CSS and JavaScript and use the provided sprite sheet
  3. Game loop using requestAnimationFrame()
  4. All colors, positions, and sizes must match specification exactly
  
  STRUCTURE:
  - HTML with canvas element (id="game-canvas")
  - CSS for styling and layout
  - JavaScript game implementation with proper game loop
  - Use sprite sheet for all graphics
  - Event listeners for keyboard and mouse input
  - Game state management (menu/playing/levelUp/victory/gameOver)
  
  DUNGEON SYSTEM:
  - Procedural generation using Binary Space Partitioning
  - Rooms connected by corridors
  - Walls, floors, doors, and exit stairs
  - Grid-based collision detection
  
  ENTITIES AND BEHAVIOR:
  - Player: WASD/Arrow controls, ranged combat
  - Enemy types: slimes, skeletons, orcs
  - Enemy AI: Chase player when in range, attack with cooldown
  - Combat: Projectile-based for player, melee/ranged for enemies
  - Health bars displayed above all entities
  
  PROGRESSION:
  - Experience system with level ups
  - Stat increases on level up (HP, ATK, DEF)
  - 10 floors with increasing difficulty
  - Gold collection and inventory management
  
  ITEMS:
  - Health potions (use with E key)
  - Chests with gold and items
  - Keys to unlock doors
  - Exit stairs (appear after all enemies defeated)
  
  The game must be immediately playable without any setup or compilation.
