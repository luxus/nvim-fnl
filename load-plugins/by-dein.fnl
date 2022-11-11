;; TOML: init.toml
;; Repo: Shougo/dein.vim

(import-macros {: if-not
                : when-not
                : tbl?
                : expand
                : g!
                : setglobal!
                : setlocal!
                : augroup!
                : au!} :my.macros)

(local {: get-script-path} (require :my.utils))

(local notify! (if (vim.fn.executable :notify-send)
                   (fn [text ?level]
                     (let [opts (if-not (= ?level vim.log.levels.WARN)
                                  []
                                  [:--urgency=critical :--expire=1000])
                           cmd [:notify-send text (unpack opts)]]
                       (vim.fn.jobstart cmd)))
                   (fn [text ?level]
                     (vim.cmd.redraw)
                     (vim.notify text ?level))))

(local dein-itself (expand :$DEIN_GITHUB_DIR/Shougo/dein.vim))

;; (local dein-data-dir (expand :$XDG_DATA_HOME/dein))

(local dein-log-file (expand :$XDG_DATA_HOME/dein/dein-log.vim))
;; TODO: Migrage all the config files in add/, source/, and post/ to rc/

(setglobal! :rtp+ (expand :$DEIN_OLD_RC_DIR))
;; Set Dein Options ///1

(g! "dein#install_log_filename" dein-log-file)
(g! "dein#auto_recache" true)
(g! "dein#lazy_rplugins" true)

;; dein#inline_vimrcs: Dein will dump the scripts into
;; `$DEIN_CACHE_HOME/state_nvim.vim` after the other `hook_add`s scripts.
;; (g! :dein#inline_vimrcs [])

(g! "dein#install_check_diff" true)
(g! "dein#install_progress_type" :title)

;; Update repositories over the threshold in seconds, comparing by
;; `git ls-remote` in `dein#check_update()`.)

(g! "dein#install_check_remote_threshold" (* 24 60 60))
(g! "dein#enable_notification" true)
(g! "dein#types#git#clone_depth" 1)

;; Note: Make sure `github.com` is set as a Host alias in ~/.ssh/config)

(g! "dein#types#git#default_protocol" :ssh)
(g! "dein#install_github_api_token"
    (let [api-token-path (expand :$VIM_API_TOKEN/dein)
          (read? lines) (pcall vim.fn.readfile api-token-path)
          api-token (?. lines 1)]
      (when-not read?
        ;
        (notify! (.. "g:dein#install_github_api_token missed token in "
                     api-token-path) vim.log.levels.WARN))
      api-token))

;; Download dein.vim if not downloaded yet. ///1

(macro dein-downloaded? []
  `(= (vim.fn.isdirectory dein-itself) 0))

(when (dein-downloaded?)
  (notify! "Installing missing dein.vim...")
  (let [url "https://github.com/Shougo/dein.vim"]
    (vim.fn.system [:git :clone :--depth 1 url dein-itself]))
  (notify! "dein.vim is installed successfully"))

;; Load plugins by Dein ///1

(setglobal! :rtp+ dein-itself)
(macro cache-outdated? []
  `(= 1 (vim.fn.dein#min#load_state (expand :$DEIN_CACHE_HOME))))

(when (cache-outdated?)
  ;; Note: &rtp before calling dein#min#load_state() must be identical;
  ;; otherwise, dein.vim would find it outdated.
  (notify! "dein.vim's cache is outdated." vim.log.levels.WARN)
  (notify! "Updating dein.vim's cache...")
  (lambda load-tomls [toml-files]
    (assert (> (length toml-files) 1) ;
            "You have specified NO toml files")
    (let [default-option-patterns {:init {:lazy 0}
                                   :lazy {:lazy 1}
                                   :ftdetect {:merge_ftdetect 1}}
          default-pattern :lazy]
      (each [_ toml-path (ipairs toml-files)]
        (assert (toml-path:match "%.toml$") (.. "Not a toml file: " toml-path))
        (let [dirname (or (toml-path:match "/([^/]+)/[^/]*%.toml$")
                          default-pattern)
              default-options (. default-option-patterns dirname)
              (ok msg) (pcall vim.fn.dein#load_toml toml-path default-options)]
          (assert ok
                  (.. "In loading plugins at " toml-path " in directory \""
                      dirname "\", an error happend:\n" msg))))))
  (let [toml-files (vim.fn.split (vim.fn.globpath (expand :$DEIN_TOML_HOME)
                                                  :/*/*.toml)
                                 "\\n")
        inline-vimrcs (?. vim.g "dein#inline_vimrcs")
        dein-related-files [(get-script-path) (unpack toml-files)]]
    (when inline-vimrcs
      (assert (tbl? inline-vimrcs)
              (.. "g:dein#inline_vimrcs must be string[],  got "
                  (type inline-vimrcs)))
      (each [_ file (ipairs inline-vimrcs)]
        (table.insert dein-related-files file)))
    (vim.fn.dein#begin (expand :$DEIN_CACHE_HOME) ;
                       ;; File list which Dein will watch to update caches.
                       dein-related-files)
    (load-tomls toml-files)
    (vim.fn.dein#end)
    (vim.fn.dein#save_state)
    (notify! "Finished to update dein's cache" vim.log.levels.WARN)))

;; Install missing plugins ///1

(macro any-plugins-missed? []
  `(= 1 (vim.fn.dein#check_install)))

(when (any-plugins-missed?)
  (vim.fn.dein#install))

;; augroup ///1

(augroup! :myLoadPluginByDein
  (au! :BufWinEnter [:*/nvim/*.toml] ;
       ["Find the plugin table on entering dein's toml"]
       #(let [alt-path (expand "#:p")
              dir-list [:rc :ftplugin :add :post :source]
              is-config-file? ;
              (accumulate [matched? false ;
                           _ dir (ipairs dir-list) ;
                           &until matched?]
                (or matched? (alt-path:match (string.format "/%s/" dir))))]
          (when is-config-file?
            (let [repo-comment-pattern " Repo: (%S+/%S+)"
                  repo-name (accumulate [repo-name nil ;
                                         ;; TODO: earlier return
                                         line (io.lines alt-path) ;
                                         &until repo-name]
                              (or repo-name (line:match repo-comment-pattern)))]
              (when repo-name
                (local repo-pattern (.. "^[# ]*repo = .*\\zs" repo-name))
                ;; Start searching at the top of toml file.
                (vim.cmd.execute :1)
                (vim.fn.search repo-pattern :W)
                (when (= 0 vim.wo.foldenable)
                  (setlocal! :foldenable true)
                  (setlocal! :foldlevel 0))
                (vim.cmd.normal! :zzzv)))))))
