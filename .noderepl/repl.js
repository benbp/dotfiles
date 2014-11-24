var lodash = require('lodash');
var repl = require('repl');

var opts = {
    useGlobal: true
};

// Built-in lodash for testing helper functions
var _repl = repl.start(opts);
_repl.context.l = lodash;
// Simple object shortcuts for testing behaviors
_repl.context.obj = {};
_repl.context.arr = [];
_repl.context.str = 'foobar';
_repl.context.cls = function C(prop) { this.prop = prop; };
