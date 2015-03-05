ask     = require "../../../ask"
Promise = require "bluebird"

module.exports = (NodeCfn) ->

  # Gather stack name input for `Aws.Stack.Params`.
  #
  class NodeCfn.Aws.Stack.Input

    # Retrieves image name and `Aws.Stack` object.
    #
    # @param [String] @name base name of the stack
    #
    constructor: (@name) ->
      @stack = new NodeCfn.Aws.Stack()

    # Ask for the user to accept stack name or type a new one.
    #
    # @return [Promise<String>]
    #
    ask: (name) ->
      ask(
        @questionText(name)
        ///(^\s*$|#{@name}-.+)///
      )

    # Generate an unused stack name.
    #
    # @return [Promise<String>]
    #
    generateName: ->
      @stack.listRunning().then (stacks) =>
        name = null

        loop
          name = NodeCfn.NameGen.twerk()
          name = [
            process.env.ENV || "staging"
            @name
            name
          ].join("-")
          
          break unless stacks.filter(
            (stack) -> stack.StackName == name
          ).length

        name

    # Generates a stack name and then asks if that name works.
    #
    # @return [Promise<String>]
    #
    getStackName: ->
      @generateName().then((name) =>
        Promise.props(
          name: name
          new_name: @ask(name)
        )
      ).then (options) =>
        if ///#{@name}-.+///.test(options.new_name)
          options.new_name
        else
          options.name

    # Question text.
    #
    # @param [String] name generated stack name
    # @return [String]
    #
    questionText: (name) ->
      """
      Press enter to accept name "#{name}" or type your own:
      """
