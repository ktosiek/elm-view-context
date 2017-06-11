=================
HTML with context
=================

This is a small experiment in wrapping the Elm's ``Html msg`` type in a user-defined context.
This way views can access some "global" data without explicitly passing it in.
This kind of data might include translation data, date/time format settings, color theme etc.
- anything that needs to be passed around most of the view.

TODO
----

- keyed lists
- all the ``node`` wrappers from ``Html``
