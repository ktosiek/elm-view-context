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


lazy : (a -> HtmlWithContext ctx msg) -> a -> HtmlWithContext ctx msg
lazy f a =
    inContext (\ctx -> Html.Lazy.lazy3 lazyHelper f a ctx)


lazyHelper : (a -> HtmlWithContext ctx msg) -> a -> ctx -> Html msg
lazyHelper f a ctx =
    f a |> unwrap ctx


map : (a -> msg) -> HtmlWithContext ctx a -> HtmlWithContext ctx msg
map f html =
    inContext (\ctx -> unwrap ctx html |> Html.map f)


mapContext : (ctx -> a) -> HtmlWithContext a msg -> HtmlWithContext ctx msg
mapContext f html =
    inContext (\outerCtx -> unwrap (f outerCtx) html)


wrapNode : (List (Html.Attribute msg) -> List (Html msg) -> Html msg) -> List (Html.Attribute msg) -> List (HtmlWithContext ctx msg) -> HtmlWithContext ctx msg
wrapNode htmlNodeF attrs children =
    inContext (\ctx -> children |> List.map (unwrap ctx) |> htmlNodeF attrs)


div : List (Html.Attribute msg) -> List (HtmlWithContext ctx msg) -> HtmlWithContext ctx msg
div =
    wrapNode Html.div


text t =
    inContext (\_ -> Html.text t)
