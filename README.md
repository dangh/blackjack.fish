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

### Separator

Default separator is a space character. To change it, create function `blackjack_sep` and return the desired string.

```fish
function blackjack_sep
    echo -n " | "
end
```

### Create custom item

There are three parts to create a custom item: init, paint and repaint.

- Init is a function to set up the paint and repaint function. Must be named `_blackjack_<item>`.
- Paint is a function that returns the string to be displayed. Must be named `_blackjack_<item>_paint`.
- Repaint are optional functions that will signal blackjack to repaint the item.

To make blackjack fast, all items are painted only once and cached. Without repaint, your item will never be updated.

Let's create a sample item called `license` to show the license field extracted from package.json of the current directory.

```fish
function _blackjack_license -d 'init license item'

    function _blackjack_license_paint -d 'paint license item'
        # use jq to read license from package.json if exists
        if test -f package.json
            jq -r .license package.json
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
