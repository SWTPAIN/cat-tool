module Route exposing (..)

import RouteParser exposing (..)
import Navigation


parser : Navigation.Location -> Route
parser location =
    fromPath location.pathname


type Route
    = Home
    | Login
    | NotFound
    | EmptyRoute


type RouteJump
    = ForMain
    | None


fromPath : String -> Route
fromPath path =
    match matchers path
        |> Maybe.withDefault NotFound


matchers : List (Matcher Route)
matchers =
    [ static Home "/"
    , static Login "/login"
    ]

toPath : Route -> String
toPath route =
    case route of
        Home ->
            "/"

        Login ->
            "/login"

        EmptyRoute ->
            "/"

        NotFound ->
            "/404"


detectJump : Route -> Route -> RouteJump
detectJump prevRoute route =
  if prevRoute /= route then
      ForMain
  else
      None
