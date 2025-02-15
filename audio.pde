import javax.sound.sampled.*;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

// Background Music
Clip audioClip;

// Sound effect pools
ArrayList<Clip> enemyDeathClips = new ArrayList<>();
ArrayList<Clip> pewClips = new ArrayList<>();
Clip playerDeathClip;
Clip bossSpawnsClip; // New clip for boss spawn sound
Clip bossDeathClip;  // New clip for boss death sound

void setupAudio() {
  try {
    // Background Music
    File musicFile = new File(dataPath("music.wav"));
    AudioInputStream musicStream = AudioSystem.getAudioInputStream(musicFile);
    audioClip = AudioSystem.getClip();
    audioClip.open(musicStream);
    audioClip.loop(Clip.LOOP_CONTINUOUSLY); // Loop background music

    // Preload sound pools
    preloadSoundPool(enemyDeathClips, "enemyDeath.wav", 5); // Pool of 5 Clips for enemy death
    preloadSoundPool(pewClips, "pew.wav", 10);             // Pool of 10 Clips for shooting

    // Player Death Sound (single instance is enough)
    File playerFile = new File(dataPath("playerDeath.wav"));
    AudioInputStream playerStream = AudioSystem.getAudioInputStream(playerFile);
    playerDeathClip = AudioSystem.getClip();
    playerDeathClip.open(playerStream);

    // Increase player death sound volume
    setVolume(audioClip,-6.0);
    setVolume(playerDeathClip,4.0);

    // Boss Spawn Sound
    File bossSpawnsFile = new File(dataPath("bossSpawns.wav"));
    AudioInputStream bossSpawnsStream = AudioSystem.getAudioInputStream(bossSpawnsFile);
    bossSpawnsClip = AudioSystem.getClip();
    bossSpawnsClip.open(bossSpawnsStream);

    // Boss Death Sound
    File bossDeathFile = new File(dataPath("bossDeath.wav"));
    AudioInputStream bossDeathStream = AudioSystem.getAudioInputStream(bossDeathFile);
    bossDeathClip = AudioSystem.getClip();
    bossDeathClip.open(bossDeathStream);

  } catch (UnsupportedAudioFileException | IOException | LineUnavailableException e) {
    e.printStackTrace();
  }
}

// Preload a pool of Clips for a specific sound
void preloadSoundPool(ArrayList<Clip> pool, String fileName, int poolSize) {
  try {
    for (int i = 0; i < poolSize; i++) {
      File soundFile = new File(dataPath(fileName));
      AudioInputStream soundStream = AudioSystem.getAudioInputStream(soundFile);
      Clip clip = AudioSystem.getClip();
      clip.open(soundStream);
      pool.add(clip);
    }
  } catch (UnsupportedAudioFileException | IOException | LineUnavailableException e) {
    e.printStackTrace();
  }
}

// Play a sound from a pool
void playSoundFromPool(ArrayList<Clip> pool) {
  for (Clip clip : pool) {
    if (!clip.isRunning()) { // Find an available Clip
      clip.setFramePosition(0); // Reset to start
      clip.start(); // Play the sound
      return;
    }
  }
  println("All clips in the pool are currently in use!");
}

// Enemy death sound
void enemyDeath() {
  playSoundFromPool(enemyDeathClips);
}

// Pew sound for shooting
void pew() {
  playSoundFromPool(pewClips);
}

// Player death sound
void playerDeath() {
  playSingleSound(playerDeathClip);
}

// Boss spawn sound
void bossSpawns() {
  playSingleSound(bossSpawnsClip);
}

// Boss death sound
void bossDeath() {
  playSingleSound(bossDeathClip);
}

// Helper function to play a single-instance Clip
void playSingleSound(Clip clip) {
  if (clip.isRunning()) {
    clip.stop(); // Stop if it's already playing
  }
  clip.setFramePosition(0); // Rewind to start
  clip.start(); // Play the sound
}

// Set volume for a specific clip
void setVolume(Clip clip, float level) {
  if (clip != null) {
    try {
      FloatControl gainControl = (FloatControl) clip.getControl(FloatControl.Type.MASTER_GAIN);
      gainControl.setValue(level); // `level` is in decibels (-80.0 to 6.0)
    } catch (IllegalArgumentException e) {
      println("Volume adjustment not supported for this clip.");
    }
  }
}
