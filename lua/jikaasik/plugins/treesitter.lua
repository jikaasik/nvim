return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "bufNewFile" },
    build = ":TSUpdate",
    dependencies = "windwp/nvim-ts-autotag",
}
