My system environment configuration using [nix](https://nixos.org/nix/) and [Home Manager](https://github.com/nix-community/home-manager).


#### Setup

After installing `nix` and `home-manager` link the `home.nix` to the location expected by Home Manager:

```
ln -s ~/location/nix-home/home.nix ~/.config/nixpkgs/home.nix
```

You'll want to at least update the `home.username` and `home.homeDirectory` attributes to be accurate for your user.

You can then run normal Home Manager workflow commands, `home-manager edit`, `home-manager switch`.

#### Inspriation

Some more comprehensive examples

* From [yrashk](https://github.com/yrashk/nix-home)
* From [srid](https://github.com/srid/nix-config)

Others can be found at the [NixOS Wiki page for Home Manager](https://nixos.wiki/wiki/Home_Manager).
