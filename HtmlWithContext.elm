module HtmlWithContext exposing (..)

import Html exposing (Html)
import Html.Lazy
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


lazy0 : HtmlWithContext ctx msg -> HtmlWithContext ctx msg
lazy0 html =
    inContext (\ctx -> Html.Lazy.lazy2 lazyHelper0 html ctx)


lazyHelper0 : HtmlWithContext ctx msg -> ctx -> Html msg
lazyHelper0 f ctx =
    f |> unwrap ctx


lazy : (a -> HtmlWithContext ctx msg) -> a -> HtmlWithContext ctx msg
lazy f a =
    inContext (\ctx -> Html.Lazy.lazy3 lazyHelper f ctx a)


lazyHelper : (a -> HtmlWithContext ctx msg) -> ctx -> a -> Html msg
lazyHelper f ctx a =
    f a |> unwrap ctx


wrapNode : (List (Html.Attribute msg) -> List (Html msg) -> Html msg) -> List (Html.Attribute msg) -> List (HtmlWithContext ctx msg) -> HtmlWithContext ctx msg
wrapNode htmlNodeF attrs children =
    inContext (\ctx -> children |> List.map (unwrap ctx) |> htmlNodeF attrs)


div : List (Html.Attribute msg) -> List (HtmlWithContext ctx msg) -> HtmlWithContext ctx msg
div =
    wrapNode Html.div


text t =
    inContext (\_ -> Html.text t)
