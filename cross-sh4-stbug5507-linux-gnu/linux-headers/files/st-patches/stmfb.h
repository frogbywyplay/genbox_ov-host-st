/***********************************************************************
 *
 * File: stgfb/Linux/video/stmfb.h
 * Copyright (c) 2000, 2004, 2005 STMicroelectronics Limited.
 * 
 * This file is subject to the terms and conditions of the GNU General Public
 * License.  See the file COPYING in the main directory of this archive for
 * more details.
 *
\***********************************************************************/

#ifndef _STMFB_H
#define _STMFB_H

/*
 * Surface definitions for usermode, in the kernel driver they are
 * already defined internally as part of the generic framework.
 */
#if !defined(__KERNEL__)
typedef enum
{
    SURF_NULL_PAD,
    SURF_RGB565 ,
    SURF_RGB888 ,
    SURF_ARGB8565,
    SURF_ARGB8888,
    SURF_ARGB1555,
    SURF_ARGB4444,
    SURF_YCBCR888,
    SURF_YCBCR422R,
    SURF_YCBCR422MB,
    SURF_YCBCR420MB,
    SURF_AYCBCR8888,
    SURF_CLUT1,
    SURF_CLUT2,
    SURF_CLUT4,
    SURF_CLUT8,
    SURF_ACLUT44,
    SURF_ACLUT88,
    SURF_A1,
    SURF_A8
}SURF_FMT;
#endif /* !__KERNEL__ */

#define STMFBIO_COLOURKEY_FLAGS_ENABLE	0x00000001
#define STMFBIO_COLOURKEY_FLAGS_INVERT	0x00000002

typedef struct
{
	unsigned long ulMinColourKey;
	unsigned long ulMaxColourKey;
	unsigned long ulFlags;
} STMFBIO_COLOURKEY_DATA;


#define BLT_OP_FLAGS_NULL                    0x00000000
#define BLT_OP_FLAGS_SRC_COLOR_KEY           0x00000001
#define BLT_OP_FLAGS_DST_COLOR_KEY           0x00000002
#define BLT_OP_FLAGS_GLOBAL_ALPHA            0x00000004
#define BLT_OP_FLAGS_BLEND_SRC_ALPHA         0x00000008
#define BLT_OP_FLAGS_BLEND_SRC_ALPHA_PREMULT 0x00000010
#define BLT_OP_FLAGS_PLANE_MASK              0x00000020
#define BLT_OP_FLAGS_FLICKERFILTER           0x00000800
#define BLT_OP_FLAGS_CLUT_ENABLE             0x00001000
#define BLT_OP_FLAGS_BLEND_DST_COLOR         0x00002000
#define BLT_OP_FLAGS_BLEND_DST_MEMORY        0x00004000


typedef enum
{
  BLT_OP_NULL,
  BLT_OP_FILL,
  BLT_OP_COPY,
  BLT_OP_DRAW_RECTANGLE,
  BLT_OP_FILL_TRIANGLE,
} STMFBIO_BLT_OP;


typedef struct
{
    unsigned long numEntries;
    unsigned long entries[256]; 
} STMFBIO_PALETTE;


typedef struct
{
  STMFBIO_BLT_OP   operation;
  unsigned long   ulFlags;
  unsigned long   colour;
  unsigned long   globalAlpha;
  unsigned long   colourKey;
  unsigned long   planeMask;
  unsigned long   srcOffset;
  unsigned long   srcPitch;
  unsigned long   dstOffset;
  unsigned long   dstPitch;
  SURF_FMT         srcFormat;
  SURF_FMT         dstFormat;
  unsigned short  src_top;
  unsigned short  src_bottom;
  unsigned short  src_left;
  unsigned short  src_right;
  unsigned short  dst_top;
  unsigned short  dst_bottom;
  unsigned short  dst_left;
  unsigned short  dst_right;
  unsigned short  tri_a_x;
  unsigned short  tri_a_y;
  unsigned short  tri_b_x;
  unsigned short  tri_b_y;
  unsigned short  tri_c_x;
  unsigned short  tri_c_y;
} STMFBIO_BLT_DATA;

/*
 * Defines for STMFBIO_SET_COMPONENT_VIDEO and STMFBIO_SET_HDMI_VIDEO IOCTLs
 */
#define STMFBIO_VIDEO_RGB   0
#define STMFBIO_VIDEO_YCRCB 1

/*
 * Defines for STMFBIO_SET_HDMI_AUDIO IOCTL
 */
#define STMFBIO_HDMI_AUDIO_SPDIF 0
#define STMFBIO_HDMI_AUDIO_I2S   1

/*
 * non-standard ioctls to control the FB plane and blitter, although
 * these can be used directly they are really provided for the DirectFB
 * driver
 */
#define STMFBIO_SET_TRANSPARENCY        _IOW('B', 0x1, unsigned int)
#define STMFBIO_SET_COLOURKEY           _IOW('B', 0x2, STMFBIO_COLOURKEY_DATA)
#define STMFBIO_BLT                     _IOW('B', 0x3, STMFBIO_BLT_DATA)
#define STMFBIO_SET_BLITTER_PALETTE     _IOW('B', 0x4, STMFBIO_PALETTE)
#define STMFBIO_SYNC_BLITTER            _IO ('B', 0x5)
#define STMFBIO_SET_PREMULTIPLIED_ALPHA _IOW('B', 0x6, unsigned int)
#define STMFBIO_SET_COMPONENT_VIDEO     _IOW('B', 0x7, unsigned int)
#define STMFBIO_SET_HDMI_VIDEO          _IOW('B', 0x8, unsigned int)
#define STMFBIO_SET_HDMI_AUDIO          _IOW('B', 0x9, unsigned int)

/*
 * Implement the matrox FB extension for VSync syncronisation, again for
 * DirectFB.
 */
#ifndef FBIO_WAITFORVSYNC
#define FBIO_WAITFORVSYNC       _IOW('F', 0x20, u_int32_t)
#endif

/* Accelerator type, reported to userspace applications, DirectFB etc.. */
#define FB_ACCEL_ST_GAMMA 100

#endif /* _STMFB_H */
