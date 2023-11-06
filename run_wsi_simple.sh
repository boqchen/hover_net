#!/bin/bash
source ~/.bashrc
source activate mvsenv_hovernet
realpath `which python`

output_dir='/cluster/work/cvl/bochen/Project_MVS/hovernet_output'
model_path='/cluster/work/cvl/bochen/Project_MVS/model_chkpts/hovernet_fast_pannuke_type_tf2pytorch.tar'
he_path='/cluster/work/cvl/bochen/Project_MVS/TCGA/HE_wsi'

wsi_paths=()
count=0

# Use find command to get all files in the directory and add them to the array
while IFS= read -r -d '' file; do
    wsi_paths+=("$file")
done < <(find "$he_path" -type f -print0)

# Loop through the files in the array using a for loop
for ((i=90; i<${#wsi_paths[@]}; i++)); do
# for ((i=90; i<90; i++)); do

    file="${wsi_paths[$i]}"
    echo "Processing file $i: $file"
    python infer_wsi_simple.py --batch_size=128 --nr_inference_workers=11 --nr_post_proc_workers=11 --gpus="4" "$file" "$output_dir" "$model_path" 6 'fast'
    ((count++))

done

echo $count