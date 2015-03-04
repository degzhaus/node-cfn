module.exports = (NodeCfn) -> 

  # Namespace for Aws.Api classes.
  #
  class NodeCfn.Aws.Api

  require("./api/cfn")(NodeCfn)
  require("./api/ec2")(NodeCfn)