FactoryBot.define do
  factory :panda_cms_post, class: "Panda::CMS::Post" do
    sequence(:title) { |n| "Post Title #{n}" }
    sequence(:slug) { |n| "/post-#{n}" }
    status { "active" }
    published_at { Time.current }
    association :user, factory: :panda_cms_user
    content do
      {
        "time" => Time.current.to_i,
        "blocks" => [
          {
            "type" => "header",
            "data" => {
              "text" => "Original Header",
              "level" => 2
            }
          },
          {
            "type" => "paragraph",
            "data" => {
              "text" => "Original content"
            }
          }
        ]
      }
    end
  end
end
