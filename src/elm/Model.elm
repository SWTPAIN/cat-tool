module Model exposing (..)
import Route exposing (Route)
import Transit
import Page.Home.Model as Home
import Page.Login.Model as Login
import Model.Shared exposing (..)

type alias Setup =
    { user : User
    }

type Msg
    = AskRoute Route
    | RouteTransition (Transit.Msg Msg)
    | MountRoute Route
    | SetUser User
    | PageMsg PageMsg
    | Navigate String
    | ToggleSidebar Bool

type PageMsg
    = HomeMsg Home.Msg
    | LoginMsg Login.Msg

type alias Pages =
    { home : Home.Model
    , login : Login.Model
    }

-- MODEL
type alias Model =
    Transit.WithTransition
        { route : Route
        , routeJump : Route.RouteJump
        , user : User
        , pages : Pages
        , layout : Layout
        }


initialModel : Setup -> Model
initialModel setup =
    { route = Route.EmptyRoute
    , routeJump = Route.None
    , transition = Transit.empty
    , user = setup.user
    , pages =
        { home = Home.initial
        , login = Login.initial
        }
    , layout =
        { showMenu = False }
    }

