
class InitializerGenerator < Rails::Generators::Base
  CONFIG_PATH = "public/surveys/application/config"
  source_root File.expand_path("../../../#{CONFIG_PATH}", __FILE__) 
  desc "This generator creates a default config file for lime_survey"

  def create_lime_survey_config_file
    # Load config
    conf = Rails.configuration.database_configuration[Rails.env] 
    table_prefix = "#{LimeExt.table_prefix}_"

    # Lines to look for
    match_on = {
      cs: /'pgsql:host=localhost;port=5432;user=postgres;password=somepassword;dbname=limesurvey;'/,
      un: /'username' => 'postgres'/,
      pw: /'password' => 'somepassword'/,
      tp: /'tablePrefix' => 'lime_'/
    }
     
    # copy from backup
    copy_file "config-sample-pgsql.php", "#{CONFIG_PATH}/config.php"
    
    # Line edits
    gsub_file("#{CONFIG_PATH}/config.php", match_on[:cs]) do |match|
      match = match.gsub('user=postgres', "user=#{conf['username']}")
      match = match.gsub('password=somepassword', "password=#{conf['password']}")
      match.gsub('dbname=limesurvey', "dbname=#{conf['database']}")
    end
    
    gsub_file("#{CONFIG_PATH}/config.php", match_on[:un]) do |match|
      match.gsub('postgres', conf['username'])
    end
    
    gsub_file("#{CONFIG_PATH}/config.php", match_on[:pw]) do |match|
      match.gsub('somepassword', conf['password'])
    end
    
    gsub_file("#{CONFIG_PATH}/config.php", match_on[:tp]) do |match|
      match.gsub('lime_', table_prefix)
    end
   
    
    # system "php ./console.php install #{conf['username']} #{conf['password']} #{Settings.admin.name} #{Settings.admin.email}"
    
  end


end
