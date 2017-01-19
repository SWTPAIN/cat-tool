module View.Utils exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import String
import Form.Error exposing (..)
import Constants exposing (..)
import Model.Shared exposing (..)
import Route exposing (Route)
import Time exposing (Time)
import Date
import Date.Format as DateFormat


-- Events


linkTo : Route -> List (Attribute msg) -> List (Html msg) -> Html msg
linkTo route attrs content =
    a ((linkAttrs route) ++ attrs) content


linkAttrs : Route -> List (Attribute msg)
linkAttrs route =
    let
        path =
            Route.toPath route
    in
        [ href path
        , attribute "data-navigate" path
        ]


onButtonClick : msg -> Attribute msg
onButtonClick msg =
    onWithOptions "click" eventOptions (Json.map (\_ -> msg) Json.value)


onEnter : msg -> Attribute msg
onEnter =
    onKeyDown 13


onEscape : msg -> Attribute msg
onEscape =
    onKeyDown 27


onKeyDown : Int -> msg -> Attribute msg
onKeyDown code msg =
    on
        "keydown"
        (Json.map (\_ -> msg) (keyCode |> Json.andThen (isKey code)))


isKey : Int -> Int -> Json.Decoder ()
isKey expected given =
    if given == expected then
        Json.succeed ()
    else
        Json.fail "not the right key code"


eventOptions : Options
eventOptions =
    { stopPropagation = True
    , preventDefault = True
    }



-- Wrappers


type alias Wrapper msg =
    List (Html msg) -> Html msg


container : String -> Wrapper msg
container className content =
    div [ class ("container " ++ className) ] content


hr_ : Html msg
hr_ =
    hr [] []


abbr_ : String -> String -> Html msg
abbr_ short long =
    abbr [ title long ] [ text short ]


mIcon : String -> List String -> Html msg
mIcon name classes =
    i
        [ class ("material-icons" :: classes |> String.join " ") ]
        [ text name ]


nbsp : Html msg
nbsp =
    text " "


formatDate : Time -> String
formatDate time =
    DateFormat.format "%e %b. %k:%M" (Date.fromTime time)


fieldGroup : String -> String -> String -> List String -> List (Html msg) -> Html msg
fieldGroup id label_ hint errors inputs =
    let
        feedbacksEl =
            div
                [ class "feedback" ]
                [ List.filter (not << String.isEmpty) (hint :: errors) |> String.join " - " |> text ]
    in
        div
            [ classList
                [ ( "form-group", True )
                , ( "with-error", not (List.isEmpty errors) )
                ]
            ]
            (inputs ++ [ label [ class "control-label", for id ] [ text label_ ], feedbacksEl ])


formGroup : Bool -> List (Html msg) -> Html msg
formGroup hasErr content =
    div
        [ classList [ ( "form-group", True ), ( "has-error", hasErr ) ] ]
        content


textInput : List (Attribute msg) -> Html msg
textInput attributes =
    input (List.append [ type_ "text", class "form-control" ] attributes) []


passwordInput : List (Attribute msg) -> Html msg
passwordInput attributes =
    input (List.append [ type_ "password", class "form-control" ] attributes) []



-- Components


loading : Html msg
loading =
    div
        [ class "loading-block" ]
        [ div
            [ class "loading-pulse" ]
            []
        ]

tabsRow : List ( String, tab ) -> (tab -> Attribute msg) -> (tab -> Bool) -> Html msg
tabsRow items toAttr isSelected =
    div
        [ class "tabs-container" ]
        [ div
            [ class "tabs-content" ]
            (List.map (tabItem toAttr isSelected) items)
        ]


tabItem : (tab -> Attribute msg) -> (tab -> Bool) -> ( String, tab ) -> Html msg
tabItem toAttr isSelected ( title, tab ) =
    div
        [ classList
            [ ( "tab", True )
            , ( "tab-selected", isSelected tab )
            ]
        , toAttr tab
        ]
        [ text title ]



-- Misc


formatTimer : Bool -> Float -> String
formatTimer showMs t =
    let
        t_ =
            t |> ceiling |> abs

        totalSeconds =
            t_ // 1000

        minutes =
            totalSeconds // 60

        seconds =
            if showMs || t <= 0 then
                rem totalSeconds 60
            else
                (rem totalSeconds 60) + 1

        millis =
            rem t_ 1000

        sMinutes =
            toString minutes

        sSeconds =
            String.padLeft 2 '0' (toString seconds)

        sMillis =
            if showMs then
                "." ++ (String.padLeft 3 '0' (toString millis))
            else
                ""
    in
        sMinutes ++ ":" ++ sSeconds ++ sMillis


colWidth : Int -> Float
colWidth col =
    (containerWidth + gutterWidth) / 12 * (toFloat col) - gutterWidth


errList : Maybe (ErrorValue e) -> List String
errList me =
    case me of
        Just e ->
            [ errMsg e ]

        Nothing ->
            []


errMsg : ErrorValue e -> String
errMsg e =
    case e of
        InvalidString ->
            "Required"

        Empty ->
            "Required"

        InvalidEmail ->
            "Invalid email format"

        InvalidUrl ->
            "Invalid URL format"

        InvalidFormat ->
            "Invalid format"

        InvalidInt ->
            "Invalid integer format"

        InvalidFloat ->
            "Invalid floating number format"

        ShorterStringThan i ->
            "At least " ++ toString i ++ " chars"

        _ ->
            toString e


pluralize : Int -> String -> String -> String
pluralize i singular plural =
    if i == 0 then
        "no " ++ plural
    else if i == 1 then
        "one " ++ singular
    else
        toString i ++ " " ++ plural
