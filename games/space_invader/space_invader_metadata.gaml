---
# Space-Invaders - Complete Metadata Specification
# Single-prompt game recreation specification
file: game_metadata.gaml # Name of this metadata file
version: "2.0" # Version number of this specification
description: | # Detailed description of what this file contains
  Corrected metadata specification for the Space-Invaders game project.
  This file outlines a working implementation using HTML5 Canvas instead of external libraries.
  Tested and verified to work without dependency issues.
schema: "https://github.com/megadigo/gaml-schema/blob/main/v0.0.1/gaml-schema.json" # URL to GAML schema definition

game: # Game configuration
  name: "Space-Invaders" # Game title
  type: "2D Shooter" # Game genre
  extend: "classic_roguelike" # Base game type
  description: "Feature-rich 2D shooter with audio support, lives system, and infinite level progression" # Short description
  credits: 
    developer: "AI & megadigo (megadigo@gmail.com)" # Developer name
    contributors: ["Claude Sonnet 4.5", "Graphics Oryx (www.oryxdesignlab.com)"] # Contributors list
    license: "MIT" # License type
  
project:
  name: "space_invaders" # Project folder name
  target: "web_browser" # Target platform
  page: "index.html" # Main HTML file
  engine: "HTML5_Canvas" # Game engine
  language: "Javascript" # Programming language

implementation: # Implementation details
  approach: "single_file_html" # Development approach
  dependencies: "none" # No external dependencies
  canvas_id: "game-canvas" # HTML canvas element ID

window: # Window/canvas configuration
  width: 1200 # Canvas width in pixels
  height: 800 # Canvas height in pixels
  title: "Space Invaders" # Browser window title

entities: # Game entities definition
  player: # Player ship configuration
    name: "Player Ship" # Entity name
    type: "player" # Entity type
    sprite: # Sprite configuration
      color: "#0080FF"  # Blue color
      width: 50 # Sprite width in pixels
      height: 50 # Sprite height in pixels
    position: # Position configuration
      x: 600  # Center horizontally (1200/2)
      y: 750  # Near bottom (800-50)
      spawn: "fixed" # Fixed spawn position
    stats: # Player statistics
      speed: 5  # Canvas pixels per frame
      bounds: # Movement boundaries
        min_x: 0 # Left edge
        max_x: 1150  # canvas.width - player.width (right edge)
    
  invaders: # Enemy invaders configuration
    name: "Invader Formation" # Entity name
    type: "enemy_formation" # Formation-based enemies
    sprite: # Sprite configuration
      color: "#FF0000"  # Red color
      width: 40 # Sprite width in pixels
      height: 40 # Sprite height in pixels
    position: # Position configuration
      spawn: "procedural" # Procedural spawning
    stats: # Formation statistics
      count: 50  # 5 rows x 10 columns (total enemies)
      rows: 5 # Number of rows
      columns: 10 # Number of columns
      start_x: 150 # Formation starting X position
      start_y: 100 # Formation starting Y position
      spacing_x: 80 # Horizontal spacing between invaders
      spacing_y: 60 # Vertical spacing between invaders
    movement: # Movement behavior
      horizontal_speed: 15  # pixels per move (increased from 10)
      descent_amount: 20    # pixels down when hitting edge
      move_frequency: 40    # frames between moves (decreased from 60 for faster movement)
    shooting: # Shooting behavior
      frequency: 30  # frames between potential shots (drastically decreased for very frequent shooting)
      probability: 0.5  # chance to shoot when timer expires (significantly increased)
  
  bullets: # Bullet configurations
    player_bullet: # Player bullet specification
      size: # Bullet size
        width: 5 # Bullet width
        height: 20 # Bullet height
      color: "#00FF00"  # Green color
      speed: 8  # pixels per frame upward
    enemy_bullet: # Enemy bullet specification
      size: # Bullet size
        width: 5 # Bullet width
        height: 20 # Bullet height
      color: "#FFFF00"  # Yellow color
      speed: 3  # pixels per frame downward
    
