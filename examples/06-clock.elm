import Html exposing (..)
import Html.Events exposing (onClick)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Time exposing (Time, second)
import Date



main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { time: Time
  , pause: Bool
  }


init : (Model, Cmd Msg)
init =
  (Model 0 False, Cmd.none)



-- UPDATE


type Msg
  = Tick Time
  | TogglePause


complement : Bool -> Bool
complement val =
  if val == True then
    False
  else
    True


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Tick time ->
      if model.pause then
        (model, Cmd.none)
      else
        ({model | time = time}, Cmd.none)
    TogglePause ->
      ({model | pause = complement model.pause}, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every second Tick



-- VIEW

type alias Coordinate =
  { x : String
  , y : String
  }

coordinate : Float -> Float -> Coordinate
coordinate length angle =
  Coordinate (toString (50 + length * cos angle)) (toString (50 + length * sin angle))


clock : Model -> Html Msg
clock model =
  let
    date =
      Date.fromTime model.time
    h =
      toFloat (Date.hour date)
    m =
      toFloat (Date.minute date)
    s =
      toFloat (Date.second date)
    hours =
      coordinate 25.0 (turns ((h - 3) + (m + s / 60.0) / 60.0) / 12.0)
    minutes =
      coordinate 35.0 (turns ((m - 15) + s / 60.0) / 60.0)
    seconds =
      coordinate 40.0 (turns (s - 15.0) / 60.0)
  in
    svg [ viewBox "0 0 100 100", width "300px" ]
      [ circle [ cx "50", cy "50", r "45", fill "#0B79CE" ] []
      , line [ x1 "50", y1 "50", x2 seconds.x, y2 seconds.y, stroke "#023963" ] []
      , line [ x1 "50", y1 "50", x2 minutes.x, y2 minutes.y, stroke "#cccccc", strokeWidth "2" ] []
      , line [ x1 "50", y1 "50", x2 hours.x, y2 hours.y, stroke "#cccccc", strokeWidth "2" ] []
      ]

buttonText : Model -> String
buttonText model =
  if model.pause then
    "Play"
  else
    "Pause"

view : Model -> Html Msg
view model =
  div [ ]
    [ clock model
    , button [ onClick TogglePause ] [ Html.text (buttonText model) ]
    ]