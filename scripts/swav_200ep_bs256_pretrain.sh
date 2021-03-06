# Copyright (c) Facebook, Inc. and its affiliates.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
#

#!/bin/bash
#SBATCH --nodes=1
#SBATCH --gpus=4
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=4
#SBATCH --job-name=swav_200ep_bs256_pretrain
#SBATCH --time=72:00:00
#SBATCH --mem=150G

# master_node=${SLURM_NODELIST:0:9}${SLURM_NODELIST:9:4}
# dist_url="tcp://"
# dist_url+=$master_node
# dist_url+=:40000

DATASET_PATH="/data/Datasets/ILSVRC2012/train"
EXPERIMENT_PATH="./experiments/swav_200ep_bs256_pretrain"
mkdir -p $EXPERIMENT_PATH

# srun --output=${EXPERIMENT_PATH}/%j.out --error=${EXPERIMENT_PATH}/%j.err --label
python -m torch.distributed.launch --nproc_per_node=8  main_swav.py \
--data_path $DATASET_PATH \
--nmb_crops 2 6 \
--size_crops 224 96 \
--min_scale_crops 0.14 0.05 \
--max_scale_crops 1. 0.14 \
--crops_for_assign 0 1 \
--use_pil_blur true \
--temperature 0.1 \
--epsilon 0.05 \
--sinkhorn_iterations 3 \
--feat_dim 128 \
--nmb_prototypes 3000 \
--queue_length 3840 \
--epoch_queue_starts 15 \
--epochs 200 \
--batch_size 32 \
--base_lr 0.6 \
--final_lr 0.0006 \
--freeze_prototypes_niters 5005 \
--wd 0.000001 \
--warmup_epochs 0 \
--arch resnet50 \
--use_fp16 false \
--sync_bn pytorch \
--dump_path $EXPERIMENT_PATH \
# --dist_url $dist_url \
