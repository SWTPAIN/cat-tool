module Update.Utils exposing (..)

import Navigation
import Route exposing (Route)

navigate : Route -> Cmd msg
navigate route =
    Navigation.newUrl (Route.toPath route)

