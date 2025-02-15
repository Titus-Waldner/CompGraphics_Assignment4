5
ChatGPT said:
Assignment 4 - Interactive 3D Game World
Overview

This project implements an interactive 3D game world using Processing 4.3. The assignment focuses on rendering a dynamic scene with player movement, enemies, projectiles, texture mapping, collision detection, and particle effects. The Processing graphics pipeline is used for rendering, along with camera transformations, texture mapping, and animation.

![image](https://github.com/user-attachments/assets/3839e025-0336-4913-84df-e1dee926f09a)
![image](https://github.com/user-attachments/assets/9e13eee4-b6c0-4881-963b-5f18be5006b7)

NOTE: For music to work, plcae music.wav file inside data. For project I used https://www.youtube.com/watch?v=kWGBJb0JsRk.

Features Implemented
3D Scene and Camera System

    Configured a 3D perspective projection using frustum() for depth perception.
    Implemented a custom camera system using camera(), allowing full control over the view.
    Defined a consistent coordinate system for object positioning and movement.

Player and Enemy Mechanics

    Created a player-controlled spaceship that moves smoothly using lerping for fluid motion.
    Implemented boundary constraints to keep the player within the world limits.
    Designed automated enemy movement with keyframe-based animations.
    Developed projectile mechanics, allowing the player and enemies to shoot bullets.
    Used a particle system for bullets, ensuring proper lifespan and cleanup.

Texture Mapping and Animation

    Applied texture mapping to the player and enemy models using loadImage(), textureMode(), and texture().
    Implemented frame-based animation, cycling through multiple sprite frames for animated movement and shooting sequences.
    Managed draw order and depth separation to prevent rendering issues with overlapping objects.

Collision Detection and Game Logic

    Implemented bounding-circle collision detection, comparing object distances to determine interactions.
    Handled collision responses for various scenarios:
        Player colliding with enemy or enemy bullets results in game over.
        Enemy colliding with the player or player bullets results in enemy destruction.
        Bullet-to-bullet collisions cause both projectiles to be removed.
    Designed an enemy spawn system that increases difficulty over time.

Particle-Based Explosions

    Implemented a particle system for explosion effects when the player or enemy is destroyed.
    Particles move in all three dimensions, creating realistic destruction effects.
    Each explosion follows a randomized motion pattern with a limited lifespan.

Interactivity and Controls

    Supported multiple key presses simultaneously, allowing precise control.
    Implemented hotkeys for movement and actions, using keyPressed() and keyReleased().
    Designed gameplay mechanics that encourage strategic movement and shooting.

Usage

    Open the .pde files in Processing 4.3 and run the program.
    Use keyboard controls to move the player and shoot projectiles.
    Avoid enemy bullets and destroy enemies to survive.
    Observe animations, enemy behavior, and particle effects.

Usage

    Assets use are for education purposes only and author makes no claim of ownership of .png or .wav assets.
Submission

All required .pde files are included. The implementation follows structured programming principles, with separate classes for different game elements.
