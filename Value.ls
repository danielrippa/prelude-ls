
  do ->

    { type-name } = dependency 'prelude.Reflection'
    { single-quotes, braces, square-brackets } = dependency 'unsafe.String'
    { date-as-string } = dependency 'platform.Date'

    #

    object-as-string = (object) -> [ ("#{ value-as-string key }: #{ value-as-string value }") for key, value of object ] * ', ' |> braces

    #

    array-as-string = (array) -> [ ("#{ value-as-string item }") for item in array ] * ', ' |> square-brackets

    #

    value-as-string = (value) ->

      switch type-name value

        | 'Object' => object-as-string value
        | 'Array'  => array-as-string value

        | 'Null' => 'null'
        | 'Void' => 'void'
        | 'NaN'  => 'NaN'

        | 'Date' => date-as-string value

        | 'String' => single-quotes value

        | 'Number', 'Boolean' => fallthrough

        else "#value"

    #

    typed-value-as-string = (value) -> "[#{ type-name value }] (#{ value-as-string value })"

    {
      value-as-string,
      typed-value-as-string
    }