module Page.Home.Update exposing (..)

import Response exposing (..)
import Page.Home.Model exposing (..)
import Dialog


mount : Model -> Response Model Msg
mount model =
    res model Cmd.none


update : Msg -> Model -> Response Model Msg
update msg model =
    case msg of
        AddOne ->
            res model Cmd.none

        ShowDialog content ->
            Dialog.taggedOpen DialogMsg { model | showDialog = content }
                |> toResponse

        DialogMsg a ->
            Dialog.taggedUpdate DialogMsg a model
                |> toResponse
