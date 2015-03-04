var NodeCfn = require("./lib/node_cfn");
var gulp    = require("gulp");
var path    = require("path");

NodeCfn.NameGen.adjectives = [ "beautiful" ];
NodeCfn.NameGen.nouns      = [ "mind" ];

gulp.task("aws:deploy", function () {
	console.log("\nOne moment...\n");
	
	var cfn_path = path.resolve("example/cfn.coffee");
	var stack    = new NodeCfn.Aws.Stack("cfn", cfn_path);

	stack.create().then(console.log);
});
