module Fragment = %relay(`
  fragment CardFragment on Repository {
    name
    description
  }
`)

@react.component
let make = (~query) => {
  let {name, description} = Fragment.use(query)

  <div
    className="block mb-4 max-w-sm p-6 bg-white border border-gray-200 rounded-lg shadow-md hover:bg-gray-100 ">
    <h3 className="mb-2 text-2xl font-bold tracking-tight text-gray-900 dark:text-gray-700">
      {name->React.string}
    </h3>
    {switch description {
    | Some(description) =>
      <p className="text-gray-700 dark:text-gray-400"> {description->React.string} </p>
    | None => React.null
    }}
  </div>
}
