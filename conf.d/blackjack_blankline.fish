status is-interactive || return

function _blackjack_blankline

    function _blackjack_blankline_paint
    end

    function _blackjack_blankline_repaint -e fish_postexec -e fish_posterror -e fish_cancel
        printf '\n'
    end

end
