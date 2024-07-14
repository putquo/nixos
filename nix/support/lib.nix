{ cell, inputs }:
let
  haumea =
    let
      # Ignore "default.nix" files when loading.
      excludingDefault = name:
        name != "default.nix";
      # Given a path, determine the file name without the last file extension.
      filenameFrom = path:
        inputs.nixpkgs.lib.lists.last
          (inputs.nixpkgs.lib.strings.splitString "/" (removeNixExtensionFrom path));
      # A "named" haumea loader that provides the current file name to the file being loaded.
      named.loader = loaderInputs: path:
        inputs.haumea.lib.loaders.default
          (loaderInputs // { name = filenameFrom path; })
          path;
      # All ".nix" files, except "default.nix".
      named.matches = excludingDefault;
      # Remove the ".nix" suffix from a stringified path.
      removeNixExtensionFrom = path:
        inputs.nixpkgs.lib.removeSuffix ".nix"
          (builtins.toString path);
    in
    {
      loaders = { inherit excludingDefault; };
      matchers = { inherit named; };
    };
in
{
  # A custom haumea load function that provides the name of the file being loaded.
  load.named = { block, cell, inputs }:
    inputs.haumea.lib.load
      {
        inputs = { inherit cell inputs; };
        loader = [ haumea.matchers.named ];
        src = block;
      };
}
