AWS = require "aws-sdk"
fs  = require "fs"

module.exports = (NodeCfn) -> 

  # Namespace for Aws classes. Also stores `.aws` configuration
  # and updates the `AWS.config` region.
  #
  class NodeCfn.Aws

    # Updates the `AWS.config` region.
    #
    # @param [String] region the AWS region to use
    # @note this method executes when the library is required
    #
    @updateRegion: (region) ->
      AWS.config.update(region: region)

  NodeCfn.Aws.updateRegion(process.env.AWS_REGION || "us-west-1")

  require("./aws/api")(NodeCfn)
  require("./aws/stack")(NodeCfn)
