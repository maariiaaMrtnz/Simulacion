// Display and output parameters:

final boolean FULL_SCREEN = false;
final int DRAW_FREQ = 100;                            // Draw frequency (Hz or Frame-per-second)
int DISPLAY_SIZE_X = 1000;                            // Display width (pixels)
int DISPLAY_SIZE_Y = 1000;                            // Display height (pixels)
final int [] BACKGROUND_COLOR = {150, 210, 240};      // Background color (RGB)
final int [] TEXT_COLOR = {0, 0, 0};                  // Text color (RGB)

final float FOV = 60;                          
final float NEAR = 0.01;                          
final float FAR = 5000.0;    
final float CAMERA_DIST = 200.0;


// Simulation values:
final boolean REAL_TIME = true;
final float TIME_ACCEL = 1.0;     // To simulate faster (or slower) than real-time
final float TS = 0.01;           // Initial simulation time step (s)

PImage img;

boolean _viewmode = false;
boolean _clear = false;

final int _MAP_SIZE = 150;
final float _MAP_CELL_SIZE = 10f;

float amplitude = random (2f) + 8f;
float wavelength = amplitude* (30 + random(2f));
float speed = wavelength/(1+random(3f));
