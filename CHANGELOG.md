# CHANGES - 14/11/2024 - 15:43 - v0.1.0-prealpha

## Components

-   Building blocks of this building system
-   Can connect with other Components via the SnapPoints
-   Keep track and move with their parent Components

## SnapPoints

-   Markers placed wherever in the component other components can connect to
-   Will successfuly connect to its parent Component as long as its a child of the SnapPoints node 2d in the component tree

# CHANGES - 14/11/2024 - 15:43 - v0.1.0-prealpha

## MainComponent

-   The actual ship, the core of the building
    -   Can be controled with WASD and ArrowKeys
    -   Other components connect to it and move with it
