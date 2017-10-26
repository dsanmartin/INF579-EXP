__includes ["bdi.nls"]

globals [errors]

;; Elements of blocks world
breed [arms arm]
breed [blocks block]

arms-own [hold beliefs desires intentions]
blocks-own [top bottom]

;;; Set the world
to setup
  ca
  ask patches [ set pcolor white ]
  set errors false
  setup-arm

  reset-ticks
end

;; Robot arm setup
to setup-arm
  create-arms 1
  [
    set color white
    set hold nobody
    set beliefs []
    set intentions []
    set desires []

    ; B_0
    setup-B0

    ;; I_0
    setup-I0

    ; Show B_0
    show "Initial Beliefs"
    show beliefs

    ; Show I_0
    show "Initial Intention"
    show intentions
    ;execute-intentions
  ]
end

to setup-blocks
  set-default-shape blocks "square"
  create-blocks 1
  [
    set color red
    set top nobody
    set bottom "table"
    setxy 0 0
  ]

  create-blocks 1
  [
    set color blue
    set top nobody
    set bottom "table"
    setxy 1 0
  ]

  create-blocks 1
  [
    set color green
    set top nobody
    set bottom "table"
    setxy 2 0
  ]

end

to setup-B0
  add-belief create-belief "ArmEmpty" ""
  ;add-belief create-belief "OnTable" "A"
  add-belief create-belief "OnTable" "B"
  add-belief create-belief "OnTable" "C"
  add-belief create-belief "Clear" "A"
  ;add-belief create-belief "Clear" "B"
  add-belief create-belief "Clear" "C"

  add-belief create-belief "On" list "A" "B"

end

to setup-I0
  ;add-intention "get-final-world" "false"
  ;add-intention "OnTable" "B"
  ;add-intention "OnTable" "C"
  ;add-intention "On" list "A" "C"
  ;add-intention "Clear" "A"
  ;add-intention "Clear" "B"

  add-intention "OnTable" "A"
  add-intention "On" list "B" "A"
  add-intention "On" list "C" "B"
  add-intention "Clear" "B"
end


;; Simulation run
to run-simulation
  if errors [ stop ]
  ;;mouse-manager
  ;;ask blocks [
  ;;  if who = 1 [show "A" show top show bottom]
  ;;]
  ;blocks-status ;; In this case this function 'see' all the world
  ;brf ;; Here the function shows the current beliefs
  ;ask arms [ set desires options beliefs intentions ];; Here the function search for the possible desires
  ;;asdf

  ; Show B_0
  agent-control-loop

  ;ask arms [ show exists-belief ["Clear" "A"] ]
  ;tick
end

to agent-control-loop
  ask arms
  [
    ; get next percept rho
    ; brf B rho
    ; options B I
    ; filter B D I
    ; let pi plan B I
    ; execute pi
  ]

  ;Pickup "B"
  ;Stack "B" "A"
  ;Pickup "C"
  ;Stack "C" "B"
  ;ClearBlock "B"
  ;ask arms [ show beliefs ]
  ;MoveBlockOnClear "B" "C"
  ;ask arms [ show beliefs ]
  TopLevelPlan
end

;;;;; Agent Control Loop Functions ;;;;;

;; Beliefs-revision-function
to brf ;;[ bel rho ]

end

;; Options function
to-report options [Bel I]
  let D (list)
  if intention-done "get-final-world" = false
  [
    ;; Add posible desires
  ;;  set D lput (list "holding" A) D
  ]

  report D
end

;; Filter function
to-report filterr [B D I]
  report I
end

;; Plan function
to-report plan [B I]
  let pii 0
  report pii
end

;; Execute function
to execute [pii]
  ;; Execute plan pi
end

;; End Agent Control Loop Functions ;;

;; Intention to get final world - to implement
to-report get-final-world
  let c 0
  ask arms
  [
    foreach intentions
    [
      if exists-belief ? [ set c c + 1]
    ]
  ]
  ifelse c = length intentions
  [ report true ]
  [ report false ]
end

;;;;; Predicates ;;;;;

to-report On [x y]
  let o false
  ask x [ if bottom = y [ set o true] ]
  report o
end

to-report OnTable [x]
  let ot false
  ask x [ if bottom = "table" [ set ot true ] ]
  report ot
end

to-report Clear [x]
  let cl false
  ask x [ if top = nobody [ set cl True ] ]
  report cl
end

to-report Holding [x]
  ifelse hold = x
  [ report True ]
  [ report False ]
end

to-report ArmEmpty
  ifelse hold = nobody
  [ report True ]
  [ report False ]
end

;;;;; End predicates ;;;;


;;;;; Actions ;;;;;

to Stack [x y]
  ask arms
  [
    ;; Precondition
    if (exists-belief list "Clear" y) and (exists-belief list "Holding" x)
    [
      ;; Delete
      remove-belief list "Clear" y
      remove-belief list "Holding" x

      ;; Add
      add-belief create-belief "ArmEmpty" ""
      add-belief create-belief "On" list x y

    ]
    ;show-beliefs
  ]
end

to UnStack [x y]
  ask arms
  [
    ;; Precondition
    if (exists-belief list "On" list x y) and (exists-belief list "Clear" x) and (exists-belief list "ArmEmpty" "")
    [
      ;; Delete
      remove-belief list "On" list x y
      remove-belief list "ArmEmpty" ""

      ;; Add
      add-belief create-belief "Holding" x
      add-belief create-belief "Clear" y

    ]
    ;show-beliefs
  ]
