# sparrow-monitor

```diff
diff --git a/libavcodec/v4l2_m2m_enc.c b/libavcodec/v4l2_m2m_enc.c
index e08db5d5d3..e707368da4 100644
--- a/libavcodec/v4l2_m2m_enc.c
+++ b/libavcodec/v4l2_m2m_enc.c
@@ -197,6 +197,7 @@ static int v4l2_prepare_encoder(V4L2m2mContext *s)
     v4l2_set_ext_ctrl(s, MPEG_CID(BITRATE) , avctx->bit_rate, "bit rate", 1);
     v4l2_set_ext_ctrl(s, MPEG_CID(FRAME_RC_ENABLE), 1, "frame level rate control", 0);
     v4l2_set_ext_ctrl(s, MPEG_CID(GOP_SIZE), avctx->gop_size,"gop size", 1);
+    v4l2_set_ext_ctrl(s, MPEG_CID(REPEAT_SEQ_HEADER), 1, "repeat parameter sets", 1);

     av_log(avctx, AV_LOG_DEBUG,
         "Encoder Context: id (%d), profile (%d), frame rate(%d/%d), number b-frames (%d), "
```
