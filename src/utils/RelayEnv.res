exception Graphql_error(string)

let fetchQuery: RescriptRelay.Network.fetchFunctionPromise = (
  operation,
  variables,
  _cacheConfig,
  _uploadables,
) => {
  open Fetch

  fetchWithInit(
    "https://api.github.com/graphql",
    RequestInit.make(
      ~method_=Post,
      ~headers=HeadersInit.make({
        "content-type": "application/json",
        "accept": "application/json",
        "Authorization": `bearer ${Env.graphqlAccessToken}`,
      }),
      ~body=Js.Dict.fromList(list{
        ("query", Js.Json.string(operation.text)),
        ("variables", variables),
      })
      ->Js.Json.object_
      ->Js.Json.stringify
      ->BodyInit.make,
      (),
    ),
  ) |> Js.Promise.then_(res =>
    if Response.ok(res) {
      res->Response.json
    } else {
      Js.Promise.reject(Graphql_error(`Request failed: ${res->Response.statusText}`))
    }
  )
}

let network = RescriptRelay.Network.makePromiseBased(~fetchFunction=fetchQuery, ())

let environment = RescriptRelay.Environment.make(
  ~network,
  ~store=RescriptRelay.Store.make(
    ~source=RescriptRelay.RecordSource.make(),
    ~gcReleaseBufferSize=10,
    (),
  ),
  (),
)
