// This file is a part of media_kit
// (https://github.com/alexmercerind/media_kit).
//
// Copyright © 2021 & onwards, Hitesh Kumar Saini <saini123hitesh@gmail.com>.
// All rights reserved.
// Use of this source code is governed by MIT license that can be found in the
// LICENSE file.

#include "include/media_kit_video/video_output_manager.h"

struct _VideoOutputManager {
  GObject parent_instance;
  GHashTable* video_outputs;
  FlTextureRegistrar* texture_registrar;
};

G_DEFINE_TYPE(VideoOutputManager, video_output_manager, G_TYPE_OBJECT)

static void video_output_manager_init(VideoOutputManager* self) {
  self->video_outputs = g_hash_table_new_full(g_int64_hash, g_int64_equal,
                                              nullptr, g_object_unref);
}

static void video_output_manager_dispose(GObject* object) {
  VideoOutputManager* self = VIDEO_OUTPUT_MANAGER(object);
  g_hash_table_unref(self->video_outputs);
  G_OBJECT_CLASS(video_output_manager_parent_class)->dispose(object);
}

static void video_output_manager_class_init(VideoOutputManagerClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = video_output_manager_dispose;
}

VideoOutputManager* video_output_manager_new(
    FlTextureRegistrar* texture_registrar) {
  auto video_output_manager = VIDEO_OUTPUT_MANAGER(
      g_object_new(video_output_manager_get_type(), nullptr));
  video_output_manager->texture_registrar = texture_registrar;
  return video_output_manager;
}

void video_output_manager_create(VideoOutputManager* self,
                                 gint64 handle,
                                 gint64 width,
                                 gint64 height,
                                 gboolean enable_hardware_acceleration,
                                 TextureUpdateCallback texture_update_callback,
                                 gpointer texture_update_callback_context) {
  if (!g_hash_table_contains(self->video_outputs, &handle)) {
    g_autoptr(VideoOutput) video_output =
        video_output_new(self->texture_registrar, handle, width, height,
                         enable_hardware_acceleration);
    video_output_set_texture_update_callback(
        video_output, texture_update_callback, texture_update_callback_context);
    g_hash_table_insert(self->video_outputs, &handle,
                        g_object_ref(video_output));
  }
}

void video_output_manager_dispose(VideoOutputManager* self, gint64 handle) {
  if (g_hash_table_contains(self->video_outputs, &handle)) {
    g_hash_table_remove(self->video_outputs, &handle);
  }
}