resources: # Game resources and state management
  game_state: # Initial game state values
    initial_lives: 3 # Starting number of lives
    initial_level: 1 # Starting level
    initial_score: 0 # Starting score
    points_per_enemy: 100 # Points awarded for destroying an enemy
  
  game_states: # Available game states
    available: ["menu", "howToPlay", "playing", "gameOver"] # List of all game states
    default: "menu" # Default starting state
    
  input_handling: # Input configuration
    keydown_events: true # Enable keydown event listening
    keyup_events: true # Enable keyup event listening
    supported_keys: ["KeyA", "KeyD", "ArrowLeft", "ArrowRight", "Space", "KeyR", "KeyH", "Escape"] # List of supported keys

game_states: # Game state configurations
  menu: # Main menu screen configuration
    canvas_rendering: # Rendering settings for this state
      background: "#000000"  # Black background
      ui_elements: # List of UI elements to render
        - text: "SPACE INVADERS" # Game title
          font: "bold 72px Arial" # Font style
          color: "#FF8000"  # Orange color
          position:  # Position configuration
            x: "center"  # canvas.width / 2 (centered horizontally)
            y: 300 # Y position
        - text: "AI-Generated Game" # Subtitle
          font: "30px Arial" # Font style
          color: "#CCCCCC"  # Light gray color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 350 # Y position
        - text: "Press SPACE to Start" # Start game prompt
          font: "bold 40px Arial" # Font style
          color: "#00FF00"  # Green color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 450 # Y position
        - text: "Press H for How to Play" # How to play prompt
          font: "30px Arial" # Font style
          color: "#FFD700"  # Gold color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 510 # Y position
        - text: "Controls: AD/Arrow Keys to move, SPACE to shoot" # Controls description
          font: "25px Arial" # Font style
          color: "#B3B3FF"  # Light blue color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 580 # Y position
        - text: "Kill them all! You have 3 lives." # Game objective
          font: "25px Arial" # Font style
          color: "#FFFF00"  # Yellow color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 630 # Y position
    input_transitions: # Key press transitions to other states
      space_key: "playing" # Start game on space key
      h_key: "howToPlay" # Go to how to play on H key

  howToPlay: # How to play instructions screen
    canvas_rendering: # Rendering settings for this state
      background: "#000000"  # Black background
      ui_elements: # List of UI elements to render
        - text: "HOW TO PLAY SPACE INVADERS" # Page title
          font: "bold 56px Arial" # Font style
          color: "#FF8000"  # Orange color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 80 # Top position
        - text: "OBJECTIVE" # Objective section header
          font: "bold 32px Arial" # Font style
          color: "#00FF00"  # Green color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 150 # Position below title
        - text: "Defend Earth from the alien invasion! Destroy all invaders to advance to the next level." # Objective description line 1
          font: "22px Arial" # Font style
          color: "#FFFFFF" # White color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 190 # Position below header
        - text: "Don't let them reach the bottom or it's game over!" # Objective description line 2
          font: "22px Arial" # Font style
          color: "#FFFFFF" # White color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 220 # Position below previous line
        - text: "CONTROLS" # Controls section header
          font: "bold 32px Arial" # Font style
          color: "#00FF00"  # Green color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 280 # Position below objective section
        - text: "A or Left Arrow - Move your ship left" # Control description
          font: "22px Arial" # Font style
          color: "#FFFFFF" # White color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 320 # Position below header
        - text: "D or Right Arrow - Move your ship right" # Control description
          font: "22px Arial" # Font style
          color: "#FFFFFF" # White color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 350 # Position below previous line
        - text: "SPACE - Shoot lasers at the invaders" # Control description
          font: "22px Arial" # Font style
          color: "#FFFFFF" # White color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 380 # Position below previous line
        - text: "GAMEPLAY MECHANICS" # Gameplay section header
          font: "bold 32px Arial" # Font style
          color: "#00FF00"  # Green color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 440 # Position below controls section
        - text: "• Player Ship (Blue Triangle) - Your last line of defense" # Gameplay mechanic description
          font: "22px Arial" # Font style
          color: "#0080FF" # Blue color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 480 # Position below header
        - text: "• Invaders (Red Squares) - 50 enemies in formation moving as a swarm" # Gameplay mechanic description
          font: "22px Arial" # Font style
          color: "#FF0000" # Red color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 510 # Position below previous line
        - text: "• Score - Earn 100 points for each invader destroyed" # Gameplay mechanic description
          font: "22px Arial" # Font style
          color: "#FFFF00" # Yellow color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 540 # Position below previous line
        - text: "• Lives - Start with 3 lives, lose one when hit by enemy fire" # Gameplay mechanic description
          font: "22px Arial" # Font style
          color: "#FFFF00" # Yellow color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 570 # Position below previous line
        - text: "• Difficulty - Invaders move and shoot faster each level!" # Gameplay mechanic description
          font: "22px Arial" # Font style
          color: "#FF8000" # Orange color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 600 # Position below previous line
        - text: "STRATEGY TIPS" # Strategy section header
          font: "bold 32px Arial" # Font style
          color: "#00FF00"  # Green color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 660 # Position below gameplay section
        - text: "Focus on invaders at the bottom - they're closest to you and shoot first" # Strategy tip
          font: "22px Arial" # Font style
          color: "#00FFFF" # Cyan color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 700 # Position below header
        - text: "Keep moving to dodge enemy fire and create better shooting angles" # Strategy tip
          font: "22px Arial" # Font style
          color: "#00FFFF" # Cyan color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 730 # Position below previous line
        - text: "Press ESC to Return to Menu" # Navigation instruction
          font: "bold 26px Arial" # Font style
          color: "#FFD700"  # Gold color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 780 # Bottom position
    input_transitions: # Key press transitions to other states
      escape_key: "menu" # Return to menu on ESC key
      space_key: "playing" # Start game on space key

  playing: # Main gameplay state
    canvas_rendering: # Rendering settings for this state
      background: "#000000"  # Black background
      ui_elements: # List of HUD elements to render
        - text: "Lives: {lives}" # Lives display with variable replacement
          font: "bold 50px Arial" # Font style
          color: "#FFFF00"  # Yellow color
          position:  # Position configuration
            x: 50  # Left side of screen
            y: 50  # Top position
            align: "left" # Left-aligned text
        - text: "Level: {level}" # Level display with variable replacement
          font: "bold 50px Arial" # Font style
          color: "#00FFFF"  # Cyan color
          position: # Position configuration
            x: 1150  # Right side (canvas.width - 50)
            y: 50 # Top position
            align: "right" # Right-aligned text
        - text: "SPACE INVADERS" # Game title in HUD
          font: "bold 40px Arial" # Font style
          color: "#FF8000"  # Orange color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 50 # Top position
            align: "center" # Center-aligned text
        - text: "Score: {score}" # Score display with variable replacement
          font: "30px Arial" # Font style
          color: "#FFFFFF"  # White color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 90 # Position below title
            align: "center" # Center-aligned text
    
    controls: # Key bindings for gameplay
      movement: ["KeyA", "KeyD", "ArrowLeft", "ArrowRight"] # Movement keys (left/right)
      shooting: ["Space"] # Shooting key
    
    collision_systems: # List of active collision detection systems
      - "player_bullets_vs_enemies" # Detect player bullet hits on enemies
      - "enemy_bullets_vs_player" # Detect enemy bullet hits on player
      - "enemies_reach_bottom_check" # Check if enemies reached the bottom 

  gameOver: # Game over screen state
    canvas_rendering: # Rendering settings for this state
      background: "#000000"  # Black background
      ui_elements: # List of UI elements to render
        - text: "GAME OVER" # Game over announcement
          font: "bold 80px Arial" # Font style
          color: "#FF0000"  # Red color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 300 # Center position
        - text: "Final Level: {level}" # Final level display with variable replacement
          font: "40px Arial" # Font style
          color: "#FFFF00"  # Yellow color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 400 # Position below title
        - text: "Final Score: {score}" # Final score display with variable replacement
          font: "40px Arial" # Font style
          color: "#FFFF00"  # Yellow color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 450 # Position below level
        - text: "Press R to Restart" # Restart instruction
          font: "30px Arial" # Font style
          color: "#00FF00"  # Green color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 550 # Position below score
        - text: "{achievement_message}" # Achievement message with variable replacement
          font: "25px Arial" # Font style
          color: "#B3B3FF"  # Light blue color
          position: # Position configuration
            x: "center" # Centered horizontally
            y: 650 # Bottom position
    
    achievement_messages: # Conditional messages based on achievements
      level_10_plus: "Amazing! You're an invaders master!" # Message for level 10+
      level_5_plus: "Great job! You're getting good at this!" # Message for level 5+
      default: "Good try! Practice makes perfect!" # Default message
    
    input_transitions: # Key press transitions to other states
      r_key: "playing"  # Restart game on R key

