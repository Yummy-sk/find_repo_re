module Query = %relay(`
  query ListContainerQuery($query: String!, $count: Int!) {
    ...ListFragment @arguments(query: $query, count: $count)
  }
`)

@react.component
let make = (~value) => {
  let {fragmentRefs} = Query.use(~variables={query: value, count: 5}, ())

  <List query={fragmentRefs} />
}
