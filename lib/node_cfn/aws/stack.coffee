module.exports = (NodeCfn) -> 

  # Create and list CloudFormation stacks.
  #
  class NodeCfn.Aws.Stack

    # Initialize `Aws.Api.Cfn`.
    #
    # @param [String] @name stack configuration name
    # @param [String] @config stack configuration
    #
    constructor: (@name, @config) ->
      @api = new NodeCfn.Aws.Api.Cfn()

    # Create a CloudFormation stack.
    #
    # @return [Promise<Object>]
    #
    create: ->
      @params = new NodeCfn.Aws.Stack.Params(@name, @config)
      @params.build().then (params) =>
        @api.createStack(params)

    # List all CloudFormation stacks.
    #
    # @param [Object] params parameters to `AWS.CloudFormation#listStacks`
    # @return [Promise<Object>]
    #
    list: (params) ->
      @api.listStacks(params)

    # List running CloudFormation stacks.
    #
    # @param [Object] params parameters to `AWS.CloudFormation#listStacks`
    # @return [Promise<Object>]
    #
    listRunning: (params) ->
      @api.listRunningStacks(params)

  require("./stack/input")(NodeCfn)
  require("./stack/params")(NodeCfn)
