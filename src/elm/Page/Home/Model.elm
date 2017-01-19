module Page.Home.Model exposing (..)

type alias Model =
        { count : Int
        }


initial : Model
initial =
    { count = 0 }


type Msg
    = AddOne
