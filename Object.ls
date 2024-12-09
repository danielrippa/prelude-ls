
  do ->

    { new-namespace-exception } = dependency 'prelude.Exception'
    { TypeDescriptor, Type, Either } = dependency 'prelude.Type'
    { Param } = dependency 'prelude.Parameter'
    { array-size, item-index, drop-array-segment } = dependency 'unsafe.Array'
    { object-keys } = dependency 'unsafe.Object'
    { string-segment-index, camel-case, kebab-case } = dependency 'unsafe.String'
    { value-as-string, typed-value-as-string } = dependency 'prelude.Value'

    new-exception = new-namespace-exception 'prelude.Object'

    ellipsis = '...'
    colon = ':'
    pipe = '|'

    Object = (member-descriptors, instance) ->

      # TODO: Implement '?' as a valid member-descriptor

      exception = new-exception 'Object'

      try member-type-descriptors = TypeDescriptor member-descriptors
      catch => throw exception "Invalid Object members type descriptor", e.message

      throw exception "Missing Object members type descriptor" \
        if (array-size member-type-descriptors) is 0

      try Param <[ Object ]> {instance}
      catch => throw exception e.message, e

      ellipsis-index = item-index member-type-descriptors, ellipsis

      strict = yes

      if ellipsis-index?

        strict = no

        member-type-descriptors = drop-array-segment member-type-descriptors, ellipsis-index, 1

      descriptors-count = array-size member-type-descriptors

      keys = object-keys instance
      keys-count = array-size keys

      if strict
        if keys-count isnt descriptors-count

          throw exception do

            * "Invalid Object value #{ value-as-string instance }."
              "The count (#descriptors-count) of members #{ typed-value-as-string member-type-descriptors } differs from the actual count (#keys-count) for the members of Object #{ value-as-string instance }"

            |> (* ' ')

      member-types = {}

      for member-descriptor, index in member-type-descriptors

        colon-index = string-segment-index member-descriptor, colon

        if colon-index?

          [ member-name, member-type-descriptor ] = member-descriptor / "#colon"

          types = member-type-descriptor / "#pipe"

          member-types[ camel-case member-name ] = types

        else

          throw exception do

            * "Invalid Object member type descriptor #{ value-as-string member-descriptor } at index #index of members type descriptor #{ value-as-string member-descriptors }."
              "Each member type descriptor must specifify both a member name and a member type descriptor separated by a colon ('#colon'). E.g. member-name:Type1|Type2 "

            |> (* ' ')

      for key, value of instance

        types = member-types[ key ]

        if types is void

          if strict

            throw exception "Invalid member '#{ kebab-case key }' in #{ typed-value-as-string instance } as per Object member type descriptor #{ value-as-string member-descriptors }"

          else

            continue

        switch array-size types

          | 0 => throw exception "Missing member type descriptor for "

          | 1 =>

            [ descriptor ] = types

            if descriptor is '?'

              continue

            type = Type

          else

            type = Either
            descriptor = types

        try type descriptor, value
        catch =>

          throw exception "Invalid type of value #{ typed-value-as-string value } for member '#{ kebab-case member-name }' as per Object member type descriptor #{ value-as-string member-descriptors }", e

      instance

    #

    MaybeObject = (type-descriptor, value) ->

      if value isnt void

        try Object type-descriptor, value
        catch => throw (new-exception 'MaybeObject') e.message, e

      value

    #

    NullableObject = (type-descriptor, value) ->

      if value?

        try Object type-descriptor, value
        catch => throw (new-exception 'NullableObject') e.message, e

    {
      Object, MaybeObject, NullableObject
    }
