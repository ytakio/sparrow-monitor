#!/bin/sh
SIZE=800x600
FPS=30
HLS_TIME=1
HLS_SIZE=3
AUDIO_FS=44100

ffmpeg \
  -loglevel info \
  -f v4l2 -input_format mjpeg -s ${SIZE} -framerate ${FPS} -thread_queue_size 32 -i /dev/video0 \
  -f alsa -channels 1 -thread_queue_size 4096 -ar ${AUDIO_FS} -i plughw:1,0 \
  -c:a aac \
  -ar ${AUDIO_FS} \
  -ab 64k \
  -pix_fmt nv12 \
  -c:v h264_v4l2m2m \
  -r ${FPS} \
  -b:v 2M \
  -bf 0 \
  -num_capture_buffers 32 \
  -f segment -segment_format mpegts \
  -segment_list_type m3u8 -segment_list /tmp/www/out.m3u8 \
  -segment_list_flags +live \
  -segment_time ${HLS_TIME} \
  -segment_list_size ${HLS_SIZE} \
  -segment_wrap 6 \
  -movflags +faststart \
  -force_key_frames "expr:gte(t,n_forced*${HLS_TIME})" \
  /tmp/www/out%d.ts \

