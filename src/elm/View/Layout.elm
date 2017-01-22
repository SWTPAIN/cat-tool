module View.Layout exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import View.Utils as Utils
import Model exposing (..)
import Model.Shared exposing (Context, User)
import Route
import Dialog
import TransitStyle


type Nav
    = Home
    | Explore
    | Build
    | Discuss
    | Login
    | Register
    | Admin


type alias Site msg =
    { id : String
    , maybeNav : Maybe Nav
    , content : List (Html msg)
    , dialog : Maybe (Dialog.View msg)
    }


site : String -> Maybe Nav -> List (Html msg) -> Site msg
site id maybeNav content =
    { id = id
    , maybeNav = maybeNav
    , content = content
    , dialog = Nothing
    }


type alias Game msg =
    { id : String
    , nav : List (Html msg)
    , side : List (Html msg)
    , main : List (Html msg)
    }


renderSite : Context -> (msg -> PageMsg) -> Site msg -> Html Msg
renderSite ctx pageTagger layout =
    let
        transitStyle =
            case ctx.routeJump of
                Route.ForMain ->
                    (TransitStyle.fade ctx.transition)

                _ ->
                    []

        dialogItems =
            case layout.dialog of
                Just dialog ->
                    tag [ dialog.content, dialog.backdrop ]

                Nothing ->
                    []

        tag =
            List.map (Html.map (pageTagger >> PageMsg))
    in
        div
            [ catchNavigationClicks Navigate ]
            [ sideMenu ctx.user layout.maybeNav
            , main_
                [ class "row main" ]
                ([ div
                    [ class "main-container small-12 column"
                    , style transitStyle
                    ]
                    (tag layout.content)
                 ]
                    ++ dialogItems
                )
            ]


brand : Msg -> Html Msg
brand clickMsg =
    div [ class "project-account margin-x-small margin-bottom" ]
        [ a
            [ class "avatar tip"
            , attribute "data-original-title" "Change.org - Website"
            , onClick clickMsg
            ]
            [ img
                [ class "avatar-img"
                , src "http://placehold.it/50x50"
                ]
                []
            ]
        ]


section : List (Attribute msg) -> List (Html msg) -> Html msg
section attrs content =
    Html.section
        attrs
        [ div [ class "container" ] content
        ]


header : Context -> List (Attribute msg) -> List (Html msg) -> Html msg
header ctx attrs content =
    Html.header
        attrs
        [ div
            [ class "container" ]
            content
        ]


appbar : User -> List (Html Msg) -> Html Msg
appbar user content =
    nav
        [ class "appbar" ]
    <|
        brand (ToggleSidebar True)
            :: content
            ++ [ appbarUser user ]


appbarUser : User -> Html Msg
appbarUser user =
    div
        [ classList
            [ ( "appbar-user", True )
            ]
        ]
    <|
        [ div [ class "user-avatar" ]
            [ span [ class "handle" ] [ text user.name ]
            ]
        ]


sideMenu : Maybe User -> Maybe Nav -> Html Msg
sideMenu maybeUser maybeCurrent =
    case maybeUser of
        Nothing ->
            div [] []

        Just user ->
            Html.header
                [ class "main-header" ]
                [ brand (ToggleSidebar False)
                , div
                    [ class "project-information" ]
                    [ ul
                        [ class "list-unstyled btn-group-project" ]
                        [ sideMenuItem Route.Home "book" "Home" (maybeCurrent == Just Home)
                        ]
                    ]
                , div
                    [ class "project-support" ]
                    [ ul
                        [ class "list-unstyled btn-group-project" ]
                        [ sideMenuItem Route.Home "keyboard-o" "Home" (maybeCurrent == Just Home)
                        , sideMenuItem Route.Home "user" "Home" (maybeCurrent == Just Home)
                        ]
                    ]
                ]


sideMenuItem : Route.Route -> String -> String -> Bool -> Html Msg
sideMenuItem route icon label current =
    li
        [ classList
            [ ( "btn-group-item", True )
            , ( "current", current )
            ]
        ]
        [ span
            [ class "tip" ]
            [ Utils.linkTo
                route
                [ class "btn-project" ]
                [ Utils.mIcon icon []
                ]
            ]
        ]


catchNavigationClicks : (String -> msg) -> Attribute msg
catchNavigationClicks tagger =
    onWithOptions
        "click"
        { stopPropagation = True
        , preventDefault = True
        }
        (Json.map tagger (Json.at [ "target" ] pathDecoder))


pathDecoder : Json.Decoder String
pathDecoder =
    Json.oneOf
        [ Json.at [ "dataset", "navigate" ] Json.string
        , Json.at [ "data-navigate" ] Json.string
        , Json.at [ "parentElement" ] (Json.lazy (\_ -> pathDecoder))
        , Json.fail "no path found for click"
        ]
