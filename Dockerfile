FROM ubuntu:bionic-20200112

ENV DEBIAN_FRONTEND=noninteractive

# read input args
ARG IDRIS_VER
# assign input arg to var in this dockerfile
ENV IDRIS_VER ${IDRIS_VER}



# apt update
RUN set -ex && apt-get update


# apt install deps
RUN set -ex && apt-get install -y \
                  cabal-install make \
                  zlibc zlib1g-dev

# install idris
RUN cabal update
RUN cabal install idris-$IDRIS_VER




# apt install vim
RUN set -ex && apt-get install -y \
                  vim \
                  git \
                  curl


# remove apt cache
RUN set -ex && rm -rf /var/lib/apt/lists/*


# add cabal builds to path
ENV PATH ${PATH}:/root/.cabal/bin



#-----------------------------------------
### user creation


# read input args
ARG UID
ARG GID

# assign input arg to var in this dockerfile
#ENV UID ${UID:-1000}
#ENV GID ${GID:-1000}
ENV UID ${UID}
ENV GID ${GID}

RUN groupadd --gid ${UID} idris && \
    useradd --uid ${GID} --no-user-group idris

WORKDIR /home/idris
RUN chown -R idris:idris /home/idris
USER idris

# pathogen for vim
RUN mkdir -p ~/.vim/autoload ~/.vim/bundle && \
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

RUN echo "execute pathogen#infect()\nsyntax on\nfiletype plugin indent on\nfiletype on" >> ~/.vimrc
RUN echo "map <C-n> :NERDTreeToggle<CR>" >> ~/.vimrc
#-----------------------------------------




#-----------------------------------------
### vim

# nerdtree for vim
RUN git clone https://github.com/preservim/nerdtree.git ~/.vim/bundle/nerdtree

# nerdtree-git-plugin
RUN git clone https://github.com/Xuyuanp/nerdtree-git-plugin.git ~/.vim/bundle/nerdtree-git-plugin



# install idris-vim

## dep: vim proc
RUN git clone https://github.com/Shougo/vimproc.vim.git ~/.vim/bundle/vimproc.vim && \
    cd ~/.vim/bundle/vimproc.vim && \
    make

## dep: vimshell
RUN git clone https://github.com/Shougo/vimshell.vim.git ~/.vim/bundle/vimshell.vim

## idris-vim itself
RUN git clone https://github.com/idris-hackers/idris-vim.git ~/.vim/bundle/idris-vim

## vim airline
RUN git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline
#-----------------------------------------



VOLUME /home/idris



#CMD ["idris"]
