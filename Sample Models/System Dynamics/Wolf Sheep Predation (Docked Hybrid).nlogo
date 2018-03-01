;; Sheep and wolves are both breeds of turtle.
breed [sheep a-sheep] ;; sheep is its own plural: we use "a-sheep" as the singular.
breed [wolves wolf]
turtles-own [energy]  ;; both wolves and sheep have energy

to setup
  clear-all
  ask patches [ set pcolor green ]
  set-default-shape sheep "sheep"
  create-sheep initial-number-sheep [ ;; create the sheep
    ;; then initialize their variables
    set color white
    set size 1.5  ;; easier to see
    set label-color blue - 2
    set energy 1 + random sheep-max-initial-energy
    setxy random-xcor random-ycor
  ]
  set-default-shape wolves "wolf"
  create-wolves initial-number-wolves [ ;; create the wolves
    ;; then initialize their variables
    set color black
    set size 1.5  ;; easier to see
    set energy random (2 * wolf-gain-from-food)
    setxy random-xcor random-ycor
  ]
  display-labels
  reset-ticks
end

to go
  if not any? turtles [ stop ]
  ask sheep [
    move
    death
    reproduce-sheep
  ]
  ask wolves [
    move
    set energy energy - 1  ;; wolves lose energy as they move
    catch-sheep
    death
    reproduce-wolves
  ]
end

to move  ;; turtle procedure
  rt random 50
  lt random 50
  fd 1
end

to reproduce-sheep  ;; sheep procedure
  if random-float 100 < sheep-reproduce [  ;; throw "dice" to see if you will reproduce
    set energy (energy / 2)                ;; divide energy between parent and offspring
    hatch 1 [ rt random-float 360 fd 1 ]   ;; hatch an offspring and move it forward 1 step
  ]
end

to reproduce-wolves  ;; wolf procedure
  if random-float 100 < wolf-reproduce [  ;; throw "dice" to see if you will reproduce
    set energy (energy / 2)               ;; divide energy between parent and offspring
    hatch 1 [ rt random-float 360 fd 1 ]  ;; hatch an offspring and move it forward 1 step
  ]
end

to catch-sheep  ;; wolf procedure
  let prey one-of sheep-here                    ;; grab a random sheep
  if prey != nobody                             ;; did we get one?  if so,
    [ ask prey [ die ]                          ;; kill it
      set energy energy + wolf-gain-from-food ] ;; get energy from eating
end

to death  ;; turtle procedure
  ;; when energy dips below zero, die
  if energy < 0 [ die ]
end

to display-labels
  ask turtles [ set label "" ]
  if show-energy? [
    ask wolves [ set label round energy ]
  ]
end

to setup-aggregate
  set-current-plot "populations"
  clear-plot
  ;; call procedure generated by aggregate modeler
  system-dynamics-setup
  system-dynamics-do-plot
end

to step-aggregate
  ;; each agent tick is DT=1
  repeat ( 1 / dt ) [ system-dynamics-go ]
end

to compare
  if dt = 0 [
    user-message "Please click SETUP COMPARISON first."
    stop
  ]
  go
  step-aggregate
  set-current-plot "populations"
  system-dynamics-do-plot
  update-plots
  display-labels
end


; Copyright 2005 Uri Wilensky.
; See Info tab for full copyright and license.
@#$#@#$#@
GRAPHICS-WINDOW
350
10
727
388
-1
-1
9.0
1
14
1
1
1
0
1
1
1
-20
20
-20
20
1
1
1
ticks
30.0

SLIDER
3
100
177
133
initial-number-sheep
initial-number-sheep
0.0
250.0
148.0
1.0
1
NIL
HORIZONTAL

SLIDER
3
135
177
168
sheep-max-initial-energy
sheep-max-initial-energy
0.0
50.0
4.0
1.0
1
NIL
HORIZONTAL

SLIDER
3
172
177
205
sheep-reproduce
sheep-reproduce
1.0
20.0
4.0
1.0
1
%
HORIZONTAL

SLIDER
181
100
346
133
initial-number-wolves
initial-number-wolves
0.0
250.0
30.0
1.0
1
NIL
HORIZONTAL

SLIDER
181
136
346
169
wolf-gain-from-food
wolf-gain-from-food
0.0
100.0
13.0
1.0
1
NIL
HORIZONTAL

SLIDER
181
172
346
205
wolf-reproduce
wolf-reproduce
0.0
20.0
5.0
1.0
1
%
HORIZONTAL

BUTTON
10
38
79
71
setup
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
92
38
159
71
go
go\ntick\ndisplay-labels
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
8
269
317
466
agent-populations
time
pop.
0.0
100.0
0.0
100.0
true
true
"" ""
PENS
"sheep" 1.0 0 -13345367 true "" "plot count sheep"
"wolves" 1.0 0 -2674135 true "" "plot count wolves"

