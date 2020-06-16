json.extract! channel, :id, :slug, :user_id, :team_id, :created_at, :updated_at

json.messages do
  json.array! channel.messages do |message|
    json.extract! message, :id, :body, :user_id
    json.date message.created_at.strftime("%d/%m/%y")
    json.user do
      json.extract! message.user, :id, :name, :email
      json.image_url url_for(message.user.avatar) if message.user.avatar.attached?
    end
  end
end
