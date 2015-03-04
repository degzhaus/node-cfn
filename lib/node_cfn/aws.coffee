AWS = require "aws-sdk"
fs  = require "fs"

module.exports = (NodeCfn) -> 

  # Namespace for Aws classes. Also stores `.aws` configuration
  # and updates the `AWS.config` region.
  #
  class NodeCfn.Aws

    # Updates the `AWS.config` region.
    #
    # @note this method executes when the library is required
    #
    @updateRegion: ->
      AWS.config.update(
        region: process.env.AWS_REGION || "us-west-1"
      )

  NodeCfn.Aws.updateRegion()

  require("./aws/api")(NodeCfn)
  require("./aws/stack")(NodeCfn)
