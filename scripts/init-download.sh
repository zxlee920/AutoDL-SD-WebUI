#! /bin/bash

model_dir="/root/autodl-tmp/models"

cd $model_dir
echo "首次使用需要下载一些基本的模型，应该挺快的，稍等一下"

if [ ! -d "$model_dir/ckpt" ]; then
  cg down StableDiffusion-checkpoints/anything-v4.5-pruned-fp16.ckpt -t $model_dir
  mv StableDiffusion-checkpoints ckpt
fi
echo "checkpoints 搞定"

if [ ! -d "$model_dir/vae" ]; then
  cg down StableDiffusion-VAE/anything-v4.0.vae.pt -t $model_dir
  mv StableDiffusion-VAE vae
fi
echo "VAE 搞定"

if [ ! -d "$model_dir/lora" ]; then
  cg down StableDiffusion-LoRAs/makimaChainsawMan_offset.safetensors -t $model_dir
  mv StableDiffusion-LoRAs lora
fi
echo "lora 搞定"

if [ ! -d "$model_dir/embeddings" ]; then
  cg down StableDiffusion-Embeddings/easy_negative.safetensors -t $model_dir
  mv StableDiffusion-Embeddings embeddings
fi
echo "embeddings 搞定"

if [ ! -d "$model_dir/controlnet" ]; then
  cg down ControlNet-v1-1 -t $model_dir
  mv ControlNet-v1-1 controlnet
fi
echo "controlnet 搞定"

if [ ! -d "$model_dir/lycoris" ]; then
  cg down StableDiffusion-lycoris/InsPX.safetensors -t $model_dir
  mv StableDiffusion-lycoris lycoris
fi
echo "lycoris 搞定"

if [ ! -d "$model_dir/others" ]; then
  cg down StableDiffusion-others -t $model_dir
  mv StableDiffusion-others others
  cd $model_dir/others

  data="controlnet_annotator/leres/res101.pth,res101.pth
controlnet_annotator/leres/latest_net_G.pth,latest_net_G.pth
controlnet_annotator/lineart_anime/netG.pth,netG.pth
controlnet_annotator/lineart/sk_model.pth,sk_model.pth
controlnet_annotator/lineart/sk_model2.pth,sk_model2.pth
controlnet_annotator/midas/dpt_hybrid-midas-501f0c75.pt,dpt_hybrid-midas-501f0c75.pt
controlnet_annotator/openpose/body_pose_model.pth,body_pose_model.pth
controlnet_annotator/openpose/hand_pose_model.pth,hand_pose_model.pth
controlnet_annotator/openpose/facenet.pth,facenet.pth
controlnet_annotator/hed/ControlNetHED.pth,ControlNetHED.pth
controlnet_annotator/zoedepth/ZoeD_M12_N.pt,ZoeD_M12_N.pt
controlnet_annotator/manga_line/erika.pth,erika.pth
controlnet_annotator/mlsd/mlsd_large_512_fp32.pth,mlsd_large_512_fp32.pth
controlnet_annotator/normal_bae/scannet.pt,scannet.pt
controlnet_annotator/pidinet/table5_pidinet.pth,table5_pidinet.pth
controlnet_annotator/oneformer/250_16_swin_l_oneformer_ade20k_160k.pth,250_16_swin_l_oneformer_ade20k_160k.pth
controlnet_annotator/oneformer/150_16_swin_l_oneformer_coco_100ep.pth,150_16_swin_l_oneformer_coco_100ep.pth
segment_anything/grounding-dino/GroundingDINO_SwinT_OGC.py,GroundingDINO_SwinT_OGC.py
segment_anything/grounding-dino/groundingdino_swint_ogc.pth,groundingdino_swint_ogc.pth
segment_anything/sam/PUT_YOUR_SAM_MODEL_HERE.txt,PUT_YOUR_SAM_MODEL_HERE.txt
segment_anything/sam/sam_vit_h_4b8939.pth,sam_vit_h_4b8939.pth"

  echo "$data" | while read line; do
    target_path=$(echo $line | cut -d ',' -f 1)
    source_path=$(echo $line | cut -d ',' -f 2)

    mkdir -p $(dirname $target_path)

    mv $source_path $target_path
  done

  rm -r /root/stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads
  ln -s $model_dir/others/controlnet_annotator /root/stable-diffusion-webui/extensions/sd-webui-controlnet/annotator/downloads

  rm -r /root/stable-diffusion-webui/extensions/sd-webui-segment-anything/models
  ln -s $model_dir/others/segment_anything /root/stable-diffusion-webui/extensions/sd-webui-segment-anything/models
fi
echo "controlnet annotator 搞定"
echo "segment anything + GroundingDINO 搞定"

#controlnet_models_urls=(
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11e_sd15_ip2p.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11e_sd15_ip2p.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11e_sd15_shuffle.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11e_sd15_shuffle.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1e_sd15_tile.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1e_sd15_tile.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_inpaint.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_inpaint.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_mlsd.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_mlsd.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_normalbae.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_normalbae.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_scribble.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_scribble.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_seg.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_seg.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_softedge.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_softedge.yaml"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15s2_lineart_anime.pth"
  #"https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15s2_lineart_anime.yaml"
#)

#for url in "${controlnet_models_urls[@]}"
#do
  #wget "$url"
#done
