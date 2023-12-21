breed [ people person ]
breed [ trees tree ]

turtles-own [ health ]

patches-own [
  pollution
  is-power-plant?
]

to setup
  clear-all

  set-default-shape people "person"
  set-default-shape trees "tree"

  ask patches [
    set pollution 0
    set is-power-plant? false
  ]

  create-power-plants

  ask patches [ pollute ]

  create-people initial-population [
    set color black
    setxy random-pxcor random-pycor
    set health 5
  ]

  reset-ticks
end

to go

  if not any? people [ stop ]

  ask people [
    wander
    reproduce
    maybe-plant
    eat-pollution
    maybe-die
  ]
  if any? people [
    ask one-of people [
    maybe-suddenly-die
  ]
  ]
  
  diffuse pollution 0.8

  ask patches [
    pollute
  ]

  ask trees [
    cleanup
    maybe-die
  ]

  tick
end

to create-power-plants
  ask n-of power-plants patches [
    set is-power-plant? true
  ]
end

to pollute  ;; patch procedure
  if is-power-plant? [
    set pcolor red
    set pollution polluting-rate
  ]
  set pcolor scale-color red (pollution - .1) 5 0
end

to cleanup  ;; tree procedure
  set pcolor green + 3
  set pollution max (list 0 (pollution - 1))
  ask neighbors [
    set pollution max (list 0 (pollution - .5))
  ]
  set health health - 0.1
end

to wander  ;; person procedure
  rt random-float 50
  lt random-float 50
  fd 1
  set health health - 0.1
end

to reproduce  ;; person procedure
  if health > 4 and random-float 1 < power-plant-positive-effect + birth-rate [
    hatch-people random 3 [
      set health 5
    ]
  ]
end

to maybe-plant  ;; person procedure
  if random-float 1 < power-plant-positive-effect + planting-rate[
    hatch-trees random 10 [
      set health 5
      set color green
    ]
  ]
end

to eat-pollution  ;; person procedure
  if pollution > 0.5 [
    set health (health - (pollution / 10))
  ]
end

to maybe-die  ;; die if you run out of health
  if health <= 0
  [ die ]
end

to maybe-suddenly-die
  if random-float 1 < probability-of-suddenly-death 
  [die]
end 

; Copyright 2007 Uri Wilensky.
; See Info tab for full copyright and license.