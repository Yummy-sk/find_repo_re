module Query = %relay(`
  query ListContainerQuery($query: String!, $count: Int!) {
    ...ListFragment @arguments(query: $query, count: $count)
  }
`)

@react.component
let make = (~keyWord) => {
  let {fragmentRefs} = Query.use(~variables={query: keyWord, count: 5}, ())

  <List query={fragmentRefs} />
}
