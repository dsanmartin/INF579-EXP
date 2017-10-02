__includes ["bdi.nls" "communication.nls"]

;;; A model that has explicit communication between agents

breed [arms arm]

arms-own [hold intentions beliefs incoming-queue]

;;; Set the system

to setup
  ca

  setup-arm

  reset-ticks
end

to setup-arm
  create-arms 1
  [
    set hold ""
  ]
end

to run-simulation
  ;ask arms ;;[execute-intentions]
  show On A B
  tick
end


;; Predicates
to-report On [x y]
  ifelse x = y
  [ report True ]
  [ report False ]
end

to-report OnTable [x]
  ifelse x = "table"
  [ report True ]
  [ report False ]
end

to-report Clear [x]
  let r True
  if x = "A" [ if B = "A" or C = "A" [ set r False ] ]
  if x = "B" [ if A = "B" or C = "B" [ set r False ] ]
  if x = "C" [ if A = "C" or B = "C" [ set r False ] ]
  report r
end

to-report Holding [x]
  ifelse hold = x
  [ report True ]
  [ report False ]
end

to-report ArmEmpty
  ifelse hold = ""
  [ report True ]
  [ report False ]
end

;; Actions
to Stack [x y]
  if Clear y and Holding x
  [

  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
510
17
890
418
16
16
11.212121212121213
1
9
1
1
1
0
0
0
1
-16
16
-16
16
1
1
1
ticks
30.0

BUTTON
6
25
79
58
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
85
25
148
58
Run
run-simulation
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
5
63
191
96
Run (cont)
run-simulation
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
7
445
256
572
Beer
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Nr. beers Owner" 1.0 0 -2674135 true "" "plot [beer] of one-of owners"
"Nr. beers Robot" 1.0 0 -14730904 true "" "plot [beer] of one-of robots"
"Money Robot" 1.0 0 -14439633 true "" "plot [money] of one-of robots"

OUTPUT
903
10
1404
623
9

BUTTON
835
589
901
622
Borrar
clear-output
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
777
553
901
586
Línea separación
output-print \"\"\noutput-print \"======================================================================================\"\noutput-print \"\"
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

CHOOSER
194
396
332
441
who_shows
who_shows
"robots" "owners" "both"
2

SWITCH
12
396
184
429
show_beliefs
show_beliefs
0
1
-1000

TEXTBOX
11
117
230
147
Initial Configuration (blocks on)
12
0.0
1

CHOOSER
10
142
148
187
A
A
"table" "B" "C"
0

CHOOSER
156
142
294
187
B
B
"table" "A" "C"
1

CHOOSER
298
142
436
187
C
C
"table" "A" "B"
0

SWITCH
14
348
188
381
show_messages
show_messages
1
1
-1000

SWITCH
194
350
365
383
show-intentions
show-intentions
1
1
-1000

TEXTBOX
11
211
226
241
Final Configuration (blocks on)
12
0.0
1

CHOOSER
9
238
147
283
A-final
A-final
"table" "B" "C"
0

CHOOSER
154
239
292
284
B-final
B-final
"table" "A" "C"
0

CHOOSER
300
239
438
284
C-final
C-final
"table" "A" "B"
0

@#$#@#$#@
## WHAT IS IT?

This is the famous "Robot Beer" example from wooldridge. A robot is instructed to get some beer from the supermarket.

## HOW IT WORKS

The owner requests beer from the robot, which in turn travels to the fridge and gets one. If the fridge is empty, then it rushes to the supermarket to get some. That is in the case it does have some money to afford it; if the latter is not the case, then it rushes to the bank first.

## HOW TO USE IT

Set the amount of money the user has press setup and then run the experiment.

## NETLOGO FEATURES

Model Uses bdi.nls for intention handling and communication.nls for passing FIPA like messages.

## CREDITS AND REFERENCES

Check the following web address for updates on the libraries mentioned above.
http://users.uom.gr/~iliass
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

bank
false
0
Polygon -7500403 true true 150 60 75 105 225 105 150 60
Rectangle -7500403 true true 75 110 226 115
Rectangle -7500403 true true 90 120 109 211
Rectangle -7500403 true true 75 215 226 220
Rectangle -7500403 true true 70 225 231 230
Rectangle -7500403 true true 124 120 143 211
Rectangle -7500403 true true 158 120 177 211
Rectangle -7500403 true true 192 120 211 211

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

building store
false
0
Rectangle -7500403 true true 30 45 45 240
Rectangle -16777216 false false 30 45 45 165
Rectangle -7500403 true true 15 165 285 255
Rectangle -16777216 true false 120 195 180 255
Line -7500403 true 150 195 150 255
Rectangle -16777216 true false 30 180 105 240
Rectangle -16777216 true false 195 180 270 240
Line -16777216 false 0 165 300 165
Polygon -7500403 true true 0 165 45 135 60 90 240 90 255 135 300 165
Rectangle -7500403 true true 0 0 75 45
Rectangle -16777216 false false 0 0 75 45

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

person business
false
0
Rectangle -1 true false 120 90 180 180
Polygon -13345367 true false 135 90 150 105 135 180 150 195 165 180 150 105 165 90
Polygon -7500403 true true 120 90 105 90 60 195 90 210 116 154 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 183 153 210 210 240 195 195 90 180 90 150 165
Circle -7500403 true true 110 5 80
Rectangle -7500403 true true 127 76 172 91
Line -16777216 false 172 90 161 94
Line -16777216 false 128 90 139 94
Polygon -13345367 true false 195 225 195 300 270 270 270 195
Rectangle -13791810 true false 180 225 195 300
Polygon -14835848 true false 180 226 195 226 270 196 255 196
Polygon -13345367 true false 209 202 209 216 244 202 243 188
Line -16777216 false 180 90 150 165
Line -16777216 false 120 90 150 165

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

refrigerator
false
0
Rectangle -7500403 true true 75 30 225 270
Rectangle -7500403 true true 184 34 200 40
Rectangle -7500403 true true 184 47 200 53
Rectangle -7500403 true true 184 63 200 69
Rectangle -7500403 true true 84 232 219 236
Rectangle -16777216 false false 90 45 210 165
Rectangle -16777216 false false 90 165 210 255
Rectangle -16777216 true false 105 90 108 208
Rectangle -10899396 true false 167 55 201 62
Rectangle -16777216 true false 90 255 210 270

robot
true
0
Line -1184463 false 150 100 111 44
Line -1184463 false 150 100 187 40
Circle -7500403 true true 118 187 64
Circle -7500403 true true 120 67 60
Circle -1184463 true false 103 33 14
Circle -1184463 true false 181 30 14
Rectangle -7500403 true true 107 124 194 223
Rectangle -1184463 true false 118 133 188 144
Polygon -7500403 true true 110 126 65 167 71 176 116 134
Polygon -7500403 true true 231 174 186 133 192 124 237 166
Circle -10899396 true false 51 161 26
Circle -10899396 true false 222 162 26
Polygon -7500403 true true 122 232 97 280 108 286 132 238
Rectangle -1184463 true false 117 156 187 167
Rectangle -1184463 true false 117 176 187 187
Polygon -7500403 true true 188 290 163 242 174 236 198 284

sheep
false
0
Rectangle -7500403 true true 151 225 180 285
Rectangle -7500403 true true 47 225 75 285
Rectangle -7500403 true true 15 75 210 225
Circle -7500403 true true 135 75 150
Circle -16777216 true false 165 76 116

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
Polygon -7500403 true true 135 285 195 285 270 90 30 90 105 285
Polygon -7500403 true true 270 90 225 15 180 90
Polygon -7500403 true true 30 90 75 15 120 90
Circle -1 true false 183 138 24
Circle -1 true false 93 138 24

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.3.1
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
