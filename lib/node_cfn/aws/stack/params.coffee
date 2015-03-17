path    = require "path"
Promise = require "bluebird"
request = require "request-promise"
fs      = Promise.promisifyAll(require "fs")

module.exports = (NodeCfn) ->

  # Generates parameters for `AWS.CloudFormation#createStack`.
  #
  # @see http://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/CloudFormation.html#createStack-property
  #
  class NodeCfn.Aws.Stack.Params

    # Initializes `AWS.Stack.Input`.
    #
    # @param [String] @name stack configuration name
    # @param [String] @config stack configuration
    #
    constructor: (@name, @config) ->
      @input = new NodeCfn.Aws.Stack.Input(@name)

    # Build `createStack` parameters.
    #
    # @return [Promise<Object>]
    #
    build: ->
      Promise.props(
        discovery_url: @etcdDiscoveryUrl()
        stack_name:    @input.getStackName()
        template:      @cfnTemplate()
      ).then (options) =>
        @stack_name = options.stack_name
        
        StackName:    options.stack_name
        Parameters:   @stackParameters(options)
        TemplateBody: options.template.toString()

    # Reads the CloudFormation template and converts it to JSON.
    #
    # @return [String]
    #
    cfnTemplate: ->
      JSON.stringify(
        (require @cfnTemplatePath())(@name, @config)
        null
        2
      )

    # Resolves the CloudFormation template path.
    #
    # @return [String]
    #
    cfnTemplatePath: ->
      path.resolve(__dirname, @config.cfn)

    # Grab a new etcd discovery URL through the `etcd.io` API.
    #
    # @return [Promise<Object>]
    # @todo move to Etcd
    #
    etcdDiscoveryUrl: ->
      if @config.coreos
        request("https://discovery.etcd.io/new")

    # Generate Parameters value for `Api.Cfn#createStack`.
    #
    # @param [Object] options
    #
    stackParameters: (options) ->
      if @config.coreos
        [
          ParameterKey: "DiscoveryURL"
          ParameterValue: options.discovery_url
        ]
      else
        []
