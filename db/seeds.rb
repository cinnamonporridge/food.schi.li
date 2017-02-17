
if Rails.env.development?
  [ { email: 'john@dev.foo.bar' , is_admin: false },
    { email: 'daisy@dev.foo.bar', is_admin: true  } ].each do |user|
    new_user = User.find_or_initialize_by(email: user[:email], is_admin: user[:is_admin])
    new_user.quick_password = 'abc'
    new_user.save!
  end
end
