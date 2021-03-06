AWS     = require "aws-sdk"
Promise = require "bluebird"

module.exports = (NodeCfn) ->

  # Wrapper for `AWS.CloudFormation`.
  #
  class NodeCfn.Aws.Api.Cfn

    # Promisifies `AWS.CloudFormation`.
    #
    constructor: ->
      @cfn = Promise.promisifyAll(new AWS.CloudFormation())

    # Creates a CloudFormation stack.
    #
    # @param [Object] params parameters to `AWS.CloudFormation#createStack`
    # @return [Promise<Object>]
    # @see http://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/CloudFormation.html#createStack-property
    #
    createStack: (params) ->
      @cfn.createStackAsync(params)

    # Returns the description for a specified stack.
    #
    # @param [Object] params parameters to `AWS.CloudFormation#describeStacks`
    # @return [Promise<Object>]
    # @see http://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/CloudFormation.html#describeStacks-property
    #
    describeStacks: (params) ->
      @cfn.describeStacksAsync(params)

    # List of running CloudFormation stacks.
    #
    # @param [Object] params parameters to `AWS.CloudFormation#listStacks`
    # @return [Promise<Object>]
    # @see http://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/CloudFormation.html#listStacks-property
    # 
    listRunningStacks: ->
      @listStacks(
        StackStatusFilter: [
          "CREATE_IN_PROGRESS"
          "CREATE_FAILED"
          "CREATE_COMPLETE"
          "UPDATE_IN_PROGRESS"
          "UPDATE_COMPLETE_CLEANUP_IN_PROGRESS"
          "UPDATE_COMPLETE"
          "UPDATE_ROLLBACK_IN_PROGRESS"
          "UPDATE_ROLLBACK_FAILED"
          "UPDATE_ROLLBACK_COMPLETE_CLEANUP_IN_PROGRESS"
          "UPDATE_ROLLBACK_COMPLETE"
        ]
      )

    # List of all CloudFormation stacks.
    #
    # @param [Object] params parameters to `AWS.CloudFormation#listStacks`
    # @see http://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/CloudFormation.html#listStacks-property
    # @return [Promise<Object>]
    #
    listStacks: (params) ->
      @cfn.listStacksAsync(params).then (stacks) ->
        stacks.StackSummaries
