@react.component
let default = () => {
  let (value, setValue) = React.useState(_ => "Hello")

  let onChange = e => setValue(_ => ReactEvent.Form.target(e)["value"])

  <div className="b-8 w-full h-screen flex flex-col items-center">
    <Input value={value} onChange={onChange} />
  </div>
}
