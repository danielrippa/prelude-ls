
  do ->

    { new-namespace-exception } = dependency 'prelude.Exception'
    { TypeDescriptor, Type } = dependency 'prelude.Type'
    { Object } = dependency 'prelude.Types'
    { object-keys } = dependency 'unsafe.Object'
    { array-size } = dependency 'unsafe.Array'
    { typed-value-as-string } = dependency 'prelude.Value'

    new-exception = new-namespace-exception 'prelude.Parameter'

    Param = (type-descriptor, param) ->

      # It is meant to be used like this: Param <[ String ]> { param1 } in order to avoid verbosity
      # It also makes possible to re-use the TypeDescriptor implementation from Type

      exception = new-exception 'Param'

      try TypeDescriptor type-descriptor
      catch e => throw exception e.message, e

      try Object param
      catch => throw exception "Invalid type of parameter 'param'", e

      keys = object-keys param

      if (array-size keys) < 1
        throw exception "Parameter 'param' must be an object whose only member has the same name and value as the original parameter"

      param-name = keys.0
      param-value = param[ param-name ]

      try Type type-descriptor, param-value
      catch => throw exception "Invalid type of parameter '#param-name' #{ typed-value-as-string param-value }", e

      param-value

    {
      Param
    }
