// This file is a part of media_kit
// (https://github.com/alexmercerind/media_kit).
//
// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
// All rights reserved.
// Use of this source code is governed by MIT license that can be found in the
// LICENSE file.

#ifndef VIDEO_OUTPUT_MANAGER_H_
#define VIDEO_OUTPUT_MANAGER_H_

#include "video_output.h"

#define VIDEO_OUTPUT_MANAGER_TYPE (video_output_manager_get_type())

// Creates & disposes |VideoOutput| instances for video embedding.
G_DECLARE_FINAL_TYPE(VideoOutputManager,
                     video_output_manager,
                     VIDEO_OUTPUT_MANAGER,
                     VIDEO_OUTPUT_MANAGER,
                     GObject)

#define VIDEO_OUTPUT_MANAGER(obj)                                     \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), video_output_manager_get_type(), \
                              VideoOutputManager))

VideoOutputManager* video_output_manager_new(
    FlTextureRegistrar* texture_registrar);

/**
 * @brief Creates a new |VideoOutput| instance for given |handle|.
 *
 * @param self |VideoOutputManager| reference.
 * @param handle |mpv_handle| reference casted to gint64.
 * @param width Preferred width of the video. Pass `NULL` for using texture
 * dimensions based on video's resolution.
 * @param height Preferred height of the video. Pass `NULL` for using texture
 * dimensions based on video's resolution.
 * @param enable_hardware_acceleration Whether to enable hardware acceleration.
 * @param texture_update_callback Callback invoked when the texture ID updates
 * i.e. video dimensions changes.
 * @param texture_update_callback_context Context passed to
 * |texture_update_callback|.
 */
void video_output_manager_create(VideoOutputManager* self,
                                 gint64 handle,
                                 gint64 width,
                                 gint64 height,
                                 gboolean enable_hardware_acceleration,
                                 TextureUpdateCallback texture_update_callback,
                                 gpointer texture_update_callback_context);

/**
 * @brief Disposes |VideoOutput| instance for given |handle|.
 *
 * @param self |VideoOutputManager| reference.
 * @param handle |mpv_handle| reference casted to gint64.
 */
void video_output_manager_dispose(VideoOutputManager* self, gint64 handle);

#endif