MONITOR
67
220
149
265
sheep
count sheep
3
1
11

MONITOR
151
220
233
265
wolves
count wolves
3
1
11

TEXTBOX
8
80
148
99
Sheep settings
11
0.0
0

TEXTBOX
186
80
299
98
Wolf settings
11
0.0
0

SWITCH
169
38
305
71
show-energy?
show-energy?
1
1
-1000

PLOT
759
271
1068
469
populations
time
pop.
0.0
100.0
0.0
100.0
true
true
"" ""
PENS
"wolfStock" 1.0 0 -2674135 true "" ""
"sheepStock" 1.0 0 -13345367 true "" ""

BUTTON
759
77
920
110
step
system-dynamics-go\nsystem-dynamics-do-plot
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

MONITOR
762
217
856
262
NIL
sheepStock
3
1
11

MONITOR
876
218
957
263
NIL
wolfStock
3
1
11

BUTTON
511
484
645
517
Step Compare
compare
NIL
1
T
OBSERVER
NIL
N
NIL
NIL
1

BUTTON
758
33
901
66
setup
setup-aggregate
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
917
123
1067
156
predationRate
predationRate
0.0
0.1
3.0E-4
1.0E-4
1
NIL
HORIZONTAL

SLIDER
757
123
909
156
predatorEfficiency
predatorEfficiency
0.0
10.0
1.0
0.1
1
NIL
HORIZONTAL

SLIDER
763
171
949
204
wolves-death-rate
wolves-death-rate
0.0
1.0
0.15
0.01
1
NIL
HORIZONTAL

BUTTON
915
33
1050
66
go
system-dynamics-go\nset-current-plot \"populations\"\nsystem-dynamics-do-plot
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

MONITOR
902
496
1043
541
NIL
sheep-deaths
3
1
11

MONITOR
753
497
894
542
NIL
sheep-births
3
1
11

MONITOR
754
553
884
598
NIL
wolves-births
3
1
11

MONITOR
892
553
1035
598
wolves-deaths
wolves-deaths
3
1
11

BUTTON
402
483
495
516
Compare
compare
T
1
T
OBSERVER
NIL
C
NIL
NIL
1

BUTTON
458
441
610
474
Setup Comparison
setup\nsetup-aggregate
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

TEXTBOX
104
10
254
28
Agent Model
11
0.0
0

TEXTBOX
868
10
1018
28
Aggregate Model
11
0.0
0

TEXTBOX
434
417
658
435
Compare Agent/Aggregate Models\n
11
0.0
0

@#$#@#$#@
## WHAT IS IT?

This model explores the relationship between two different models of predator-prey ecosystems: an agent-based model and a aggregate model.  Each of the models can be run separately, or docked side-by-side for comparison.

In the agent model, wolves and sheep wander randomly around the landscape, while the wolves look for sheep to prey on. Each step costs the wolves energy, and they must eat sheep in order to replenish their energy - when they run out of energy they die. To allow the population to continue, each wolf or sheep has a fixed probability of reproducing at each time step.

The aggregate model is a System Dynamics model of the relationship between populations our wolves and sheep.  It is based on a version of the famous Lotka-Volterra model of interactions between two species in an ecosystem.

## HOW TO USE IT

1. Adjust the slider parameters (see below), or use the default settings.
3. Press the SETUP-COMPARISON button.
4. Press the COMPARE button to begin the simulation.
5. View the POPULATIONS and AGENT-POPULATIONS plots to watch the populations fluctuate over time

Parameters shared between agent and aggregate models:
- INITIAL-NUMBER-SHEEP: The initial size of sheep population
- INITIAL-NUMBER-WOLVES: The initial size of wolf population
- SHEEP-REPRODUCE: The probability of a sheep reproducing at each time step

Parameters for agent model:
- SHEEP-MAX-INITIAL-ENERGY: At setup time, sheep are given an energy between 1 and this value
- WOLF-GAIN-FROM-FOOD: The amount of energy wolves get for every sheep eaten
- WOLF-REPRODUCE: The probability of a wolf reproducing at each time step

Parameters for aggregate model:
- WOLVES-DEATH-RATE: The rate at which wolves die.
- PREDATION-RATE: The rate at which wolves eat sheep.
- PREDATOR-EFFICIENCY: The efficiency of the wolves in extracting energy to reproduce from the prey they eat.

## THINGS TO NOTICE

Why do you suppose that some variations of the model might be stable while others are not?

## THINGS TO TRY

Try adjusting the parameters under various settings. How sensitive is the stability of the model to the particular parameters?

