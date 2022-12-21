module Fragment = %relay(`
  fragment ListFragment on Query {
    search(query: $query, first: $count, type: REPOSITORY) {
      repositoryCount
    }
  }
`)

@react.component
let make = (~query) => {
  let response = Fragment.use(query)

  response->Js.log

  <div> {"good"->React.string} </div>
}
