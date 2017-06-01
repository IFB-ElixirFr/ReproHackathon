apt update
apt install -y emacs git aspcud utop

wget https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh -O - | sh -s /usr/local/bin
/usr/local/bin/opam init --comp 4.04.0

eval `opam config env`

opam pin add bistro --dev-repo

#opam install tuareg merlin ocp-indent
