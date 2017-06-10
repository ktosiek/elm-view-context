module Main exposing (..)

import HtmlWithContext exposing (HtmlWithContext, div, text)
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Debug


type alias Model =
    { language : Language
    , count : Int
    }


initModel : Model
initModel =
    { language = PL
    , count = 0
    }


type alias Context =
    TranslatableText -> String


type Msg
    = SetLanguage Language
    | Count



-- Translations {


type TranslatableText
    = THello


type Language
    = PL
    | ENG


messageToEng : TranslatableText -> String
messageToEng THello =
    "Hello!"


messageToPl : TranslatableText -> String
messageToPl THello =
    "Cześć!"


transText : TranslatableText -> HtmlWithContext Context msg
transText tt =
    HtmlWithContext.inContext (\translate -> Html.text (translate tt)) |> Debug.log "transText"



-- } Translations


view : Model -> Html.Html Msg
view model =
    HtmlWithContext.unwrap (getContext model) (contextView model)


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetLanguage l ->
            { model
                | language = l
            }

        Count ->
            { model | count = model.count + 1 }


getContext : Model -> Context
getContext model =
    case model.language of
        PL ->
            messageToPl

        ENG ->
            messageToEng


contextView : Model -> HtmlWithContext Context Msg
contextView model =
    div []
        [ HtmlWithContext.lazy transText THello
        , div [] [ HtmlWithContext.lift nativeElement ]
        , div [ Html.Events.onClick (SetLanguage PL) ] [ text "PL" ]
        , div [ Html.Events.onClick (SetLanguage ENG) ] [ text "ENG" ]
        , div [ Html.Events.onClick Count ] [ text (toString model.count) ]
        ]


nativeElement : Html msg
nativeElement =
    Html.img
        [ Html.Attributes.src "http://elm-lang.org/assets/logo.svg"
        , Html.Attributes.style
            [ ( "max-width", "100px" )
            , ( "max-height", "100px" )
            ]
        ]
        []
        |> Debug.log "img"


main =
    Html.beginnerProgram
        { model = initModel
        , view = view
        , update = update
        }
