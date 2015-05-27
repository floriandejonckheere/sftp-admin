json.users @users.each do |user|
  json.name user.name
  json.email user.email
  json.pub_keys user.pub_keys
end
