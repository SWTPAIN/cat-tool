module ServerApi exposing (..)

import Http exposing (..)
import Task exposing (Task, andThen)
import Json.Decode as Json
import Json.Encode as JsEncode
import Dict exposing (Dict)
import Result exposing (Result(Ok, Err))
import Model.Shared exposing (..)
import Decoders exposing (..)
import Encoders exposing (..)


-- GET


type alias GetJsonTask a =
    Task Never (Result () a)


postLogin : String -> String -> Request User
postLogin email password =
    let
        body =
            JsEncode.object
                [ ( "email", JsEncode.string email )
                , ( "password", JsEncode.string password )
                ]
    in
        post "http://localhost:3000/login" (jsonBody body) playerDecoder


postLogout : Request User
postLogout =
    post "/api/logout" Http.emptyBody playerDecoder


recoverFormError : Error -> Task Never (FormResult a)
recoverFormError error =
    case error of
        BadStatus response ->
            case Json.decodeString errorsDecoder response.body of
                Ok errors ->
                    Task.succeed (Err errors)

                Err _ ->
                    Task.succeed (Err serverError)

        _ ->
            Task.succeed (Err serverError)


errorsDecoder : Json.Decoder FormErrors
errorsDecoder =
    Json.dict (Json.list Json.string)


serverError : FormErrors
serverError =
    Dict.singleton "global" [ "Unexpected server response." ]


queryString : List ( String, String ) -> String
queryString params =
    if List.isEmpty params then
        ""
    else
        "?" ++ (List.map (\( k, v ) -> k ++ "=" ++ v) params |> String.join "&")



-- Tooling


sendForm : (FormResult a -> msg) -> Request a -> Cmd msg
sendForm toMsg request =
    toFormTask request
        |> Task.perform toMsg


toFormTask : Request a -> Task Never (FormResult a)
toFormTask request =
    toTask request
        |> Task.map Ok
        |> Task.onError recoverFormError
