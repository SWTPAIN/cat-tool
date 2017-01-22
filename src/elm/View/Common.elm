module View.Common exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Dialog


fqDialog : Dialog.Layout msg
fqDialog =
    { header = [ Dialog.title "Q&A" ]
    , body =
        [ ul
            [ class "list-unstyled list-rankings" ]
            []
        ]
    , footer =
        [ text "footer"
        ]
    }
