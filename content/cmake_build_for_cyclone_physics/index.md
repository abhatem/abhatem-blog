+++
title = "Just created a CMakeLists.txt for the Cyclone Physics Engine"
description = "brining the Cyclone Physics Engine to the 21st century with a CMakeLists.txt file"
date = 2024-08-29
draft = false
slug = "cmake_build_for_cyclone_physics"

[taxonomies]
categories = ["showing off"]
tags = ["cmake", "c++", "simulation", "gamedev"]

[extra]
comments = true
lang = "en"
+++


So recently I got my hands on a copy of "Game Physics Engine Development" by Ian Millington, and was ready to get my hands on the [accompanying source code](https://github.com/idmillington/cyclone-physics/) only to find out that it was missing a `CMakeLists.txt` file, making it virtually impossible to work with my neovim lsp setup that depends on CMake as it's backbone. so I decided to take the oppurtunity and try to make one myself, and after a while I managed to get something to work, wrote a readme, and called it a pull request. 

The result can be found here: [https://github.com/abhatem/cyclone-physics-cmake](https://github.com/abhatem/cyclone-physics-cmake) and the link to the pull request is here: [https://github.com/idmillington/cyclone-physics/pull/67](https://github.com/idmillington/cyclone-physics/pull/67)
