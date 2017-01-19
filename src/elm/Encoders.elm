module Encoders exposing (..)

import Dict exposing (Dict)
import Json.Decode exposing (..)
import Json.Encode as Js

tag : String -> List ( String, Value ) -> Value
tag name fields =
    Js.object <| ( "tag", Js.string name ) :: fields


dictEncoder : (comparable -> Value) -> (v -> Value) -> Dict comparable v -> Value
dictEncoder encodeKey encodeValue dict =
    let
        encodeField ( k, v ) =
            Js.list [ encodeKey k, encodeValue v ]

        fields =
            dict
                |> Dict.toList
                |> List.map encodeField
    in
        Js.list fields
