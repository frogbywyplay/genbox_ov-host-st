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

#define VIDIOC_S_OVERLAY_ALPHA _IOW ('V',  BASE_VIDIOC_PRIVATE, unsigned int)

/*
 * Repeats the first field (see V4L2_BUF_FLAG_BOTTOM_FIELD_FIRST).
 */
#define V4L2_BUF_FLAG_REPEAT_FIRST_FIELD  0x1000

/*
 * Forces the first field of the buffer (see V4L2_BUF_FLAG_BOTTOM_FIELD_FIRST)
 * to be displayed on the correct display field.
 */
#define V4L2_BUF_FLAG_RESYNC_FIELD_ORDER  0x2000

/*
 * V4L2 does not allow us to specify if an interlaced buffer is to be
 * presented top field first or bottom field first. For video capture
 * this can be determined by the input video standard; for output
 * devices this is a property of the content to be presented, not the
 * video display standard. So we define an additional buffer flag
 * to indicate the field order of this buffer.
 */
#define V4L2_BUF_FLAG_BOTTOM_FIELD_FIRST  0x4000

/*
 * When doing pause or slow motion with interlaced content the fields
 * will get displayed (alternately) for several "frames". As there may
 * be motion between the fields, this results in the image "shaking" usually
 * from side to side. If you know this is going to be the case, then setting
 * the following buffer flag will cause the driver to produce both display fields
 * from the same field data in the buffer (using interpolation for the wrong
 * field) while the buffer continues to be on display. This produces a stable
 * image, but with reduced image quality due to the interpolation.
 */
#define V4L2_BUF_FLAG_INTERPOLATE_FIELDS  0x8000

/*
 * If the field order has become reversed by some combination of repeat first
 * field and bottom field first, then the driver will try and present a
 * correct field by either ignoring the reversal and displaying the right
 * field or by displaying an interpolated field if V4L2_BUF_FLAG_INTERPOLATE_FIELDS
 * is set. This behaviour can be overriden with the force field display flag;
 * in this case the hardware will be programmed to display the actual buffer
 * field that has been requested by the above field flags, regardless of the
 * display field being output to the TV. This is highly likely to cause
 * vertical artifacts!
 */
#define V4L2_BUF_FLAG_FORCE_FIELD_DISPLAY 0x10000


/*
 * The following define private controls available in the driver
 */
#define V4L2_CID_STM_BACKGROUND_RED     (V4L2_CID_PRIVATE_BASE+0)
#define V4L2_CID_STM_BACKGROUND_GREEN   (V4L2_CID_PRIVATE_BASE+1)
#define V4L2_CID_STM_BACKGROUND_BLUE    (V4L2_CID_PRIVATE_BASE+2)
#define V4L2_CID_STM_CVBS_FILTER        (V4L2_CID_PRIVATE_BASE+3)
#define V4L2_CID_STM_TV_ASPECT_RATIO    (V4L2_CID_PRIVATE_BASE+4)
#define V4L2_CID_STM_LETTERBOX          (V4L2_CID_PRIVATE_BASE+5)
#define V4L2_CID_STM_VIDEO_ASPECT_RATIO (V4L2_CID_PRIVATE_BASE+6)
#define V4L2_CID_STM_CP_SIGNALLING      (V4L2_CID_PRIVATE_BASE+7)

#endif /* __STMVOUT_H */
