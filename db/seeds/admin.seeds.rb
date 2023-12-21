# frozen_string_literal: true

Admin.where(email: "admin@nbt.com").first_or_create!(
  email: "admin@nbt.com",
  password: "qwerqwer!",
  created_at: Time.zone.now,
  updated_at: Time.zone.now
)
# encrypted_password: "$2a$12$OErtn5DnTdxpFcxynXqPaeL8SgxjH332bNac2AqEEGXueTCKfLqy2", # qwerqwer!
