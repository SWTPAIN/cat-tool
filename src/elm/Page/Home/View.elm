module Page.Home.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Model.Shared exposing (..)
import Route exposing (..)
import Page.Home.Model exposing (..)
import View.Utils as Utils exposing (..)
import View.Layout as Layout

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
                [ ]
            , div
                [ class "row" ]
                []
            ]
        ]
    )


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
            [ h1 [] [ text "Sailing tactics from the sofa" ]
            , p
                [ class "subtitle" ]
                [ text """
                    Tacks is a free regatta simulation game.
                    engage yourself in a realtime multiuser race
                    or attempt to break your best time to climb the rankings."""
                ]
            , Utils.linkTo Login
                [ class "btn btn-flat btn-transparent" ]
                [ text "or log in" ]
            ]
        ]
