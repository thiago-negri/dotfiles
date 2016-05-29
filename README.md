# Install VIM

Get the compile-dependencies of vim, with X11 support.

    sudo apt-get build-dep vim
    sudo apt-get install libx11-dev libxtst-dev

If you haven't got mercurial, get it

    sudo apt-get install mercurial

Get the source

    hg clone https://vim.googlecode.com/hg/ vim_source

Compile it

    cd vim_source

    ./configure \
	--enable-perlinterp=dynamic \
	--enable-pythoninterp=dynamic \
	--enable-rubyinterp=dynamic \
	--enable-cscope \
	--enable-gui=auto \
	--enable-gtk2-check \
	--enable-gnome-check \
	--with-features=huge \
	--with-x \
	--with-compiledby="Thiago B. Negri <evohunz@gmail.com>" \
	--with-python-config-dir=/usr/lib/python2.7/config

    make && make install
