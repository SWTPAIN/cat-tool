module Dialog exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Transit exposing (Step(..), getValue, getStep)
import Keyboard
import Debug


type Msg
    = NoOp
    | Close
    | KeyDown Int
    | TransitMsg (Transit.Msg Msg)


type alias Model =
    Transit.WithTransition
        { open : Bool
        , options : Options
        }


type alias WithDialog a =
    { a | dialog : Model }


initial : Model
initial =
    { transition = Transit.empty
    , open = False
    , options = defaultOptions
    }


type alias Options =
    { duration : Float
    , closeOnEscape : Bool
    , onClose : Maybe Msg
    }


defaultOptions : Options
defaultOptions =
    { duration = 50
    , closeOnEscape = True
    , onClose = Nothing
    }


taggedOpen : (Msg -> msg) -> WithDialog model -> ( WithDialog model, Cmd msg )
taggedOpen tagger model =
    let
        ( newDialog, cmd ) =
            open model.dialog
    in
        ( { model | dialog = newDialog }, Cmd.map tagger cmd )


open : Model -> ( Model, Cmd Msg )
open model =
    Transit.start TransitMsg NoOp ( 0, model.options.duration ) { model | open = True }


taggedUpdate : (Msg -> msg) -> Msg -> WithDialog model -> ( WithDialog model, Cmd msg )
taggedUpdate tagger msg model =
    let
        ( newDialog, cmd ) =
            update msg model.dialog
    in
        ( { model | dialog = newDialog }, Cmd.map tagger cmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        KeyDown code ->
            if model.options.closeOnEscape && code == 27 && model.open then
                closeUpdate model
            else
                ( model, Cmd.none )

        Close ->
            closeUpdate model

        TransitMsg transitMsg ->
            Transit.tick TransitMsg transitMsg model


closeUpdate : Model -> ( Model, Cmd Msg )
closeUpdate model =
    Transit.start TransitMsg NoOp ( model.options.duration, 0 ) { model | open = False }


subscriptions : Transit.WithTransition model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.downs KeyDown
        , Transit.subscriptions TransitMsg model
        ]


type alias Layout msg =
    { header : List (Html msg)
    , body : List (Html msg)
    , footer : List (Html msg)
    }


emptyLayout : Layout msg
emptyLayout =
    Layout [] [] []


type alias View msg =
    { content : Html msg
    , backdrop : Html msg
    }


view : (Msg -> msg) -> Model -> Layout msg -> View msg
view tagger model layout =
    { content =
        div
            [ class "modal fade modal-hotkeys in"
            , style
                [ ( "display", display model )
                ]
            ]
            [ div
                [ class "modal-dialog modal-dialog-large" ]
                [ div
                    [ class "panel panel-modal" ]
                    [ if List.isEmpty layout.header then
                        text ""
                      else
                        div
                            [ class "panel-header" ]
                            (layout.header ++ [ Html.map tagger closeButton ])
                    , div
                        [ class "panel-body padding padding-top-large padding-bottom-large" ]
                        layout.body
                    , if List.isEmpty layout.footer then
                        text ""
                      else
                        div
                            [ class "panel-footer" ]
                            layout.footer
                    ]
                ]
            ]
    , backdrop =
        div
            [ class "modal-backdrop fade in"
            , style
                [ ( "display", display model )
                ]
            , onClick (tagger Close)
            ]
            []
    }


closeButton : Html Msg
closeButton =
    button
        [ class "close pull-right", type_ "button", onClick Close ]
        [ text "Close "
        , i [ class "icon icon-times" ]
            []
        ]


title : String -> Html msg
title s =
    div [ class "dialog-title" ] [ text s ]


subtitle : String -> Html msg
subtitle s =
    div [ class "dialog-subtitle" ] [ text s ]


isVisible : Model -> Bool
isVisible { open, transition } =
    open


opacity : Model -> Float
opacity { open, transition } =
    if open then
        case Transit.getStep transition of
            Exit ->
                0

            Enter ->
                Transit.getValue transition

            Done ->
                1
    else
        case Transit.getStep transition of
            Exit ->
                Transit.getValue transition

            _ ->
                0


display : Model -> String
display model =
    if isVisible model then
        Debug.log "isVisible" "block"
    else
        Debug.log "not isVisible" "none"
