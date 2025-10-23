---
# Space-Invaders - Complete Metadata Specification
# Single-prompt game recreation specification
file: game_metadata.gaml 
version: "2.0"
description: |
  Corrected metadata specification for the Space-Invaders game project.
  This file outlines a working implementation using HTML5 Canvas instead of external libraries.
  Tested and verified to work without dependency issues.
schema: "https://github.com/megadigo/gaml-schema/blob/main/v0.0.1/gaml-schema.json"
game:
  name: "Space-Invaders"
  type: "2D Shooter"
  engine: "HTML5_Canvas"
  language: "Javascript"
  version: "1.0"
  description: "Feature-rich 2D shooter with audio support, lives system, and infinite level progression"

project:
  name: "space_invaders"
  target: "web_browser"
  structure:
    - "index.html (single file with embedded CSS and JavaScript)"
    - "assets/ (optional audio files)"

implementation:
  approach: "single_file_html"
  dependencies: "none"
  canvas_id: "game-canvas"

window:
  width: 1200
  height: 800
  title: "Space Invaders"

entities:
  player:
    name: "Player Ship"
    type: "player"
    sprite:
      color: "#0080FF"  # Blue
      width: 50
      height: 50
    position:
      x: 600  # Center horizontally (1200/2)
      y: 750  # Near bottom (800-50)
      spawn: "fixed"
    stats:
      speed: 5  # Canvas pixels per frame
      bounds:
        min_x: 0
        max_x: 1150  # canvas.width - player.width
    
  invaders:
    name: "Invader Formation"
    type: "enemy_formation"
    sprite:
      color: "#FF0000"  # Red
      width: 40
      height: 40
    position:
      spawn: "procedural"
    stats:
      count: 50  # 5 rows x 10 columns
      rows: 5
      columns: 10
      start_x: 150
      start_y: 100
      spacing_x: 80
      spacing_y: 60
    movement:
      horizontal_speed: 15  # pixels per move (increased from 10)
      descent_amount: 20    # pixels down when hitting edge
      move_frequency: 40    # frames between moves (decreased from 60 for faster movement)
    shooting:
      frequency: 30  # frames between potential shots (drastically decreased for very frequent shooting)
      probability: 0.5  # chance to shoot when timer expires (significantly increased)
  
  bullets:
    player_bullet:
      size:
        width: 5
        height: 20
      color: "#00FF00"  # Green
      speed: 8  # pixels per frame upward
    enemy_bullet:
      size:
        width: 5
        height: 20
      color: "#FFFF00"  # Yellow  
      speed: 3  # pixels per frame downward
    
resources:
  game_state:
    initial_lives: 3
    initial_level: 1
    initial_score: 0
    points_per_enemy: 100
  
  game_states:
    available: ["menu", "playing", "gameOver"]
    default: "menu"
    
  input_handling:
    keydown_events: true
    keyup_events: true
    supported_keys: ["KeyA", "KeyD", "ArrowLeft", "ArrowRight", "Space", "KeyR"]
    
  game_audio:
    player_shoot: "assets/player_shoot.wav"
    player_die: "assets/player_die.wav" 
    enemy_die: "assets/enemy_die.wav"
    note: "Audio files are optional - game works without them"

game_states:
  menu:
    canvas_rendering:
      background: "#000000"  # Black
      ui_elements:
        - text: "SPACE INVADERS"
          font: "bold 72px Arial"
          color: "#FF8000"  # Orange
          position: 
            x: "center"  # canvas.width / 2
            y: 300
        - text: "AI-Generated Game"
          font: "30px Arial"
          color: "#CCCCCC"  # Light gray
          position:
            x: "center"
            y: 350
        - text: "Press SPACE to Start"
          font: "bold 40px Arial"
          color: "#00FF00"  # Green
          position:
            x: "center"
            y: 450
        - text: "Controls: AD/Arrow Keys to move, SPACE to shoot"
          font: "25px Arial"
          color: "#B3B3FF"  # Light blue
          position:
            x: "center"
            y: 550
        - text: "Kill them all! You have 3 lives."
          font: "25px Arial"
          color: "#FFFF00"  # Yellow
          position:
            x: "center"
            y: 600
    input_transitions:
      space_key: "playing"

  playing:
    canvas_rendering:
      background: "#000000"  # Black
      ui_elements:
        - text: "Lives: {lives}"
          font: "bold 50px Arial"
          color: "#FFFF00"  # Yellow
          position: 
            x: 50  # Left side
            y: 50  # Top
            align: "left"
        - text: "Level: {level}"
          font: "bold 50px Arial"
          color: "#00FFFF"  # Cyan
          position:
            x: 1150  # Right side (canvas.width - 50)
            y: 50
            align: "right"
        - text: "SPACE INVADERS"
          font: "bold 40px Arial"
          color: "#FF8000"  # Orange
          position:
            x: "center"
            y: 50
            align: "center"
        - text: "Score: {score}"
          font: "30px Arial"
          color: "#FFFFFF"  # White
          position:
            x: "center"
            y: 90
            align: "center"
    
    controls:
      movement: ["KeyA", "KeyD", "ArrowLeft", "ArrowRight"]
      shooting: ["Space"]
    
    collision_systems:
      - "player_bullets_vs_enemies"
      - "enemy_bullets_vs_player"  
      - "enemies_reach_bottom_check" 

  gameOver:
    canvas_rendering:
      background: "#000000"  # Black  
      ui_elements:
        - text: "GAME OVER"
          font: "bold 80px Arial"
          color: "#FF0000"  # Red
          position:
            x: "center"
            y: 300
        - text: "Final Level: {level}"
          font: "40px Arial"
          color: "#FFFF00"  # Yellow
          position:
            x: "center"
            y: 400
        - text: "Final Score: {score}"
          font: "40px Arial" 
          color: "#FFFF00"  # Yellow
          position:
            x: "center"
            y: 450
        - text: "Press R to Restart"
          font: "30px Arial"
          color: "#00FF00"  # Green
          position:
            x: "center"
            y: 550
        - text: "{achievement_message}"
          font: "25px Arial"
          color: "#B3B3FF"  # Light blue
          position:
            x: "center"
            y: 650
    
    achievement_messages:
      level_10_plus: "Amazing! You're an invaders master!"
      level_5_plus: "Great job! You're getting good at this!"
      default: "Good try! Practice makes perfect!"
    
    input_transitions:
      r_key: "playing"  # Restart game

