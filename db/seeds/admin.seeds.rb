# frozen_string_literal: true

admin = Admin.where(email: "admin@nbt.com").first_or_create!(
  email: "admin@nbt.com",
  password: "qwerqwer!",
  created_at: Time.zone.now,
  updated_at: Time.zone.now
)
admin.add_role :moderator

admin2 = Admin.where(email: "admin2@nbt.com").first_or_create!(
  email: "admin2@nbt.com",
  password: "qwerqwer!",
  created_at: Time.zone.now,
  updated_at: Time.zone.now
)
admin2.add_role :reader
