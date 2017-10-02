import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import String
import Char


main =
  Html.beginnerProgram
    { model = model
    , view = view
    , update = update
    }



-- MODEL


type alias Model =
  { name : String
  , password : String
  , passwordAgain : String
  , age: String
  , validate: Bool
  }


model : Model
model =
  Model "" "" "" "" False



-- UPDATE


type Msg
    = Name String
    | Password String
    | PasswordAgain String
    | Age String
    | Validate


update : Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }

    Age age ->
      { model | age = age }

    Validate ->
      { model | validate = True }



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ viewInput "text" "Name" Name
    , viewInput "password" "Password" Password
    , viewInput "password" "Re-enter Password" PasswordAgain
    , viewInput "text" "Age" Age
    , button [ onClick Validate ] [ text "Submit" ]
    , viewValidation model
    ]


viewInput : String -> String -> (String -> Msg) -> Html Msg
viewInput inputType placeholderText messageType =
  input [ type_ inputType, placeholder placeholderText, onInput messageType ] []

viewValidation : Model -> Html msg
viewValidation model =
  let
    (color, message) =
      if model.validate == False then
        ("", "")
      else if String.length model.password < 8 then
        ("red", "Password must be at least 8 characters long")
      else if String.any Char.isUpper model.password == False then
        ("red", "Password must contain one or more uppercase characters")
      else if String.any Char.isLower model.password == False then
        ("red", "Password must contain one or more lowercase characters")
      else if String.any Char.isDigit model.password == False then
        ("red", "Password must contain one or more numeric characters")
      else if model.password /= model.passwordAgain then
        ("red", "Passwords do not match!")
      else if String.all Char.isDigit model.age == False then
        ("red", "Invalid age")
      else
        ("green", "OK")
  in
    div [ style [("color", color)] ] [ text message ]
