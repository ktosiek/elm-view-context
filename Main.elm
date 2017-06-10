module Main exposing (..)

import HtmlWithContext exposing (HtmlWithContext, div, text)
import Html exposing (Html)
import Html.Attributes
import Html.Events
import Debug


type alias Model =
    { language : Language
    , count : Int
    , context : Context
    }


initModel : Model
initModel =
    { language = PL
    , count = 0
    , context = { language = PL }
    }


type alias Context =
    { language : Language
    }


type Msg
    = SetLanguage Language
    | Count



-- Translations {


type TranslatableText
    = THello


type Language
    = PL
    | ENG


type alias Translator =
    TranslatableText -> String


messageToEng : Translator
messageToEng THello =
    "Hello!"


messageToPl : Translator
messageToPl THello =
    "Cześć!"


translate : Language -> TranslatableText -> String
translate language =
    case language of
        PL ->
            messageToPl

        ENG ->
            messageToEng


transText : TranslatableText -> HtmlWithContext Context msg
transText tt =
    simpleTrans tt
        |> HtmlWithContext.mapContext (\{ language } -> language)


simpleTrans : TranslatableText -> HtmlWithContext Language msg
simpleTrans tt =
    HtmlWithContext.inContext (\l -> Html.text (translate l tt)) |> Debug.log "simpleTrans"



-- } Translations


view : Model -> Html.Html Msg
view model =
    HtmlWithContext.unwrap model.context (contextView model)


update : Msg -> Model -> Model
update msg model =
    case msg of
        SetLanguage l ->
            { model
                | language = l
            }

        Count ->
            { model | count = model.count + 1 }


recalculateContext : Model -> Model
recalculateContext model =
    { model
        | context = leftIfEqual model.context (getContext model)
    }


leftIfEqual : a -> a -> a
leftIfEqual a b =
    if a == b then
        a
    else
        b


wrappedUpdate : Msg -> Model -> Model
wrappedUpdate msg model =
    update msg model
        |> recalculateContext


getContext : Model -> Context
getContext model =
    { language = model.language
    }


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
        , update = wrappedUpdate
        }
