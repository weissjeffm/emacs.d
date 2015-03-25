(defun s3ql-mount-backup (share-url mountpoint user secret encryption-password)
  ;; Mount 
  (let* ((proc-name (concat "mount.s3ql " share-url))
         (proc (start-process proc-name
                              proc-name
                              "mount.s3ql"
                              share-url
                              mountpoint)))
    (process-send-string proc (concat user "\n"))
    (process-send-string proc (concat secret "\n"))
    (process-send-string proc (concat encryption-password "\n"))
    proc))

(defun my-mount-s3ql ()
  (let* ((collection "Login")
         (item "s3ql oauth")
         (user (secrets-get-attribute collection item :user))
         (token (secrets-get-attribute collection item :token))
         (password (secrets-get-secret collection item)))
    (s3ql-mount-backup "gs://jweiss-backup/mail" "/home/jweiss/mail-backup" user token password)))
