json.name @user.name
json.email @user.email
json.pub_keys @user.pub_keys.each do |pub_key|
 json.title pub_key.title
 json.key pub_key.key
end
json.shares @user.shares.each do |share|
 json.name share.name
 json.uri URI.join('/shares/', share.id)
end
