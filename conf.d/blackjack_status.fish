status is-interactive || return

function _blackjack_status

    function _blackjack_status_paint
        for code in $_blackjack_status
            if test $code -ne 0
                set_color red
                echo -n '|' $_blackjack_status
                break
            end
        end
        set -e _blackjack_status
    end

    function _blackjack_status_repaint -e fish_postexec
        set -g _blackjack_status $pipestatus
        emit blackjack_paint status
    end

end