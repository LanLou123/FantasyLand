# CIS 566 Homework 1: Noisy Terrain

## [Demo]( https://lanlou123.github.io/hw01-noisy-terrain/)

## Current features:
- fbm combine worley noise terrain (two octaves of woley in the outter layer and 6 octaves of perlin noise together with one layer of large scale worley as mask in the outermost layer.
  - different noise comparision:
  
  pure worley fbm | pure perlin fbm 
  ----|---
  ![](img/pureworley.JPG) | ![](img/pureperlin.JPG) 
  
  combine of two:
  
  ![](img/wp.JPG)

- biomes based on terrain altitude and a large scale fbm perlin noise
  - including grasslands forest and mud land , and also mapping of terrain color to it's altitude
![](img/bio.gif)

- worley noise ocean (acheived by compositing multiple layers of worley noise in fbm style based on u_time,
each of which possess different velocity and direction)
- remapping of terrain:

pow 0.2 | pow 1.0 |pow 3.0
----|---|-------
![](img/pow0.2.JPG) | ![](img/pow1.JPG) | ![](img/pow3.JPG)

- alpha blending based on depth of terrain for ocean
  - you can notice water transparency changes with it's elevation
![](img/waterele.gif)
- terrain color layers based on terrain hight as well as slope angle
- simple lambert shading for terrain
- specularity and fresnel effect for ocean surface

## some examples

![](img/aaa.gif)
![](img/dd.JPG)
