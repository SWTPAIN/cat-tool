module View exposing (..)

import Html exposing (..)
import Model exposing (..)
import Model.Shared exposing (Context)
import Page.Home.View as HomePage
import Page.Login.View as LoginPage
import Route exposing (..)
import View.Layout exposing (renderSite, renderGame)
-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view ({ pages, user , layout, transition, routeJump } as model) =
    let
        ctx =
            Context user transition layout routeJump
    in
        case model.route of
            Home ->
                renderSite ctx HomeMsg (HomePage.view ctx pages.home)
            Login ->
                renderSite ctx LoginMsg (LoginPage.view ctx pages.login)
            NotFound ->
                text "Not found!"

            EmptyRoute ->
                text ""





-- CSS STYLES
styles : { img : List ( String, String ) }
styles =
  {
    img =
      [ ( "width", "33%" )
      , ( "border", "4px solid #337AB7")
      ]
  }
