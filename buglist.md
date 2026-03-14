# BUGLIST

##when equipping a shield while sword is swinging, sword animation gets stuck
- this is not particularly important because youre not supposed to be able to open your inventory while doing an action

##when consuming a potion while inventory is open, the potion gets used but not consumed
- same as above, youre not supposed to be able to consume potions(do actions) while inventory or ui is open 

##healthbars from enemies can be seen "infinitely" far because **no depth test** is turned on 
- gotta create some sort of min/max-distance-to-player component that disables it
