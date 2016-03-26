# docker-buildroot for recalbox
[![Build Status](https://travis-ci.org/MikaXII/docker-buildroot.svg)](https://travis-ci.org/MikaXII/docker-buildroot)

[Recalbox-buildroot](https://github.com/recalbox/recalbox-buildroot) in a docker container

Build the recalbox os with a single command !

You will be able to test and modify recalboxos with no configuration effort.

Build the image with :  
`sudo docker build -t recalbox-docker-build https://github.com/recalbox/recalbox-docker-build.git`

Start the compilation with :  
`sudo docker run -t -v /path/to/your/build/directory/:/usr/share/recalbox/build/ docker-recalbox`

Customize the build : 
The  `-v /path/to/your/build/directory/:/usr/share/recalbox/build/` create the data volume so you can access the compilation file directly on your host. Go to `/path/to/your/build/directory/` and see the rpiX directory with the whole compilation files in it.
If you only want the recalbox target zip (boot.tar.xz, root.tar.xz) you can use :  
`sudo docker run -t -v /path/to/your/images/directory/:/usr/share/recalbox/build/rpi3/output/images/recalbox docker-recalbox`
and you will have only the images created at the end of the compilation in your host directory.

ENV variables : 
- RECALBOX_AUTO_BUILD : set to 1 to auto build when starting the container (default 1)
- RECALBOX_BRANCH : set the branch to compile (default rb-4.1.X)
- RECALBOX_ARCH : set the Raspberry pi arch you want to use between rpi1, rpi2, rpi3 (default rpi3)
- RECALBOX_CLEANBUILD : clean all the compiled programs when restarting a build (default 1)

Examples : 
- build recalbox rb-4.1.X (default) for rpi2 :  
`sudo docker run -v /tmp/recalboxbuild/:/usr/share/recalbox/build/ -t -e "RECALBOX_ARCH=rpi2" docker-recalbox`
- build recalbox rb-4.0.X for rpi1 :  
`sudo docker run -v /tmp/recalboxbuild/:/usr/share/recalbox/build/ -t -e "RECALBOX_ARCH=rpi1" -e "RECALBOX_BRANCH=rb-4.0.X" docker-recalbox`
- build recalbox rb-4.0.X for rpi1 and avoid cleaning all the target of the last build :  
`sudo docker run -v /tmp/recalboxbuild/:/usr/share/recalbox/build/ -t -e "RECALBOX_ARCH=rpi1" -e "RECALBOX_BRANCH=rb-4.0.X" docker-recalbox`
