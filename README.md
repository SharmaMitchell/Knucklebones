![knucklebones](https://github.com/SharmaMitchell/Knucklebones/assets/90817905/44ff9e57-a321-4ff3-9475-9d8b0ec6af8f)

Knucklebones is a mini-game featured in the 2022 rougelike videogame [Cult of the Lamb](https://en.wikipedia.org/wiki/Cult_of_the_Lamb). This is a recreation of the game, implemented using SwiftUI and assets from the original game (taken from the Cult of the Lamb [official wiki](https://cult-of-the-lamb.fandom.com/wiki/Cult_of_the_Lamb_Wiki)).

## Game Rules
The game consists of two 3x3 boards, one belonging to the player and the other belonging to an automated opponent. Each turn, the player rolls a six-sided die and places the die in a column on their board. Lining up multiple dice of the same value multiplies each die’s score, but all matching dice can be destroyed if an opponent places a die of the same value in the corresponding column on their board. The game ends when either board is full, at which point the player with the higher score wins.

## UI Design
![knucklebones_mockups](https://github.com/SharmaMitchell/Knucklebones/assets/90817905/1bce8b65-0b8d-4274-b754-0904ecb1ec15)
The user interface for this Knucklebones app was designed with the original game in mind, incorporating visual effects, animations, and assets matching the theme of the original. Animated assets, including animated character gifs that respond to the ongoing game, were taken from the original game (see [Asset Usage](/#asset-usage)). UI assets like buttons were designed using Figma, incorporating colors and icons from the original game.

This app consists of three main tabs. The Game tab functions as a landing screen from which players can select their difficulty and start the game, during which the game tab will display the ongoing game UI. The Stats tab displays statistics on dice rolls and game wins/losses from the current session.

## User Flow Journeys
![knucklebones_user_flow](https://github.com/SharmaMitchell/Knucklebones/assets/90817905/6cac307a-854d-4e60-8bf4-08ed508a8b4c)

<!-- ## Implementation -->

## Continuing Development Goals
There are numerous features and iterations in mind to expand on the current version of this game:
- Publish to app store
  - Current assets would need to be removed/replaced to avoid copywright infringement.
- Multiplayer functionality (via Firebase)
  - Set up account auth via Firebase
  - Allow users to create game sessions, storing game state using Firestore real-time database
  - Allow users to invite other users to their game sessions
  - Delete game session DB entries upon game finish
  - Store single-player and multi-player stats on user accounts in Firebase
- Additional difficulty levels
  - Tweak RNG logic using weighted dice mechanics to create more granular difficulty levels
- Additional opponents
  - Add assets for different opponents from the original game
  - Tie difficulty to opponent, similarly to the original game
- Add progression system
  - Improve statistics system to track stats/progression across sessions (either locally, or via a database with an account system)
  - Implement a progression system that rewards long-term play
    - Allow players to unlock customization items (dice, board backgrounds, characters/animations, etc.)
    - Allow players to unlock higher difficulty levels upon clearing lower levels
    - Implement a level-up system
    - Implement an in-game currency that can be bet/gambled on games, similarly to the original mini-game

## Asset Usage
This project was created for educational purposes, as a term project for an iOS development class at the University of Houston. All assets (animated gifs, images, etc.) are property of the Cult of the Lamb team. This project was created for educational purposes; the use of this project's code or assets for profit is not permitted, as this would violate Fair Use copywright protections for the usage of the original game's assets.

The "Knucklebones" title image was adapted from the "Knuckleclone" title of [Nafeij's web-based recreation](https://github.com/Nafeij/kbclone).
