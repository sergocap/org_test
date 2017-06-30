namespace 'organizations' do
  desc 'Добавление информации об организациях в Redis'
  task create_redis_records: :environment do
    Organization.all.map(&:create_redis_record)
  end
end
