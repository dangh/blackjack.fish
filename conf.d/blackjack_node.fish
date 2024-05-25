status is-interactive || return

function _blackjack_node

    function _blackjack_node_paint
        set_color green
        echo -n $nvm_current_version
    end

    function _blackjack_node_repaint -v nvm_current_version
        emit blackjack_paint node
    end

end
