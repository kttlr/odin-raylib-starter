local function get_os()
  if vim.uv and vim.uv.os_uname then
    local uname = vim.uv.os_uname()
    if uname.sysname == "Windows_NT" then
      return "Windows"
    elseif uname.sysname == "Darwin" then
      return "OSX"
    elseif uname.sysname == "Linux" then
      return "Linux"
    end
  end
  return jit and jit.os or "Unknown"
end

vim.api.nvim_create_user_command("BuildHotReload", function()
  local os_name = get_os()
  local cmd = os_name == "Windows" and "build_hot_reload.bat run" or "./build_hot_reload.sh run"

  local tmp_file = os.tmpname()
  local full_cmd = cmd .. " > " .. tmp_file .. " 2>&1"

  local exit_code = os.execute(full_cmd)

  -- if there is an error, it outputs to a new split
  if exit_code ~= 0 then
    vim.cmd("botright split | view " .. tmp_file .. " | resize 10")
  else
    vim.notify("Hot reload build completed successfully", vim.log.levels.INFO)
  end

  os.remove(tmp_file)
end, {})

vim.keymap.set("n", "<F5>", ":BuildHotReload<CR>", { noremap = true, silent = true })
vim.notify("Odin + Raylib project settings loaded!", vim.log.levels.INFO)
