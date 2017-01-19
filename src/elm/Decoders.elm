module Decoders exposing (..)

import Json.Decode as Json exposing (..)
import Model.Shared exposing (..)


tuple2 : Decoder a -> Decoder b -> Decoder ( a, b )
tuple2 da db =
    map2 (,) (index 0 da) (index 1 db)


playerDecoder : Decoder User
playerDecoder =
    map3
        User
        (field "id" string)
        (field "name" string)
        (field "email" string)