Notice that under stable settings, the populations tend to fluctuate at a predictable pace. Can you find any parameters that will speed this up or slow it down?

## EXTENDING THE MODEL

There are a number ways to alter the model so that it will be stable with only wolves and sheep (no grass). Some will require new elements to be coded in or existing behaviors to be changed. Can you develop such a version?

## NETLOGO FEATURES

Note the use of the System Dynamics Modeler to create the aggregate model.

## RELATED MODELS

Look at the Wolf Sheep Predation model for an example of an agent model which can produce a stable model of predator-prey ecosystems.

## CREDITS AND REFERENCES

- Lotka, A.J. (1956) Elements of Mathematical Biology.  New York: Dover.
- Wilensky, U. & Reisman, K. (1999). Connected Science: Learning Biology through Constructing and Testing Computational Theories -- an Embodied Modeling Approach. International Journal of Complex Systems, M. 234, pp. 1 - 12. (This model is a slightly extended version of the model described in the paper.)
- Wilensky, U. & Reisman, K. (in press). Thinking like a Wolf, a Sheep or a Firefly: Learning Biology through Constructing and Testing Computational Theories -- an Embodied Modeling Approach. Cognition & Instruction.

## HOW TO CITE

If you mention this model or the NetLogo software in a publication, we ask that you include the citations below.

For the model itself:

* Wilensky, U. (2005).  NetLogo Wolf Sheep Predation (Docked Hybrid) model.  http://ccl.northwestern.edu/netlogo/models/WolfSheepPredation(DockedHybrid).  Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

Please cite the NetLogo software as:

* Wilensky, U. (1999). NetLogo. http://ccl.northwestern.edu/netlogo/. Center for Connected Learning and Computer-Based Modeling, Northwestern University, Evanston, IL.

## COPYRIGHT AND LICENSE

Copyright 2005 Uri Wilensky.

