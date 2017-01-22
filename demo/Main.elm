module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random
import SweetAlert
import Tuple exposing (first)


(=>) =
    (,)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { alert : SweetAlert.Model
    }


init : ( Model, Cmd Msg )
init =
    ( { alert = first SweetAlert.init
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = Alert SweetAlert.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Alert subMsg ->
            let
                ( alert, alertCmd ) =
                    SweetAlert.update subMsg model.alert
            in
                ( { model | alert = alert }, Cmd.map Alert alertCmd )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map Alert (SweetAlert.subscriptions model.alert)
        ]



-- VIEW


sweetButtonStyle : List ( String, String )
sweetButtonStyle =
    [ "background-color" => "#AEDEF4"
    , "color" => "white"
    , "border" => "none"
    , "box-shadow" => "none"
    , "font-size" => "17px"
    , "font-weight" => "500"
    , "border-radius" => "5px"
    , "padding" => "10px 32px"
    , "margin" => "26px 5px 0 5px"
    , "cursor" => "pointer"
    ]


bodyStyle =
    [ "background-color" => "antiquewhite"
    , "width" => "100%"
    , "height" => "100%"
    , "display" => "flex"
    , "justify-content" => "center"
    , "align-items" => "center"
    ]


view : Model -> Html Msg
view model =
    div [ style bodyStyle ]
        -- REMOVE THIS at some point, we want to use elm for animation and styleing, cuz reasons hehe.
        [ node "link" [ rel "stylesheet", href "https://cdnjs.cloudflare.com/ajax/libs/sweetalert/1.1.3/sweetalert.min.css" ] []
        , button [ onClick (Alert <| SweetAlert.Show), style sweetButtonStyle ] [ text "click me" ]
        , SweetAlert.alert
            (SweetAlert.config
                ({ onOkClick = (Alert <| SweetAlert.Hide)
                 , title = "Here's a message!"
                 , text = "It's pretty, isn't it"
                 }
                )
            )
            model.alert
        ]
