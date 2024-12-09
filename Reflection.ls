
  do ->

    type-name = (value) ->

      switch {} |> (.to-string) |> (.call value) |> (.slice 8, -1)

        | 'Array', 'Arguments' => 'Array'
        | 'Object', 'Error' =>

          switch value

            | void => 'Undefined'
            | null => 'Null'

            else 'Object'

        | 'Number' =>

          switch value

            | value => 'Number'

            else => 'NaN'

        else that

    #

    is-a = (value, type) -> (type-name value) is type

    isnt-a = (value, type) -> not value `is-a` type

    {
      type-name,
      is-a, isnt-a
    }