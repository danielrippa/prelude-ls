
  do ->

    { new-namespace-exception } = dependency 'prelude.Exception'
    { TypeDescriptor, Type } = dependency 'prelude.Type'
    { Param } = dependency 'prelude.Parameter'
    { item-index, array-size, drop-array-segment, inject-array-segment, repeat-item } = dependency 'unsafe.Array'
    { typed-value-as-string, value-as-string } = dependency 'prelude.Value'

    new-exception = new-namespace-exception 'prelude.Tuple'

    #

    ellipsis = '...'
    question-mark = '?'

    #

    Tuple = (elements-descriptor, value) ->

      exception = new-exception 'Tuple'

      try element-types = TypeDescriptor elements-descriptor
      catch => throw exception "Invalid tuple elements type descriptor", e

      try Param <[ Array ]> {value}
      catch => throw exception e.message, e

      types-count = array-size element-types
      elements-count = array-size value

      ellipsis-index = item-index element-types, ellipsis

      if ellipsis-index?

        element-types = drop-array-segment element-types, ellipsis-index, 1

      else

        if elements-count isnt types-count

          throw exception do

            * "Invalid Tuple value #{ value-as-string value }."
              "The count (#types-count) of required types #{ typed-value-as-string element-types } differs from the actual tuple elements count (#elements-count)"

            |> (* ' ')

      indexes-to-skip = if ellipsis-index?

        types-count = array-size element-types

        types-to-inject = repeat-item '?', elements-count - types-count

        switch ellipsis-index

          | 0 =>

            [ to elements-count - types-count ]

            element-types = inject-array-segment element-types, types-to-inject, 0

          else

            [ ellipsis-index til elements-count ]

            element-types = inject-array-segment element-types, types-to-inject, ellipsis-index

      else

        null

      for item, index in value

        if indexes-to-skip?

          continue if index in indexes-to-skip

        element-type = element-types[ index ]

        continue if element-type is '?'

        try Type element-type, item
        catch => throw exception "Invalid type of item #{ typed-value-as-string item } at index #index of Tuple #{ value-as-string value } as per the Tuple elements type descriptor #{ value-as-string elements-descriptor }", e

      value

    #

    MaybeTuple = (type-descriptor, value) ->

      if value isnt void

        try Tuple type-descriptor, value
        catch => throw (new-exception 'MaybeTuple') e.message, e

      value

    #

    NullableTuple = (type-descriptor, value) ->

      if value?

        try Tuple type-descriptor, value
        catch => throw (new-exception 'NullableTuple') e.message, e

      value

    {
      Tuple, MaybeTuple, NullableTuple
    }