### Hyper Chaos Pong 
## A Small Rouge-lite(?) Pong Game

# description:
this is a small game where you play pong for 10 rounds while getting upgrades between each round , your enemies get more and more powerful as you progress through rounds 

# features:
  - Controller Support
  - Local Multiplayer Mode
  - Several Upgrades

# Making Custom Upgrades
you can make your custom upgrades by making new scripts inheriting the [Upgrades](https://github.com/Vedomom/hyper-pong/blob/main/Scripts/Upgrades/Scripts/upgrade.gd) class for the Player , or the [EnemyUpgrades](https://github.com/Vedomom/hyper-pong/blob/main/Scripts/Upgrades/Enemy/Scripts/enemy_upgrade.gd) for the CPU Upgrades.
after coding the upgrade script , assign it to an empty *Node* scene and save it, then make a new Resource inheriting the [Upgrade_selection](https://github.com/Vedomom/hyper-pong/blob/main/Resources/upgrade_selection.gd) class , and assign the upgrade scene to the *scene* property , then give it a title and a description and save it.

all you have to do is to put the resource in "Resources/Upgrades" and build the game
I am currently working on an external ability maker to make this process easy

# Known Bugs:
  - Sometimes the CPU can make the ball stuck between the wall and itself, right now this just makes the point count for the player and all the problems are audio\visual
  - when the player moves into the ball from the side this can lead to the player being erratically moved for a second , again this effect is purely visual

# Credits:
  - [pixel-quantization ](https://godotshaders.com/shader/pixel-quantization/) Shader
  - [Pixel art input-prompts](https://kenney.nl/assets/input-prompts-pixel) Image-Pack
  - [fractal-noise-scene-transition](https://godotshaders.com/shader/fractal-noise-scene-transition/) Shader
  - [pixelated-warped-fractal-noise](https://godotshaders.com/shader/pixelated-warped-fractal-noise/) Shader (Main Menu Background)