![CC BY-NC-SA 3.0](http://ccl.northwestern.edu/images/creativecommons/byncsa.png)

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 3.0 License.  To view a copy of this license, visit https://creativecommons.org/licenses/by-nc-sa/3.0/ or send a letter to Creative Commons, 559 Nathan Abbott Way, Stanford, California 94305, USA.

Commercial licenses are also available. To inquire about commercial licenses, please contact Uri Wilensky at uri@northwestern.edu.

<!-- 2005 -->
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
NetLogo 6.0.3-RC1
@#$#@#$#@
setup
setup-aggregate
repeat 75 [ go step-aggregate ]
@#$#@#$#@
0.001
    org.nlogo.sdm.gui.AggregateDrawing 25
        org.nlogo.sdm.gui.StockFigure "attributes" "attributes" 1 "FillColor" "Color" 225 225 175 270 100 60 40
            org.nlogo.sdm.gui.WrappedStock "sheepStock" "initial-number-sheep ;; taken from agent model's slider" 1
        org.nlogo.sdm.gui.StockFigure "attributes" "attributes" 1 "FillColor" "Color" 225 225 175 352 246 60 40
            org.nlogo.sdm.gui.WrappedStock "wolfStock" "initial-number-wolves ;; taken from agent model's slider" 0
        org.nlogo.sdm.gui.ReservoirFigure "attributes" "attributes" 1 "FillColor" "Color" 192 192 192 15 105 30 30
        org.nlogo.sdm.gui.RateConnection 3 45 120 151 120 258 120 NULL NULL 0 0 0
            org.jhotdraw.figures.ChopEllipseConnector REF 5
            org.jhotdraw.standard.ChopBoxConnector REF 1
            org.nlogo.sdm.gui.WrappedRate "sheepStock * sheep-birth-rate" "sheep-births"
                org.nlogo.sdm.gui.WrappedReservoir  REF 2 0
        org.nlogo.sdm.gui.RateConnection 3 342 120 443 120 544 120 NULL NULL 0 0 0
            org.jhotdraw.standard.ChopBoxConnector REF 1
            org.jhotdraw.figures.ChopEllipseConnector
                org.nlogo.sdm.gui.ReservoirFigure "attributes" "attributes" 1 "FillColor" "Color" 192 192 192 543 105 30 30
            org.nlogo.sdm.gui.WrappedRate "sheepStock * ( predation-rate * wolfStock )" "sheep-deaths" REF 2
                org.nlogo.sdm.gui.WrappedReservoir  0   REF 14
        org.nlogo.sdm.gui.ReservoirFigure "attributes" "attributes" 1 "FillColor" "Color" 192 192 192 47 251 30 30
        org.nlogo.sdm.gui.RateConnection 3 77 266 208 266 340 266 NULL NULL 0 0 0
            org.jhotdraw.figures.ChopEllipseConnector REF 17
            org.jhotdraw.standard.ChopBoxConnector REF 3
            org.nlogo.sdm.gui.WrappedRate "wolfStock * ( predation-rate * predator-efficiency ) * sheepStock" "wolves-births"
                org.nlogo.sdm.gui.WrappedReservoir  REF 4 0
        org.nlogo.sdm.gui.RateConnection 3 424 265 489 264 554 264 NULL NULL 0 0 0
            org.jhotdraw.standard.ChopBoxConnector REF 3
            org.jhotdraw.figures.ChopEllipseConnector
                org.nlogo.sdm.gui.ReservoirFigure "attributes" "attributes" 1 "FillColor" "Color" 192 192 192 553 249 30 30
            org.nlogo.sdm.gui.WrappedRate "wolfStock * predator-death-rate" "wolves-deaths" REF 4
                org.nlogo.sdm.gui.WrappedReservoir  0   REF 26
        org.nlogo.sdm.gui.ConverterFigure "attributes" "attributes" 1 "FillColor" "Color" 120 188 182 287 176 50 50
            org.nlogo.sdm.gui.WrappedConverter "predationRate" "predation-rate"
        org.nlogo.sdm.gui.ConverterFigure "attributes" "attributes" 1 "FillColor" "Color" 120 188 182 83 175 50 50
            org.nlogo.sdm.gui.WrappedConverter "predatorEfficiency" "predator-efficiency"
        org.nlogo.sdm.gui.ConverterFigure "attributes" "attributes" 1 "FillColor" "Color" 120 188 182 427 178 50 50
            org.nlogo.sdm.gui.WrappedConverter "wolves-death-rate" "predator-death-rate"
        org.nlogo.sdm.gui.ConverterFigure "attributes" "attributes" 1 "FillColor" "Color" 120 188 182 198 21 50 50
            org.nlogo.sdm.gui.WrappedConverter ";; convert from agent's percentage\n;; representation to decimal\nsheep-reproduce / 100" "sheep-birth-rate"
        org.nlogo.sdm.gui.BindingConnection 2 210 58 151 120 NULL NULL 0 0 0
            org.jhotdraw.contrib.ChopDiamondConnector REF 35
            org.nlogo.sdm.gui.ChopRateConnector REF 6
        org.nlogo.sdm.gui.BindingConnection 2 258 120 151 120 NULL NULL 0 0 0
            org.jhotdraw.standard.ChopBoxConnector REF 1
            org.nlogo.sdm.gui.ChopRateConnector REF 6
        org.nlogo.sdm.gui.BindingConnection 2 123 209 208 266 NULL NULL 0 0 0
            org.jhotdraw.contrib.ChopDiamondConnector REF 31
            org.nlogo.sdm.gui.ChopRateConnector REF 18
        org.nlogo.sdm.gui.BindingConnection 2 327 191 443 120 NULL NULL 0 0 0
            org.jhotdraw.contrib.ChopDiamondConnector REF 29
            org.nlogo.sdm.gui.ChopRateConnector REF 11
        org.nlogo.sdm.gui.BindingConnection 2 342 120 443 120 NULL NULL 0 0 0
            org.jhotdraw.standard.ChopBoxConnector REF 1
            org.nlogo.sdm.gui.ChopRateConnector REF 11
        org.nlogo.sdm.gui.BindingConnection 2 395 234 443 120 NULL NULL 0 0 0
            org.jhotdraw.standard.ChopBoxConnector REF 3
            org.nlogo.sdm.gui.ChopRateConnector REF 11
        org.nlogo.sdm.gui.BindingConnection 2 461 218 489 264 NULL NULL 0 0 0
            org.jhotdraw.contrib.ChopDiamondConnector REF 33
            org.nlogo.sdm.gui.ChopRateConnector REF 23
        org.nlogo.sdm.gui.BindingConnection 2 340 266 208 266 NULL NULL 0 0 0
            org.jhotdraw.standard.ChopBoxConnector REF 3
            org.nlogo.sdm.gui.ChopRateConnector REF 18
        org.nlogo.sdm.gui.BindingConnection 2 296 210 208 266 NULL NULL 0 0 0
            org.jhotdraw.contrib.ChopDiamondConnector REF 29
            org.nlogo.sdm.gui.ChopRateConnector REF 18
        org.nlogo.sdm.gui.BindingConnection 2 424 265 489 264 NULL NULL 0 0 0
            org.jhotdraw.standard.ChopBoxConnector REF 3
            org.nlogo.sdm.gui.ChopRateConnector REF 23
        org.nlogo.sdm.gui.BindingConnection 2 279 152 208 266 NULL NULL 0 0 0
            org.jhotdraw.standard.ChopBoxConnector REF 1
            org.nlogo.sdm.gui.ChopRateConnector REF 18
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
