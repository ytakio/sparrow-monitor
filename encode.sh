#!/bin/bash -x
FORMAT=yuyv422
SIZE=800x600
FPS=30
HLS_TIME=10
HLS_SIZE=3
AUDIO_FS=44100

#  -f alsa -channels 1 -thread_queue_size $((2**11)) -ar ${AUDIO_FS} -i plughw:1,0 \

ffmpeg \
  -loglevel info \
  -re \
  -f v4l2 -video_size ${SIZE} -input_format ${FORMAT} -thread_queue_size $((2**20)) -framerate ${FPS} -i /dev/video0 \
  -c:a aac \
  -ar ${AUDIO_FS} \
  -ab 64k \
  -an \
  -c:v h264_v4l2m2m \
  -r ${FPS} \
  -b:v 5M \
  -num_capture_buffers $((2**8)) \
  -f segment -segment_format mpegts \
  -segment_list_type m3u8 -segment_list /tmp/www/out.m3u8 \
  -segment_list_flags +live \
  -segment_time ${HLS_TIME} \
  -segment_list_size ${HLS_SIZE} \
  -segment_wrap 8 \
  -movflags +faststart \
  -g $((${HLS_TIME}*${FPS})) \
  -keyint_min $((${HLS_TIME}*${FPS})) \
  -reset_timestamps 1 \
  -force_key_frames "expr:gte(t,n_forced*${HLS_TIME})" \
  /tmp/www/out%d.ts \