gameplay_systems: # Core gameplay mechanics definitions
  player_movement: # Player movement system configuration
    keys: # Key bindings for directional movement
      left: ["KeyA", "ArrowLeft"] # Keys for moving left
      right: ["KeyD", "ArrowRight"] # Keys for moving right
    speed: 5  # pixels per frame movement speed
    boundaries: # Movement boundaries
      left: 0 # Left edge of screen
      right: "canvas.width - player.width" # Right edge calculation

  player_shooting: # Player shooting system configuration
    key: "Space" # Shooting key
    bullet_spawn_offset: # Bullet spawn position relative to player
      x: "player.width / 2 - 2"  # Center of player (horizontally)
      y: 0  # Top of player (vertically)
    cooldown: "none"  # Can shoot continuously while holding space
  
  enemy_movement: # Enemy movement system configuration
    pattern: "swarm" # Movement pattern type
    timer_based: true # Use timer for movement
    move_interval: 60  # frames between moves
    horizontal_distance: 10  # pixels per horizontal move
    edge_behavior: "descend_and_reverse" # Behavior when hitting screen edge
    descent_distance: 20  # pixels to descend when hitting edge
  
  enemy_shooting: # Enemy shooting system configuration
    timer_based: true # Use timer for shooting
    shoot_interval: 120  # frames between potential shots
    probability: 0.1  # 10% chance when timer expires
    random_shooter: true  # Pick random alive enemy to shoot
  
  collision_detection: # Collision detection configuration
    systems: # List of collision systems
      - name: "bullets_vs_enemies" # System name
        check: "rectangular_overlap" # Detection method
        result: "destroy_both_add_score" # Action on collision
      - name: "enemy_bullets_vs_player" # System name
        check: "rectangular_overlap" # Detection method
        result: "destroy_bullet_damage_player" # Action on collision
      - name: "enemies_reach_bottom" # System name
        check: "enemy.y + enemy.height > canvas.height - 100" # Detection condition
        result: "game_over" # Action when condition met

