# docker_template
template for docker container


## Installation
- OSX 
  Just install docker for max.
- Windows
  Install docker for windows
- linux
---
## How to use?
Put `.devcontainer` folder into your projects. 

### Without remote container

  - go to `.devcontainer` folder and run `docker-compose up -d `
  - `docker container ls -a` to check the list container. You may see an image with running status.
  - `docker exec -it <project_name> bash` to run bash terminal inside the docker container.

### With remote container
  - Install remote container extension in vscode.
  - go to command palette or press `F1` and choose `Reopen in container ..` command.
  - For the first time, you need to build image and compose a container.
  - If you want to rebuild, run `Rebuild ..` in command palette.

- ## compose.yml
  - In order to use github, you need to check `.ssh` folder is under home directory (`~`) in host machine.
    - This enable using the private keys without copying
- ## dockerfile
  - It uses `mcr.microsoft.com/vscode/devcontainers` that best suit for remote container.
    - If you pick `mcr.microsoft.com/vscode/devcontainers/base:ubuntu-22.04`, there is no differece between `ubuntu:22.04`  which is the official image.
    - `Dockerfile_base` uses base ubuntu image.
  - This image have user called `vscode`. If you wanto change user name, then change `ARG USERNAME=<name>` in `dockerfile` or `USERNAME:<name>` in `docker-compose.yml`

- ## About permissions

  - ### OSX
    - Some error message when trying to save in vscode?
      ~~No solution yet.~~
      Maybe because of autosave.
      - you need to turn-off the autosave.

      <!-- - It is severe problem. If you change permissions with `chmod 777 -R .`, then error message won't come out.
      - Other than that, no solution is provided yet. -->
        <!-- - If I choose `- ../:/home/user/project:delegated` instead of `:consistent` error doesn't raise. -->
        

  - ### Windows



# versions

- ## v1.0
  - The use of bind mount makes it so that any changes made within the Docker container are reflected on the host machine.
  - However, there is a potential for this setup to negatively impact performance.
- ## v2.0
  - We've switched to using volume mount instead.
  - This means that any changes made within the container will be stored in a separate folder from the host machine, so if you want work in docker container, you'll need to copy or move the folder.
  - Performance (mainly I/O) increased.
  - bug fixed
    - ssh_find_agent is fixed.


- ## v3.0 
  - since poor performance (read and write b/w HD) only yeild on M1 mac, it's not necessary to use v2.0 on normal PC
  - for max os higher than 12.5, one can use `Virtiofs` and it solve performance problem on bind volume. 
  - So, v3.0 is basically same as v1.0

