Scratch Mode:
- chart UUID generated on client
- client-side verification of policy
- single-user

Upstream Directory Mode:
- chart UUID generated on client
- client-side verification of policy
- runs potentially untrusted code on client (pre-receive hooks)
- multi-user

Upstream Server Mode:
- chart UUID generated on server
- no .git write access
- both client and server-side verification of policy
- git commands run on server
- multi-user


### OUTDATED ###
nchart _new_uuid
A
- uuid/conflict resolutions
- provide server_gen uuid
B
- uuid/conflict resolutions
- provide client_gen uuid

nchart new_chart (--uuid <UUID>)
- run nchart _new_uuid
A (permissive)
- attempt strict mode first
- run scripts/init_chart.sh on scratch with uuid (import flag)
- run nchart open with uuid
A (strict)
- run scripts/init_chart.sh on upstream with uuid
- run nchart open with uuid
B
- run scripts/init_chart.sh on scratch with uuid (import flag)
- run nchart open with uuid

nchart open <UUID>
A
- cp from upstream to scratch/$user/
B
- git clone from 
- cp from upstream to scratch/$user/

nchart close <UUID>
- run nchart commit


nchart close_all
- run nchart commit * n

nchart commit
- enforce date format
- enforce _id.nt modification
- slow enforce _summary.nt
- git commit

nchart sync
- run nchart commit
- git pull from origin/master
- git merge
  - if binary --> copy both please
  - https://stackoverflow.com/questions/62924962/keep-both-binary-files-when-there-is-a-merge-conflict-in-git
  - if text --> merge
- atomic push
https://stackoverflow.com/questions/8424232/are-concurrent-git-pushes-always-safe-if-the-second-push-only-has-fast-forwards?noredirect=1&lq=1
- fail --> retry later

How to do chart import
- if import flag is set on chart 
  - if uuid exists in upstream
    - halt, ask if import_fresh or import_merge is desired
      - if import_fresh follow instructions from: "if uuid dne in upstream"
      - if import_merge do git pull and normal stuff
    - if import_merge chosen with unrelated history (orignal commit is different hash)
      - ask if allow-unrelated-histories
      - https://stackoverflow.com/questions/37937984/git-refusing-to-merge-unrelated-histories-on-rebase
  - if uuid dne in upstream
    - init_chart.sh on upstream with new uuid
    - rename old uuid -> new uuid
    - we good

nchart sync_safe




