module Page.Home.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model.Shared exposing (..)
import Route exposing (..)
import Page.Home.Model exposing (..)
import View.Utils as Utils exposing (..)
import View.Layout as Layout
import View.Common as Common
import Dialog


view : Context -> Model -> Layout.Site Msg
view ctx model =
    (Layout.Site
        "home"
        (Just Layout.Home)
        [ Layout.header ctx
            []
            [ onboard ]
        , Layout.section
            [ class "white inside" ]
            [ div
                [ class "row live-center" ]
                []
            , div
                [ class "row" ]
                []
            ]
        ]
        (Just (Dialog.view DialogMsg model.dialog (dialogContent model)))
    )


dialogContent : Model -> Dialog.Layout msg
dialogContent model =
    case model.showDialog of
        Empty ->
            Dialog.emptyLayout

        FQDialog ->
            Common.fqDialog


onboard : Html Msg
onboard =
    div
        [ class "row" ]
        [ div
            [ class "col-sm-6" ]
            [ img
                [ src "/assets/images/screenshot1.png"
                , class "screenshot"
                ]
                []
            ]
        , div
            [ class "col-sm-6" ]
            [ h1 [] [ text "Pro T Tool" ]
            , p
                [ class "subtitle", onClick (ShowDialog FQDialog) ]
                [ text """
                    Welcome to OneSky Pro T Tool"""
                ]
            , Utils.linkTo Login
                [ class "btn btn-flat btn-transparent" ]
                [ text "log in" ]
            ]
        ]
