;; TOML: operator.toml
;; Repo: arthurxavierx/vim-caser

;; cspell:words caser

(import-macros {: g! : nmap! : xmap!} :my.macros)

(g! :caser_no_mappings true)

(macro setup-keymaps []
  (let [printf string.format
        prefix :<BSlash>u
        suffix-map {:t {:case :Title :desc "Change To Title Case"}
                    "(" {:case :Sentence :desc "Change to sentence case"}
                    ")" {:case :Space :desc "change to normal case"}
                    :c {:case :Camel :desc :changeToCamelCase}
                    :p {:case :Pascal :desc :ChangeToPascalCase}
                    :- {:case :Kebab :desc :change-to-kebab-case}
                    :k {:case :Kebab :desc :change-to-kebab-case}
                    :_ {:case :Snake :desc :change_to_snake_case}
                    :s {:case :Snake :desc :change_to_snake_case}
                    :. {:case :Dot :desc :change.to.dot.case}
                    :d {:case :Dot :desc :change.to.dot.case}}]
    `(do
       ,(icollect [suffix {: case : desc} (pairs suffix-map)]
          (let [operator (printf "<Plug>Caser%sCase" case)
                v-operator (printf "<Plug>CaserV%sCase" case)
                l-operator (printf "^<Plug>Caser%sCase$" case)
                l-desc (.. "[Line] " desc)
                lhs (.. prefix suffix)
                l-lhs (.. prefix suffix suffix)]
            `(do
               (xmap! ,lhs ,v-operator {:desc ,desc})
               (nmap! ,lhs ,operator {:desc ,desc})
               (nmap! ,l-lhs ,l-operator {:desc ,l-desc})))))))

(setup-keymaps)

(nmap! [:desc :CHANGE_TO_UPPER_CASE] :<BSlash>U :<Plug>CaserUpperCase)
(xmap! [:desc :CHANGE_TO_UPPER_CASE] :<BSlash>U :<Plug>CaserVUpperCase)
(nmap! [:desc :CHANGE_TO_UPPER_CASE_IN_LINE] :<BSlash>UU
       :V<Plug>CaserVUpperCase)
