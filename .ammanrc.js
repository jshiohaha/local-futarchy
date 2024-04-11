// [source] https://github.com/metaplex-foundation/amman/blob/master/amman/README.md
// [relayer] https://amman-explorer.metaplex.com

// @ts-check
"use strict";

require("dotenv").config();
const path = require("path");
const binaries = require("./config.json");

const { LOCALHOST, tmpLedgerDir } = require("@metaplex-foundation/amman");

const CLUSTER_URL = process.env.CLUSTER_URL;
if (!CLUSTER_URL) {
  throw new Error('Missing required "CLUSTER_URL" environment variable');
} else {
  console.log(`Using CLUSTER_URL = ${CLUSTER_URL}`);
}

const programs = binaries.map((b) => ({
  label: b.program_name,
  programId: b.program_id,
  deployPath: path.join(
    "binaries",
    `${b.program_name.toLowerCase().replace(/\s/g, "_")}.so`
  ),
}));

console.log("setting up validator with programs: ", programs);

const validator = {
  killRunningValidators: true,
  // by default Amman will pull the account data from the accountsCluster (can be overridden on a per account basis)
  accountsCluster: CLUSTER_URL,
  /**
   * specify what accounts to seed the validator with. an example of a program is like:
   *
   * accounts: [
   *    {
   *      label: "Token Metadata Program",
   *      accountId: "metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s",
   *      // marking executable as true will cause Amman to pull the executable data account as well automatically
   *      executable: true,
   *    }
   * ]
   */
  programs,
  commitment: "confirmed",
  resetLedger: true,
  verifyFees: false,
  jsonRpcUrl: LOCALHOST,
  websocketUrl: "",
  ledgerDir: tmpLedgerDir(),
};

module.exports = {
  programs,
  validator,
  relay: {
    enabled: true,
    killlRunningRelay: true,
  },
  storage: {
    enabled: process.env.CI == null,
    storageId: "mock-storage",
    clearOnStart: true,
  },
};
