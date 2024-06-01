status is-interactive || return

function _blackjack_paint_item -e blackjack_paint -a item
    set paint _blackjack_{$item}_paint
    functions -q "$paint" && begin
        _blackjack_format $item ($paint) | read -gz _blackjack_painted__{$item}
        emit blackjack_paint__{$item}
    end
end

function _blackjack_format -a item
    set value $argv[2..-1]
    test -n "$value" || return
    set format _blackjack_{$item}_format
    functions -q "$format" || set format _blackjack_{$item}_format_default
    if functions -q "$format"
        $format $value
        set_color normal
    else
        printf $value
    end
end

function blackjack
    test -n "$argv" || return

    set preset (string escape --style var -- $argv | string join _)
    set items $argv
    set live_items

    # init items
    for item in $items
        set init _blackjack_{$item}
        functions -q "$init" && begin
            $init
            functions -e $init
            set -a live_items $item

            set repaint _blackjack_{$item}_repaint
            functions -q "$repaint" && begin
                # run repaint function once
                function {$repaint}_once -e $repaint -a repaint
                    $repaint >/dev/null
                end
                emit $repaint $repaint
                functions -e {$repaint}_once
            end
        end
    end

    function _blackjack_paint__{$preset} '-eblackjack_paint__'$live_items -V items -V preset
        # paint separator
        _blackjack_format sep ' ' | read -z sep

        # paint items
        set painted_items
        for item in $items
            set painted_item _blackjack_painted__{$item}
            if set -q $painted_item 2>/dev/null
                test -n "$$painted_item" && set -a painted_items $$painted_item
            else
                set -a painted_items $item
            end
        end
        string join '\x1b[0m'$sep -- $painted_items | read -gz _blackjack_painted__{$preset}

        # repaint prompt
        commandline -f repaint
    end

    # initial paint
    for item in $items
        _blackjack_paint_item $item
    end

    # return painter function
    set painter _blackjack_painter__{$preset}
    set painted _blackjack_painted__{$preset}
    eval "function $painter
        printf \$$painted
    end"
    printf $painter
end
