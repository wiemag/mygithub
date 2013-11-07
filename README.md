mygithub
--------

A script to download my (your) packages/scripts/files from github.com.


USAGE

	mygithub [-o OWNER] [-r REPO] [-f FILENAME] [-p] [-g] [-z] [-h]

- OWNER defaults to the current $USER.
- REPO is a repository on https://github.com/${OWNER}.
- FILENAME is a file in the $REPO.
- Flag "p" tells the script to look for a PKGBUILD.
- Flag "g" tells the script to download the latest tar.gz release of the REPO.
- Flag "z" tells the script to download the latest zip file of REPO master branch.
- The "h" desplays a help/usage message.

At least one of the "-r" and "-f" flags must be invoked for the script to know what to look for.


DESCRIPTION

The script looks for the file "FILENAME" in the given repository and downloads it. If the repository is not defined, the script first makes a list of existing repositories that contain the looked-for filename.

If FILENAME is not defined, the script looks for the REPO and downloads its latest .tar.gz release, setting the "-z" flag in the process. 

The "-p" flag tells the script to look for a package build file in
	http://github.com/<OWNER>/PKGBUILDs/
If there is one there, the script downloads it.

Note that the package build name checked is "PKGBUILD.<REPO>".


DEPENDENCIES

- curl: for downloading
- grep
- cut


USAGE EXAMPLES

(1)  Here's a trick that will let you download all the latest zip's of your repos:

	mygithub -o MYSELF -f README.md -z

- MYSELF is of course you.
- README.md is a file name that will be used to look for a repo that contains it. Presumably all repos have it.
- The "z" flag downloads the latest <REPO>.zip file.

(2)  This way you will download a repo: the latest release, the latest files, and a package build if it exists.

	mygithub -o MYSELT -r MYREPO -gzp
