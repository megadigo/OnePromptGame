{
  "file": "labyrinth.gaml",
  "version": "1.0",
  "description": "A PICO-8 dungeon crawler roguelike where the player navigates procedurally generated labyrinths, fights monsters, collects treasure, and descends deeper into the depths. Features grid-based movement, turn-based combat, and ASCII-style graphics.",
  "schema": "https://github.com/megadigo/gaml-schema/blob/main/v0.0.1/gaml-schema.json",
  
  "game": {
    "name": "Labyrinth Descent",
    "type": "Roguelike Dungeon Crawler",
    "engine": "PICO-8",
    "language": "Lua",
    "version": "1.0",
    "description": "Explore procedurally generated dungeons, fight monsters, collect treasure, and survive as long as you can in this classic roguelike adventure.",
    "credits": {
      "developer": "GAML Generator",
      "contributors": ["AI Assistant"],
      "license": "MIT"
    }
  },
  
  "project": {
    "name": "labyrinth",
    "target": "pico8",
    "page": "labyrinth.p8",
    "structure": [
      "labyrinth.p8 (main game cartridge)",
      "labyrinth.gaml (game specification)"
    ],
    "engine": "PICO-8",
    "language": "Lua"
  },
  
  "implementation": {
    "approach": "single_file_p8",
    "dependencies": "none",
    "constraints": "PICO-8 token limit (8192), sprite limit (256 8x8 sprites), map size (128x64 tiles)"
  },
  
  "window": {
    "width": 128,
    "height": 128,
    "title": "Labyrinth Descent"
  },
  
  "game_world": {
    "dungeon": {
      "grid_size": 8,
      "rows": 16,
      "columns": 16,
      "offset_x": 0,
      "offset_y": 0,
      "generation_rules": {
        "algorithm": "Binary Space Partition",
        "generation": "random_each_level",
        "rooms": {
          "room_count": 5,
          "room_min_size": 3,
          "room_max_size": 7,
          "corridor_width": 1
        },
        "floor_color": "6",
        "walls": {
          "color": "5",
          "render": "fillRect"
        },
        "exit_stairs": {
          "color": "10",
          "spawn_rule": "farthest_room_from_player",
          "requires": "none",
          "detection_radius": 8,
          "interaction": "automatic_on_proximity"
        }
      }
    }
  },
  
  "entities": {
    "player": {
      "name": "Hero",
      "type": "player",
      "sprite": {
        "id": 1,
        "width": 8,
        "height": 8
      },
      "position": {
        "spawn": "first_room_center",
        "rule": "first_room_center"
      },
      "speed": 1,
      "stats": {
        "max_health": 20,
        "health": 20,
        "attack": 3,
        "defense": 1,
        "level": 1,
        "experience": 0,
        "experience_to_next_level": 10
      },
      "inventory": {
        "gold": 0,
        "potions": 2
      }
    },
    
    "enemies": {
      "list": [
        {
          "name": "Rat",
          "type": "rat",
          "sprite_id": 16,
          "health": 3,
          "attack": 1,
          "defense": 0,
          "speed": 1,
          "experience_value": 2,
          "gold_drop": {"min": 1, "max": 3},
          "spawn_chance": 0.4,
          "ai_behavior": {
            "detection_range": 40,
            "chase_player": true,
            "attack_range": 8,
            "attack_cooldown": 30
          }
        },
        {
          "name": "Skeleton",
          "type": "skeleton",
          "sprite_id": 17,
          "health": 6,
          "attack": 2,
          "defense": 1,
          "speed": 1,
          "experience_value": 5,
          "gold_drop": {"min": 3, "max": 7},
          "spawn_chance": 0.3,
          "ai_behavior": {
            "detection_range": 50,
            "chase_player": true,
            "attack_range": 8,
            "attack_cooldown": 25
          }
        },
        {
          "name": "Orc",
          "type": "orc",
          "sprite_id": 18,
          "health": 10,
          "attack": 4,
          "defense": 2,
          "speed": 1,
          "experience_value": 10,
          "gold_drop": {"min": 5, "max": 12},
          "spawn_chance": 0.2,
          "ai_behavior": {
            "detection_range": 60,
            "chase_player": true,
            "attack_range": 8,
            "attack_cooldown": 20
          }
        },
        {
          "name": "Dragon",
          "type": "dragon",
          "sprite_id": 19,
          "health": 20,
          "attack": 6,
          "defense": 3,
          "speed": 1,
          "experience_value": 25,
          "gold_drop": {"min": 15, "max": 30},
          "spawn_chance": 0.1,
          "ai_behavior": {
            "detection_range": 70,
            "chase_player": true,
            "attack_range": 8,
            "attack_cooldown": 15
          }
        }
      ],
      "spawn_rules": {
        "enemies_per_room": {"min": 1, "max": 3},
        "scale_with_level": true,
        "exclude_player_room": true,
        "exclude_exit_room": false
      }
    },
    
    "items": {
      "list": [
        {
          "name": "health_potion",
          "sprite_id": 32,
          "effect": "restore_10_health",
          "spawn_chance": 0.3,
          "spawn_per_level": {"min": 1, "max": 2}
        },
        {
          "name": "gold_pile",
          "sprite_id": 33,
          "effect": "add_gold",
          "value": {"min": 5, "max": 15},
          "spawn_chance": 0.4,
          "spawn_per_level": {"min": 2, "max": 4}
        },
        {
          "name": "chest",
          "sprite_id": 34,
          "effect": "loot_container",
          "contains": {
            "gold": {"min": 10, "max": 30},
            "potion_chance": 0.5
          },
          "spawn_chance": 0.2,
          "spawn_per_level": {"min": 0, "max": 1}
        }
      ]
    }
  },
  
  "resources": {
    "game_state": {
      "initial_level": 1,
      "initial_floor": 1,
      "max_floor": 10
    },
    "game_states": {
      "available": ["title", "playing", "levelup", "gameover", "victory"],
      "default": "title"
    },
    "input_handling": {
      "supported_keys": ["up", "down", "left", "right", "z", "x"]
    }
  },
  
  "game_states": {
    "title": {
      "canvas_rendering": {
        "background": "0",
        "ui_elements": [
          {
            "text": "labyrinth descent",
            "font": "default",
            "color": "12",
            "position": {"x": 64, "y": 40, "align": "center"}
          },
          {
            "text": "press ❎ to start",
            "font": "default",
            "color": "7",
            "position": {"x": 64, "y": 70, "align": "center"}
          }
        ]
      },
      "input_transitions": {
        "x_button": "playing"
      }
    },
    
    "playing": {
      "canvas_rendering": {
        "dungeon_floor_color": "6",
        "dungeon_wall_color": "5"
      },
      "controls": {
        "movement": ["up", "down", "left", "right"],
        "attack": ["z"],
        "use_potion": ["x"]
      }
    },
    
    "levelup": {
      "duration": 60,
      "canvas_rendering": {
        "background": "transparent_overlay",
        "ui_elements": [
          {
            "text": "level up!",
            "font": "default",
            "color": "10",
            "position": {"x": 64, "y": 60, "align": "center"}
          }
        ]
      },
      "auto_transition": {
        "target_state": "playing",
        "delay": 60
      }
    },
    
    "gameover": {
      "canvas_rendering": {
        "background": "0",
        "ui_elements": [
          {
            "text": "game over",
            "font": "default",
            "color": "8",
            "position": {"x": 64, "y": 50, "align": "center"}
          },
          {
            "text": "floor: {floor}",
            "font": "default",
            "color": "7",
            "position": {"x": 64, "y": 65, "align": "center"}
          },
          {
            "text": "press ❎ to restart",
            "font": "default",
            "color": "7",
            "position": {"x": 64, "y": 80, "align": "center"}
          }
        ]
      },
      "input_transitions": {
        "x_button": "playing"
      }
    },
    
    "victory": {
      "canvas_rendering": {
        "background": "0",
        "ui_elements": [
          {
            "text": "victory!",
            "font": "default",
            "color": "11",
            "position": {"x": 64, "y": 50, "align": "center"}
          },
          {
            "text": "you escaped!",
            "font": "default",
            "color": "7",
            "position": {"x": 64, "y": 65, "align": "center"}
          }
        ]
      }
    }
  },
  
  "gameplay_systems": {
    "player_movement": {
      "movement_type": "grid_aligned",
      "collision": "wall_detection",
      "diagonal_movement": false
    },
    
    "combat_system": {
      "type": "turn_based",
      "player_attack": {
        "type": "melee",
        "trigger": "adjacent_enemy",
        "damage_calculation": "player.attack - enemy.defense",
        "auto_attack": true
      },
      "enemy_attack": {
        "type": "melee",
        "trigger": "adjacent_player",
        "damage_calculation": "enemy.attack - player.defense"
      }
    },
    
    "experience_system": {
      "level_up_formula": "10 * level",
      "stat_gains_per_level": {
        "max_health": 5,
        "attack": 1,
        "defense": 1
      },
      "health_restore_on_level": "full"
    },
    
    "loot_system": {
      "gold_drops": true,
      "item_drops": true
    },
    
    "progression_system": {
      "floors": 10,
      "difficulty_scaling": {
        "enemy_health_multiplier": 1.2,
        "enemy_attack_multiplier": 1.1,
        "enemy_count_increase": 1
      }
    }
  },
  
  "level_progression": {
    "trigger": "reach_exit_stairs",
    "action": "generate_new_level",
    "difficulty_increase": true
  },
  
  "game_over_conditions": [
    "player_health <= 0"
  ],
  
  "win_condition": [
    "floor >= 10 AND reached_exit"
  ],
  
  "prompt_instruction": {
    "overview": "Create a complete PICO-8 roguelike dungeon crawler game following classic roguelike conventions with procedural generation, turn-based combat, and permadeath.",
    
    "requirements": [
      "Single-file PICO-8 cartridge (.p8 format)",
      "Procedural dungeon generation using BSP algorithm",
      "Grid-based movement (8x8 pixel tiles)",
      "Turn-based gameplay (enemies move after player)",
      "Fog of war / line of sight system",
      "Multiple enemy types with increasing difficulty",
      "Experience and leveling system",
      "Item collection (gold, potions, chests)",
      "HUD showing health, level, floor, gold",
      "Victory condition: reach floor 10 exit",
      "Game over on death with restart option"
    ],
    
    "implementation_details": [
      "Use PICO-8 map() for dungeon tiles or draw with rectfill()",
      "Implement BSP dungeon generation algorithm",
      "Store dungeon as 2D array (0=wall, 1=floor, 2=exit)",
      "Use simple line-of-sight algorithm (Bresenham or distance-based)",
      "Enemy AI: chase player when in detection range using simple pathfinding",
      "Combat: automatic melee when adjacent, with damage calculation",
      "Use PICO-8 color palette for entities (sprites or text glyphs)",
      "Save state not required (roguelike permadeath)",
      "Keep within PICO-8 token limits (~8192 tokens)"
    ],
    
    "dungeon_generation": [
      "Create 16x16 grid of 8x8 tiles",
      "Initialize all tiles as walls",
      "Generate 4-7 rectangular rooms with random sizes (3-7 tiles)",
      "Connect rooms with corridors",
      "Place player in center of first room",
      "Place exit stairs in farthest room",
      "Spawn enemies in rooms (excluding player room)",
      "Spawn items randomly on floor tiles"
    ],
    
    "ui_layout": [
      "Top 16 pixels: HUD (HP, LVL, FLOOR, GOLD)",
      "Bottom 112 pixels: Dungeon view (16x14 visible tiles)",
      "Use print() for text rendering",
      "Use symbols: @ = player, r/s/o/D = enemies, $ = gold, ! = potion, = = chest, > = stairs"
    ],
    
    "code_structure": [
      "Global variables: player, enemies[], items[], dungeon[][], gamestate",
      "_init(): initialize game, generate first dungeon",
      "_update(): handle input, update game logic based on state",
      "_draw(): render dungeon, entities, UI",
      "gen_dungeon(): procedural generation function",
      "move_player(dx,dy): movement with collision",
      "enemy_turn(): AI and movement for all enemies",
      "do_combat(attacker,defender): damage calculation",
      "check_levelup(): experience system",
      "spawn_entities(): place enemies and items"
    ]
  }
}
