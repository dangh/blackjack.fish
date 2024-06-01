status is-interactive || return

function _blackjack_node

    function _blackjack_node_paint
        echo -n $nvm_current_version
    end

    function _blackjack_node_repaint -v nvm_current_version
        emit blackjack_paint node
    end

    function _blackjack_node_format_default
        set_color green
        echo -n $argv
    end

end
