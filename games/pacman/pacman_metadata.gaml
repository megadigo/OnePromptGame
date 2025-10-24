---
# Pac-Man - Complete Metadata Specification
# Single-prompt game recreation specification
file: pacman_metadata.gaml 
version: "2.0"
description: |
  Complete metadata specification for the Pac-Man game project.
  This file outlines a working implementation using HTML5 Canvas.
  Classic maze-based arcade game with ghosts, pellets, and power-ups.
schema: "https://github.com/megadigo/gaml-schema/blob/main/v0.0.1/gaml-schema.json"
game:
  name: "Pac-Man"
  type: "Maze Chase"
  extend: "classic_pacman"
  engine: "HTML5_Canvas"
  language: "Javascript"
  version: "1.0"
  description: "Classic maze-based game with pellets, power pellets, ghosts, and infinite level progression"

project:
  name: "pacman"
  target: "web_browser"
  structure:
    - "pacman.html (single file with embedded CSS and JavaScript)"
    - "assets/ (optional audio files)"

implementation:
  approach: "single_file_html"
  dependencies: "none"
  canvas_id: "game-canvas"

window:
  width: 700
  height: 750
  title: "Pac-Man"

gameplayground:
  maze:
    grid_size: 20  # Each cell is 20x20 pixels
    rows: 29  # Actual playable maze rows
    columns: 29  # 580 pixels for maze
    offset_x: 60  # Center the maze (700 - 580 = 120, 120/2 = 60)
    offset_y: 70  # Leave room for UI at top
    generation_rules:
      algorithm: "Depth-First Search"  # Maze generation algorithm
      generation: "random"  # Generate always random maze each level from level 1
      path_width: 20  # Width of paths in pixels
      wall_thickness: 20  # Thickness of walls in pixels (full cell)
      wall_color: "#0000FF"  # Blue walls
      wall_fill: true  # Fill walls with solid color (not just outline)
      wall_render: "fillRect"  # Use fillRect instead of strokeRect
      path_color: "#000000"  # Black paths
      limits: "No maze on edges"
      ghost_house:
        grid_x_min: 11
        grid_x_max: 16
        grid_y_min: 10
        grid_y_max: 13
        color: "#1a0033"  # Dark purple background
        description: "Center area where ghosts spawn, no pellets placed here"
      pellet_placement:
        place_rule: "every_path_cell_except_spawn_areas_and_player_start_positions"  # Place pellets in every path cell except ghost house and spawn positions
        exclude_ghost_house: true
      power_pellet_placement:
        place_rule: "maze_corners_or_near_on_paths_only"  # Place power pellets in maze corners or near if corner is a wall, only on valid path cells
        count: 4  # Total power pellets per level
        search_radius: 8  # Search up to 8 cells from corner to find valid path
        ensure_on_path: true  # Power pellets must be on path cells (maze value = 0)
entities:
  pacman:
    shape: "circle"
    size: 
      radius: 10
    color: "#FFFF00"  # Yellow
    spawn_position: 
      grid_x: 14  # Center of maze
      grid_y: 24  # Bottom area
    speed: 0.1  # Movement speed multiplier (grid-based movement)
    move_delay: 8  # frames between moves (slower = more frames)
    animation:
      mouth_open_angle: 45  # degrees for pac-man mouth
      animation_speed: 8  # frames per animation cycle
    
  ghosts:
    count: 4
    names: ["Blinky", "Pinky", "Inky", "Clyde"]
    spawn_positions:
      - { grid_x: 12, grid_y: 11, name: "Blinky" }  # Red ghost
      - { grid_x: 14, grid_y: 11, name: "Pinky" }   # Pink ghost
      - { grid_x: 13, grid_y: 12, name: "Inky" }    # Cyan ghost
      - { grid_x: 15, grid_y: 12, name: "Clyde" }   # Orange ghost
    colors:
      Blinky: "#FF0000"  # Red
      Pinky: "#FFB8FF"   # Pink
      Inky: "#00FFFF"    # Cyan
      Clyde: "#FFB851"   # Orange
    size:
      radius: 10
    speed: 0.08  # Movement speed multiplier (slightly slower than Pac-Man)
    move_delay: 10  # frames between moves
    frightened_color: "#0000FF"  # Blue when vulnerable
    frightened_speed: 0.06  # Much slower when frightened
    frightened_move_delay: 12  # More frames between moves when frightened
    frightened_duration: 300  # frames (5 seconds at 60fps)
    
  pellets:
    size:
      radius: 3
    color: "#FFB897"  # Light orange
    points: 10
    
  power_pellets:
    size:
      radius: 8
    color: "#FFB897"  # Light orange
    points: 50
    blink_speed: 15  # frames between blinks
    effect: "frighten_ghosts"
    
