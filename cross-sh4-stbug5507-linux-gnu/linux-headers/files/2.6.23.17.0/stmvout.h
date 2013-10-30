/***********************************************************************
 * File: stgfb/Linux/video/stmvout.h
 * Copyright (c) 2005 STMicroelectronics Limited.
 *
 * This file is subject to the terms and conditions of the GNU General Public
 * License.  See the file COPYING in the main directory of this archive for
 * more details.
 * 
 ***********************************************************************/
 
#ifndef __STMVOUT_H
#define __STMVOUT_H

#define VID_HARDWARE_STMVOUT 100

#define V4L2_PIX_FMT_STM422MB v4l2_fourcc('4','2','2','B') /* STMicroelectronics 422 Macro Block */
#define V4L2_PIX_FMT_STM420MB v4l2_fourcc('4','2','0','B') /* STMicroelectronics 420 Macro Block */

/*
 * Add some defines for 16bit RGB formats with alpha channel
 */
#define V4L2_PIX_FMT_BGRA5551 v4l2_fourcc('B','G','R','T')
#define V4L2_PIX_FMT_BGRA4444 v4l2_fourcc('B','G','R','S')

#define VIDIOC_S_OVERLAY_ALPHA _IOW ('V',  BASE_VIDIOC_PRIVATE, unsigned int)

/*
 * Add some CLUT surfaces
 */
#define V4L2_PIX_FMT_CLUT2  v4l2_fourcc('C','L','T','2')
#define V4L2_PIX_FMT_CLUT4  v4l2_fourcc('C','L','T','4')
#define V4L2_PIX_FMT_CLUT8  v4l2_fourcc('C','L','T','8')
#define V4L2_PIX_FMT_CLUTA8 v4l2_fourcc('C','L','T','A')

/*
 * Repeats the first field (see V4L2_BUF_FLAG_BOTTOM_FIELD_FIRST).
 */
#define V4L2_BUF_FLAG_REPEAT_FIRST_FIELD  0x1000

/*
 * V4L2 does not allow us to specify if an interlaced buffer is to be
 * presented top field first or bottom field first. For video capture
 * this can be determined by the input video standard; for output
 * devices this is a property of the content to be presented, not the
 * video display standard. So we define an additional buffer flag
 * to indicate the field order of this buffer. When combined with the
 * V4L2_BUF_FLAG_REPEAT_FIRST_FIELD it can be used to implement 3/2 pulldown
 * as specified in MPEG2 picture extension headers.
 */
#define V4L2_BUF_FLAG_BOTTOM_FIELD_FIRST  0x4000

/*
 * When doing pause or slow motion with interlaced content the fields
 * will get displayed (alternately) for several "frames". As there may
 * be motion between the fields, this results in the image "shaking" usually
 * from side to side. If you know this is going to be the case, then setting
 * the following buffer flag will cause the driver to produce both display
 * fields from the same field data in the buffer (using interpolation for the
 * wrong field) while the buffer continues to be on display. This produces a
 * stable image, but with reduced image quality due to the interpolation.
 */
#define V4L2_BUF_FLAG_INTERPOLATE_FIELDS  0x8000

/*
 * When displaying ARGB buffers the driver will by default blend with the 
 * layer below assuming that pixel RGB values are already pre-multiplied by the
 * pixel alpha value. Setting this flag changes the blend maths so that
 * each pixel's RGB values are multiplied by the pixel's alpha value before the
 * blend takes place.
 */ 
#define V4L2_BUF_FLAG_NON_PREMULTIPLIED_ALPHA 0x10000

/*
 * By the default the full colour range of the buffer contents is output to
 * the compositor. This is generally correct for video but not for RGB graphics.
 * Buffers being queued on graphics planes can optionally rescale the colour
 * components to the nominal 8bit range 16-235; although internally this is
 * all done after pixel values have been upscaled to a 10bit range so there is
 * no loss of colour information with this operation.
 */
#define V4L2_BUF_FLAG_RESCALE_COLOUR_TO_VIDEO_RANGE 0x20000

