#!/bin/sh
SIZE=800x600
FPS=30
HLS_TIME=5
HLS_SIZE=3

ffmpeg \
  -loglevel info \
  -f v4l2 -input_format yuyv422 -s ${SIZE} -framerate ${FPS} -thread_queue_size 32 -i /dev/video0 \
  -f alsa -channels 1 -thread_queue_size 4096 -ar 8000 -i plughw:1,0 \
  -c:a aac \
  -ar 8000 \
  -ab 64k \
  -c:v h264_v4l2m2m \
  -r ${FPS} \
  -b:v 5M \
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

