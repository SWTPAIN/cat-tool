module Page.Home.Update exposing (..)

import Response exposing (..)
import Model.Shared exposing (..)
import Page.Home.Model exposing (..)

mount : Model -> Response Model Msg
mount model =
    res model Cmd.none


update : User -> Msg -> Model -> Response Model Msg
update user msg model =
    case msg of
        AddOne ->
            res model Cmd.none