/*
 * The following define private controls available in the driver
 */
#define V4L2_CID_STM_CVBS_FILTER        (V4L2_CID_PRIVATE_BASE+0)
#define V4L2_CID_STM_TV_ASPECT_RATIO    (V4L2_CID_PRIVATE_BASE+1)
#define V4L2_CID_STM_LETTERBOX          (V4L2_CID_PRIVATE_BASE+2)
#define V4L2_CID_STM_VIDEO_ASPECT_RATIO (V4L2_CID_PRIVATE_BASE+3)

#define V4L2_CID_STM_BACKGROUND_ARGB    (V4L2_CID_PRIVATE_BASE+4)

#define V4L2_CID_STM_IQI_SET_CONFIG     (V4L2_CID_PRIVATE_BASE+5)
#define V4L2_CID_STM_IQI_DEMO           (V4L2_CID_PRIVATE_BASE+6)
#define V4L2_CID_STM_XVP_SET_CONFIG     (V4L2_CID_PRIVATE_BASE+7)
#define V4L2_CID_STM_XVP_SET_TNRNLE_OVERRIDE (V4L2_CID_PRIVATE_BASE+8)
#define V4L2_CID_STM_XVP_SET_TNR_TOPBOTSWAP  (V4L2_CID_PRIVATE_BASE+9)
#define V4L2_CID_STM_DEI_SET_FMD_ENABLE (V4L2_CID_PRIVATE_BASE+10)
#define V4L2_CID_STM_DEI_SET_MODE       (V4L2_CID_PRIVATE_BASE+11)
#define V4L2_CID_STM_DEI_SET_CTRLREG    (V4L2_CID_PRIVATE_BASE+12)

#define V4L2_CID_STM_Z_ORDER_VID0       (V4L2_CID_PRIVATE_BASE+20)
#define V4L2_CID_STM_Z_ORDER_VID1       (V4L2_CID_PRIVATE_BASE+21)
#define V4L2_CID_STM_Z_ORDER_RGB0       (V4L2_CID_PRIVATE_BASE+22)
#define V4L2_CID_STM_Z_ORDER_RGB1       (V4L2_CID_PRIVATE_BASE+23)
#define V4L2_CID_STM_Z_ORDER_RGB1_0     (V4L2_CID_PRIVATE_BASE+24)
#define V4L2_CID_STM_Z_ORDER_RGB1_1     (V4L2_CID_PRIVATE_BASE+25)
#define V4L2_CID_STM_Z_ORDER_RGB1_2     (V4L2_CID_PRIVATE_BASE+26)
#define V4L2_CID_STM_Z_ORDER_RGB1_3     (V4L2_CID_PRIVATE_BASE+27)
#define V4L2_CID_STM_Z_ORDER_RGB1_4     (V4L2_CID_PRIVATE_BASE+28)
#define V4L2_CID_STM_Z_ORDER_RGB1_5     (V4L2_CID_PRIVATE_BASE+29)
#define V4L2_CID_STM_Z_ORDER_RGB1_6     (V4L2_CID_PRIVATE_BASE+30)
#define V4L2_CID_STM_Z_ORDER_RGB1_7     (V4L2_CID_PRIVATE_BASE+31)
#define V4L2_CID_STM_Z_ORDER_RGB1_8     (V4L2_CID_PRIVATE_BASE+32)
#define V4L2_CID_STM_Z_ORDER_RGB1_9     (V4L2_CID_PRIVATE_BASE+33)
#define V4L2_CID_STM_Z_ORDER_RGB1_10    (V4L2_CID_PRIVATE_BASE+34)
#define V4L2_CID_STM_Z_ORDER_RGB1_11    (V4L2_CID_PRIVATE_BASE+35)
#define V4L2_CID_STM_Z_ORDER_RGB1_12    (V4L2_CID_PRIVATE_BASE+36)
#define V4L2_CID_STM_Z_ORDER_RGB1_13    (V4L2_CID_PRIVATE_BASE+37)
#define V4L2_CID_STM_Z_ORDER_RGB1_14    (V4L2_CID_PRIVATE_BASE+38)
#define V4L2_CID_STM_Z_ORDER_RGB1_15    (V4L2_CID_PRIVATE_BASE+39)
#define V4L2_CID_STM_Z_ORDER_RGB2       (V4L2_CID_PRIVATE_BASE+99)