resources:
  game_state:
    initial_lives: 3
    initial_level: 1
    initial_score: 0
    points_per_ghost: 200  # Points for eating a ghost
    ghost_combo_multiplier: 2  # Each ghost eaten in sequence doubles
  
  game_states:
    available: ["menu", "howToPlay", "playing", "levelComplete", "gameOver"]
    default: "menu"
    
  input_handling:
    keydown_events: true
    supported_keys: ["KeyW", "KeyA", "KeyS", "KeyD", "ArrowUp", "ArrowLeft", "ArrowDown", "ArrowRight", "Space", "KeyR", "KeyH", "Escape"]
    
  game_audio:
    chomp: "assets/chomp.wav"
    ghost_eaten: "assets/ghost_eaten.wav"
    pacman_death: "assets/pacman_death.wav"
    power_pellet: "assets/power_pellet.wav"
    note: "Audio files are optional - game works without them"

game_states:
  menu:
    canvas_rendering:
      background: "#000000"  # Black
      ui_elements:
        - text: "PAC-MAN"
          font: "bold 60px Arial"
          color: "#FFFF00"  # Yellow
          position: 
            x: "center"
            y: 200
        - text: "AI-Generated Game"
          font: "22px Arial"
          color: "#CCCCCC"  # Light gray
          position:
            x: "center"
            y: 250
        - text: "Press SPACE to Start"
          font: "bold 30px Arial"
          color: "#FFB8FF"  # Pink
          position:
            x: "center"
            y: 350
        - text: "Press H for How to Play"
          font: "24px Arial"
          color: "#FFD700"  # Gold
          position:
            x: "center"
            y: 400
        - text: "Controls: WASD or Arrow Keys"
          font: "20px Arial"
          color: "#00FFFF"  # Cyan
          position:
            x: "center"
            y: 480
        - text: "Eat all pellets! Avoid ghosts!"
          font: "20px Arial"
          color: "#FF0000"  # Red
          position:
            x: "center"
            y: 520
        - text: "Power pellets let you eat ghosts!"
          font: "20px Arial"
          color: "#FFB851"  # Orange
          position:
            x: "center"
            y: 560
    input_transitions:
      space_key: "playing"
      h_key: "howToPlay"

  howToPlay:
    canvas_rendering:
      background: "#000000"  # Black
      ui_elements:
        - text: "HOW TO PLAY PAC-MAN"
          font: "bold 48px Arial"
          color: "#FFFF00"  # Yellow
          position:
            x: "center"
            y: 70
        - text: "OBJECTIVE"
          font: "bold 28px Arial"
          color: "#FFB8FF"  # Pink
          position:
            x: "center"
            y: 130
        - text: "Navigate the maze and eat all the pellets to advance to the next level."
          font: "18px Arial"
          color: "#FFFFFF"
          position:
            x: "center"
            y: 165
        - text: "Avoid the ghosts or you'll lose a life! Run out of lives and it's game over."
          font: "18px Arial"
          color: "#FFFFFF"
          position:
            x: "center"
            y: 190
        - text: "CONTROLS"
          font: "bold 28px Arial"
          color: "#FFB8FF"  # Pink
          position:
            x: "center"
            y: 240
        - text: "WASD or Arrow Keys - Move Pac-Man in four directions"
          font: "18px Arial"
          color: "#FFFFFF"
          position:
            x: "center"
            y: 275
        - text: "Movement is grid-aligned for precise maze navigation"
          font: "18px Arial"
          color: "#CCCCCC"
          position:
            x: "center"
            y: 300
        - text: "GAMEPLAY ELEMENTS"
          font: "bold 28px Arial"
          color: "#FFB8FF"  # Pink
          position:
            x: "center"
            y: 350
        - text: "• Small Pellets - Worth 10 points each, eat all to complete the level"
          font: "18px Arial"
          color: "#FFB897"
          position:
            x: "center"
            y: 385
        - text: "• Power Pellets (Large) - Worth 50 points, turn ghosts blue for 5 seconds"
          font: "18px Arial"
          color: "#FFB897"
          position:
            x: "center"
            y: 410
        - text: "• Blue Ghosts - Can be eaten for bonus points (200, 400, 800, 1600)"
          font: "18px Arial"
          color: "#0000FF"
          position:
            x: "center"
            y: 435
        - text: "• Lives - Start with 3 lives, lose one when touched by a ghost"
          font: "18px Arial"
          color: "#FFFF00"
          position:
            x: "center"
            y: 460
        - text: "THE GHOSTS"
          font: "bold 28px Arial"
          color: "#FFB8FF"  # Pink
          position:
            x: "center"
            y: 510
        - text: "Blinky (Red) • Pinky (Pink) • Inky (Cyan) • Clyde (Orange)"
          font: "18px Arial"
          color: "#FFFFFF"
          position:
            x: "center"
            y: 545
        - text: "Ghosts chase you through the maze and get faster each level!"
          font: "18px Arial"
          color: "#FFFFFF"
          position:
            x: "center"
            y: 570
        - text: "STRATEGY TIPS"
          font: "bold 28px Arial"
          color: "#FFB8FF"  # Pink
          position:
            x: "center"
            y: 620
        - text: "Plan your route to collect all pellets efficiently"
          font: "18px Arial"
          color: "#00FF00"
          position:
            x: "center"
            y: 655
        - text: "Save power pellets for when you're surrounded by ghosts"
          font: "18px Arial"
          color: "#00FF00"
          position:
            x: "center"
            y: 680
        - text: "Press ESC to Return to Menu"
          font: "bold 22px Arial"
          color: "#FFD700"  # Gold
          position:
            x: "center"
            y: 730
    input_transitions:
      escape_key: "menu"
      space_key: "playing"

  playing:
    canvas_rendering:
      background: "#000000"  # Black
      maze_wall_color: "#0000FF"  # Blue walls
      ui_elements:
        - text: "Lives: {lives}"
          font: "bold 24px Arial"
          color: "#FFFF00"  # Yellow
          position: 
            x: 30
            y: 30
            align: "left"
        - text: "Level: {level}"
          font: "bold 24px Arial"
          color: "#00FFFF"  # Cyan
          position:
            x: 670
            y: 30
            align: "right"
        - text: "PAC-MAN"
          font: "bold 28px Arial"
          color: "#FFFF00"  # Yellow
          position:
            x: "center"
            y: 30
            align: "center"
        - text: "Score: {score}"
          font: "bold 24px Arial"
          color: "#00FF00"  # Green
          position:
            x: "center"
            y: 735
            align: "center"
    
    controls:
      movement: ["KeyW", "KeyA", "KeyS", "KeyD", "ArrowUp", "ArrowLeft", "ArrowDown", "ArrowRight"]
    
    collision_systems:
      - "pacman_vs_pellets"
      - "pacman_vs_power_pellets"
      - "pacman_vs_ghosts"
      - "pacman_vs_frightened_ghosts"

  levelComplete:
    duration: 120  # frames to show level complete screen
    canvas_rendering:
      background: "#000000"  # Black
      ui_elements:
        - text: "LEVEL COMPLETE!"
          font: "bold 45px Arial"
          color: "#00FF00"  # Green
          position:
            x: "center"
            y: 320
        - text: "Get Ready for Level {next_level}!"
          font: "32px Arial"
          color: "#FFFF00"  # Yellow
          position:
            x: "center"
            y: 400
    auto_transition:
      target_state: "playing"
      delay: 120  # frames

  gameOver:
    canvas_rendering:
      background: "#000000"  # Black  
      ui_elements:
        - text: "GAME OVER"
          font: "bold 60px Arial"
          color: "#FF0000"  # Red
          position:
            x: "center"
            y: 280
        - text: "Final Level: {level}"
          font: "32px Arial"
          color: "#FFFF00"  # Yellow
          position:
            x: "center"
            y: 350
        - text: "Final Score: {score}"
          font: "32px Arial" 
          color: "#FFFF00"  # Yellow
          position:
            x: "center"
            y: 395
        - text: "Press R to Restart"
          font: "24px Arial"
          color: "#00FF00"  # Green
          position:
            x: "center"
            y: 470
        - text: "{achievement_message}"
          font: "20px Arial"
          color: "#FFB8FF"  # Pink
          position:
            x: "center"
            y: 550
    
    achievement_messages:
      level_10_plus: "Incredible! You're a Pac-Man master!"
      level_5_plus: "Excellent! You're really good at this!"
      default: "Nice try! Practice makes perfect!"
    
    input_transitions:
      r_key: "playing"  # Restart game

