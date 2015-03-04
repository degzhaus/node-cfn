requireDirectory = require("require-directory")

# Namespace for `NodeCfn` classes.
#
class NodeCfn

require("./node_cfn/aws")(NodeCfn)
require("./node_cfn/name_gen")(NodeCfn)

module.exports = NodeCfn