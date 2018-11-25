port module OutsideInfo exposing (sendInfoOutside, InfoForOutside(..), InfoForElm(..), getInfoFromOutside)

import Json.Encode
import Json.Decode exposing (decodeValue)

port infoForOutside : GenericOutsideData -> Cmd msg


port infoForElm : (GenericOutsideData -> msg) -> Sub msg


sendInfoOutside : InfoForOutside -> Cmd msg
sendInfoOutside info =
    case info of
        Initialized payload ->
            infoForOutside { tag = "Initialized", data = Json.Encode.bool payload }

        LogError err ->
            infoForOutside { tag = "LogError", data = Json.Encode.string err }


getInfoFromOutside : (InfoForElm -> msg) -> (String -> msg) -> Sub msg
getInfoFromOutside tagger onError =
    infoForElm
        (\outsideInfo ->
            case outsideInfo.tag of
                "Bla" ->
                    case decodeValue  Json.Decode.string outsideInfo.data of
                        Ok bla ->
                            tagger <| Bla bla
                        Err e ->
                            onError <| Json.Decode.errorToString e

                _ ->
                    onError <| "Unexpected info from outside: " ++ outsideInfo.tag ++ " " ++ Debug.toString outsideInfo.data
        )


type InfoForOutside
    = LogError String
    | Initialized Bool


type InfoForElm
    = Bla String


type alias GenericOutsideData =
    { tag : String
    , data : Json.Encode.Value
    }
