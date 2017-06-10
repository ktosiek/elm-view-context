module HtmlWithContext exposing (..)

import Html exposing (Html)
import List
import Debug


type HtmlWithContext ctx msg
    = HtmlWithContext (ctx -> Html msg)


unwrap : ctx -> HtmlWithContext ctx msg -> Html msg
unwrap ctx (HtmlWithContext unwrap) =
    unwrap ctx


inContext : (ctx -> Html msg) -> HtmlWithContext ctx msg
inContext =
    HtmlWithContext


lift : Html msg -> HtmlWithContext ctx msg
lift html =
    inContext (always html)


wrapNode : (List (Html.Attribute msg) -> List (Html msg) -> Html msg) -> List (Html.Attribute msg) -> List (HtmlWithContext ctx msg) -> HtmlWithContext ctx msg
wrapNode htmlNodeF attrs children =
    inContext (\ctx -> children |> List.map (unwrap ctx) |> htmlNodeF attrs)


div : List (Html.Attribute msg) -> List (HtmlWithContext ctx msg) -> HtmlWithContext ctx msg
div =
    wrapNode Html.div


text t =
    inContext (\_ -> Html.text t)
