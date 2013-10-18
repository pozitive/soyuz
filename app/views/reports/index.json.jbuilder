json.array!(@reports) do |report|
  json.extract! report, :name, :content, :image
  json.url report_url(report, format: :json)
end
