module Planet exposing (..)

type alias Planet =
  { perihelion : Int -- 1,000,000 km or 1 Gm
  , aphelion : Int -- 1,000,000 km or 1 Gm
  , radius : Int -- 1,000 km
  , colour : String
  , orbitalPeriod : Int -- Days to complete orbit
  }

mercury : Planet
mercury =
  { perihelion = 46
  , aphelion = 70
  , radius = 2
  , colour = "#E2E2E2"
  , orbitalPeriod = 88
  }

venus : Planet
venus =
  { perihelion = 107
  , aphelion = 109
  , radius = 6
  , colour = "#FFF5C3"
  , orbitalPeriod = 225
  }

earth : Planet
earth =
  { perihelion = 147
  , aphelion = 152
  , radius = 6
  , colour = "#2DA144"
  , orbitalPeriod = 365
  }

mars : Planet
mars =
  { perihelion = 207
  , aphelion = 249
  , radius = 3
  , colour = "#451804"
  , orbitalPeriod = 687
  }

jupiter : Planet
jupiter =
  { perihelion = 740
  , aphelion = 816
  , radius = 70
  , colour = "#663300"
  , orbitalPeriod = 4333
  }

saturn : Planet
saturn =
  { perihelion = 1350
  , aphelion = 1509
  , radius = 58
  , colour = "#FFFFE0"
  , orbitalPeriod = 10759
  }

uranus : Planet
uranus =
  { perihelion = 2742
  , aphelion = 3008
  , radius = 25
  , colour = "#00FFFF"
  , orbitalPeriod = 30689
  }

neptune : Planet
neptune =
  { perihelion = 4460
  , aphelion = 4540
  , radius = 25
  , colour = "#336699"
  , orbitalPeriod = 60182
  }

planets : List Planet
planets = [mercury, venus, earth, mars, jupiter, saturn, uranus, neptune]

getScaledOrbitRadius : Planet -> Float
getScaledOrbitRadius planet =
  (planet.perihelion + planet.aphelion)
  |> toFloat
  |> logBase 1.5
  |> (+) (-11)
  |> (*) 50
