module HtmlWithContext exposing (..)

import Html exposing (Html)
import Html.Lazy
import List
import Debug
import ExtraLazy


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
    inContext (\ctx -> Html.Lazy.lazy3 lazyHelper f ctx a)


lazyHelper : (a -> HtmlWithContext ctx msg) -> ctx -> a -> Html msg
lazyHelper f ctx a =
    f a |> unwrap ctx


lazy2 : (a -> b -> HtmlWithContext ctx msg) -> a -> b -> HtmlWithContext ctx msg
lazy2 f a b =
    inContext (\ctx -> ExtraLazy.lazy4 lazyHelper2 f ctx a b)


lazyHelper2 : (a -> b -> HtmlWithContext ctx msg) -> ctx -> a -> b -> Html msg
lazyHelper2 f ctx a b =
    f a b |> unwrap ctx


lazy3 : (a -> b -> c -> HtmlWithContext ctx msg) -> a -> b -> c -> HtmlWithContext ctx msg
lazy3 f a b c =
    inContext (\ctx -> ExtraLazy.lazy5 lazyHelper3 f ctx a b c)


lazyHelper3 : (a -> b -> c -> HtmlWithContext ctx msg) -> ctx -> a -> b -> c -> Html msg
lazyHelper3 f ctx a b c =
    f a b c |> unwrap ctx


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
