turtles-own
[ infected?  ;; if true, the turtle has measles
  time-sick  ;; how many days has the turtle been with measles
  immune?       ;; if true, turtle cannot get infected
  hospitalized? ;; if true, turtle has serious complications from measles, must be hospitalized and does not move
]


globals
  [ number-vaccinated   ;; number of turtles vaccinated
    number-dead         ;; number of turtles that died
    number-total-hospitalized    ;; total number of people that required hospitalization
    number-total-infected   ;; total number of people that caught measles
]


to setup
  clear-all
  create-turtles number-of-people   ;; creating turtles
  [ setxy random-xcor random-ycor
    set color white                 ;; turtles are initially white
    set infected? false
    set immune? false
    set hospitalized? false
  ]
  ;; setting up some variables
  set number-vaccinated  %vaccinated * count turtles / 100
  set number-dead 0
  set number-total-hospitalized 0
  set number-total-infected 0

  ;; a number of turtles are vaccinated and become immune
  ask n-of number-vaccinated turtles
      [ get-immune ]
  ;; a small initial number of turtles are infected with measles

  ask n-of initial-number-infected turtles [ get-infected ]
  reset-ticks
end


to go
  ask turtles [
    ifelse hospitalized? [ immune-or-die ] [ move ]
    if infected? [ immune-or-hospitalized ]
    if infected? [ infect ]
  ]
    update-color
  if count turtles with [ color = red ] = 0 [ stop ] ;; stops simulations once there are no more infected
  tick
end


to get-immune
  set immune? true
  set infected? false
  set hospitalized? false
  set color blue
  set time-sick 0
end

to get-infected
  set infected? true
  set color red
  set number-total-infected number-total-infected + 1
end


to move
  rt random 100
  lt random 100
  fd 1
end

to infect ;; infects other turtles on the same patch
  if time-sick >  5    ;; turtles become infectious after 5 days sick
     [ask other turtles-here with [ not infected? and not immune? ]
      [ if random-float 100 < 90   ;; 9 out 10 people get infected with measles
        [ get-infected]
        ]
  ]
  set time-sick time-sick + 1
end

to immune-or-hospitalized
  if time-sick = 10
        [ if random-float 100 < 20  [      ;; turtles with measles have 20% chance of complications
          set number-total-hospitalized number-total-hospitalized + 1
          set hospitalized? true] ]
  if time-sick = 20    ;; after 20 days, the infected turtles recover and become immune
        [ get-immune ]
end


to immune-or-die
  ifelse random-float 100 < 0.5 [    ;; 0.5% probability of dying if turtle has complication
    set number-dead number-dead + 1
    die ] [ get-immune ]
end


to update-color   ;; updating the turtles' color
  ask turtles
      [ set color ifelse-value hospitalized? [ green ]
        [ ifelse-value infected? [ red ] [
          ifelse-value immune? [ blue ] [ white] ]

        ]
      ]
end
@#$#@#$#@
GRAPHICS-WINDOW
273
20
860
608
-1
-1
5.733
1
10
1
1
1
0
1
1
1
-50
50
-50
50
1
1
1
ticks
30.0

SLIDER
54
93
226
126
%vaccinated
%vaccinated
0
100
50.0
1
1
NIL
HORIZONTAL

BUTTON
72
134
135
167
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
144
134
207
167
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

PLOT
9
415
258
606
People with measles at given time
time (days)
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot count turtles with [ color = red ]"

SLIDER
53
19
225
52
number-of-people
number-of-people
0
10000
7000.0
500
1
NIL
HORIZONTAL

SLIDER
52
56
226
89
initial-number-infected
initial-number-infected
1
10
1.0
1
1
NIL
HORIZONTAL

MONITOR
10
173
258
218
Total number of people that have been infected
number-total-infected
17
1
11

MONITOR
10
366
260
411
Number of days
ticks
17
1
11

MONITOR
9
222
258
267
Number that required hospitalization
number-total-hospitalized
17
1
11

MONITOR
9
271
258
316
Number of deaths
number-dead
17
1
11

MONITOR
10
319
259
364
% Immune
count turtles with [ color = blue ]  / number-of-people * 100
0
1
11

@#$#@#$#@
## WHAT IS IT?

This model simulates the transmission of measles in a human population, taking into account vaccination coverage.

## HOW IT WORKS

Agents are people moving randomly around the world. The user determines the density of the population. A few agents are infected with the measles virus (RED). Healthy non-immune agents are identified by the color WHITE.

