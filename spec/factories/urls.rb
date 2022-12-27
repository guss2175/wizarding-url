FactoryBot.define do
  factory :url do
    original_url {Faker::Internet.url}
    alias_url {Converters::Base62.encode(Url.secret_key)}
  end
end
