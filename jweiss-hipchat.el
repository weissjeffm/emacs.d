(setq jabber-account-list
      `(("1_19@chat.btf.hipchat.com"
         (:password . ,(secrets-get-secret "Login" monetas-server-keyring-item))
         (:network-server . "hipchat.monetas.io")
         (:port . 5223)
         (:connection-type . ssl))))
