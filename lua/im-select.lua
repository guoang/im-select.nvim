local M = {}

local im_select_command = ""
local auto_select_normal = true
local auto_select_insert = true

M.im_normal = ""
M.im_insert = ""
M.im_normal_ft = {}
M.im_insert_ft = {}

local function determine_os()
  if vim.fn.has("macunix") == 1 then
    im_select_command = "macism"
    M.im_normal = "com.apple.keylayout.ABC"
    return "macOS"
  elseif vim.fn.has("win32") == 1 then
    -- WSL share same config with Windows
    im_select_command = "im-select.exe"
    M.im_normal = "1033"
    return "Windows"
  elseif vim.fn.has("unix") == 1 and vim.fn.empty("$WSL_DISTRO_NAME") ~= 1 then
    return "WSL"
  else
    return "Linux"
  end
end

M.select_normal_im = function()
  if M.im_normal_ft[vim.bo.filetype] ~= nil then
    vim.fn.jobstart({ im_select_command, M.im_normal_ft[vim.bo.filetype] })
  else
    vim.fn.jobstart({ im_select_command, M.im_normal })
  end
end

M.select_insert_im = function()
  if M.im_insert_ft[vim.bo.filetype] ~= nil then
    vim.fn.jobstart({ im_select_command, M.im_insert_ft[vim.bo.filetype] })
  elseif M.im_insert then
    vim.fn.jobstart({ im_select_command, M.im_insert })
  end
end

M.set_normal_im_auto = function(auto)
  vim.api.nvim_clear_autocmds({ event = "InsertLeave", buffer = 0, group = "im-select" })
  if auto then
    vim.api.nvim_create_autocmd({ "InsertLeave" }, {
      group = "im-select",
      buffer = 0,
      callback = M.select_normal_im,
      desc = "select normal im",
    })
    vim.api.nvim_buf_set_var(0, "im_select_auto_normal", true)
  else
    vim.api.nvim_buf_set_var(0, "im_select_auto_normal", false)
  end
end

M.set_insert_im_auto = function(auto)
  vim.api.nvim_clear_autocmds({ event = "InsertEnter", buffer = 0, group = "im-select" })
  if auto then
    vim.api.nvim_create_autocmd({ "InsertEnter" }, {
      group = "im-select",
      buffer = 0,
      callback = M.select_insert_im,
      desc = "select insert im",
    })
    vim.api.nvim_buf_set_var(0, "im_select_auto_insert", true)
  else
    vim.api.nvim_buf_set_var(0, "im_select_auto_insert", false)
  end
end

M.toggle_normal_im_auto = function()
  local status, auto = pcall(vim.api.nvim_buf_get_var, 0, "im_select_auto_normal")
  if not status then
    M.set_normal_im_auto(not auto_select_normal)
    return
  end
  M.set_normal_im_auto(not auto)
end

M.toggle_insert_im_auto = function()
  local status, auto = pcall(vim.api.nvim_buf_get_var, 0, "im_select_auto_insert")
  if not status then
    M.set_insert_im_auto(not auto_select_insert)
    return
  end
  M.set_insert_im_auto(not auto)
end

M.setup = function(opts)
  local current_os = determine_os()
  -- Linux is not support yet, PR welcome
  if current_os == "Linux" then
    return
  end
  -- Check whether im-select is installed
  if vim.fn.executable(im_select_command) ~= 1 then
    vim.api.nvim_err_writeln(
      [[please install `im-select` binary first, repo url: https://github.com/daipeihust/im-select]]
    )
    return
  end
  -- config
  if opts ~= nil and opts.im_normal ~= nil then
    M.im_normal = opts.im_normal
  end
  if opts ~= nil and opts.im_insert ~= nil then
    M.im_insert = opts.im_insert
  end
  if opts ~= nil and opts.im_normal_ft ~= nil then
    M.im_normal_ft = opts.im_normal_ft
  end
  if opts ~= nil and opts.im_insert_ft ~= nil then
    M.im_insert_ft = opts.im_insert_ft
  end
  if opts ~= nil and opts.auto_select_normal ~= nil then
    auto_select_normal = opts.auto_select_normal
  end
  if opts ~= nil and opts.auto_select_insert ~= nil then
    auto_select_insert = opts.auto_select_insert
  end
  -- set autocmd
  vim.api.nvim_create_augroup("im-select", {})
  if auto_select_normal then
    vim.api.nvim_create_autocmd({ "BufReadPost" }, {
      group = "im-select",
      callback = function() M.set_normal_im_auto(true) end,
      desc = "set auto select normal im",
    })
    -- Dynamically add FileType autocmd for each im_normal_ft filetype
    for ft, _ in pairs(M.im_normal_ft) do
      vim.api.nvim_create_autocmd("FileType", {
        group = "im-select",
        pattern = ft,
        callback = function() M.set_normal_im_auto(true) end,
        desc = "set auto select normal im for " .. ft,
      })
    end
  end
  if auto_select_insert then
    vim.api.nvim_create_autocmd({ "BufReadPost" }, {
      group = "im-select",
      callback = function() M.set_insert_im_auto(true) end,
      desc = "set auto select insert im",
    })
    -- Dynamically add FileType autocmd for each im_insert_ft filetype
    for ft, _ in pairs(M.im_insert_ft) do
      vim.api.nvim_create_autocmd("FileType", {
        group = "im-select",
        pattern = ft,
        callback = function() M.set_insert_im_auto(true) end,
        desc = "set auto select insert im for " .. ft,
      })
    end
  end
  -- keymaps
  vim.keymap.set({ 'n', 'x', 'o' }, "<Plug>ImSelect_toggle_auto_insert", M.toggle_insert_im_auto,
    { silent = true, desc = "Toggle auto select insert im" })
  vim.keymap.set({ 'n', 'x', 'o' }, "<Plug>ImSelect_toggle_auto_normal", M.toggle_normal_im_auto,
    { silent = true, desc = "Toggle auto select normal im" })

  if opts ~= nil and opts.keymaps ~= nil then
    if opts.keymaps.togle_auto_select_normal then
      vim.keymap.set({ 'n' }, opts.keymaps.togle_auto_select_normal, "<Plug>ImSelect_toggle_auto_normal",
        { silent = true, desc = "Toggle auto select normal im" })
    end
    if opts.keymaps.togle_auto_select_insert then
      vim.keymap.set({ 'n' }, opts.keymaps.togle_auto_select_insert, "<Plug>ImSelect_toggle_auto_insert",
        { silent = true, desc = "Toggle auto select insert im" })
    end
  end
end

return M
