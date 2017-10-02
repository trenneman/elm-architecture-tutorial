import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Random



main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { dieFace : Int
  , dieFace2 : Int
  }


init : (Model, Cmd Msg)
init =
  (Model 1 1, Cmd.none)



-- UPDATE


type Msg
  = Roll
  | NewFace Int
  | NewFace2 Int


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Roll ->
      (model, Cmd.batch [ Random.generate NewFace (Random.int 1 6), Random.generate NewFace2 (Random.int 1 6) ] )

    NewFace newFace ->
      ({ model | dieFace = newFace }, Cmd.none)

    NewFace2 newFace ->
      ({ model | dieFace2 = newFace }, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


dieStyle : Int -> Attribute Msg
dieStyle dieFace =
  style
    [ ("background", "url(https://cdn.pixabay.com/photo/2012/04/10/22/53/dice-26772_960_720.png)")
    , ("width", "160px")
    , ("height", "160px")
    , ("background-position-y", "-160px")
    , ("background-position-x", String.append (toString (-160 * (dieFace - 1))) "px")
    ]

die : Int -> Html Msg
die dieFace =
  div [ dieStyle dieFace ] [ ]

view : Model -> Html Msg
view model =
  div []
    [ die model.dieFace
    , die model.dieFace2
    , button [ onClick Roll ] [ text "Roll" ]
    ]
