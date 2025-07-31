status is-interactive || return

function _blackjack_jobs

    function _blackjack_jobs_paint
        if jobs -q
            jobs -l | read last_id __
            jobs | sort | while read job_id __
                set -l cmd (jobs -c %$job_id)
                set -l is_last no
                test "$last_id" = "$job_id" && set is_last yes
                printf ' %s' (_blackjack_format jobs_cmd $cmd $is_last)
                set_color normal
            end
        end
    end

    function _blackjack_jobs_cmd_format_default -a cmd is_last
        switch $is_last
            case yes
                set_color -u magenta
            case '*'
                set_color -d magenta
        end
        printf $cmd
        set_color normal
    end

    functions -c fish_job_summary _blackjack__fish_job_summary

    function fish_job_summary
        emit blackjack_paint jobs
        _blackjack__fish_job_summary
    end

end
