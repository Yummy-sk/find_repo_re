type env = {"NEXT_PUBLIC_ACCESS_TOKEN": string}

@val external env: env = "process.env"

let graphqlAccessToken = env["NEXT_PUBLIC_ACCESS_TOKEN"]