rendering: # Rendering configuration
  method: "canvas_2d" # Rendering method
  shapes: # Shape rendering definitions
    player: # Player ship rendering
      type: "triangle" # Shape type
      color: "#0080FF" # Color
      points: # Triangle points definition
        - "x + width/2, y"          # top (vertex at top center)
        - "x, y + height"           # bottom left (vertex at bottom left)
        - "x + width, y + height"   # bottom right (vertex at bottom right)
    enemies: # Enemy rendering
      type: "rectangle" # Shape type
      color: "#FF0000" # Color
    bullets: # Bullet rendering
      type: "rectangle" # Shape type
      player_color: "#00FF00" # Player bullet color (green)
      enemy_color: "#FFFF00" # Enemy bullet color (yellow)
  
  text_rendering: # Text rendering configuration
    context: "canvas_2d" # Rendering context type
    alignment_support: ["left", "right", "center"] # Supported text alignments

gameplay_conditions: # Conditions for game events

  level_progression: # Level progression configuration
    trigger: "all_enemies_destroyed" # What triggers level advancement
    action: "increment_level_and_respawn_enemies" # Action on level completion
    enemy_speed_increase: 15  # Speed increment per level (increased from 10)
    move_frequency_decrease: 5  # Decrease move interval by this amount each level
    shoot_frequency_decrease: 5  # Decrease shoot interval by this amount each level (faster shooting)
    shoot_probability_increase: 0.05  # Increase shoot probability each level (more bullets)
    
  game_over_conditions: # Conditions that trigger game over
    - "lives <= 0" # Player runs out of lives
    - "enemies_reach_bottom" # Enemies reach the bottom of screen


prompt_instruction:  # Detailed AI prompt instructions for game implementation
  
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
  - Game loop using requestAnimationFrame()
  - Keyboard event listeners MUST be set up in a function called at the END of the script
  - Set up keyboard event listeners AFTER all functions are defined to avoid reference errors
  - Add preventDefault() for all game control keys to prevent default browser behaviors

  IMPLEMENTATION_REQUIREMENTS:
  - Ensure all game states transition correctly based on user input and game events
  - Ensure player and enemy movement and collision detection function correctly
  - Ensure combat mechanics function correctly
  - Ensure level progression and difficulty scaling function correctly

  FIX:
  
  