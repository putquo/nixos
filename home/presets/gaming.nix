{ config, lib', ... }: with lib'; templated.preset "gaming" {
  inherit config;
  whenEnabled = { };
}