end

to Pickup [x]
  ask arms
  [
    ;; Precondition
    if (exists-belief list "Clear" x) and (exists-belief list "OnTable" x) and (exists-belief list "ArmEmpty" "")
    [
      ;; Delete
      remove-belief list "OnTable" x
      remove-belief list "ArmEmpty" ""

      ;; Add
      add-belief create-belief "Holding" x

      ;execute-
    ]
    ;show-beliefs
  ]
end

to PutDown [x]
  ask arms
  [
    ;; Precondition
    if (exists-belief list "Holding" x)
    [
      ;; Delete
      remove-belief list "Holding" x

      ;; Add
      add-belief create-belief "ArmEmpty" ""
      add-belief create-belief "OnTable" x

    ]
    ;show-beliefs
  ]
end


;;;;; Plans ;;;;;

to TopLevelPlan

  ask arms
  [
    foreach beliefs
    [
      ;show word "INT:" ?
      if get-final-world [ show "OK" stop]

      let bel ?

      foreach intentions [
        show word "INT: " intentions
        ifelse ? = bel [
          remove-intention ?
        ]
        [
          let a item 0 ?
          let b item 1 ?
          if a = "Clear" [ show word "Cleaning " b ClearBlock b]
          if a = "OnTable" [ show word "Moving on table " b MoveBlockOnTable b ]
          if a = "On" [ show word "Moving block " b MoveBlockOnClear item 0 b item 1 b ]
          show word "BEL: " beliefs
        ]

      ]

    ]
  ]
end

to TopLevelPlan2

  ask arms
  [
    foreach intentions
    [
      show word "INT:" ?
      if get-final-world [ show "OK" stop]


      let a item 0 ?
      let b item 1 ?
      if a = "Clear" [ show word "Cleaning " b ClearBlock b]
      if a = "OnTable" [ show word "Moving on table " b MoveBlockOnTable b ]
      if a = "On" [ show word "Moving block " b MoveBlockOnClear item 0 b item 1 b ]
      show beliefs
    ]
  ]
end

to-report ClearBlock [x]
  let ok true
  let y nobody
  ask arms
  [
    ; Check if block x has a block on
    foreach beliefs
    [
      if (belief-type ? = "On") and ( (item 1 belief-content ?) = x)
      [
        set y item 0 belief-content ?
      ]
    ]
  ]

  ; If x has a block upside, then put down
  ifelse y != nobody
  [
    UnStack y x
    Putdown y
  ]
  [
    let ok false
  ]
  report ok
end

to MoveBlockOnClear [x y]
  let ok true
  let a ClearBlock x
  let b ClearBlock y

  ifelse a and b
  [
    Pickup x
    Stack x y
  ]
  [
    let ok false
  ]
  report ok
end

to MoveBlockOnTable [x]
  let ok true
  let y nobody
  ask arms
  [
    ; Check if block x has a block below
    foreach beliefs
    [
      if (belief-type ? = "On") and ( (item 0 belief-content ?) = x)
      [
        set y item 1 belief-content ?
      ]
    ]
  ]

  ; If x has a block upside, then put down
  ifelse y != nobody
  [
    UnStack x y
    Putdown x
  ]
  [
    let ok false
  ]
  report ok
end


;;;;; Plans ;;;

;;;;; End Actions ;;;;;

;; Control drag movement of block
;; Based on Uri Wilensky's Mouse Drag One Example
;; http://modelingcommons.org/browse/one_model/2330
to mouse-manager
  if mouse-down? [
    let candidate min-one-of turtles [distancexy mouse-xcor mouse-ycor]
    if [distancexy mouse-xcor mouse-ycor] of candidate < 1 [
      ;; The WATCH primitive puts a "halo" around the watched turtle.
      watch candidate
      while [mouse-down?] [
        ;; If we don't force the view to update, the user won't
        ;; be able to see the turtle moving around.
        display
        ;; The SUBJECT primitive reports the turtle being watched.
        ask subject [ setxy round mouse-xcor round mouse-ycor ]
      ]
      ;; Undoes the effects of WATCH.  Can be abbreviated RP.
      reset-perspective
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
315
10
625
341
-1
-1
100.0
1
9
1
1
1
0
0
0
1
0
2
0
2
1
1
1
ticks
30.0

BUTTON
70
29
143
62
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
149
29
212
62
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

OUTPUT
708
10
1404
623
9

BUTTON
559
394
631
427
Clean
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

CHOOSER
60
310
229
355
who_shows
who_shows
"robots" "owners" "both"
2

SWITCH
62
229
229
262
show_beliefs
show_beliefs
0
1
-1000

TEXTBOX
23
84
103
116
Initial world
12
0.0
1

SWITCH
62
189
229
222
show_messages
show_messages
1
1
-1000

SWITCH
61
270
230
303
show-intentions
show-intentions
0
1
-1000

TEXTBOX
187
86
307
116
Final world
12
0.0
1

BUTTON
9
109
118
142
Save
initial-world
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
175
108
287
141
Save
final-world
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

TEXTBOX
126
168
156
186
Log
12
0.0
1

@#$#@#$#@
## WHAT IS IT?

The "Blocks world" example from wooldridge. A robot arm has to move three blocks.

## HOW IT WORKS

The robot arm has to move the blocks from an initial configuration of blocks to a final or objective configuration.

## HOW TO USE IT

Click setup and run. Then move a block to check the world status.

## NETLOGO FEATURES

Model Uses bdi.nls for beliefs and intention handling.

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
