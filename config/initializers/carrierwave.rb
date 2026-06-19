if ENV["BUCKET"].present?
  CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {
      provider: "AWS",
      aws_access_key_id: ENV.fetch("ACCESS_KEY_ID"),
      aws_secret_access_key: ENV.fetch("SECRET_ACCESS_KEY"),
      region: ENV.fetch("REGION", "auto"),
      endpoint: ENV["ENDPOINT"],
      path_style: true
    }.compact

    config.fog_directory = ENV.fetch("BUCKET")
    config.fog_public = false
  end
end
