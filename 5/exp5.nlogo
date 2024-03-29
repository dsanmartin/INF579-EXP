
breed [sellers seller]
breed [buyers buyer]

globals [round_ turn sample deals all_prices plot_buyer_price plot_seller_price]
sellers-own [goal incoming price prices min_price max_price min_max store-location]
buyers-own [goal incoming price prices min_price max_price min_max ]

to setup
  ca
   setup-buyer-A
   setup-buyer-B
   setup-buyer-C
   setup-seller-X
   setup-seller-Y
   setup-seller-Z
   set sample []
   set all_prices []
   reset-ticks
end

to setup-buyer-A
  create-buyers 1 [
    set label "A"
    set goal "buy"
    set prices []
    set min_price A_min_price
    set max_price A_max_price
    set incoming []
    set min_max []
    set shape "person"
    set color 86
    set size 3
    setxy  0 0
  ]
end
to setup-buyer-B
  create-buyers 1 [
    set label "B"
    set goal "buy"
    set prices []
    set min_price B_min_price
    set max_price B_max_price
    set incoming []
    set min_max []
    set shape "person"
    set color 76
    set size 3
    setxy  0 0
  ]
end
to setup-buyer-C
  create-buyers 1 [
    set label "C"
    set goal "buy"
    set prices []
    set min_price C_min_price
    set max_price C_max_price
    set incoming []
    set min_max []
    set shape "person"
    set color 66
    set size 3
    setxy  0 0
  ]
end

to setup-seller-X
  create-sellers 1 [
    set label "X"
    set goal "sell"
    set prices []
    set min_price X_min_price
    set max_price X_max_price
    set incoming []
    set min_max []
    set shape "person"
    set color 16
    set size 3
    setxy  0 0
    set store-location []
  ]
end
to setup-seller-Y
  create-sellers 1 [
    set label "Y"
    set goal "sell"
    set prices []
    set min_price Y_min_price
    set max_price Y_max_price
    set incoming []
    set min_max []
    set shape "person"
    set color 26
    set size 3
    setxy  0 0
    set store-location []
  ]
end
to setup-seller-Z
  create-sellers 1 [
    set label "Z"
    set goal "sell"
    set prices []
    set min_price Z_min_price
    set max_price Z_max_price
    set incoming []
    set min_max []
    set shape "person"
    set color 36
    set size 3
    setxy  0 0
    set store-location []
  ]
 seller-position
end

to run-simulation
  if round_ = max_round [ stop ]
  go-until-empty-here
  run-round_
  plot_prices
end

to run-round_
  set round_ round_ + 1
  output-show (list "Round: " round_)
  set turn 1
  to-sample
  while  [turn != 7] [
    run-turn
    tick
  ]
  tick
end

to run-turn
  output-show (list "Turn: " turn)
  if sample = [] [ stop ]
  ask one-of sample [
    set sample remove self sample
    if goal = "buy" [
      let xs one-of sellers
      face xs
      fd 12
      move-to xs
      recover_price(xs)
      ask_to_buy(xs)
      rt 180
      fd 12
      setxy 0 0
      go-until-empty-here
    ]
     if goal = "sell" [
      let xc one-of buyers
      face xc
      fd 12
      move-to xc
      recover_price(xc)
      ask_to_sell(xc)
      rt 180
      fd 12
      let x item 0 (item 0 store-location)
      let y item 1 (item 0 store-location)
      setxy x y
    ]
  ]
  tick
  set turn turn + 1
end

to to-sample
  set sample []
  ask buyers [ set sample lput self sample ]
  ask sellers [ set sample lput self sample ]
end

to ask_to_buy [x]
  let m (list "want to buy at price" price)
  send_message(x)(m)(self)
end

to ask_to_sell [x]
  let m (list "want to sell at price" price)
  send_message(x)(m)(self)
end

to send_message[receiver message sender]
  ask receiver [ set incoming fput (list message sender) incoming ]
  output-show (list receiver message)
  ask receiver [ negotiate ]
end

to recover_price [xx]
  if goal = "buy" [
    set price "NULL"
    foreach prices [
      if (member? xx ?) [ set price item 1 ?]
    ]
    if price = "NULL" [
      set prices fput (list xx min_price) prices
      set price min_price
    ]
  ]
  if goal = "sell" [
    set price "NULL"
    foreach prices [
      if (member? xx ?) [ set price item 1 ?]
    ]
    if price = "NULL" [
      set prices fput (list xx max_price) prices
      set price max_price
    ]
  ]
end

