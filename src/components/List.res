module Fragment = %relay(`
  fragment ListFragment on Query
  @refetchable(queryName: "ListQuery")
  @argumentDefinitions(
    query: { type: "String!" }
    count: { type: "Int", defaultValue: 10 }
    cursor: { type: "String" }
  ) {
    search(query: $query, first: $count, type: REPOSITORY, after: $cursor)
      @connection(key: "Repos_search") {
      repositoryCount
      edges {
        cursor
        node {
          ...CardFragment
        }
      }
    }
  }
`)

@react.component
let make = (~query) => {
  let count = 5
  let {data, hasNext, isLoadingNext, loadNext} = Fragment.usePagination(query)
  let edges =
    data.search.edges
    ->Belt.Option.getWithDefault([])
    ->Belt.Array.keepMap(Belt.Option.map(_, edge => (edge.node, edge.cursor)))

  <>
    <ul className="w-96 mt-5">
      {edges
      ->Belt.Array.map(((node, cursor)) =>
        <li key={cursor}>
          {switch node {
          | Some(node) => <Card query={node.fragmentRefs} />
          | None => <div />
          }}
        </li>
      )
      ->React.array}
    </ul>
    {switch (hasNext, isLoadingNext) {
    | (true, true) => <div> {"Loading..."->React.string} </div>
    | (true, false) =>
      <button onClick={_ => loadNext(~count, ())->ignore}> {"Load more"->React.string} </button>
    | (false, _) => <div> {"No more results"->React.string} </div>
    }}
  </>
}
