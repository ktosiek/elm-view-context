module Main exposing (..)

import HtmlWithContext exposing (HtmlWithContext, div, text)
import Html exposing (Html)
import Html.Attributes
import Html.Events


type alias Model =
    { language : Language
    }


type alias Context =
    TranslatableText -> String


type Msg
    = SetLanguage Language



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
    HtmlWithContext.inContext (\translate -> Html.text (translate tt))



-- } Translations


view : Model -> Html.Html Msg
view model =
    HtmlWithContext.unwrap (getContext model) (contextView model)


update : Msg -> Model -> Model
update (SetLanguage l) model =
    { language = l
    }


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
        [ transText THello
        , div [] [ HtmlWithContext.lift nativeElement ]
        , div [ Html.Events.onClick (SetLanguage PL) ] [ text "PL" ]
        , div [ Html.Events.onClick (SetLanguage ENG) ] [ text "ENG" ]
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


main =
    Html.beginnerProgram
        { model = { language = PL }
        , view = view
        , update = update
        }
