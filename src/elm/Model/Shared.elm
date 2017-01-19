module Model.Shared exposing (..)
import Dict exposing (Dict)
import Transit
import Route

type alias Context =
    { user : User
    , transition : Transit.Transition
    , layout : Layout
    , routeJump : Route.RouteJump
    }

type alias Layout =
    { showMenu : Bool
    }

type alias Id =
    String

type alias FormResult a =
    Result FormErrors a

type alias FormErrors =
    Dict String (List String)


type alias User =
    { id : Id
    , name : String
    , email : String
    }
