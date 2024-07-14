{ cell, inputs }@_stdArgs:
inputs.cells.support.lib.load.named {
  inherit cell inputs;
  block = ./.;
}
