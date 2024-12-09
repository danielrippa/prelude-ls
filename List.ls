
  do ->

    { new-namespace-exception } = dependency 'prelude.Exception'
    { TypeDescriptor, Type } = dependency 'prelude.Type'
    { Param } = dependency 'prelude.Parameter'
    { array-size } = dependency 'unsafe.Array'
    { value-as-string, typed-value-as-string } = dependency 'prelude.Value'

    new-exception = new-namespace-exception 'prelude.Array'

    List = (type-descriptor, value) ->

      exception = new-exception 'List'

      try item-types = TypeDescriptor type-descriptor
      catch => throw exception "Invalid Array items type descriptor", e

      switch array-size item-types

        | 0 => throw exception "Missing List item type in type descriptor"

        | 1 =>

        else throw exception "Invalid List items type descriptor #{ value-as-string type-descriptor }. Only one type must be specified."

      [ item-type ] = item-types

      try Param <[ Array ]> {value}
      catch => throw exception e.message, e

      for item, index in value

        try Type item-type, item
        catch => throw exception "Invalid type of item #{ typed-value-as-string item } at index #index of List #{ value-as-string value } as per the List items type descriptor #{ value-as-string type-descriptor }", e

      value

    #

    MaybeList = (type-descriptor, value) ->

      if value isnt void

        try List type-descriptor, value
        catch => throw (new-exception 'MaybeList') e.message, e

      value

    #

    NullableList = (type-descriptor, value) ->

      if value?

        try List type-descriptor, value
        catch => throw (new-exception 'NullableList') e.message, e

      value

    {
      List, MaybeList, NullableList
    }