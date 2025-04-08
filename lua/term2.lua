local M = {}

M.config = {
    height = 15,
    shell = vim.o.shell,
    keymap = nil
}

M.state = {
    terminal_bufnr = nil,
    terminal_winnr = nil
}

function M.open()
    local is_new_terminal = false

    if not M.state.terminal_bufnr or not vim.api.nvim_buf_is_valid(M.state.terminal_bufnr) then
        M.state.terminal_bufnr = vim.api.nvim_create_buf(false, true)
        is_new_terminal = true
    end

    if M.state.terminal_winnr and vim.api.nvim_win_is_valid(M.state.terminal_winnr) then
        vim.api.nvim_set_current_win(M.state.terminal_winnr)
    else
        vim.cmd('split')
        vim.cmd('wincmd K')
        vim.cmd('resize ' .. M.config.height)

        M.state.terminal_winnr = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(M.state.terminal_winnr, M.state.terminal_bufnr)
    end

    if is_new_terminal then
        vim.fn.termopen(M.config.shell)

        vim.api.nvim_create_autocmd("BufLeave", {
            buffer = M.state.terminal_bufnr,
            callback = function()
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-\\><C-n>', true, true, true), 'n', false)
            end
        })

        vim.api.nvim_buf_set_keymap(M.state.terminal_bufnr, 't', '<Esc>',
            '<C-\\><C-n>', {noremap = true, silent = true})
        vim.api.nvim_buf_set_keymap(M.state.terminal_bufnr, 't', '<C-q>',
            '<C-\\><C-n>:lua require("term2").close()<CR>', {noremap = true, silent = true})
        vim.api.nvim_buf_set_keymap(M.state.terminal_bufnr, 'n', 'q',
            ':lua require("term2").close()<CR>', {noremap = true, silent = true})
    end

    vim.cmd('startinsert')
end

function M.close()
    if M.state.terminal_winnr and vim.api.nvim_win_is_valid(M.state.terminal_winnr) then
        vim.api.nvim_win_close(M.state.terminal_winnr, true)
        M.state.terminal_winnr = nil
    end
end

function M.toggle()
    if M.state.terminal_winnr and vim.api.nvim_win_is_valid(M.state.terminal_winnr) then
        M.close()
    else
        M.open()
    end
end

function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})

    vim.api.nvim_create_user_command("Term2", function()
        M.toggle()
    end, {})

    if M.config.keymap then
        vim.keymap.set('n', M.config.keymap, M.toggle, { silent = true })
    end

    return M
end

return M
