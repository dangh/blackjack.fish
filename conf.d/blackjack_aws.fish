status is-interactive || return

function _blackjack_aws

    function _blackjack_aws_paint
        printf $AWS_PROFILE
    end

    function _blackjack_aws_repaint -v AWS_PROFILE
        emit blackjack_paint aws
    end

    function _blackjack_aws_format_default -a profile
        switch $profile
            case DEV
                set_color cyan
            case DEV-IN
                set_color magenta
            case TEST
                set_color blue
            case STAGE
                set_color yellow
            case PROD
                set_color red
        end
        printf $profile
    end

end
