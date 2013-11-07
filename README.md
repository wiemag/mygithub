mygithub
--------

A script to download my (your) packages/scripts/files from github.com.


DESCRIPTION

The script first checks if there is a package build (PKGBUILD) at 
	http://github.com/<OWNER>/PKGBUILDs/
If there is one, the script downloads it and finishes.
Note that the package build name checked is "PKGBUILD.<REPO>".
If the package build is not found, the script goes on to check if a repository exists for the given name
	http://github.com/<OWNER>/<REPO>/
and if the repository does exist, the script downloads a gzipped version or a raw file.

Searching may also be done by specifying a file name to look for. In such a case, the script looks for a script in a repository, if specified, or on the entire github tree for the given owner/user.


USAGE

	mygithub [-o OWNER] [-r REPO] [-f FILENAME] [-p] [-z] [-h]

- OWNER defaults to the current $USER.
- REPO is a repository on https://github.com/${OWNER}.
- FILENAME is a file in the $REPO.
- Flag "p" tells the script to look for a PKGBUILD.
- Flag "z" tells the script to download the latest tar.gz release of the REPO.
- "h" desplays a help/usage message.

At least one of the "-r" and "-f" flags must be invoked for the script to know what to look for.


DEPENDENCES

- curl: for downloading
- grep
- cut
