module Fragment = %relay(`
  fragment ListFragment on Query
  @argumentDefinitions(
    query: { type: "String!" }
    count: { type: "Int", defaultValue: 10 }
  ) {
    search(query: $query, first: $count, type: REPOSITORY) {
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
  let response = Fragment.use(query)
  let edges =
    response.search.edges
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
    <button> {"Load more"->React.string} </button>
  </>
}
