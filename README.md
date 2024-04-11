<div>
    <div align="center">
        <img src="./assets/banner.png" />
    </div>
</div>

## Description

This is a simple utility repository to help spin up a test validator with all the programs required to run MetaDAO's futarchy tooling. See [solana-test-validator](https://docs.solanalabs.com/cli/examples/test-validator) for more information on how the test validator works.

Once the local validator is up and running, you should be able to execute transactions directly against the endpoint `http://127.0.0.1:8899`.

### Programs

The configuration for the programs that are loaded onto the validator can be found in the [local configuration file](./config.json). The binaries are located in the [./binaries/](./binaries/) directory.

For quick reference, here are the included programs with links to their respective Github repositories:

| Program             | Owned by MetaDAO | Github                                                    |
| :------------------ | :--------------- | :-------------------------------------------------------- |
| `Autocrat V0`       | Yes              | https://github.com/metaDAOproject/futarchy                |
| `Conditional Vault` | Yes              | https://github.com/metaDAOproject/futarchy                |
| `Openbook TWAP`     | Yes              | https://github.com/metaDAOproject/openbook-twap           |
| `Openbook v2`       | No               | https://github.com/openbook-dex/openbook-v2               |
| `MPL Metadata`      | No               | https://github.com/metaplex-foundation/mpl-token-metadata |

## Getting Started

### Dependencies

You will need to make sure the following are installed:

- **Solana CLI**: Amman  https://docs.solanalabs.com/cli/install
- **jq**: The [dump_binaries.sh](./scripts/dump_binaries.sh) script uses `jq` to parse program configuration in [config.json](./config.json). Download details here: https://jqlang.github.io/jq/download. Homebrew users can install the package with command `brew install jq`.

### Package Manager Dependencies

After the above are installed, you will need to install the javascript dependencies as specified in [package.json](./package.json)via running `yarn install`.

### Environment variables

The easiest way to set and forget environment variables is by adding a `.env` file at this repository root.

**Required environment variables**
- CLUSTER_URL: The [dump_binaries.sh](./scripts/dump_binaries.sh) script and the [amman.js](./.ammanrc.js) configuration rely on the `CLUSTER_URL` environment variable. This varialbe will inform the code what RPC (and cluster) to use.

### Usage

You can quicly check command shortcuts listed in the [package.json](./package.json) scripts section. Or, if you don't want to leave the CLI, you can run `yarn run` to list the available commands. 

#### Refresh binaries

Run the command: `yarn dump-binaries`. You should see output in the console like

```bash
[Cluster = https://api.mainnet-beta.solana.com] Dumping binary for program Conditional Vault (id = vAuLTQjV5AZx5f3UgE75wcnkxnQowWxThn1hGjfCVwP) to file: ./binaries/conditional_vault.so
Wrote program to ./binaries/conditional_vault.so

...
```

You can also manually override what binaries are included if you copy new binaries into the [./binaries/](./binaries/) directory. This might be useful if you're quickly iterating on changes that aren't published to a remote cluster. As soon as the build process produces a new `.so` binary, you can include it in the programs that are seeded onto the test validator when it starts up. However, you will have to stop and re-start the underlying validator process in this case so that the changes are picked up.

❗ **Note**: If you are not able to execute the dump binaries script, you might need to mark it as executable: `chmod +x ./scripts/dump_binaries.sh`

#### Start the validator

Run `yarn start-validator`

❗ **Note**: This command will fail if there is another instance of a local validator running on your computer.

#### Stop the validator

Run `yarn stop-validator` in a tab where the validator process isn't running.

❗ **Note**: You can also just quickly use this keyboard shortcut (`ctrl + c`) to stop the validator in the same tab in which it is currently running.