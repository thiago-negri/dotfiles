# Install Vundle

First clone Vundle.

    $ git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    
Then open VIM and run `:PluginInstall`.

# How I roll

    $ cd ~
    $ git clone <this repo>
    $ ln -s dot-files/.vimrc .vimrc


# Install VIM (deprecated)

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
