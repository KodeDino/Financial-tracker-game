# Financial Tracker - Godot Mobile Game

## Claude Instructions

- When the user indicates they are done for the day (e.g. "let's wrap up", "I'm done for today", "that's it for today"), automatically update MEMORY.md with the day's progress before ending the session
- Always note down hiccups, bugs, or unexpected discoveries in the progress entry — these make for richer video content

## Project Overview

Converting existing financial tracker web app into a Godot mobile game with custom pixel art UI.

### Key Decisions

- Platform: Godot (instead of WeChat Mini Program)
- Storage: Local save data only (using Godot's FileAccess system, no backend)
- UI Style: Custom pixelated assets for game-like feel (not using built-in Godot UI components)
- Complexity: Simpler than previous basketball game - mainly UI screens and data management

### Core Features

- Goal tracking & progress visualization
- Investment/transaction logging (CDs, T-bills, etc.)
- Save/load system
- Four main screens: Dashboard, Tracker, History, Instruction

### UI Design

- Color scheme: Dark blue/teal with pixel art style
- Bottom navigation: 4 circular buttons for main screens
- Card-based layout for investments/goals
- See: Assets/mockup.png for full design reference

---

## Add Investment Form — Field Specification

### Date Picker
- Picks the **starting date** of the investment

### Investment Type (CD or T-Bill — toggled by RadioButton)

**CD fields:**
- Amount → amount invested ($)
- Rate → interest rate (%)

**T-Bill fields:**
- Face Value → amount when T-Bill matures ($)
- Actual Cost → actual purchase cost of the T-Bill ($)

### Reinvesting Checkbox (bottom of form)
- Checkbox: "Reinvesting from matured investment?"
- If checked, shows one additional field:
  - Reinvested Amount → amount taken from a previously matured investment ($)
  - This represents the portion of the new investment funded by a prior maturity

### Input Field Implementation
- Hybrid approach: transparent `LineEdit` layered on top of pixel art `NinePatchRect` background
- Number fields: `virtual_keyboard_type = NUMBER_DECIMAL`
- CD and T-Bill field groups are shown/hidden based on RadioButton selection
