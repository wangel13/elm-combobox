module Combobox where
-- Bible
import Html (..)
import Html.Attributes (..)
import Html.Events (..)
import Signal
import List
import String
import LocalChannel as LC
import Maybe
import Debug
-- Custom

type alias Model = { dataList     : List String
                    ,dataCurrent  : String
                    ,dataModified : List String
                    ,isEdited     : Bool
                    ,listTake     : Int
                    ,curTakeOption: Int
                    }

type Action = NoOp
            | ChangeDataCurrent String
            | Choose            String
            | KeyUp Int

initialModel suggestions maxTake = { dataList    = suggestions
                                    ,dataCurrent  = ""
                                    ,dataModified = []
                                    ,isEdited     = False
                                    ,listTake     = maxTake
                                    ,curTakeOption = 0
                                    }

update : Action -> Model -> Model
update action model =
    case  Debug.watch "action"  action of
      ChangeDataCurrent val ->
        {model | dataCurrent   <- val
               , isEdited      <- if val == "" then False else True
               , curTakeOption <- 0
               , dataModified  <-
                   let val' = String.toUpper val
                   in List.take model.listTake
                         <| List.filter (\x -> String.startsWith val' (String.toUpper x)) model.dataList
                            ++ List.filter (\x -> not ( String.startsWith val' (String.toUpper x) ) && String.contains val' (String.toUpper x) ) model.dataList
              }
      Choose val ->
        {model | dataCurrent   <- val
                ,curTakeOption <- 0
                ,isEdited      <- False
        }
      KeyUp key -> let len = List.length model.dataModified
        in if | key == 40  -> {model | curTakeOption <- (if model.curTakeOption + 1 < len then model.curTakeOption + 1 else model.curTakeOption)}
              | key == 38  -> {model | curTakeOption <- (if model.curTakeOption > 0 then model.curTakeOption - 1 else 0)}
              | key == 13  -> {model | dataCurrent   <- if [] == List.drop model.curTakeOption model.dataModified
                                                                       then ""
                                                                       else List.head <| List.drop model.curTakeOption model.dataModified
                                                    , isEdited      <- False
                                                    , curTakeOption <- 0
                                              }
              | otherwise -> model
      _ -> model

-- VIEW

view : List Attribute -> LC.LocalChannel Action -> Model -> Html
view attributes chan model =
  div (attributes) [
    input [
      type' "text"
      , value model.dataCurrent
      , on "input" targetValue (\x -> LC.send chan (ChangeDataCurrent x))
      , on "keydown" keyCode (\x -> LC.send chan (KeyUp x))
    ] []
    , if model.isEdited
        then viewSuggestions chan model
        else div [] []
  ]

viewSuggestions chan model =
    let selectClass i = if i == model.curTakeOption then " combobox-active" else ""
    in div [class "fadeIn combobox-list"]
      (List.indexedMap (\i x ->
        div [class ("combobox-list-item" ++ selectClass i), onClick (LC.send chan (Choose x))]
        [text x]) model.dataModified)