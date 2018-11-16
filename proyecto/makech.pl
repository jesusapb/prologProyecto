:-dynamic here/1.
:-dynamic have/1.
:-dynamic location/2.
:-dynamic acciond/1.
:-dynamic status/1.
:-dynamic accion/1.

%nombre:Jesus Antonio Pacheco Balam

room(office).
room(kitchen).
room('dining room').
room(hall).
room(cellar).

door(office,hall).
door(hall,'dining room').
door('dining room',kitchen).
door(kitchen,cellar).
door(kitchen,office).

location(desk, office).
location(apple, kitchen).
location(flashlight, desk).
location(washingmachine, cellar).
location(makech,washingmachine).
location(broccoli, kitchen).
location(crackers, kitchen).
location(computer, office).

edible(apple).
edible(crackers).

tastes_yucky(broccoli).

%disponibles para ser abiertos
disponibles(desk).
disponibles(whashingmachine).


here(kitchen).
%lo que puede ser abierto/cerrado prendido/apagado
acciond(cerrado).
prender(flashlight).
status(off).
accion(cerrado).
llave(cellar).

connect(X,Y):-
  door(X,Y).
connect(X,Y):-
  door(Y,X).

look:-
  here(Here),
  write('You are in the '),write(Here),nl,
  write('You can see the following things:'),nl,
  list_things(Here),
  write('You can go to the following rooms:'),nl,
  list_connections(Here),
  write('You have:'),nl,
  list_have.

list_things(Place):-
  location(X,Place),
  tab(2),write(X),nl,
  fail.
list_things(_).

list_connections(Place):-
  connect(Place,X),
  tab(2),write(X),nl,
  fail.
list_connections(_).

list_have:-
  have(X),
  tab(2),write(X),nl,
  fail.
list_have.



goto(Room):-
  can_go(Room),
  retractall(here(_)),
  assert(here(Room)),
  look.
can_go(Room):-
  here(Here),
  connect(Here,Room).
can_go(Room):-
  write('You can''t get to '),write(Room),write(' from here'),nl,fail.

take(Thing):-
  can_take(Thing),
  retractall(location(Thing,_)),
  assert(have(Thing)).

can_take(Thing):-
  here(Room),
  location(Thing,Room).
can_take(Thing):-write('You can''t take '),write(Thing),nl,fail.


drop(Thing):-
  can_drop(Thing),
  retractall(have(Thing)),
  here(Room),
  assert(location(Thing,Room)).

can_drop(Thing):-
  have(Thing).
can_drop(Thing):-write('You can''t drop '),write(Thing),nl,fail.

eat(Thing):-
  eat2(Thing).
eat(Thing):-
  write(['You don''t have the: ',Thing]),nl,fail.



eat2(Thing):-
  edible(Thing),
  retract(location(Thing,_)),
  write([' that ',Thing,' was good']),nl.
eat2(Thing):-
  tastes_yucky(Thing),
  write(['you should not eat the',Thing]),nl.
eat2(Thing):-
  write(['the ',Thing,'is not edible']),nl,fail.


openoffice(Thing):-
  disponibles(Thing),
  opendesk2(Thing),
  retractall(acciond(_)),
  assert(acciond(abierto)),nl.
openoffice(Thing):-
  write(['el objeto',Thing,' no puede ser abierto']),nl,fail.

opendesk2(Thing):-
   here(Room),
   location(Thing,Room),
   write(['la',Thing,' ya esta abierta']),nl.
opendesk2(Thing):-
   write(['el objeto',Thing,' no se encuentra']),nl,fail.

watchoffice(Thing):-
  watchdesk1(Thing),
  here(Room),
  retractall(location(flashlight,Thing)),
  assert(location(flashlight,Room)),
  look.
watchoffice(Thing):-
  write(['no se puede ver dentro',Thing]),nl,fail.

watchdesk1(Thing):-
  here(Room),
  location(Thing,Room),
  acciond(abierto),
  write('ya esta disponible la flashlight para poder tomarla'),nl.
watchdesk1(Thing):-
  write(['no se puede ver dentro',Thing,'primero debes abrirlo']),nl,fail.


turn_on(Thing):-
  turn_on2(Thing),
  retractall(status(_)),
  assert(status(on)),nl.
turn_on(Thing):-
  write(['the ',Thing,'no es la linterna']),nl,fail.

turn_on2(Thing):-
  have(Thing),
  prender(Thing),
  write('encendida'),nl.
turn_on2(Thing):-
  write(['the',Thing,'es un objeto que no se puede encender']),nl,fail.

turn_off(Thing):-
  turn_off2(Thing),
  retractall(status(_)),
  assert(status(off)),nl.
turn_off(Thing):-
  write(['the ',Thing,'no es la linterna']),nl,fail.

turn_off2(Thing):-
  have(Thing),
  prender(Thing),
  write('apagada'),nl.
turn_off2(Thing):-
  write(['the',Thing,'es un objeto que esta apagado o no puede se apagado']),nl,fail.

  %funciones para abrir la lavadora
open(Thing):-
  disponibles(Thing),
  open2(Thing),
  retractall(accion(_)),
  assert(accion(abierto)),nl.
open(Thing):-
  write(['el objeto',Thing,' no puede ser abierto']),nl,fail.

open2(Thing):-
   here(Room),
   location(Thing,Room),
   write(['la',Thing,' ya esta abierta']),nl.
open2(Thing):-
   write(['el objeto',Thing,' no se encuentra']),nl,fail.


close1(Thing):-
  close2(Thing),
  retractall(accion(_)),
  assert(accion(cerrado)),nl.
close1(Thing):-
   write(['el objeto',Thing,' no puede ser abierto']),nl,fail.

close2(Thing):-
   here(Room),
   location(Thing,Room),
   write(['la',Thing,' ya esta cerrada']),nl.
close2(Thing):-
   write(['el objeto',Thing,' no se encuentra']),nl,fail.

   %funciones de ver dentro de la lavadora
watch(Thing):-
  watch1(Thing),
  here(Room),
  retractall(location(makech,Thing)),
  assert(location(makech,Room)),
  look.
watch(Thing):-
  write(['no se puede ver dentro',Thing]),nl,fail.

watch1(Thing):-
  here(Room),
  location(Thing,Room),
  accion(abierto),nl.
watch1(Thing):-
  write(['no se puede ver dentro',Thing,'del objeto']),nl,fail.

