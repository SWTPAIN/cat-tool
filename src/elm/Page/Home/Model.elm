module Page.Home.Model exposing (..)

import Dialog exposing (WithDialog)


type alias Model =
    WithDialog
        { count : Int
        , showDialog : Dialog
        }


type Dialog
    = Empty
    | FQDialog


initial : Model
initial =
    { count = 0
    , dialog = Dialog.initial
    , showDialog = Empty
    }


type Msg
    = AddOne
    | ShowDialog Dialog
    | DialogMsg Dialog.Msg