to negotiate
  if incoming = [] [stop]
  let responded 0
  let m item 0 (item 0 incoming)
  let respond_to item 1 (item 0 incoming)
  if m = ["not interested"] [ set incoming []
    stop]
  if m = ["thanks for the info"] [ set incoming []
    stop]
  if item 0 m = "sold at" [  set incoming []
    stop]
  if item 0 m = "bought at" [ set incoming []
    stop ]
  if goal = "buy" and (item 0 m = "want to sell at price") [
    let offered_price item 1 m
    update_all_prices(respond_to)(self)(offered_price)
    recover_price(respond_to)
    if price >= offered_price [
      let r (list "sold at" offered_price)
      send_message(respond_to)(r)(self)
      set deals deals + 1
      set responded 1
      set incoming []
      update_my_price(offered_price)(respond_to)
    ]
    if price < offered_price [
      let r (list "would buy at" price)
      send_message(respond_to)(r)(self)
      set responded 1
    ]
   ]
  if goal = "buy" and (item 0 m = "would sell at") [
    let offered_price item 1 m
    update_all_prices(respond_to)(self)(offered_price)
    let r (list "thanks for the info")
    send_message(respond_to)(r)(self)
    set responded 1
    set incoming []
    update_my_price(offered_price)(respond_to)
   ]
  if goal = "sell" and (item 0 m = "want to buy at price") [
    let offered_price item 1 m
    update_all_prices(respond_to)(self)(offered_price)
    recover_price(respond_to)
    if price <= offered_price [
      let r (list "bought at" offered_price)
      send_message(respond_to)(r)(self)
      set deals deals + 1
      set responded 1
    ]
    if price > offered_price [
      let r (list "would sell at" price)
      send_message(respond_to)(r)(self)
      set responded 1
      set incoming []
      update_my_price(offered_price)(respond_to)
    ]
   ]
  if goal = "sell" and (item 0 m = "would buy at") [
    let offered_price item 1 m
    update_all_prices(respond_to)(self)(offered_price)
    let r (list "thanks for the info")
    send_message(respond_to)(r)(self)
    set responded 1
    set incoming []
    update_my_price(offered_price)(respond_to)
   ]
  if responded = 0 [
    let r (list "not interested")
    send_message(respond_to)(r)(self)
    set incoming []
  ]
end

to update_my_price[offered_price offerer]
  recover_price(offerer)
  recover_min_max(offerer)(self)
  let minj 1
  let maxj 100
  foreach min_max [
      if (member? offerer ?) [
        set minj item 1 ?
        set maxj item 2 ?
      ]
    ]
  if goal = "buy" [
    let utility_i_j (max_price - offered_price) / (max_price - min_price)
    let utility_i_i (max_price - price) / (max_price - min_price)
    let risk_i ((utility_i_i - utility_i_j) / utility_i_i)

    let utility_j_j (offered_price - minj) / (maxj - minj)
    let utility_j_i (price - minj) / (maxj - minj)

    let risk_j ((utility_j_j - utility_j_i) / utility_j_j)

    while [risk_i <= risk_j and risk_i > 0 and price < max_price] [
      set price price + 1
      set utility_i_j (max_price - offered_price) / (max_price - min_price)
      set utility_i_i (max_price - price) / (max_price - min_price)
      set risk_i ((utility_i_i - utility_i_j) / utility_i_i)

      set utility_j_j (offered_price - minj) / (maxj - minj)
      set utility_j_i (price - minj) / (maxj - minj)
      set risk_j ((utility_j_j - utility_j_i) / utility_j_j)
    ]
  ]
  if goal = "sell" [
    let utility_i_j (offered_price - min_price) / (max_price - min_price)
    let utility_i_i (price - min_price) / (max_price - min_price)
    let risk_i ((utility_i_i - utility_i_j) / utility_i_i)

    let utility_j_j (maxj - offered_price) / (maxj - minj)
    let utility_j_i (maxj - price) / (maxj - minj)
    let risk_j ((utility_j_j - utility_j_i) / utility_j_j)

    while [risk_i <= risk_j and risk_i > 0 and (price > min_price + 1)] [
      set price price - 1
      set utility_i_j (offered_price - min_price) / (max_price - min_price)
      set utility_i_i (price - min_price) / (max_price - min_price)
      set risk_i ((utility_i_i - utility_i_j) / utility_i_i)

      set utility_j_j (maxj - offered_price) / (maxj - minj)
      set utility_j_i (maxj - price) / (maxj - minj)
      set risk_j ((utility_j_j - utility_j_i) / utility_j_j)
    ]
  ]
  foreach prices [
      if (member? offerer ?) [ set prices remove ? prices  ]
    ]
    set prices fput (list offerer price) prices
end

to recover_min_max [xx recoverer]
 ask xx [
   save_min_max(recoverer)(min_price)(max_price)(self)
 ]
end

