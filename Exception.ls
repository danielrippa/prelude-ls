
  do ->

    new-namespace-exception = (qualified-namespace) ->

      (context) ->

        (message, cause) ->

          throw { qualified-namespace, context, message, cause }


    {
      new-namespace-exception
    }