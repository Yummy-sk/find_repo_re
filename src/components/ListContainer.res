module Query = %relay(`
  query ListContainerQuery($query: String!, $count: Int!, $cursor: String) {
    ...ListFragment @arguments(query: $query, count: $count, cursor: $cursor)
  }
`)

@react.component
let make = (~value) => {
  let {fragmentRefs} = Query.use(~variables={query: value, count: 5}, ())

  <List query={fragmentRefs} />
}
