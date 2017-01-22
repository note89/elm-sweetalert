module SweetAlert exposing (..)

import Html exposing (Html, div, p, h2, span, button)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Animation


-- import Alert.Types exposing (Model, Msg(..), Position(..), AlertType(..))


(=>) : a -> b -> ( a, b )
(=>) =
    (,)


type alias Model =
    { style : Animation.State
    , visible : Bool
    }


type Msg
    = Animate Animation.Msg
    | Show
    | Hide


subscriptions : Model -> Sub Msg
subscriptions model =
    Animation.subscription Animate [ model.style ]


init =
    ( { style =
            Animation.style [ Animation.opacity 0.0 ]
      , visible = False
      }
    , Cmd.none
    )


update msg model =
    case msg of
        Show ->
            ( { model
                | visible = True
                , style =
                    Animation.interrupt
                        [ Animation.to
                            [ Animation.opacity 1.0
                            ]
                        ]
                        model.style
              }
            , Cmd.none
            )

        Hide ->
            ( { model
                | visible = False
                , style =
                    Animation.interrupt
                        [ Animation.to
                            [ Animation.opacity 0.0
                            ]
                        ]
                        model.style
              }
            , Cmd.none
            )

        Animate animMsg ->
            ( { model
                | style = Animation.update animMsg model.style
              }
            , Cmd.none
            )


overlay : Html msg
overlay =
    div [ class "sweet-overlay", style sweetOverlayStyle ]
        []


sweetOverlayStyle : List ( String, String )
sweetOverlayStyle =
    [ "background-color" => "rgba(0,0,0,0.4)"
    , "position" => "fixed"
    , "left" => "0"
    , "right" => "0"
    , "top" => "0"
    , "bottom" => "0"
    , "display" => "none"
    , "z-index" => "1010"
    , "opacity" => "1.01"
    , "display" => "block"
    ]



-- alert : Html msg


type Config msg
    = Config
        { title : String
        , text : String
        , onOkClick : msg
        }



--


config :
    { title : String
    , text : String
    , onOkClick : msg
    }
    -> Config msg
config { title, text, onOkClick } =
    Config
        { title = title
        , text = text
        , onOkClick = onOkClick
        }



-- alert : SweetAlertConfig


alert : Config msg -> Model -> Html msg
alert (Config { onOkClick, title, text }) model =
    if model.visible then
        div (Animation.render model.style)
            [ overlay
            , basicAlert onOkClick title text
            ]
    else
        div [] []



-- basicAlert : Html msg -> String -> String -> Html msg


basicAlert onOkClick title text =
    div
        [ class "sweet-alert showSweetAlert visible"
        , style <| sweetAlertStyle ++ sweetStyle
        ]
        [ div [ class "icon error", style displayStyle ]
            [ span [ class "x-mark" ]
                [ span [ class "line left" ]
                    []
                , span [ class "line right" ]
                    []
                ]
            ]
        , div [ class "icon warning", style displayStyle ]
            [ span [ class "body" ]
                []
            , span [ class "dot" ]
                []
            ]
        , div [ class "icon info", style displayStyle ]
            []
        , div [ class "icon success", style displayStyle ]
            [ span [ class "line tip" ]
                []
            , span [ class "line long" ]
                []
            , div [ class "placeholder" ]
                []
            , div [ class "fix" ]
                []
            ]
        , div [ class "icon custom", style displayStyle ]
            []
        , h2 [ style sweetH2Style ]
            [ Html.text title ]
        , p [ style <| [ "display" => "block" ] ++ sweetPStyle ]
            [ Html.text "yeee what he said" ]
        , button [ class "cancel", style displayStyle ]
            [ Html.text text ]
        , button
            [ class "confirm"
            , style sweetButtonStyle
            , onClick onOkClick
            ]
            [ Html.text "OK" ]
        ]


sweetPStyle : List ( String, String )
sweetPStyle =
    [ "color" => "#797979"
    , "font-size" => "16px"
    , "text-align" => "center"
    , "font-weight" => "300"
    , "position" => "relative"
    , "text-align" => "inherit"
    , "float" => "none"
    , "margin" => "0"
    , "padding" => "0"
    , "line-height" => "normal"
    ]


sweetStyle : List ( String, String )
sweetStyle =
    [ "background-color" => "white"
    , "width" => "478px"
    , "padding" => "17px"
    , "border-radius" => "5px"
    , "text-align" => "center"
    , "position" => "fixed"
    , "left" => "50%"
    , "top" => "50%"
    , "margin-left" => "-256px"
    , "margin-top" => "-200px"
    , "overflow" => "hidden"
    , "display" => "block"
    , "z-index" => "2000"
    , "opacity" => "1"
      -- , "box-shadow" => "1px 1px 1px 0px rgba(0,0,0,0.75)"
    ]


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


sweetH2Style : List ( String, String )
sweetH2Style =
    [ "color" => "#575757"
    , "font-size" => "30px"
    , "text-align" => "center"
    , "font-weight" => "600"
    , "text-transform" => "none"
    , "position" => "relative"
    ]


sweetAlertStyle : List ( String, String )
sweetAlertStyle =
    [ "display" => "block"
    , "margin-top" => "-104px"
    ]


displayStyle : List ( String, String )
displayStyle =
    [ "display" => "none" ]
