# Orishas Path

A turn-based RPG mobile game with African mythology theme, built with Godot 4.x.

## Overview

- **Genre:** Turn-based RPG
- **Theme:** Yoruba mythology (Orishas)
- **Target Market:** Nigeria (English, Flutterwave payments)
- **Engine:** Godot 4.2+ with GDScript
- **Backend:** Supabase (PostgreSQL, Edge Functions, Auth)
- **Monetization:** Recharge cards + Monthly card

## Classes

| Class | Role | Specialty |
|-------|------|-----------|
| Ogun Warrior | Tank/Melee DPS | High HP, physical attacks |
| Shango Mage | Ranged DPS | Lightning/fire magic, AOE |
| Oshun Healer | Support | Healing, buffs, cleanse |
| Eshu Scout | Speed/Control | Debuffs, high SPD |

## Project Structure

`
scripts/
  autoload/       - GameManager, NetworkManager, DataManager, AudioManager
  characters/     - 4 classes + base character
  combat/         - Battle system, skills, damage calc
  items/          - Equipment, consumables, skill books
  pets/           - Pet system (lion, cheetah, crocodile)
  shop/           - Shop + IAP manager
  social/         - Chat + friend system
  ui/             - All UI scripts
scenes/           - Godot scene files (.tscn)
supabase/         - Database schema + Edge Functions
tests/            - Unit and integration tests
`

## Setup

1. Install Godot 4.2+
2. Open project.godot in Godot
3. Create a Supabase project at https://supabase.com
4. Run supabase/schema.sql in Supabase SQL Editor
5. Update scripts/autoload/network_manager.gd with your Supabase URL and anon key
6. Deploy Edge Functions: supabase functions deploy
7. Run tests via GUT plugin in Godot

## Building for Android

1. Install Android build templates in Godot
2. Configure export preset (already done in export_presets.cfg)
3. Project > Export > Android > Export Project

## Monetization

- **Ori Coin** - In-game currency purchased via recharge cards
- **Recharge Cards** - Physical/virtual cards redeemed for Ori Coin
- **Monthly Card** - 500 Ori Coin/month, daily 50 Ori Coin login bonus
- **Shop** - Equipment, skill books, consumables

## License

Proprietary. All rights reserved.