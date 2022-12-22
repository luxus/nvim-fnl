(local lazy (require :lazy))
(local opts {:defaults {:lazy true}})

;; Just manage their versions
(lazy.setup [:rktjmp/hotpot.nvim
             :aileot/nvim-laurel
             ...]
            opts)
