module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text, ul, li)
import Html.Events exposing (onClick)
import Html.Attributes exposing (id)
import OutsideInfo exposing (..)


main =
    Browser.element
       { init = init
       , update = update
       , view = view
       , subscriptions = subscriptions
       }


subscriptions: Model -> Sub Msg
subscriptions model =
    Sub.batch [ OutsideInfo.getInfoFromOutside Outside LogErr ]

type alias Trip =
    { name : String }


type alias Model =
    { value : Int
    , trips : List Trip
    }

type alias Flags = { }

init : Flags -> ( Model, Cmd Msg )
init flags =
    ( Model
        0
        [ Trip "Strasbourg"
        , Trip "Kressbronn am Bodensee"
        , Trip "Clairvaux-les-lacs"
        ]
    , sendInfoOutside (OutsideInfo.Initialized True)
    )

-- UPDATE


type Msg
    = Increment
    | Decrement
    | LogErr String
    | Outside InfoForElm


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Increment ->
            ({ model | value = model.value + 1 }, Cmd.none)

        Decrement ->
            ({ model | value = model.value - 1 }, Cmd.none)


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
        , viewTrips model.trips
        , div [ id "map" ] []
        ]


viewTrips : List Trip -> Html Msg
viewTrips trips =
    ul [] <| List.map viewTrip trips


viewTrip : Trip -> Html Msg
viewTrip trip =
    li [] [ text trip.name ]
