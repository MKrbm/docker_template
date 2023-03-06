FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

# install python3-pip
RUN apt update && apt install python3-pip -y

#n* install dependencies via pip
RUN pip3 install numpy scipy six wheel
RUN pip3 install --upgrade "jax[cuda]" -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html