
  do ->

    { Type, Maybe, Nullable } = dependency 'prelude.Type'
    { new-namespace-exception } = dependency 'prelude.Exception'

    new-exception = new-namespace-exception 'prelude.Types'

    #

    String = ->

      try return Type <[ String ]> it
      catch => throw (new-exception 'StringType') e.message, e

    MaybeString = ->

      try return Maybe <[ String ]> it
      catch => throw (new-exception 'MaybeString') e.message, e

    NullableString = ->

      try return Nullable <[ String ]> it
      catch => throw (new-exception 'NullableString') e.message, e

    #

    Number = ->

      try return Type <[ Number ]> it
      catch => throw (new-exception 'Number') e.message, e

    MaybeNumber = ->

      try return Maybe <[ Number ]> it
      catch => throw (new-exception 'MaybeNumber') e.message, e

    NullableNumber = ->

      try return Type <[ Number ]> it
      catch => throw (new-exception 'NullableNumber') e.message, e

    #

    Boolean = ->

      try return Type <[ Boolean ]> it
      catch => throw (new-exception 'Boolean') e.message, e

    MaybeBoolean = ->

      try return Maybe <[ Boolean ]> it
      catch => throw (new-exception) e.message, e

    NullableBoolean = ->

      try return Nullable <[ Boolean ]> it
      catch => throw (new-exception) e.message, e

    #

    Function = ->

      try return Type <[ Function ]> it
      catch => throw (new-exception 'Function') e.message, e

    MaybeFunction = ->

      try return Maybe <[ Function ]> it
      catch => throw (new-exception 'Function') e.message, e

    NullableFunction = ->

      try return Nullable <[ Function ]> it
      catch => throw (new-exception 'NullableFunction') e.message, e

    #

    Object = ->

      try return Type <[ Object ]> it
      catch => throw (new-exception 'Object') e.message, e

    MaybeObject = ->

      try return Maybe <[ Object ]> it
      catch => throw (new-exception 'MaybeObject') e.message, e

    NullableObject = ->

      try return Nullable <[ Object ]> it
      catch => throw (new-exception 'NullableObject') e.message, e

    #

    Array = ->

      try return Type <[ Array ]> it
      catch => throw (new-exception 'Array') e.message, e

    MaybeArray = ->

      try return Maybe <[ Array ]> it
      catch => throw (new-exception 'MaybeArray') e.message, e

    NullableArray = ->

      try return Nullable <[ Array ]> it
      catch => throw (new-exception 'NullableArray') e.message, e

    {
      String, MaybeString, NullableString,
      Number, MaybeNumber, NullableNumber,
      Boolean, MaybeBoolean, NullableBoolean,
      Function, MaybeFunction, NullableFunction,
      Object, MaybeObject, NullableObject,
      Array, MaybeArray, NullableArray
    }
