
  do ->

    { value-as-string } = dependency 'prelude.Value'

    run = (main) -> try main! catch exception => throw new Error value-as-string exception

    {
      run
    }