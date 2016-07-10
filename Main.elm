import Html exposing (..)
import Html.App as App
import Html.Attributes as HtmlAttributes
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time)
import Planet exposing (..)
import Random as Random
import Debug as Debug

{-
TODO
  use better calculation for size/position of planet
  make planets / sun look better (textured colour?)
  add occassional random comet? Will have to use Model, possibly also Cmd
  add moons?
  add planet rings
  make planets show when in front of sun / hide when behind
-}

main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions }

type alias Model = Time

init : (Model, Cmd Msg)
init =
  (0, Cmd.none)

type Msg
  = Tick Time

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick newTime ->
      (newTime, Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every Time.millisecond Tick

width = 1800
height = 920
speed = 20
viewingAngle = pi / 12 -- the angle the viewer plane makes with the plane the planets are orbiting on

circle' : a -> b -> c -> String -> Svg d
circle' x y radius colour =
  circle
    [ x |> toString |> cx,
      y |> toString |> cy,
      radius |> toString |> r,
      fill colour ]
    []

stars : List (Svg a)
stars =
  let
    xGenerator = Random.int 0 width
    yGenerator = Random.int 0 height
    generator = Random.pair xGenerator yGenerator
    initialSeed = Random.initialSeed 0
    nextCoords i (seed, coords) =
      let (nextCoords, nextSeed) = Random.step generator seed
      in (nextSeed, (nextCoords :: coords))
  in
    [0..15]
    |> List.foldr nextCoords (initialSeed, [])
    |> snd
    |> List.map (\(x, y) -> circle' x y 1 "#EDEDCC")

scaleRadius : Int -> Float -> Float
scaleRadius radius distanceToViewingPlane =
  let distancePlaneToEye = height / 10
  in
    radius
    |> toFloat
    |> logBase 2
    |> (*) (8 * distancePlaneToEye / (distanceToViewingPlane + distancePlaneToEye))

buildPlanetSvg : Float -> Planet -> Svg a
buildPlanetSvg time planet =
  let
    angle = time * speed / (toFloat planet.orbitalPeriod |> logBase 1.1)
    orbitRadius = getScaledOrbitRadius planet
    x = width / 2 + orbitRadius * cos angle
    yOnOrbitalPlane = orbitRadius * sin angle
    y = yOnOrbitalPlane * sin viewingAngle
    displayY = -y + height / 2
    distancePlanetToPlane = (yOnOrbitalPlane * cos viewingAngle) + (3 * height / 5)
    radius = scaleRadius planet.radius distancePlanetToPlane
  in
    circle' x displayY radius planet.colour

view : Model -> Html Msg
view model =
  let 
    time = Time.inSeconds model
    planetSvgs = planets |> List.map (buildPlanetSvg time)
    sun = circle' (width / 2) (height / 2) (scaleRadius 695 (3 * height / 5)) "#EDE158"
    solarSystem =
      sun :: planetSvgs
      |> List.append stars
  in
    div
      [ HtmlAttributes.style [ ("background-color", "#000000"), ("width", "100%"), ("height", "100%") ] ]
      [ Svg.svg
        [ viewBox ("0 0 " ++ toString width ++ " " ++ toString height) ]
        solarSystem ]
