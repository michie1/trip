module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text, ul, li)
import Html.Events exposing (onClick)
import Html.Attributes exposing (id)


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Trip =
    { name : String }


type alias Model =
    { value : Int
    , trips : List Trip
    }


init : Model
init =
    Model 0 [ Trip "Strasbourg" ]



-- UPDATE


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            { model | value = model.value + 1 }

        Decrement ->
            { model | value = model.value - 1 }



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
    li [ ] [ text trip.name ]

