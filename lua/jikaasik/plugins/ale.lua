return {
    'dense-analysis/ale',
    config = function()
        -- Configuration goes here.
        local g = vim.g
        g.ale_sign_column_always = 1
        g.ale_lint_on_save = 1
        g.ale_lint_on_text_changed = 'always'
        g.ale_echo_msg_error_str = 'Error'
        g.ale_echo_msg_warning_str = 'Warning'
        g.ale_sign_error = '●'
        g.ale_sign_warning = '.'
        g.ale_echo_msg_format='[%linter%] %s [%severity%]: [%...code...%]'

        g.ale_linters = {
            ruby = {'rubocop', 'ruby'},
            lua = {'lua_language_server'},
            python = {'flake8'}
        }
    end
}
