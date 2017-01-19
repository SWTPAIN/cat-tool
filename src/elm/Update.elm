module Update exposing (..)

import Model exposing (..)
import Model.Event as Event exposing (Event)
import Page.Home.Update as Home
import Page.Home.Model as HomeModel
import Page.Login.Update as Login
import Page.Login.Model as LoginModel
import Response exposing (..)
import Route exposing (..)
import Update.Utils exposing (..)
import Transit
import Navigation

subscriptions : Model -> Sub Msg
subscriptions ({ pages } as model) =
    let
        pageSub =
            case model.route of
                _ ->
                    Sub.none
    in
        Sub.batch
            [ Sub.map PageMsg pageSub
            , Transit.subscriptions RouteTransition model
            ]




update : Msg -> Model -> ( Model, Cmd Msg )
update = Response.updateWithEvent eventMsg msgUpdate

init : Setup -> Navigation.Location -> ( Model, Cmd Msg )
init setup location =
    askRoute (Route.parser location) (initialModel setup)


eventMsg : Event -> Msg
eventMsg event =
    case event of
        Event.SetUser p ->
            SetUser p

msgUpdate : Msg -> Model -> Response Model Msg
msgUpdate msg ({ layout } as model) =
  case msg of
    SetUser u ->
        res { model | user = u } (navigate Route.Home)
    AskRoute route ->
        askRoute route model |> toResponse
    RouteTransition subMsg ->
        Transit.tick RouteTransition subMsg model |> toResponse
    MountRoute new ->
        mountRoute new model
    PageMsg pageMsg ->
        pageUpdate pageMsg model
    Navigate path ->
        res model (Navigation.newUrl path)

    ToggleSidebar visible ->
        res { model | layout = { layout | showMenu = visible } } Cmd.none
        


askRoute : Route -> Model -> ( Model, Cmd Msg )
askRoute route model =
    Transit.start RouteTransition (MountRoute route) ( 50, 200 ) model

mountRoute : Route -> Model -> Response Model Msg
mountRoute newRoute ({ pages, user, route } as prevModel) =
    let
        routeJump =
            Route.detectJump route newRoute

        model =
            { prevModel
                | routeJump = routeJump
                , route = newRoute
            }
    in
        case newRoute of
            Home ->
                applyHome (Home.mount pages.home) model

            Login ->
                applyLogin Login.mount model

            _ ->
                res model Cmd.none

applyHome : Response HomeModel.Model HomeModel.Msg -> Model -> Response Model Msg
applyHome =
    applyPage (\s pages -> { pages | home = s }) HomeMsg


applyLogin : Response LoginModel.Model LoginModel.Msg -> Model -> Response Model Msg
applyLogin =
    applyPage (\s pages -> { pages | login = s }) LoginMsg


applyPage : (model -> Pages -> Pages) -> (msg -> PageMsg) -> Response model msg -> Model -> Response Model Msg
applyPage pagesUpdater msgWrapper response model =
    response
        |> mapModel (\p -> { model | pages = pagesUpdater p model.pages })
        |> mapCmd (msgWrapper >> PageMsg)

pageUpdate : PageMsg -> Model -> Response Model Msg
pageUpdate pageMsg ({ pages, user } as model) =
    case pageMsg of
        HomeMsg a ->
            applyHome (Home.update user a pages.home) model

        LoginMsg a ->
            applyLogin (Login.update a pages.login) model

