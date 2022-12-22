@react.component
let default = () => {
  let (value, setValue) = React.useState(_ => "Hello")

  let onChange = e => setValue(_ => ReactEvent.Form.target(e)["value"])

  let checkStringIsEmpty = str => {
    str == "" ? None : Some(str)
  }

  <div className="b-8 w-full h-screen flex flex-col items-center">
    <Input value={value} onChange={onChange} />
    <React.Suspense fallback={<div> {"loading..."->React.string} </div>}>
      {value
      ->Some
      ->Belt.Option.flatMap(checkStringIsEmpty)
      ->Belt.Option.mapWithDefault(<div> {"No value"->React.string} </div>, _ =>
        <ListContainer value={value} />
      )}
    </React.Suspense>
  </div>
}
