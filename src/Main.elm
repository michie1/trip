module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text, ul, li, span, pre)
import Html.Events exposing (onClick)
import Html.Attributes exposing (id)
import OutsideInfo exposing (..)
import Http
import Json.Decode
-- import Json.Decode.Extra
-- import Json.Decode.Pipeline


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ OutsideInfo.getInfoFromOutside Outside LogErr ]


type alias Trip =
    { name : String }


type Hoi
    = Failure
    | Loading
    | Success String


type alias Model =
    { value : Int
    , trips : List Trip
    , hoi : Hoi
    }


type alias Flags =
    {}


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model
        0
        [ Trip "Strasbourg"
        , Trip "Kressbronn am Bodensee"
        , Trip "Clairvaux-les-lacs"
        ]
        Loading
    , sendInfoOutside (OutsideInfo.Initialized True)
    )



-- UPDATE


type Msg
    = Increment
    | Decrement
    | LogErr String
    | Outside InfoForElm
    | Load
    | Received (Result Http.Error (List String))


type alias Foo =
    {}


nameDecoder : Json.Decode.Decoder String
nameDecoder =
    (Json.Decode.field "display_name" Json.Decode.string)

namesDecoder : Json.Decode.Decoder (List String)
namesDecoder =
    Json.Decode.list nameDecoder

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | value = model.value + 1 }, Cmd.none )

        Decrement ->
            ( { model | value = model.value - 1 }, Cmd.none )

        Load ->
            ( model
            , Http.get
                { url = "https://nominatim.openstreetmap.org/search?q=strasbourg&format=json&limit=11&addressdetails=1&polygon_geojson=1"
                , expect = Http.expectJson Received namesDecoder
                }
            )

        Received result ->
            case result of
                Ok displayNames ->
                    ( { model | hoi = Success <| String.join "" displayNames }, Cmd.none )

                Err err ->
                    case err of
                        Http.BadBody badBody ->
                            ( { model | hoi = Failure }
                            , OutsideInfo.sendInfoOutside <| OutsideInfo.LogError badBody
                            )

                        _ ->
                            ( { model | hoi = Failure }, Cmd.none )

        Outside infoForElm ->
            case infoForElm of
                OutsideInfo.Bla _ ->
                    ( model, Cmd.none )

        LogErr err ->
            ( model, OutsideInfo.sendInfoOutside <| OutsideInfo.LogError err )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (String.fromInt model.value) ]
        , button [ onClick Increment ] [ text "+" ]
        , button [ onClick Load ] [ text "load" ]
        , viewLoading model
        , viewTrips model.trips
        , div [ id "map" ] []
        ]


viewTrips : List Trip -> Html Msg
viewTrips trips =
    ul [] <| List.map viewTrip trips


viewTrip : Trip -> Html Msg
viewTrip trip =
    li [] [ text trip.name ]


viewLoading : Model -> Html Msg
viewLoading model =
    case model.hoi of
        Failure ->
            span [] [ text "failure" ]

        Loading ->
            span [] [ text "loading" ]

        Success fullText ->
            pre [] [ text fullText ]
