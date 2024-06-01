status is-interactive || return

function _blackjack_cmd_duration

    set -g _blackjack_cmd_duration_threshold 1000
    set -g _blackjack_cmd_duration 0

    function _blackjack_cmd_duration_paint
        test "$_blackjack_cmd_duration" -lt "$_blackjack_cmd_duration_threshold" && return

        set s (math -s 1 $_blackjack_cmd_duration/1000 % 60)
        set m (math -s 0 $_blackjack_cmd_duration/60000 % 60)
        set h (math -s 0 $_blackjack_cmd_duration/3600000)

        test "$h" -gt 0 && set -a out {$h}h
        test "$m" -gt 0 && set -a out {$m}m
        test "$s" -gt 0 && set -a out {$s}s

        printf (string join ' ' $out)
    end

    function _blackjack_cmd_duration_repaint -e fish_postexec
        test "$CMD_DURATION" -lt "$_blackjack_cmd_duration_threshold" -a "$_blackjack_cmd_duration" -lt "$_blackjack_cmd_duration_threshold" && return
        set -g _blackjack_cmd_duration $CMD_DURATION
        emit blackjack_paint cmd_duration
    end

    function _blackjack_cmd_duration_format_default
        set_color yellow
        printf $argv
    end

end
