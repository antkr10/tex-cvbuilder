FROM ubuntu:bionic

# update the system
RUN apt-get -qq update
# install required in our templates tools and fonts
RUN apt-get -y -q install wget perl unzip fontconfig

# copy custom texlive.profile to container
COPY texlive.profile /

# install TexLive using the profile
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz; \
    mkdir /install-tl-unx; \
    tar -xvf install-tl-unx.tar.gz -C /install-tl-unx --strip-components=1; \
    /install-tl-unx/install-tl -profile /texlive.profile; \
    rm -r /install-tl-unx; \
    rm install-tl-unx.tar.gz

# set up working directory and used volume
ENV PATH="/usr/local/texlive/2020/bin/x86_64-linux:${PATH}"
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/update-tlmgr-latest.sh; \
    chmod +x update-tlmgr-latest.sh; \
    /update-tlmgr-latest.sh; \
    rm /update-tlmgr-latest.sh; \
    tlmgr install xetex etoolbox xifthen ifmtarg microtype fontspec pgf parskip setspace multirow fontawesome5 progressbar titlesec enumitem tcolorbox environ listings paracol booktabs pagecolor lipsum xkeyval collectbox adjustbox
ENV HOME /tex-cvbuilder
WORKDIR /tex-cvbuilder
