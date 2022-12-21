module Req = {
  type t = {"headers": {"user-agent": string}}

  @set external setRelayEnv: (t, RescriptRelay.Environment.t) => unit = "relayEnv"
  @get external getRelayEnv: t => RescriptRelay.Environment.t = "relayEnv"
}

module Res = {
  type t

  @send external setHeader: (t, string, string) => unit = "setHeader"
  @send external write: (t, string) => unit = "write"
  @send external end: t => unit = "end"
}

module GetServerSideProps = {
  // See: https://github.com/zeit/next.js/blob/canary/packages/next/types/index.d.ts
  type context<'props, 'params, 'previewData> = {
    params: 'params,
    query: Js.Dict.t<string>,
    preview: option<bool>, // preview is true if the page is in the preview mode and undefined otherwise.
    previewData: Js.Nullable.t<'previewData>,
    req: Req.t,
    res: Res.t,
  }

  // The definition of a getServerSideProps function
  type t<'props, 'params, 'previewData> = context<'props, 'params, 'previewData> => Js.Promise.t<{
    "props": 'props,
  }>
}

module GetStaticProps = {
  // See: https://github.com/zeit/next.js/blob/canary/packages/next/types/index.d.ts
  type context<'props, 'params, 'previewData> = {
    params: 'params,
    preview: option<bool>, // preview is true if the page is in the preview mode and undefined otherwise.
    previewData: Js.Nullable.t<'previewData>,
  }

  // The definition of a getStaticProps function
  type t<'props, 'params, 'previewData> = context<'props, 'params, 'previewData> => Js.Promise.t<{
    "props": 'props,
  }>
}

module GetStaticPaths = {
  // 'params: dynamic route params used in dynamic routing paths
  // Example: pages/[id].js would result in a 'params = { id: string }
  type path<'params> = {params: 'params}

  type return<'params> = {
    paths: array<path<'params>>,
    fallback: bool,
  }

  // The definition of a getStaticPaths function
  type t<'params> = unit => Js.Promise.t<return<'params>>
}

module App = {
  type props<'pageProps> = {
    @as("Component")
    component: React.component<'pageProps>,
    mutable pageProps: 'pageProps,
  }

  type ctx = {
    query: Js.Dict.t<string>,
    req: option<Req.t>,
    res: option<Res.t>,
  }

  type context<'pageProps> = {ctx: ctx}

  // The definition of a _app.getInitialProps function
  type t<'pageProps> = context<'pageProps> => Js.Promise.t<props<'pageProps>>

  @module("next/app") @scope("default")
  external getInitialProps: t<'pageProps> = "getInitialProps"
}

module Link = {
  @module("next/link") @react.component
  external make: (
    ~href: string,
    ~_as: string=?,
    ~prefetch: bool=?,
    ~replace: option<bool>=?,
    ~scroll: option<bool>=?,
    ~shallow: option<bool>=?,
    ~passHref: option<bool>=?,
    ~children: React.element,
  ) => React.element = "default"
}

module Router = {
  /*
      Make sure to only register events via a useEffect hook!
 */
  module Events = {
    type t

    @send
    external on: (
      t,
      @string
      [
        | #routeChangeStart(string => unit)
        | #routeChangeComplete(string => unit)
        | #hashChangeComplete(string => unit)
      ],
    ) => unit = "on"

    @send
    external off: (
      t,
      @string
      [
        | #routeChangeStart(string => unit)
        | #routeChangeComplete(string => unit)
        | #hashChangeComplete(string => unit)
      ],
    ) => unit = "off"
  }

  type router = {
    route: string,
    asPath: string,
    events: Events.t,
    pathname: string,
    query: Js.Dict.t<string>,
    isReady: bool,
  }

  type pathObj = {
    pathname: string,
    query?: Js.Dict.t<string>,
    hash?: string,
  }

  @send external push: (router, string) => unit = "push"
  @send external pushObj: (router, pathObj) => unit = "push"
  @send external pushAs: (router, string, string) => unit = "push"
  @send
  external pushWithOption: (router, pathObj, option<string>, ~options: {..}) => unit = "push"
  @send external reload: (router, string) => unit = "reload"

  @send external back: router => unit = "back"

  @module("next/router") external useRouter: unit => router = "useRouter"

  @send external replace: (router, string) => unit = "replace"
  @send external replaceObj: (router, pathObj) => unit = "replace"
  @send
  external replaceWithOption: (router, pathObj, option<string>, ~options: {..}) => unit = "replace"

  let replaceShallow = (router, pathObj) => {
    replaceWithOption(router, pathObj, None, ~options={"shallow": true})
  }
  let pushShallow = (router, pathObj) => {
    pushWithOption(router, pathObj, None, ~options={"shallow": true})
  }
}

module Head = {
  @module("next/head") @react.component
  external make: (~children: React.element) => React.element = "default"
}

module Error = {
  @module("next/error") @react.component
  external make: (~statusCode: int, ~children: React.element) => React.element = "default"
}

module Dynamic = {
  @deriving(abstract)
  type options = {
    @optional
    ssr: bool,
    @optional
    loading: unit => React.element,
  }

  @module("next/dynamic")
  external dynamic: (unit => Js.Promise.t<'a>, options) => 'a = "default"

  @val external import_: string => Js.Promise.t<'a> = "import"
}

module Image = {
  type placeholder = [#blur | #empty]

  type layout = [#intrinsic | #fixed | #responsive | #fill]

  type objectFit = [#fill | #contain | #cover | #none]

  @module("next/image") @react.component
  external make: (
    ~src: string,
    ~placeholder: placeholder=?,
    ~blurDataURL: string=?,
    ~alt: string=?,
    ~width: int=?,
    ~height: int=?,
    ~loader: (~src: string, ~width: int, ~height: int) => string=?,
    ~className: string=?,
    ~layout: layout=?,
    ~objectFit: objectFit=?,
    ~priority: bool=?,
  ) => React.element = "default"
}

module Script = {
  @module("next/script") @react.component
  external make: (~src: string, ~strategy: string=?) => React.element = "default"
}
