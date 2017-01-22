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
    { alertBasic : SweetAlert.Model
    , alertText : SweetAlert.Model
    }


init : ( Model, Cmd Msg )
init =
    ( { alertBasic = first SweetAlert.init
      , alertText = first SweetAlert.init
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = AlertBasic SweetAlert.Msg
    | AlertText SweetAlert.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AlertBasic subMsg ->
            let
                ( alertBasic, alertCmd ) =
                    SweetAlert.update subMsg model.alertBasic
            in
                ( { model | alertBasic = alertBasic }, Cmd.map AlertBasic alertCmd )

        AlertText subMsg ->
            let
                ( alertText, alertCmd ) =
                    SweetAlert.update subMsg model.alertText
            in
                ( { model | alertText = alertText }, Cmd.map AlertText alertCmd )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map AlertBasic (SweetAlert.subscriptions model.alertBasic)
        , Sub.map AlertText (SweetAlert.subscriptions model.alertText)
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
    , "margin" => "10px 5px 10px 5px"
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
        , div [ style [ "flex-direction" => "row" ] ]
            [ div [] [ text "A basic message" ]
            , button [ onClick (AlertBasic <| SweetAlert.Show), style sweetButtonStyle ] [ text "Try me!" ]
            , div [] [ text "A title with a text under" ]
            , button [ onClick (AlertText <| SweetAlert.Show), style sweetButtonStyle ] [ text "Try me!" ]
            ]
        , SweetAlert.alert
            (SweetAlert.config
                ({ onOkClick = (AlertBasic <| SweetAlert.Hide)
                 , title = "Here's a message!"
                 , text = Nothing
                 }
                )
            )
            model.alertBasic
        , SweetAlert.alert
            (SweetAlert.config
                ({ onOkClick = (AlertText <| SweetAlert.Hide)
                 , title = "Here's a message!"
                 , text = Just "It's pretty, isn't it"
                 }
                )
            )
            model.alertText
        ]
