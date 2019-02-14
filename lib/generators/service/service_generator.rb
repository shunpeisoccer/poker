class ServiceGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  # パラメータを定義
  argument :card

  # サービスクラスを作成する
  def create_service_file
    destination = Rails.root.join("app/services/Cards.rb")
    template('service.rb.erb', destination)
  end

  # サービスクラスのテストクラスを作成する
  def create_test_file
    destination = Rails.root.join("test/services/Cards.rb")
    template('test.rb.erb', destination)
  end
end
