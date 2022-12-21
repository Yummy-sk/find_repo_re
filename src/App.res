let default = (props: Next.App.props<'a>) => {
  let {component, pageProps} = props

  <RescriptRelay.Context.Provider environment=RelayEnv.environment>
    {React.createElement(component, pageProps)}
  </RescriptRelay.Context.Provider>
}
