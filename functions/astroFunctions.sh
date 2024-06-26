
InstallIndiDriver() {
    mkdir ~/packages/indi-3rdparty/build/
    cd ~/packages/indi-3rdparty/build/
    mkdir $1
    cd $1
    cmake -DCMAKE_INSTALL_PREFIX=/usr ~/packages/indi-3rdparty/$1
    make -j4
    sudo make install
}

InstallIndi() {
    CloneOrUpdateGitRepoToPackages "indi" "https://github.com/indilib/indi"
    cd ~/packages/indi
    mkdir build
    cd build
    cmake -DCMAKE_INSTALL_PREFIX=/usr ..
    make -j4
    sudo make install
}

InstallPlanetaryImager() {
    cd ~/packages/PlanetaryImager
    mkdir build
    cd build
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr
    make all && sudo make install
}

InstallAstroPy() {
    if [ ! -d ${HOME}/packages/astropy ]; then
        cd ~/packages
        git clone --recursive git://github.com/astropy/astropy.git
        cd astropy
        pip3 install . -v
    fi
}

InstallKstars() {
    mkdir -p ~/packages/kde
    cd ~/packages/kde
    sudo pacman -S eigen wcslib xplanet cmake kf5 extra-cmake-modules --needed --noconfirm

    if [ ! -d kstars ]
    then
        git clone https://anongit.kde.org/kstars
    else
        cd kstars
        git stash
        git pull
        git stash pop
        cd ..
    fi

    mkdir build
    cd build
    cmake ../kstars -DCMAKE_INSTALL_PREFIX=/usr
    make
    sudo make install
}

InstallAstrometryNet() {
    pip install numpy
    pip install fitsio
    cd ~/packages
    mkdir astrometryNet
    cd astrometryNet
    wget http://astrometry.net/downloads/astrometry.net-latest.tar.gz
    tar xvzf astrometry.net-latest.tar.gz
    rm astrometry.net-latest.tar.gz
    cd  "$(\ls -1dt ./*/ | head -n 1)"
    sudo make
    sudo make py
    sudo make extra
    sudo make install  # to put it in /usr/local/astrometry
}

InstallPHD2() {
    cd ~/packages/phd2
    mkdir -p compiled
    cd compiled
    cmake ..
    make
    sudo make install
}

DownloadIndexFiles() {
    if [ ! -d ~/AstrometryIndexes ]; then
        echo "Downloading astrometry index files ..."
        mkdir ~/AstrometryIndexes
        cd ~/AstrometryIndexes
        wget http://data.astrometry.net/4200/index-4211.fits
        wget http://data.astrometry.net/4200/index-4210.fits
        wget http://data.astrometry.net/4200/index-4209.fits
        wget http://data.astrometry.net/4200/index-4208.fits

       for i in {00..11}
       do
            wget http://data.astrometry.net/4200/index-4207-$i.fits
       done

       for i in {00..11}
       do
            wget http://data.astrometry.net/4200/index-4206-$i.fits
       done

       for i in {00..11}
       do
            wget http://data.astrometry.net/4200/index-4205-$i.fits
       done

       for i in {00..47}
       do
            wget http://data.astrometry.net/4200/index-4204-$i.fits
       done

       for i in {00..47}
       do
            wget http://data.astrometry.net/4200/index-4203-$i.fits
       done

       for i in {00..47}
       do
            wget http://data.astrometry.net/4200/index-4202-$i.fits
       done
    fi
}

InstallFxLoad() {
    CloneOrUpdateGitRepoToPackages "fx3load-code" "https://git.code.sf.net/p/fx3load/code"
    cd ~/packages/fx3load-code
    make clean
    make fxload
    sudo make install
}