gameplay_systems:
  player_movement:
    keys: 
      left: ["KeyA", "ArrowLeft"]
      right: ["KeyD", "ArrowRight"]
    speed: 5  # pixels per frame
    boundaries:
      left: 0
      right: "canvas.width - player.width"

  player_shooting:
    key: "Space"
    bullet_spawn_offset:
      x: "player.width / 2 - 2"  # Center of player
      y: 0  # Top of player
    cooldown: "none"  # Can shoot continuously while holding space
  
  enemy_movement:
    pattern: "swarm"
    timer_based: true
    move_interval: 60  # frames
    horizontal_distance: 10  # pixels per move
    edge_behavior: "descend_and_reverse"
    descent_distance: 20  # pixels
  
  enemy_shooting:
    timer_based: true
    shoot_interval: 120  # frames
    probability: 0.1  # 10% chance when timer expires
    random_shooter: true  # Pick random alive enemy
  
  collision_detection:
    systems:
      - name: "bullets_vs_enemies"
        check: "rectangular_overlap"
        result: "destroy_both_add_score"
      - name: "enemy_bullets_vs_player"
        check: "rectangular_overlap"  
        result: "destroy_bullet_damage_player"
      - name: "enemies_reach_bottom"
        check: "enemy.y + enemy.height > canvas.height - 100"
        result: "game_over"

rendering:
  method: "canvas_2d"
  shapes:
    player:
      type: "triangle"
      color: "#0080FF"
      points: 
        - "x + width/2, y"          # top
        - "x, y + height"           # bottom left  
        - "x + width, y + height"   # bottom right
    enemies:
      type: "rectangle"
      color: "#FF0000"
    bullets:
      type: "rectangle"
      player_color: "#00FF00"
      enemy_color: "#FFFF00"
  
  text_rendering:
    context: "canvas_2d"
    alignment_support: ["left", "right", "center"]

level_progression:
  trigger: "all_enemies_destroyed"
  action: "increment_level_and_respawn_enemies"
  enemy_speed_increase: 15  # Speed increment per level (increased from 10)
  move_frequency_decrease: 5  # Decrease move interval by this amount each level
  shoot_frequency_decrease: 5  # Decrease shoot interval by this amount each level (faster shooting)
  shoot_probability_increase: 0.05  # Increase shoot probability each level (more bullets) 
  
game_over_conditions:
  - "lives <= 0"
  - "enemies_reach_bottom"

prompt_instruction: |
  Create a complete 2D Space Invaders game using this corrected GAML specification.
  
  CRITICAL IMPLEMENTATION REQUIREMENTS:
  1. Use HTML5 Canvas with vanilla JavaScript - NO external libraries
  2. Create a single index.html file with embedded CSS and JavaScript
  3. Canvas dimensions: 1200x800 pixels
  4. Game loop using requestAnimationFrame()
  5. All colors, positions, and sizes must match specification exactly
  
  STRUCTURE:
  - HTML with canvas element (id="game-canvas")
  - CSS for styling and layout
  - JavaScript game implementation with proper game loop
  - Event listeners for keyboard input
  - Game state management (menu/playing/gameOver)
  
  ENTITIES AND BEHAVIOR:
  - Player: Blue triangle, moves with A/D or arrows, shoots with space
  - Enemies: Red rectangles in 5x10 formation, move as swarm
  - Bullets: Green (player) and yellow (enemy) rectangles
  - Collision detection using rectangular overlap
  - Lives system (3 lives), scoring (100 per enemy), level progression
  
  The game must be immediately playable without any setup or compilation. 


  