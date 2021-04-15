# Screenplay for #3

## Brief

The following is a brief introduction on how to start coding in the mess that is the OCaml ecossystem.

You can call me Eduardo and I will be helping you to setup an OCaml environment ... TODO: joke with trying

## Introduction??

### What will you need?

To do that, you will need a couple of tools, they're. The OCaml compiler. A build system. And a language server for VSCode, because no one deserves to code without autocomplete. Everything can be installed through a package manager, so you just get the package manager and that should be it.

For this video we will be using `esy`, an "easy" package manager for OCaml, mostly because it simplifies the life of Windows users a lot.

### Windows Warning

Warning, if you're using windows, I'm sorry for you. Ok, seriously, if you're using windows everything here must be executed as admin, because "windows bad", to run VSCode as admin you need to close all VSCode windows and execute it as admin.

### Installing esy

To install esy, you're going to need the node package manager and git installed. If you have both, you can just put

```sh
npm install --global esy
```

on your terminal.t should take a couple of seconds. But that's it.

## Install project

After that you can just clone my example project on github,

```sh
git clone https://github.com/EduardoRFS/youtube-channel.git
```

Enter the folder `03-coding-ocaml-on-vscode/hello`

```sh
cd youtube-channel/03-coding-ocaml-on-vscode/hello
```

And call `esy`

```sh
esy
```

The first time running `esy` it will install everything that we need, so it will take a couple of minutes, but on subsequent executions everything is cached, so it should be quite fast. On windows it may take a long time and you need to run your VSCode and terminal as an admin.

To check if everything is working, you can call

```sh
esy start
```

If you see `Tu tu ru~ Mayushii desu!`, that means everything is working and we can now setup VSCode.

## VSCode

You should go to your VSCode and install the extension "OCaml Platform". That's it, now you can open the example project on VSCode, open the file `Hello.ml` and you should have everything working, autocomplete, types when you hover some identifier and in-editor typechecking.

## Ending

Yeah, now you can play with OCaml, like a prefessional. If you have any question send a comment below, something something like and subscribe.