/*
 * A/V receiver controls to control the "D1-DVP0" input
 */
#define V4L2_CID_STM_BLANK                   (V4L2_CID_PRIVATE_BASE+100)
#define V4L2_CID_STM_CEA861_MODE             (V4L2_CID_PRIVATE_BASE+101)
#define V4L2_CID_STM_CEA861_NTSC_PIXCLOCK    (V4L2_CID_PRIVATE_BASE+102)
#define V4L2_CID_STM_LATENCY                 (V4L2_CID_PRIVATE_BASE+103)

/*
 * A/V receiver controls to control the "I2S0" audio input
 */
#define V4L2_CID_STM_AUDIO_MUTE              (V4L2_CID_PRIVATE_BASE+110)
#define V4L2_CID_STM_AUDIO_SAMPLE_RATE       (V4L2_CID_PRIVATE_BASE+111)
#define V4L2_CID_STM_AUDIO_MASTER_LATENCY    (V4L2_CID_PRIVATE_BASE+112)
#define V4L2_CID_STM_AUDIO_HDMI_LATENCY      (V4L2_CID_PRIVATE_BASE+113)
#define V4L2_CID_STM_AUDIO_SPDIF_LATENCY     (V4L2_CID_PRIVATE_BASE+114)
#define V4L2_CID_STM_AUDIO_ANALOG_LATENCY    (V4L2_CID_PRIVATE_BASE+115)

/* I dont' think they should be here. They should be defined in audio counterpart of stmdisplayoutput.h */
#define STM_CTRL_AUDIO_MUTE               0
#define STM_CTRL_AUDIO_SAMPLE_RATE        1 
#define STM_CTRL_AUDIO_MASTER_LATENCY     2
#define STM_CTRL_AUDIO_HDMI_LATENCY       3
#define STM_CTRL_AUDIO_SPDIF_LATENCY      4
#define STM_CTRL_AUDIO_ANALOG_LATENCY     5
    
/* 
 * Define DVP video modes
 */
#define DVP_NTSC_I59 		0x80000001			/* NTSC 720x480-59i*/
#define DVP_PAL_I50 		0x80000002			/* PAL B,D,G,H,I,N, SECAM 720x576-50i*/
#define DVP_PAL_P50 		0x80000003			/* PAL P50 (625p ?)720x576-50*/
#define DVP_NTSC_P59 		0x80000004			/* NTSC P59.94 (525p ?) 720x576-50*/
#define DVP_NTSC_P60 		0x80000005			/* NTSC P60 720x480-60*/
#define DVP_SMPTE296M_P59 	0x80000006			/* EIA770.3 #2 P60 /1.001= SMPTE 296M #2 P60 /1.001 1280x720-59*/
#define DVP_SMPTE296M_P60 	0x80000007			/* EIA770.3 #1 P60 = SMPTE 296M #1 P60 1280x720-60*/
#define DVP_SMPTE296M_P50 	0x80000008			/* SMPTE 296M Styled 1280x720 50P CEA/HDMI Code 19 1280x720-50*/
#define DVP_SMPTE247M_I59 	0x80000009			/* EIA770.3 #4 I60 /1.001 = SMPTE274M #5 I60 /1.001 1920x1080-59i*/
#define DVP_SMPTE247M_I60 	0x80000010			/* EIA770.3 #3 I60 = SMPTE274M #4 I60 1920x1080-60i*/
#define DVP_SMPTE247M_I50 	0x80000011			/* SMPTE 274M Styled 1920x1080 I50 CEA/HDMI Code 20 1920x1080-50i*/
#define DVP_VGA_P60		0x80000012			/* VGA 640x480-60p */

#endif /* __STMVOUT_H */