Measles is most infectious 4 days before/after a rash appears/disappears. This rash usually appears in two weeks and lasts 5 to 6 days [1]. In this model, agents are contagious between days 7 and 20 after being infected.

The Measles virus is very infectious, with a transmissibility of around 90% among non-immunized individuals [1]. Therefore, in this model, when an infected agent is in the same patch as healthy agents that are not immune, the probability of transmission is 90%.

Around 20% to 40% of those infected with measles suffer complications which require hospitalization, especially children [2]. One to three in a thousand infected will die from these complications [3]. To model this, infected have a probability of 20% of transitioning to a "hospitalized" (GREEN) state on the 10th day of illness. Hospitalized agents do not move. Most hospitalized agents recover and become immune after the 20th day. A small percentage of hospitalized (0.5%) dies.

Immunity is possible through vaccination or by recovering after illness. In this model, life-time immunity is assured. Immune agents are identified by the color BLUE.



## HOW TO USE IT

User can modify the following parameters:

NUMBER-OF-PEOPLE:  The size of the population.

INITIAL-NUMBER-INFECTED: The number of people that are initially infected with measles.

%VACCINATED: Percentage of the population that has received vaccination.
 
The SETUP button allows user to set and reset simulation, randomly distributing the individuals of the population. The GO button starts the simulation, which will run until no more individuals are infected.

Monitors show:

- the total number of people in the population that were infected with the measles virus during the epidemic
- the total number of people hospitalized due to complications
- the number of deaths
- the percentage of the population that is immune
- the number of days that have passed (one day per tick).

The graphical output shows how the number of infected changes over time.


## THINGS TO NOTICE

Since the modelled population is a closed society, with no new members appearing after the start of the simulation, eventually the measles virus is eradicated. This is true even with %VACCINATED of zero. However, it is important to consider not only deaths, but elevated numbers of hospitalizations. Measles infection can lead to severe complications, some of which have long lasting consequences [4].

This model shows how high levels of immunization is needed to prevent measles from spreading. This is in agreement with the WHO framework [5] and explains the measles outbreak in 2024 in UK, with an overall vaccination coverage of 85% [6].


## THINGS TO TRY

Experiment on how populational density influences the level of immunization required to erradicate the virus by changing NUMBER-OF-PEOPLE.

Find the minimal %VACCINATED to prevent the spread of measles, given certain population density and initial number of infected. Remember that in the real world there is a part of the population for whom the measles vaccine is not recommended or contraindicated, such children under the age of one and pregnant or immunocompromised individuals [7].

Is an epidemic with longer duration a positive or negative outcome? Experiment with the parameters and you will notice that a short epidemy (small “number of days”) not only could mean that the virus was not able to spread, but also that the transmission rate was very high.




## EXTENDING THE MODEL

Modify parameters such as the probability of hospitalization and/or death, based on different information sources.

Consider that the population could be heterogenic. For example, the population could have an age distribution. Children are the most affected by measles.

Adapt the model to a disease that does not provide lifetime immunity.



## RELATED MODELS

Wilensky, U. (1998). NetLogo Virus model. http://ccl.northwestern.edu/netlogo/models/Virus. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## CREDITS AND REFERENCES


[1] Measles. World Health Organization. Available at: https://www.who.int/news-room/fact-sheets/detail/measles (Accessed: 06 March 2024). 

[2] London at risk of major measles outbreak, UK Health Security Agency warns (2023) The Guardian. Available at: https://www.theguardian.com/society/2023/jul/14/measles-outbreak-risk-london-uk-health-security-agency-mmr-vaccine-take-up (Accessed: 06 March 2024). 

[3] For healthcare professionals - diagnosing and treating measles (2020) Centers for Disease Control and Prevention. Available at: https://www.cdc.gov/measles/hcp/index.html (Accessed: 06 March 2024). 

[4] Measles complications (2020) Centers for Disease Control and Prevention. Available at: https://www.cdc.gov/measles/symptoms/complications.html (Accessed: 06 March 2024). 

[5] Measles and rubella strategic framework 2021–2030. Geneva: World Health
Organization; 2020. Licence: CC BY-NC-SA 3.0 IGO.

[6] Specia, M. (2024) Vaccination rates dipped for years. now, there’s a measles outbreak in Britain., The New York Times. Available at: https://www.nytimes.com/2024/03/03/world/europe/uk-measles-outbreak.html (Accessed: 06 March 2024). 

[7] Routine MMR vaccination recommendations: For Providers (2021) Centers for Disease Control and Prevention. Available at: https://www.cdc.gov/vaccines/vpd/mmr/hcp/recommendations.html (Accessed: 06 March 2024).
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.4.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
