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

    # Chooses the formatting of the answer.
    #
    # @param [String] type type of question
    # @return [RegExp] the format of the answer
    #
    answerFormat: (type) ->
      switch type
        when "getStackName"
          ///(^\s*$|#{@name}-.+)///
        when "getExistingStack"
          /(\d|\s*)/

    # Ask for the user to accept stack name or type a new one.
    #
    # @return [Promise<String>]
    #
    ask: (type, name) ->
      ask(
        @questionText(type, name)
        @answerFormat(type)
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

    # Allows the user to choose a stack from existing ones.
    #
    # @param [Array<Object>] stacks output from `Stack#listRunning`
    # @return [Promise<Object>] a promise that returns the stack object
    # 
    getExistingStack: (stacks) ->
      console.log ""

      stacks = stacks.filter (stack, index) =>
        [ env, name, release ] = stack.StackName.split("-")
        name == @name

      throw "no stacks found" unless stacks.length

      for stack, index in stacks
        console.log "(#{index})\t#{stack.StackName}\t#{stack.CreationTime}"

      @ask("getExistingStack").then (index) ->
        stacks[parseInt(index)]

    # Generates a stack name and then asks if that name works.
    #
    # @return [Promise<String>]
    #
    getStackName: ->
      @generateName().then((name) =>
        Promise.props(
          name: name
          new_name: @ask("getStackName", name)
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
    questionText: (type, name) ->
      switch type
        when "getStackName"
          """
          Press enter to accept name "#{name}" or type your own:
          """
        when "getExistingStack"
          """
          Enter the number of the stack:
          """
