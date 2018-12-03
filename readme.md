# peer-star-infra
> Infrastructure for peer-star and related applications

## Usage

- Ask @protocol/infra for access to the S3 bucket for `peer-star-infra`,
  which is where the tfstate is being hosted
- Ask @protocol/infra for existing .tfvars values
- Copy `terraform.tfvars.dist` to `terraform.tfvars`
- Modify `terraform.tfvars` with the values received in step two
- Run `terraform plan` to ensure no changes are pending

### Deploying changes

Once you're ready to deploy changes, just do `terraform apply`, make sure
the changes are right, then write `yes` and it'll be applied.

## Adding a new pinner

The basic configuration of a pinner needs at least `name`, `swarm_address` and `app_name`.

- `name` is the name of the application in Heroku. You'll need this later so keep it in mind
- `swarm_address` is which rendezvous server your pinner will be connected to. Make sure it's the same as the peer-star application you're building is using, otherwise they won't be able to find each other.
- `app_name` is your peer-star application name.

Once you have these values, add the following snippet to the `main.tf` file, replacing `$name` and the rest with your values:

```hcl
module "$name" {
  source  = "./pinner"
  name = "$name"
  swarm_address = "$swarm_address"
  app_name = "$app_name"
}

```
Then run `terraform apply` and answer `yes` after making sure it's correct. You should now have a new instance deployed on Heroku that you can deploy a new pinner to.

## Adding configuration to `peer-star-app` for CD deployments

Now the final step. You need to add another value for making Travis deploying the Pinner to Heroku when master changes.

Take a look at the bottom of https://github.com/ipfs-shipyard/peer-star-app/blob/master/.travis.yml and add the following snippet, again replacing the `$name` variables with your values.

```
  - provider: heroku
    app: $name
    after_deploy: PEER_STAR_SWARM_ADDRESS=$swarm_address PEER_STAR_APP_NAME=$app_name npm run post-deploy
    api_key:
secure: iWcuNFe6WMs3cTHbeOxhCX4Te+sL+R/vPrhWcAnhwVvbq2OTwmq2pxQ+CL8Py8N494F7HNyl/muWePUJvfFsvIlNkMx13Jl24FMyf2zn/sQ6m8H7qjaz9McGSTq7znf80vX9YAZPexnAV9SdtIpzJc37I3WzJwkkNY2EQKt4QwCTALIagcec5pcA6kYvSJsbxSPaH0oPM69gVDDRJwTRE9+aryj+stLqCVPZ8nN6ze9dvSbGmVNcbAf7sTrrlWOgbazrzpjAZxfTLmkCNb5Dlqx+pkl4uQ4h4EpP0XtI2XKQwJuovhf5P0fok/WKV1Um0rYfbsLisgPI1UmUPq8UUvSUVz07VtsNkKcBkamQC7VtX+jrPct3n0tkXV//YcF3EkCQ/lHAlDhR7lkQWqm8bMX/07EQyAfMhUDOG2coEvKKW++W2ZzlMQv7nFHg4LWoO0Uw25Gsco4CxuXLdqtFAuuQM67eKhIMmBWKwdGEe19tWi689ugmcUkt+gGriMuTiZdeK6tYheWk5m4o49vxscc8RrbdMUJNCWWvFTYJMktfEAJ8mpvyVI80p1pN+GIuEqqaTAi5vJjcPkocv49Y0gKECSZgzQPXk5bgBwEk0wvFjONORzrNnyH6EfVzqCHlQc7l5ctxOy0X3l9AdcBcCj2qsG1rIYXVuPd/DGvaowg=
```

Create a PR with your changes, and once it's merged, the pinner should now work correctly!

# License

MIT License

Copyright (c) 2018 IPFS Shipyard

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
