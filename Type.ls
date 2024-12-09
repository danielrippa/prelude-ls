
  do ->

    { type-name } = dependency 'prelude.Reflection'
    { new-namespace-exception } = dependency 'prelude.Exception'
    { typed-value-as-string } = dependency 'prelude.Value'

    new-exception = new-namespace-exception 'prelude.Type'

    #

    must-be = (value, types) ->

      exception = new-exception 'must-be'

      article = switch types.length

        | 1 => 'a'

        else 'any of'

      throw exception "Value #{ typed-value-as-string value } must be #article #{ types * ', ' }" \
        unless (type-name value) in types

      value

    #

    type-descriptor-as-array = (type-descriptor) ->

      switch type-name type-descriptor

        | 'Array' => type-descriptor
        | 'String' => type-descriptor / ' '

    TypeDescriptor = (type-descriptor) ->

      try type-descriptor `must-be` <[ Array String ]>
      catch => throw (new-exception 'TypeDescriptor') "Invalid type of Type descriptor", e

      type-descriptor-as-array type-descriptor

    #

    Type = (type-descriptor, value) ->

      try TypeDescriptor type-descriptor
      catch => throw (new-exception 'Type') e.message, e

      value `must-be` type-descriptor-as-array type-descriptor

    #

    Either = (type-descriptor, value) ->

      exception = new-exception 'Either'

      try return Type type-descriptor, value
      catch => throw exception e.message, e

    #

    Maybe = (type-descriptor, value) ->

      exception = new-exception 'Maybe'

      try return Type type-descriptor, value unless value is void
      catch => throw exception e.message, e

    Nullable = (type-descriptor, value) ->

      try return Type type-descriptor, value if value?
      catch => throw exception e.message, e

    {
      TypeDescriptor,
      Type, Either, Maybe, Nullable,
      must-be
    }
