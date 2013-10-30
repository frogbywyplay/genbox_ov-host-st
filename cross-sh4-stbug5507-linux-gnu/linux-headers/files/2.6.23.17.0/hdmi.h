/***********************************************************************
 *
 * File: stgfb/Linux/stm/coredisplay/stmhdmi.h
 * Copyright (c) 2007 STMicroelectronics Limited.
 * 
 * This file is subject to the terms and conditions of the GNU General Public
 * License.  See the file COPYING in the main directory of this archive for
 * more details.
 *
\***********************************************************************/

#ifndef _STMHDMI_H
#define _STMHDMI_H

struct stmhdmiio_spd
{
  unsigned char vendor_name[8];
  unsigned char product_name[16];
  unsigned char identifier;      /* As specified in CEA861 SPD InfoFrame byte 25 */
};


/*
 * The following bytes will be placed directly into the audio InfoFrame when
 * audio is sent, with those bits manidated to be zero in the HDMI spec 
 * suitably masked.
 *
 * The default is to send all zeros, to match either 2ch L-PCM or
 * IEC60958 encoded data streams. If other audio sources are transmitted then
 * this information should be set correctly.
 */
struct stmhdmiio_audio
{
  unsigned char channel_count;      /* As specified in CEA861 Audio InfoFrame byte 1 (bits 0-2) */
  unsigned char sample_frequency;   /* As specified in CEA861 Audio InfoFrame byte 2 (bits 2-4) */
  unsigned char speaker_mapping;    /* As specified in CEA861 Audio InfoFrame byte 4            */
  unsigned char downmix_info;       /* As specified in CEA861 Audio InfoFrame byte 5 (bits 3-7) */
};


struct stmhdmiio_data_packet
{
  unsigned char type;
  unsigned char version; // Or ACP type or ISRC1 HB1
  unsigned char length;
  unsigned char data[28];
};


typedef enum {
  STMHDMIIO_SCAN_UNKNOWN,
  STMHDMIIO_SCAN_OVERSCANNED,
  STMHDMIIO_SCAN_UNDERSCANNED
} stmhdmiio_overscan_mode_t;


typedef enum {
  STMHDMIIO_IT_GRAPHICS,
  STMHDMIIO_IT_PHOTO,
  STMHDMIIO_IT_CINEMA,
  STMHDMIIO_IT_GAME,
  STMHDMIIO_CE_CONTENT,
} stmhdmiio_content_type_t;


typedef enum {
  STMHDMIIO_EDID_STRICT_MODE_HANDLING,     /* Do not enable HDMI if display mode        */
                                           /* not indicated in EDID (default)           */
  STMHDMIIO_EDID_NON_STRICT_MODE_HANDLING, /* Always output display mode, ignoring EDID */
} stmhdmiio_edid_mode_t;


#define STMHDMIIO_AUDIO_SOURCE_2CH_I2S (0)
#define STMHDMIIO_AUDIO_SOURCE_PCM     STMHDMIIO_AUDIO_SOURCE_2CH_I2S
#define STMHDMIIO_AUDIO_SOURCE_SPDIF   (1)
#define STMHDMIIO_AUDIO_SOURCE_8CH_I2S (2)
#define STMHDMIIO_AUDIO_SOURCE_NONE    (0xffffffff)

#define STMHDMIIO_AUDIO_TYPE_NORMAL     (0) /* LPCM or IEC61937 compressed audio */
#define STMHDMIIO_AUDIO_TYPE_ONEBIT     (1) /* 1-bit audio (SACD)                */
#define STMHDMIIO_AUDIO_TYPE_DST        (2) /* Compressed DSD audio streams      */
#define STMHDMIIO_AUDIO_TYPE_DST_DOUBLE (3) /* Double Rate DSD audio streams     */
#define STMHDMIIO_AUDIO_TYPE_HBR        (4) /* High bit rate compressed audio    */

#define STMHDMIIO_SET_SPD_DATA            _IOW ('H', 0x1, struct stmhdmiio_spd)
#define STMHDMIIO_SET_AUDIO_DATA          _IOW ('H', 0x2, struct stmhdmiio_audio)
#define STMHDMIIO_SEND_DATA_PACKET        _IOW ('H', 0x3, struct stmhdmiio_data_packet)
#define STMHDMIIO_SET_AVMUTE              _IO  ('H', 0x5)
#define STMHDMIIO_SET_AUDIO_SOURCE        _IO  ('H', 0x6)
#define STMHDMIIO_SET_AUDIO_TYPE          _IO  ('H', 0x8)
#define STMHDMIIO_SET_OVERSCAN_MODE       _IO  ('H', 0x9)
#define STMHDMIIO_SET_CONTENT_TYPE        _IO  ('H', 0xa)
#define STMHDMIIO_SET_EDID_MODE_HANDLING  _IO  ('H', 0xb)

#endif /* _STMHDMI_H */
