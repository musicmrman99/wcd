# Windows Change Directory (wcd)

A quick Bash function to change directory to a Windows path in WSL.

wcd will automatically:

- Convert drive letters (`C:` -> `/mnt/c`)
- Convert backslashes to forward slashes (`C:\Users\me\Documents` -> `/mnt/c/Users/me/Documents`)
- Mount needed drives (`P:\example.txt` -> `/mnt/p/example.txt` + mounts `P:` -> `/mnt/p`)

You can set the parent directory for drive mount points with the `wcd__mount_dir` variable. The default is `/mnt`.