gameplay_systems:
  pacman_movement:
    keys: 
      up: ["KeyW", "ArrowUp"]
      down: ["KeyS", "ArrowDown"]
      left: ["KeyA", "ArrowLeft"]
      right: ["KeyD", "ArrowRight"]
    speed: 2  # pixels per frame
    movement_type: "grid_aligned"  # Must align to grid cells
    collision: "wall_detection"
    direction_queue: true  # Queue next direction for smooth turning
  
  ghost_ai:
    movement_type: "grid_aligned"
    continuous_movement: true  # Ghosts never stay still
    prevent_backtracking: true  # Avoid going backwards unless no other option
    ai_modes:
      - name: "chase"
        description: "Actively chase Pac-Man (70% of the time)"
        chase_probability: 0.7
      - name: "random"
        description: "Random movement for unpredictability (30% of the time)"
        random_probability: 0.3
      - name: "frightened"
        description: "Flee randomly when power pellet eaten"
        duration: 300  # frames (5 seconds)
        movement: "fully_random"
    behavior:
      all_ghosts: "mix_of_chase_and_random"  # All ghosts use mixed behavior
      chase_weight: 0.7  # 70% chase behavior
      random_weight: 0.3  # 30% random movement
      description: "Ghosts primarily chase Pac-Man but occasionally move randomly for variety"
    respawn_on_eaten: true
    respawn_location: { grid_x: 14, grid_y: 11 }
  
  pellet_collection:
    on_collect: "remove_and_add_score"
    chomp_sound: true
  
  power_pellet_collection:
    on_collect: "remove_add_score_frighten_ghosts"
    effect_duration: 300  # frames
    ghost_behavior_change: "frightened"
  
  collision_detection:
    systems:
      - name: "pacman_vs_pellets"
        check: "grid_position_match"
        result: "collect_pellet_add_score"
      - name: "pacman_vs_power_pellets"
        check: "grid_position_match"
        result: "collect_power_pellet_frighten_ghosts"
      - name: "pacman_vs_normal_ghosts"
        check: "distance_threshold"
        threshold: 20  # pixels
        result: "lose_life"
      - name: "pacman_vs_frightened_ghosts"
        check: "distance_threshold"
        threshold: 20  # pixels
        result: "eat_ghost_add_score_respawn_ghost"

