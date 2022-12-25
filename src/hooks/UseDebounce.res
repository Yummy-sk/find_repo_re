let useDebounce = (func: 'a => 'b, delay) => {
  let timeoutId = React.useRef(None)

  React.useCallback2(args => {
    switch timeoutId.current {
    | Some(id) => Js.Global.clearTimeout(id)
    | None => ()
    }

    timeoutId.current = Some(Js.Global.setTimeout(() => {
        func(args)
        timeoutId.current = None
      }, delay))
  }, (func, delay))
}
