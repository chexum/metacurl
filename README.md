# metacurl

## What's meta about it?

It's just like curl, but tries to save essential metadata about the files it transfers.
One significant difference is that it always saves to a file, not to standard output.
In addition, follows redirects,
attempts to save the last-modified time from the server,
makes sure all of the file is transferred,
computes several hashes during the transfer (and verifies them if the server provides a way).

It also records these metadata for later:

1. in a file in $FLMETADIR, in JSON format
2. in an sqlite database named $FLDB
3. in a plaintext file in the current directory called .meta

## Why?

To have a way of looking up, what's that project.txt if it was downloaded from the web,
and providing a way to check what was the SHA1 of zlib-1.2.11.tar.xz when it was downloaded.
In essence a basic building block of archival for reproducible environments.