rendering:
  method: "canvas_2d"
  shapes:
    pacman:
      type: "circle_with_mouth"
      color: "#FFFF00"
      animation: "chomping"
    ghosts:
      type: "rounded_ghost"
      eyes: true
      frightened_appearance: "blue_with_eyes"
    maze:
      type: "grid_based"
      wall_color: "#0000FF"
      wall_thickness: 2
      path_color: "#000000"
    pellets:
      type: "circle"
      color: "#FFB897"
    power_pellets:
      type: "circle"
      color: "#FFB897"
      animation: "blinking"
  
  text_rendering:
    context: "canvas_2d"
    alignment_support: ["left", "right", "center"]

level_progression:
  trigger: "all_pellets_collected"
  action: "increment_level_and_reset_maze"
  ghost_speed_increase: 0.2  # Speed increment per level
  frightened_duration_decrease: 20  # Frames less each level
  min_frightened_duration: 120  # Minimum frames (2 seconds)
  
game_over_conditions:
  - "lives <= 0"

win_condition:
  - "all_pellets_collected"

prompt_instruction: |
  Create a complete Pac-Man game using this GAML specification.
  
  CRITICAL IMPLEMENTATION REQUIREMENTS:
  1. Use HTML5 Canvas with vanilla JavaScript - NO external libraries
  2. Create a single pacman.html file with embedded CSS and JavaScript
  3. Canvas dimensions: 700x750 pixels
  4. Game loop using requestAnimationFrame()
  5. All colors, positions, and sizes must match specification exactly
  
  STRUCTURE:
  - HTML with canvas element (id="game-canvas")
  - CSS for styling and layout
  - JavaScript game implementation with proper game loop
  - Event listeners for keyboard input
  - Game state management (menu/howToPlay/playing/levelComplete/gameOver)
  
  GAME STATES:
  - menu: Main menu with title, start option, and "How to Play" button (Press H)
  - howToPlay: Detailed instructions page explaining objective, controls, gameplay elements, ghosts, and strategy
  - playing: Active gameplay state
  - levelComplete: Level completion notification screen
  - gameOver: Death screen with final score and restart option
  
  HOW TO PLAY PAGE:
  - Accessed from menu by pressing H key
  - Display comprehensive game instructions including:
    * Objective: Eat all pellets to advance levels, avoid ghosts
    * Controls: WASD/Arrow keys for movement
    * Gameplay elements: Small pellets (10 pts), power pellets (50 pts), blue ghosts (bonus points), lives system
    * The Ghosts: Blinky (Red), Pinky (Pink), Inky (Cyan), Clyde (Orange) - chase behavior
    * Strategy tips: Route planning, power pellet timing
  - Press ESC to return to menu, or SPACE to start playing
  - Use exact styling from the howToPlay state specification
  
  MAZE SYSTEM:
  - Grid-based 28x28 maze layout
  - Blue walls forming classic Pac-Man style maze
  - Pellets (small dots) and power pellets (large dots) on paths
  - Grid-aligned movement for both Pac-Man and ghosts
  
  ENTITIES AND BEHAVIOR:
  - Pac-Man: Yellow circle with chomping animation, controlled with WASD or arrows
  - 4 Ghosts: Red (Blinky), Pink (Pinky), Cyan (Inky), Orange (Clyde)
  - Ghost AI with chase and scatter behaviors
  - Pellets: 10 points each, collected automatically
  - Power Pellets: 50 points, make ghosts vulnerable for 5 seconds
  - Collision detection using distance threshold
  - Lives system (3 lives), scoring system, level progression
  
  GAMEPLAY:
  - Eat all pellets to complete level
  - Avoid ghosts or lose a life
  - Eat power pellets to turn ghosts blue and eat them for bonus points
  - Progressive difficulty: ghosts get faster each level
  
  KEYBOARD INPUT:
  - Menu state: SPACE to start game, H to view How to Play
  - How to Play state: ESC to return to menu, SPACE to start game
  - Playing state: WASD/Arrows for movement
  - Game Over state: R to restart
  
  The game must be immediately playable without any setup or compilation.
