@react.component
let default = () => {
  let (keyWord, setKeyword) = React.Uncurried.useState(_ => "Hello")
  let (value, setValue) = React.Uncurried.useState(_ => keyWord)

  let onSubmit = e => {
    e->ReactEvent.Form.preventDefault
    setKeyword(._ => value)
  }

  let onChange = e => setValue(._ => ReactEvent.Form.target(e)["value"])

  let checkStringIsEmpty = str => {
    str == "" ? None : Some(str)
  }

  <div className="b-8 w-full h-screen flex flex-col items-center">
    <Input value={value} onSubmit={onSubmit} onChange={onChange} />
    <React.Suspense fallback={<div> {"loading..."->React.string} </div>}>
      {keyWord
      ->Some
      ->Belt.Option.flatMap(checkStringIsEmpty)
      ->Belt.Option.mapWithDefault(<div> {"No value"->React.string} </div>, _ =>
        <ListContainer keyWord={keyWord} />
      )}
    </React.Suspense>
  </div>
}
