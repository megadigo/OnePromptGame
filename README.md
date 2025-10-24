# OnePromptGame

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Version](https://img.shields.io/badge/version-2.0-green.svg)
![GAML](https://img.shields.io/badge/GAML-v0.0.1-orange.svg)

**OnePromptGame** is an innovative project that demonstrates how complete, playable games can be generated from a single AI prompt using **GAML (Game AI Markup Language)** metadata specifications. Each game is fully functional, built with HTML5 Canvas and vanilla JavaScript, requiring no external libraries or dependencies.

## 🎮 What's Inside

This repository contains three complete classic arcade games, each generated entirely from AI using comprehensive GAML metadata files:

### 1. **Space Invaders** 🚀
A feature-rich 2D shooter with infinite level progression.

**Features:**
- Player ship with smooth keyboard controls
- 50 invaders in swarm formation (5 rows × 10 columns)
- Collision detection and scoring system
- Lives system (3 lives)
- Progressive difficulty scaling
- Game states: Menu, How to Play, Playing, Game Over

**Tech Stack:** HTML5 Canvas, Vanilla JavaScript  
**Play:** Open `games/space_invader/index.html`  
**Metadata:** `games/space_invader/space_invader_metadata.gaml`

---

### 2. **Pac-Man** 🟡
Classic maze-based game with procedurally generated mazes.

**Features:**
- Procedurally generated mazes using Depth-First Search algorithm
- 4 AI-controlled ghosts (Blinky, Pinky, Inky, Clyde) with chase behavior
- Pellets and power pellets system
- Ghost eating with combo multiplier (200, 400, 800, 1600 points)
- Frightened ghost mode (5 seconds)
- Lives system and infinite level progression
- Random maze generation for each level

**Tech Stack:** HTML5 Canvas, Vanilla JavaScript  
**Play:** Open `games/pacman/pacman.html`  
**Metadata:** `games/pacman/pacman_metadata.gaml`

---

### 3. **RPG Dungeon** ⚔️
Dungeon crawler with procedural generation and combat.

**Features:**
- Procedurally generated dungeons
- Turn-based combat system
- Character stats and inventory
- Multiple enemy types
- Level progression

**Tech Stack:** HTML5 Canvas, Vanilla JavaScript  
**Play:** Open `games/rpg_dungeon/index.html`  
**Metadata:** `games/rpg_dungeon/rpg_dungeon_metadata.gaml`

---

## 📋 GAML (Game AI Markup Language)

GAML is a comprehensive metadata specification format (YAML-based) that describes every aspect of a game in detail, enabling AI to generate complete, playable games from a single prompt.

### GAML Features:
- **Game Configuration**: Title, genre, description, credits, license
- **Project Structure**: Target platform, engine, language
- **Window/Canvas**: Dimensions, rendering settings
- **Entities**: Player, enemies, collectibles with complete specifications
- **Game States**: Menu, gameplay, game over, transitions
- **UI Elements**: HUD, menus, text rendering with exact positioning
- **Gameplay Systems**: Movement, collision detection, AI behaviors
- **Resources**: Audio, sprites, state management
- **Level Progression**: Win conditions, difficulty scaling

### Schema
All GAML files conform to the official schema:  
`https://github.com/megadigo/gaml-schema/blob/main/v0.0.1/gaml-schema.json`

---

## 🛠️ GAML Validator

The project includes a validation tool to ensure GAML files meet the specification.

### Installation
```bash
cd validator
npm install
```

### Usage
```bash
npm run validate
```

### Validation Results
The validator checks all GAML files and generates reports in `validator/results/`:
- Individual validation reports for each game
- Summary report with overall validation status

### What It Validates
- YAML syntax correctness
- Required fields presence
- Data type validation
- Schema compliance
- Structure integrity

---

## 🚀 Quick Start

### Playing the Games
1. Clone the repository:
   ```bash
   git clone https://github.com/megadigo/OnePromptGame.git
   cd OnePromptGame
   ```

2. Open any game HTML file in your web browser:
   - **Space Invaders**: `games/space_invader/index.html`
   - **Pac-Man**: `games/pacman/pacman.html`
   - **RPG Dungeon**: `games/rpg_dungeon/index.html`

3. No build process, no dependencies, no setup required!

### Validating GAML Files
```bash
cd validator
npm install
npm run validate
```

---

## 🎯 Game Controls

### Space Invaders
- **Menu**: SPACE to start, H for How to Play
- **Movement**: A/D or Arrow Keys (left/right)
- **Shoot**: SPACE
- **Game Over**: R to restart

### Pac-Man
- **Menu**: SPACE to start, H for How to Play
- **Movement**: WASD or Arrow Keys (4 directions)
- **Game Over**: R to restart
- **How to Play**: ESC to return to menu

### RPG Dungeon
- **Menu**: SPACE to start
- **Movement**: WASD or Arrow Keys
- **Game Over**: R to restart

---

## 📁 Project Structure

```
OnePromptGame/
├── README.md
├── games/
│   ├── space_invader/
│   │   ├── index.html                      # Complete game (single file)
│   │   └── space_invader_metadata.gaml     # GAML specification
│   ├── pacman/
│   │   ├── pacman.html                     # Complete game (single file)
│   │   ├── pacman_metadata.gaml            # GAML specification
│   │   └── assets/                         # Optional audio files
│   └── rpg_dungeon/
│       ├── index.html                      # Complete game (single file)
│       ├── rpg_dungeon_metadata.gaml       # GAML specification
│       └── assets/                         # Optional assets
└── validator/
    ├── package.json
    ├── validate-gaml.js                    # GAML validator
    └── results/                            # Validation reports
        ├── pacman_metadata-validation.json
        ├── rpg_dungeon_metadata-validation.json
        ├── space_invader_metadata-validation.json
        └── validation-summary.json
```

---

## 🎨 Design Philosophy

### Single-Prompt Generation
Each game was created by providing the GAML metadata file to an AI (Claude Sonnet 4.5) with a single prompt instruction. This demonstrates:
- The power of comprehensive specifications
- AI's capability to generate complete, functional games
- Reproducibility through structured metadata

### No Dependencies
All games are built with:
- Pure HTML5 Canvas
- Vanilla JavaScript
- Embedded CSS
- No external libraries
- No build tools
- No compilation required

### Complete Specifications
GAML files include:
- Exact pixel dimensions and positions
- Complete color specifications (hex codes)
- Detailed gameplay mechanics
- State machine definitions
- UI element layouts
- Animation parameters
- Collision systems
- AI behaviors

---

## 📊 Technical Specifications

### Space Invaders
- **Canvas**: 1200×800px
- **Entities**: Player ship, 50 invaders, bullets
- **Game Loop**: requestAnimationFrame (60 FPS target)
- **Features**: Lives (3), scoring, level progression, difficulty scaling

### Pac-Man
- **Canvas**: 700×750px
- **Grid**: 29×29 cells (20px each)
- **Entities**: Pac-Man, 4 ghosts, pellets, power pellets
- **Maze Generation**: Depth-First Search algorithm
- **Game Loop**: requestAnimationFrame (60 FPS target)
- **Features**: Lives (3), scoring, ghost AI, power-up system

### RPG Dungeon
- **Canvas**: Variable
- **Features**: Procedural dungeons, turn-based combat, inventory
- **Game Loop**: requestAnimationFrame
- **Systems**: Combat, inventory, character stats

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. **Add New Games**: Create GAML specifications for other classic games
2. **Improve Validator**: Enhance validation rules and error reporting
3. **Extend GAML Schema**: Propose new metadata fields
4. **Bug Fixes**: Report and fix issues in existing games
5. **Documentation**: Improve guides and examples

### Development Workflow
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-game`)
3. Create GAML metadata file
4. Generate game using AI
5. Validate GAML file
6. Test thoroughly
7. Submit pull request

---

## 📜 License

This project is licensed under the MIT License - see individual game files for details.

---

## 👥 Credits

### Development
- **Developer**: AI & megadigo (megadigo@gmail.com)
- **AI Contributors**: Claude Sonnet 4.5

### Assets
- **Graphics**: Oryx Design Lab (www.oryxdesignlab.com)

---

## 🔗 Links

- **GAML Schema**: https://github.com/megadigo/gaml-schema/blob/main/v0.0.1/gaml-schema.json
- **Repository**: https://github.com/megadigo/OnePromptGame

---

## 🌟 Showcase

### What Makes This Special?

1. **AI-Generated**: Complete games from single prompts
2. **No Dependencies**: Pure HTML5, CSS, and JavaScript
3. **Instant Play**: Open HTML files directly in browser
4. **Comprehensive Specs**: GAML provides complete game definitions
5. **Educational**: Learn game development through structured metadata
6. **Reproducible**: Same GAML + AI = Same game
7. **Validated**: All metadata files pass schema validation

---

## 📈 Future Plans

- [ ] More classic games (Tetris, Snake, Breakout)
- [ ] GAML v2.0 with enhanced features
- [ ] Visual GAML editor
- [ ] Automated game generation pipeline
- [ ] Multiplayer support specifications
- [ ] Mobile-responsive templates
- [ ] Audio system enhancements
- [ ] Advanced AI behaviors

---

## 💡 Use Cases

- **Education**: Learn game development through structured examples
- **Prototyping**: Rapid game concept validation
- **AI Research**: Study AI code generation capabilities
- **Game Design**: Template for classic game mechanics
- **Portfolio**: Showcase of AI-assisted development

---

## 📞 Contact

- **Email**: megadigo@gmail.com
- **Issues**: [GitHub Issues](https://github.com/megadigo/OnePromptGame/issues)

---

## ⭐ Star History

If you find this project interesting or useful, please consider giving it a star! ⭐

---

**Made with 🤖 AI and ❤️ by megadigo**
