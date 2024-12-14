return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- Configuración de dap-ui
		dapui.setup({
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.5 }, -- Mostrar variables
						{ id = "stacks", size = 0.5 }, -- Mostrar stack traces
					},
					size = 40,
					position = "left",
				},
			},
			controls = {
				enabled = false, -- Desactivar controles flotantes
			},
		})

		-- Abrir/cerrar automáticamente dap-ui
		dap.listeners.before.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		-- Mapeos básicos para depuración
		vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, {})
		vim.keymap.set("n", "<Leader>dc", dap.continue, {})
		vim.keymap.set("n", "<Leader>ds", dap.step_over, {})
		vim.keymap.set("n", "<Leader>di", dap.step_into, {})
		vim.keymap.set("n", "<Leader>do", dap.step_out, {})

		-- -- Configuración para LLDB (C/C++/Rust)
		dap.adapters.lldb = {
			type = "executable",
			command = "/usr/bin/lldb", -- Ruta al ejecutable de LLDB
			name = "lldb",
		}

		dap.configurations.c = {
			{
				name = "Launch LLDB",
				type = "lldb",
				request = "launch",
				program = function()
					return vim.fn.input("Ruta al ejecutable: ", vim.fn.getcwd() .. "/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopOnEntry = false,
				args = {},
				runInTerminal = false, -- Cambiar a true si prefieres usar la terminal
			},
		}
		dap.configurations.cpp = dap.configurations.c
		dap.configurations.rust = dap.configurations.c

		-- Configuración para Python
		dap.adapters.python = {
			type = "executable",
			command = "python", -- Ruta al ejecutable de Python
			args = { "-m", "debugpy.adapter" },
		}

		dap.configurations.python = {
			{
				type = "python",
				request = "launch",
				name = "Run Python file",
				program = function()
					return vim.fn.input("Ruta al archivo Python: ", vim.fn.getcwd() .. "/", "file")
				end,
				pythonPath = "/usr/bin/python", -- Ruta al Python del sistema o virtualenv
				justMyCode = true, -- Ignorar errores en librerías externas
				console = "integratedTerminal", -- Usar terminal integrada
			},
		}

		-- Opcional: Simplificar ejecución con terminal flotante
		vim.keymap.set("n", "<Leader>dr", function()
			local file = vim.fn.input("Archivo a ejecutar: ", vim.fn.getcwd() .. "/", "file")
			vim.cmd("split term://python " .. file)
		end, {})
	end,
}
