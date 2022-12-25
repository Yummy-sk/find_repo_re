let default = (props: Next.App.props<'a>) => {
  let {component, pageProps} = props

  <RescriptReactErrorBoundary fallback={_ => <div> {"error"->React.string} </div>}>
    <RescriptRelay.Context.Provider environment=RelayEnv.environment>
      {React.createElement(component, pageProps)}
    </RescriptRelay.Context.Provider>
  </RescriptReactErrorBoundary>
}
