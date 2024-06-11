status is-interactive || return

function _blackjack_pwd_truncate
    argparse 'l/length=' -- $argv
    test -n "$_flag_length" || set -l _flag_length 1
    string replace -r -a -- "(\.?[^/]{$_flag_length})[^/]*(/?)" '$1$2' $argv[1]
end

function _blackjack_pwd

    function _blackjack_pwd_paint
        # parse
        set -l pwd $PWD
        switch $pwd
            case $HOME "$HOME/*"
                set -g _blackjack_pwd_home $HOME
                set pwd (string sub -s (math 2+(string length $HOME)) $pwd)
            case '*'
                set -g _blackjack_pwd_home
        end
        if test -n "$_blackjack_pwd_git_root"
            set -g _blackjack_pwd_git_dir (path dirname "$_blackjack_pwd_git_root")
            set -g _blackjack_pwd_git_base (path basename "$_blackjack_pwd_git_root")
            set -g _blackjack_pwd_git_path (string sub -s (math 2+(string length "$_blackjack_pwd_git_root")) $PWD)
            set pwd (string sub -s (math 2+(string length "$_blackjack_pwd_git_root")) $PWD)
            switch $_blackjack_pwd_git_dir
                case $HOME "$HOME/*"
                    set -g _blackjack_pwd_git_dir (string sub -s (math 2+(string length $HOME)) $_blackjack_pwd_git_dir)
            end
        else
            set -g _blackjack_pwd_git_root
            set -g _blackjack_pwd_git_dir
            set -g _blackjack_pwd_git_base
            set -g _blackjack_pwd_git_path
        end
        set -g _blackjack_pwd_dir (path dirname $pwd)
        test "$_blackjack_pwd_dir" = "." && set -g _blackjack_pwd_dir
        set -g _blackjack_pwd_base (path basename $pwd)
        test "$_blackjack_pwd_base" = "$_blackjack_pwd_dir" && set -g _blackjack_pwd_dir

        _blackjack_format pwd_sep / | read -z sep
        set first
        for part in home git_dir git_base dir base
            set var _blackjack_pwd_{$part}
            printf $$var | while read -d / -z dir
                if set -q first
                    set -e first
                else
                    printf $sep
                end
                printf (_blackjack_format pwd_{$part} $dir)
            end
        end
    end

    function _blackjack_pwd_repaint -v PWD
        set -g _blackjack_pwd_git_root (command git --no-optional-locks rev-parse --show-toplevel 2>/dev/null)
        emit blackjack_paint pwd
    end

    function _blackjack_pwd_home_format_default
        set_color green
        printf '〜'
    end

    function _blackjack_pwd_git_dir_format_default
        set_color green
        printf (_blackjack_pwd_truncate -l 2 $argv)
    end

    function _blackjack_pwd_git_base_format_default
        set_color yellow
        printf $argv
    end

    function _blackjack_pwd_dir_format_default
        set_color green
        printf (_blackjack_pwd_truncate -l 2 $argv)
    end

    function _blackjack_pwd_base_format_default
        set_color green
        printf $argv
    end

    function _blackjack_pwd_sep_format_default
        set_color green
        printf /
    end

end
