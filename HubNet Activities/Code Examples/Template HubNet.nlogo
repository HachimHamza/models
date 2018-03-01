;; create a breed of turtles that the students control through the clients
;; there will be one student turtle for each client.
breed [ students student ]

students-own
[
  user-id   ;; students choose a user name when they log in whenever you receive a
            ;; message from the student associated with this turtle hubnet-message-source
            ;; will contain the user-id
  step-size ;; you should have a turtle variable for every widget in the client interface that
            ;; stores a value (sliders, choosers, and switches). You will receive a message
            ;; from the client whenever the value changes. However, you will not be able to
            ;; retrieve the value at will unless you store it in a variable on the server.
]

;; the STARTUP procedure runs only once at the beginning of the model
;; at this point you must initialize the system.
to startup
  hubnet-reset
end

to setup
  clear-patches
  clear-drawing
  clear-output
  ;; during setup you do not want to kill all the turtles
  ;; (if you do you'll lose any information you have about the clients)
  ;; so reset any variables you want to default values, and let the clients
  ;; know about the change if the value appears anywhere in their interface.
  ask turtles
  [
    set step-size 1
    hubnet-send user-id "step-size" step-size
  ]
  ;; calling reset-ticks enables the 'go' button
  reset-ticks
end

to go
  ;; process incoming messages and respond to them (if needed)
  ;; listening for messages outside of the every block means that messages
  ;; get processed and responded to as fast as possible
  listen-clients
  every 0.1
  [
    ;; tick (and display) causes world updates messages to be sent to clients
    ;; these types of messages should only be sent inside an every block.
    ;; otherwise, the messages will be created as fast as possible
    ;; and consume your bandwidth.
    tick
  ]
end

;;
;; HubNet Procedures
;;

to listen-clients
  ;; as long as there are more messages from the clients
  ;; keep processing them.
  while [ hubnet-message-waiting? ]
  [
    ;; get the first message in the queue
    hubnet-fetch-message
    ifelse hubnet-enter-message? ;; when clients enter we get a special message
    [ create-new-student ]
    [
      ifelse hubnet-exit-message? ;; when clients exit we get a special message
      [ remove-student ]
      [ ask students with [user-id = hubnet-message-source]
        [ execute-command hubnet-message-tag ] ;; otherwise the message means that the user has
      ]                                        ;; done something in the interface hubnet-message-tag
                                               ;; is the name of the widget that was changed
    ]
  ]
end

;; when a new user logs in create a student turtle
;; this turtle will store any state on the client
;; values of sliders, etc.
to create-new-student
  create-students 1
  [
    ;; store the message-source in user-id now
    ;; so when you get messages from this client
    ;; later you will know which turtle it affects
    set user-id hubnet-message-source
    set label user-id
    ;; initialize turtle variables to the default
    ;; value of the corresponding widget in the client interface
    set step-size 1
    ;; update the clients with any information you have set
    send-info-to-clients
  ]
end

;; when a user logs out make sure to clean up the turtle
;; that was associated with that user (so you don't try to
;; send messages to it after it is gone) also if any other
;; turtles of variables reference this turtle make sure to clean
;; up those references too.
to remove-student
  ask students with [user-id = hubnet-message-source]
  [ die ]
end

;; Other messages correspond to users manipulating the
;; client interface, handle these individually.
to execute-command [command]
  ;; you should have one if statement for each widget that
  ;; can affect the outcome of the model, buttons, sliders, switches
  ;; choosers and the view, if the user clicks on the view you will receive
  ;; a message with the tag "View" and the hubnet-message will be a
  ;; two item list of the coordinates
  if command = "step-size"
  [
    ;; note that the hubnet-message will vary depending on
    ;; the type of widget that corresponds to the tag
    ;; for example if the widget is a slider the message
    ;; will be a number, of the widget is switch the message
    ;; will be a boolean value
    set step-size hubnet-message
    stop
  ]
  if command = "up"
  [ execute-move 0 stop ]
  if command = "down"
  [ execute-move 180 stop ]
  if command = "right"
  [ execute-move 90 stop ]
  if command = "left"
  [ execute-move 270 stop ]
end

;; whenever something in world changes that should be displayed in
;; a monitor on the client send the information back to the client
to send-info-to-clients ;; turtle procedure
  hubnet-send user-id "location" (word "(" pxcor "," pycor ")")
end

to execute-move [new-heading]
  set heading new-heading
  fd step-size
  send-info-to-clients
end


; Public Domain:
; To the extent possible under law, Uri Wilensky has waived all
; copyright and related or neighboring rights to this model.
@#$#@#$#@
GRAPHICS-WINDOW
231
10
659
439
-1
-1
20.0
1
10
1
1
1
0
0
0
1
-10
10
-10
10
1
1
0
ticks
30.0

BUTTON
34
51
105
84
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
107
51
178
84
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

@#$#@#$#@
## WHAT IS IT?

This template contains code that can serve as a starting point for creating new HubNet activities. It shares many of the basic procedures used by other HubNet activities, which are required to connect to and communicate with clients in Disease-like activities.

## HOW IT WORKS

In activities like Disease, each client controls a single turtle on the server.  These turtles are a breed called STUDENTS.  When a client logs in we create a new student turtle and set it up with the default attributes.  Students own a variable for every widget on the client that holds a state, that is, sliders, switches, choosers, and input boxes.  Whenever a user changes one of these elements on the client, a message is sent to the server.  The server catches the message and stores the result.  In this example a slider is used to demonstrate this behavior.  You can also send messages to the client-side widgets using `hubnet-send`.  Monitors on clients must be updated manually by the model, that is you must send a message to a monitor every time you want the value displayed to change. For example, if you have a monitor that displays the current location of the client's avatar, you must send a message to the client like this:

     hubnet-send user-id "location" (word xcor " " ycor)

whenever the client moves.  Buttons on the client side send but do not receive messages.  When a user presses a button, a message is sent to the server.  The server catches the message and executes the appropriate commands.  In this case, the commands should always be turtle commands since the clients control only a single turtle.

## HOW TO USE IT

To start the activity press the GO button.  Ask students to login using the HubNet client or you can test the activity locally by pressing the LOCAL button in the HubNet Control Center. To see the view in the client interface check the Mirror 2D view on clients checkbox.  The clients can use the UP, DOWN, LEFT, and RIGHT buttons to move their avatar and change the amount they move each step by changing the STEP-SIZE slider.

<!-- 2007 -->
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

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.3-RC1
@#$#@#$#@
need-to-manually-make-preview-for-this-model
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
VIEW
252
10
682
440
0
0
0
1
1
1
1
1
0
1
1
1
-10
10
-10
10

BUTTON
85
121
147
154
up
NIL
NIL
1
T
OBSERVER
NIL
I

BUTTON
85
187
150
220
down
NIL
NIL
1
T
OBSERVER
NIL
K

BUTTON
147
154
210
187
right
NIL
NIL
1
T
OBSERVER
NIL
L

BUTTON
23
154
85
187
left
NIL
NIL
1
T
OBSERVER
NIL
J

SLIDER
39
78
189
111
step-size
step-size
1.0
5.0
2
1.0
1
NIL
HORIZONTAL

MONITOR
70
21
157
70
location
NIL
0
1

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