to save_min_max [xx minj maxj xj]
  ask xx [
    foreach min_max [
      if member? xj ? [
        set min_max remove ? min_max
      ]
    ]
    set min_max fput (list xj minj maxj) min_max
  ]
end

to seller-position
  ask sellers with [label = "X"][
    set heading 0
    fd 13
    set store-location fput (list int xcor int ycor) store-location
  ]
  ask sellers with [label = "Y"][
    set heading 120
    fd 15
    set store-location fput (list int xcor int ycor) store-location
  ]
  ask sellers with [label = "Z"][
    set heading 240
    fd 15
    set store-location fput (list int xcor int ycor) store-location
  ]

end

to update_all_prices[offerer offered price_]
  foreach all_prices [
    if item 0 ? = offerer and item 1 ? = offered [ set all_prices remove ? all_prices]
  ]
  set all_prices fput (list offerer offered price_) all_prices
end

to plot_prices
  let buyer_ one-of buyers with [label =  Follow_Buyer]
  let seller_ one-of sellers with [label =  Follow_Seller]
  foreach all_prices [
     if item 0 ? = buyer_ and item 1 ? = seller_ [ set plot_buyer_price item 2 ? ]
     if item 0 ? = seller_ and item 1 ? = buyer_ [ set plot_seller_price item 2 ? ]
  ]
  output-show all_prices
  output-show plot_buyer_price
end

to go-until-empty-here  ;; buyers not overlap
  ask buyers [
    while [any? other buyers-here]
      [ rt 90
        fd 4 ]

   while [any? other sellers-here]
      [ rt 180
        fd 2 ]
  ]
  ask sellers [
    while [any? other buyers-here]
      [ rt 180
        fd 2 ]

   while [any? other sellers-here]
      [ rt 90
        fd 4 ]
  ]
  ;;tick
end
@#$#@#$#@
GRAPHICS-WINDOW
669
109
1022
483
16
16
10.4
1
10
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
0
0
1
ticks
30.0

BUTTON
662
10
735
43
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
744
10
878
43
NIL
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

SLIDER
661
46
833
79
max_round
max_round
1
300
150
1
1
NIL
HORIZONTAL

SLIDER
23
28
195
61
A_min_price
A_min_price
1
100
24
1
1
NIL
HORIZONTAL

SLIDER
22
60
194
93
A_max_price
A_max_price
1
100
81
1
1
NIL
HORIZONTAL

SLIDER
21
100
193
133
B_min_price
B_min_price
1
100
13
1
1
NIL
HORIZONTAL

SLIDER
21
133
193
166
B_max_price
B_max_price
1
100
85
1
1
NIL
HORIZONTAL

SLIDER
20
173
192
206
C_min_price
C_min_price
1
100
31
1
1
NIL
HORIZONTAL

SLIDER
20
203
192
236
C_max_price
C_max_price
1
100
83
1
1
NIL
HORIZONTAL

SLIDER
20
279
192
312
X_min_price
X_min_price
1
100
13
1
1
NIL
HORIZONTAL

SLIDER
20
309
192
342
X_max_price
X_max_price
1
100
75
1
1
NIL
HORIZONTAL

SLIDER
20
347
192
380
Y_min_price
Y_min_price
1
100
27
1
1
NIL
HORIZONTAL

SLIDER
20
378
192
411
Y_max_price
Y_max_price
1
100
97
1
1
NIL
HORIZONTAL

SLIDER
20
422
192
455
Z_min_price
Z_min_price
1
100
23
1
1
NIL
HORIZONTAL

SLIDER
20
453
192
486
Z_max_price
Z_max_price
1
100
78
1
1
NIL
HORIZONTAL

MONITOR
851
47
909
92
NIL
round_
17
1
11

PLOT
1035
286
1271
466
Last Price by Agent
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "ask turtles [\n  create-temporary-plot-pen (word who)\n  set-plot-pen-color color\n  plotxy ticks price\n]"

MONITOR
916
48
973
93
Deals
Deals
17
1
11

OUTPUT
201
10
656
483
12

TEXTBOX
25
12
175
30
Buyers\n
12
0.0
1

TEXTBOX
24
260
174
278
Sellers
12
0.0
1

CHOOSER
1039
10
1177
55
Follow_Buyer
Follow_Buyer
"A" "B" "C"
1

CHOOSER
1041
61
1179
106
Follow_Seller
Follow_Seller
"X" "Y" "Z"
0

PLOT
1035
113
1269
282
Followed Price
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -15040220 true "" "plotxy ticks plot_buyer_price"
"pen-1" 1.0 0 -2674135 true "" "plotxy ticks plot_seller_price"

MONITOR
1180
10
1268
55
Buyer Price
plot_buyer_price
17
1
11

MONITOR
1181
61
1269
106
Seller Price
plot_seller_price
17
1
11

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
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
