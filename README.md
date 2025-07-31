![Blackjack and hookers meme](https://github.com/dangh/blackjack.fish/assets/1020347/69e5311c-9982-4063-a711-9d27192129cc)

# blackjack.fish

## Installation

```fish
fisher install dangh/blackjack.fish
```

## Usage

To build prompts with blackjack, add the following to your `~/.config/fish/config.fish`:

```fish
alias fish_prompt=(blackjack pwd status)
alias fish_right_prompt=(blackjack cmd_duration)
```

## Customization

### Builtin items customization

Builtin items shipped with default format. To change it, create the `_blackjack_<item>_format` function and print the desired string.
List of builtin format functions:

- `_blackjack_sep_format`: separator between items, default is a white space character
- `_blackjack_pwd_format`: current working directory
- `_blackjack_pwd_home_format`: user home directory, default is `〜`
- `_blackjack_pwd_git_dir_format`: dirname of the git repository, without the home directory prefix if exists. Truncated to 2 characters by default.
- `_blackjack_pwd_git_base_format`: basename of the git directory
- `_blackjack_pwd_dir_format`: dirname of the current directory. Truncated to 2 characters by default.
- `_blackjack_pwd_base_format`: basename of the current directory
- `_blackjack_status_format`: status code of the last command
- `_blackjack_cmd_duration_format`: duration of the last command
- `_blackjack_aws_format`: current AWS profile, read from `$AWS_PROFILE`
- `_blackjack_node_format`: current NodeJS version, read from `$nvm_current_version`
- `_blackjack_jobs_cmd_format`: command of background jobs

### Create custom item

There are three parts to create a custom item: init, paint and repaint.

- Init is a function to set up the paint and repaint function. Must be named `_blackjack_<item>`.
- Paint is a function that returns the string to be displayed. Must be named `_blackjack_<item>_paint`.
- Repaint are optional functions that will signal blackjack to repaint the item. Must be named `_blackjack_<item>_repaint`.

To make blackjack fast, all items are painted only once and cached. Without repaint, your item will never be updated.

Let's create a sample item called `license` to show the license field extracted from the package.json of the current directory.

```fish
function _blackjack_license -d 'init license item'

    function _blackjack_license_paint -d 'paint license item'
        # use jq to read license from package.json if exists
        if test -f package.json
            jq -j -r .license package.json
        end
    end

    function _blackjack_license_repaint -v PWD -d 'repaint license item when changing directory'
        # signal blackjack to repaint the license item
        emit blackjack_paint license
    end

end

# now we can add it to our prompt
alias fish_prompt=(blackjack pwd license status)
```

It works perfectly and blazing fast. But let’s say the package.json file is ridiculously huge, every paint will be noticable slow.

We can fake the slowness by adding a sleep command to the paint function. Now the first prompt took 2 seconds to show up. And everytime we cd into a directory with package.json file, it will take 2 seconds to repaint the prompt.

```fish
function _blackjack_license_paint
    if test -f package.json
        sleep 2
        jq -j -r .license package.json
    end
end
```

Let's see the test results:

```fish
$ time blackjack license
_blackjack_painter__license
________________________________________________________
Executed in    2.02 secs      fish           external
   usr time    5.76 millis    1.13 millis    4.63 millis
   sys time    6.62 millis    2.49 millis    4.13 millis
```

To overcome this, we can leverage repaint function. It will do the heavy lifting in the background and redraw the prompt when it’s done. Initialy the license item will not be shown, but it's a small trade-off for the responsiveness.

```fish
function _blackjack_license_paint
    # read the license from the cache
    printf $_blackjack_licence
end

function _blackjack_license_repaint -v PWD
    # use global var to cache the license
    set -g _blackjack_licence

    # use jq to read license from package.json if exists. Cache the result in $_blackjack_license
    if test -f package.json
        sleep 2
        set -g _blackjack_license (jq -j -r .license package.json)
    end

    # signal blackjack to repaint the license item
    emit blackjack_paint license
end
```

Let's see the result again:

```fish
$ time blackjack license
_blackjack_painter__license
________________________________________________________
Executed in  630.00 micros    fish           external
   usr time  459.00 micros  459.00 micros    0.00 micros
   sys time  183.00 micros  183.00 micros    0.00 micros
```
