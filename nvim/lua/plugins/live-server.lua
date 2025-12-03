vim.api.nvim_create_user_command("LiveServer", function()
  -- Run live-server detached in the background
  vim.fn.jobstart("live-server", {
    cwd = vim.fn.getcwd(),   -- serve current working directory
    detach = true,           -- run independently of Neovim
  })
  print("🚀 Live Server started...")
end, { desc = "Start live-server in background and open browser" })

vim.api.nvim_create_user_command("LiveServerStop", function()
  vim.fn.jobstart("pkill -f live-server")
  print("🛑 Live Server stopped.")
end, { desc = "Stop live-server process" })

