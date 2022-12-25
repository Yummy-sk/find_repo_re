type state = Loading | LoadMore | NoResult

module Fragment = %relay(`
  fragment ListFragment on Query
  @refetchable(queryName: "ListQuery")
  @argumentDefinitions(
    query: { type: "String!" }
    count: { type: "Int", defaultValue: 5 }
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

  let map2 = (xs, ys, f) => xs->Belt.Option.flatMap(x => ys->Belt.Option.map(y => f(x, y)))

  let edges =
    data.search.edges
    ->Belt.Option.getWithDefault([])
    ->Belt.Array.reduce(Some([]), (acc, edge) =>
      map2(acc, edge, (acc, edge) => acc->Belt.Array.concat([edge]))
    )
    ->Belt.Option.mapWithDefault([], edges =>
      edges->Belt.Array.keepMap(({node, cursor}) => node->Belt.Option.map(node' => (node', cursor)))
    )

  let getStatus = (hasNext, isLoadingNext) => {
    switch (hasNext, isLoadingNext) {
    | (true, true) => Loading
    | (true, false) => LoadMore
    | (false, _) => NoResult
    }
  }

  <>
    <ul className="w-96 mt-5">
      {edges
      ->Belt.Array.map(((node, cursor)) =>
        <li key={cursor}>
          <Card query={node.fragmentRefs} />
        </li>
      )
      ->React.array}
    </ul>
    {switch getStatus(hasNext, isLoadingNext) {
    | Loading => <div> {"Loading..."->React.string} </div>
    | LoadMore =>
      <button onClick={_ => loadNext(~count, ())->ignore}> {"Load more"->React.string} </button>
    | NoResult => <div> {"No more results"->React.string} </div>
    }}
  </>
}
