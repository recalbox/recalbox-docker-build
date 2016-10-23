# docker-buildroot for recalbox

[Recalbox-buildroot](https://github.com/recalbox/recalbox-buildroot) in a docker container

Build the recalbox os with a single command !

You will be able to test and modify recalboxos with no configuration effort.

**1 - Pull the image with :**  
`sudo docker pull recalbox/recalbox-docker-build`

**2 - Or build your own image with :**  
`sudo docker build -t <name-of-you-want> https://github.com/recalbox/recalbox-docker-build.git`

**3 - Start the compilation with :**   
`sudo docker run -t -v /path/to/your/build/directory/:/usr/share/recalbox/build/ recalbox/recalbox-docker-build`

**4 - Customize the build :**   
The  `-v /path/to/your/build/directory/:/usr/share/recalbox/build/` create the data volume so you can access the compilation file directly on your host. Go to `/path/to/your/build/directory/` and see the rpiX directory with the whole compilation files in it.
If you only want the recalbox target zip (boot.tar.xz, root.tar.xz) you can use :  
`sudo docker run -t -v /path/to/your/images/directory/:/usr/share/recalbox/build/rpi3/output/images/recalbox recalbox/recalbox-docker-build`
and you will have only the images created at the end of the compilation in your host directory.

ENV variables : 
- *RECALBOX_AUTO_BUILD* : set to 1 to auto build when starting the container (default 1)
- *RECALBOX_BRANCH* : set the branch to compile (default rb-4.1.X)
- *RECALBOX_ARCH* : set the Raspberry pi arch you want to use between rpi1, rpi2, rpi3 (default rpi3)
- *RECALBOX_CLEANBUILD* : clean all the compiled programs when restarting a build (default 1)
- *RECALBOX_SINGLE_PKG (optional)* : Build only the selected package (default NULL)
- *RECALBOX_VERSION_LABEL* : recalbox version to use for recalbox.version (default ${RECALBOX_BRANCH}-${RECALBOX_ARCH}-${DATE})
- *RECALBOX_UPDATE_MESSAGE* : recalbox message to show on update (default "")
- *RECALBOX_DL_PARENT_FOLDER* : use parent folder for downloads (default 0)
- *RECALBOX_HOST_PARENT_FOLDER* : use parent folder for host builds (default 0)
- *RECALBOX_GIT_RESET* : git reset --hard HEAD before pulling (default 1)
- *RECALBOX_GIT_COMMIT* : the commit to checkout (default last commit on branch)


> For ENV RECALBOX_SINGLE_PKG : if you work on a specifique package and you have already the same version of recalbox on your raspberry, you can built only your package rather than build all system.


**Examples :** 
- build recalbox rb-4.1.X (default) for rpi2 :  
`sudo docker run -v /tmp/recalboxbuild/:/usr/share/recalbox/build/ -t -e "RECALBOX_ARCH=rpi2" recalbox/recalbox-docker-build`
- build recalbox rb-4.0.X for rpi1 :  
`sudo docker run -v /tmp/recalboxbuild/:/usr/share/recalbox/build/ -t -e "RECALBOX_ARCH=rpi1" -e "RECALBOX_BRANCH=rb-4.0.X" recalbox/recalbox-docker-build`
- build recalbox rb-4.0.X for rpi1 and avoid cleaning all the target of the last build :  
`sudo docker run -v /tmp/recalboxbuild/:/usr/share/recalbox/build/ -t -e "RECALBOX_ARCH=rpi1" -e "RECALBOX_BRANCH=rb-4.0.X"  -e "RECALBOX_CLEANBUILD=0" recalbox/recalbox-docker-build`
- build only virtualgamepad for recalbox rb-4.1.X (default) for rpi2 :  
`sudo docker run -v /tmp/recalboxbuild/:/usr/share/recalbox/build/ -t -e "RECALBOX_ARCH=rpi2" -e "RECALBOX_SINGLE_PKG=recalbox-api" recalbox/recalbox-docker-build`
 - get compiled package to `/tmp/recalboxbuild/rpi2/output/target/<path(s)-to-compiled-binarys-or-installed-files>` and copy `<path(s)-to-compiled-binarys/files>` to your recalbox folder for tests. 


**5 - Container management**  
Each time you start a container with the run command, a new container is created from the docker image.  
To avoid that, you can :
- Automatically remove the container at the end of the compilation. For this you can add the `--rm` option when you run the docker command `sudo docker run --rm -t -v   /path/to/your/images/directory/:/usr/share/recalbox/build/rpi3/output/images/recalbox recalbox/recalbox-docker-build`
- Reuse the last container using the docker start command :  
`sudo docker ps -a` will give you the list of all the containers on your system. Use `sudo docker start -i [containerID]` to start an existing container
- Open a bash tty on the container you start : `sudo docker run --rm -ti -v /path/to/your/images/directory/:/usr/share/recalbox/build/rpi3/output/images/recalbox recalbox/recalbox-docker-build /bin/bash` and then call run `/usr/local/bin/build-recalbox.sh` to start the compilation.
